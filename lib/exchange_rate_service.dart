import 'package:flutter/foundation.dart';

import 'exchange_rate.dart';
import 'pocketbase_service.dart';
import 'quote_calculations.dart';

/// Notifies UI when shop `exchange_rate_*` fields change in PocketBase.
class ExchangeRatePolicy {
  ExchangeRatePolicy._();
  static final ExchangeRatePolicy instance = ExchangeRatePolicy._();

  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void notifyChanged() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }
}

class ExchangeRateAutoUpdateResult {
  final bool skipped;
  final bool failed;
  final bool updated;
  final double? rate;

  const ExchangeRateAutoUpdateResult({
    this.skipped = false,
    this.failed = false,
    this.updated = false,
    this.rate,
  });
}

/// Shop ERP exchange rate sync (PocketBase `settings` + Bank of Canada).
class ExchangeRateService {
  ExchangeRateService._();
  static final ExchangeRateService instance = ExchangeRateService._();

  static const _rateEpsilon = 0.00005;
  static const _staleAfter = Duration(hours: 24);

  bool _inFlight = false;

  static double _storedRate(Map<String, dynamic> data) {
    final v = data['exchange_rate_usd_to_cad'];
    if (v == null || v == '') return 1.3;
    return double.tryParse(v.toString()) ?? 1.3;
  }

  static bool _ratesDiffer(double a, double b) =>
      (a - b).abs() > _rateEpsilon;

  static bool _isStale(dynamic lastUpdated) {
    if (lastUpdated == null || lastUpdated.toString().isEmpty) return true;
    try {
      final dt = DateTime.parse(lastUpdated.toString());
      return DateTime.now().difference(dt) > _staleAfter;
    } catch (_) {
      return true;
    }
  }

  /// Fetches BoC USD→CAD and persists to shop settings when appropriate.
  ///
  /// [force] — always fetch and save (updates `exchange_rate_last_updated` even if
  /// the rate is unchanged). Use after enabling auto-update and saving settings.
  ///
  /// [respectStaleness] — when true, skip unless auto-update is on and
  /// `exchange_rate_last_updated` is older than 24 hours (for app resume).
  Future<ExchangeRateAutoUpdateResult> autoUpdateShopExchangeRateIfEnabled({
    bool force = false,
    bool respectStaleness = false,
  }) async {
    if (_inFlight) {
      return const ExchangeRateAutoUpdateResult(skipped: true);
    }
    _inFlight = true;
    try {
      final record = await PocketBaseService().getShopSettings();
      final data = Map<String, dynamic>.from(record.data as Map? ?? {});

      if (data['exchange_rate_auto_update'] != true && !force) {
        return const ExchangeRateAutoUpdateResult(skipped: true);
      }

      if (respectStaleness && !force) {
        if (!_isStale(data['exchange_rate_last_updated'])) {
          return const ExchangeRateAutoUpdateResult(skipped: true);
        }
      }

      final fetched = await fetchUsdCadExchangeRate();
      if (fetched == null) {
        return const ExchangeRateAutoUpdateResult(failed: true);
      }

      final newRate = quoteRound2(fetched) ?? fetched;
      final stored = _storedRate(data);

      if (!force && !_ratesDiffer(newRate, stored)) {
        return ExchangeRateAutoUpdateResult(rate: newRate);
      }

      await PocketBaseService().updateShopSettings(record.id, {
        'exchange_rate_usd_to_cad': newRate,
        'exchange_rate_last_updated': DateTime.now().toUtc().toIso8601String(),
      });
      ExchangeRatePolicy.instance.notifyChanged();

      return ExchangeRateAutoUpdateResult(updated: true, rate: newRate);
    } catch (_) {
      return const ExchangeRateAutoUpdateResult(failed: true);
    } finally {
      _inFlight = false;
    }
  }
}

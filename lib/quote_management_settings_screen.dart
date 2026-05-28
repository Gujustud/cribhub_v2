import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'workspace_layout.dart';
import 'workspace_scaffold.dart';
import 'drawer_behavior.dart';
import 'jobs_only_guard.dart';
import 'drawer_data_cache.dart';
import 'erp_quote_defaults.dart';
import 'exchange_rate.dart';
import 'exchange_rate_service.dart';
import 'pocketbase_service.dart';
import 'quote_sidebar.dart';

/// ERP quote defaults (PocketBase `settings` — DharmaCore Settings.jsx layout).
class QuoteManagementSettingsScreen extends StatefulWidget {
  const QuoteManagementSettingsScreen({super.key});

  @override
  State<QuoteManagementSettingsScreen> createState() =>
      _QuoteManagementSettingsScreenState();
}

class _QuoteManagementSettingsScreenState extends State<QuoteManagementSettingsScreen>
    with AutoOpenDrawerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = true;
  bool _saving = false;
  bool _fetchingRate = false;
  String? _settingsId;
  String? _message;
  bool _messageIsError = false;
  String? _exchangeMessage;
  bool _exchangeMessageIsError = false;

  final _shippingMarkup = TextEditingController();
  final _finalMarkup = TextEditingController();
  final _rateProgramming = TextEditingController();
  final _rateSetup = TextEditingController();
  final _rateFirstRun = TextEditingController();
  final _rateProduction = TextEditingController();
  final _exchangeRate = TextEditingController();

  bool _exchangeRateAutoUpdate = false;
  String? _exchangeRateLastUpdated;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void initState() {
    super.initState();
    guardQuotesAccess(context);
    ExchangeRatePolicy.instance.addListener(_onShopExchangeRateChanged);
    _load();
  }

  @override
  void dispose() {
    ExchangeRatePolicy.instance.removeListener(_onShopExchangeRateChanged);
    _shippingMarkup.dispose();
    _finalMarkup.dispose();
    _rateProgramming.dispose();
    _rateSetup.dispose();
    _rateFirstRun.dispose();
    _rateProduction.dispose();
    _exchangeRate.dispose();
    super.dispose();
  }

  void _onShopExchangeRateChanged() {
    if (!mounted || _loading) return;
    _reloadFromServer();
  }

  void _applyFromRecord(Map<String, dynamic> d) {
    _shippingMarkup.text = _fieldStr(d['default_shipping_markup_percent']);
    _finalMarkup.text = _fieldStr(d['default_final_markup_percent']);
    _rateProgramming.text = _fieldStr(d['default_hourly_rate_programming']);
    _rateSetup.text = _fieldStr(d['default_hourly_rate_setup']);
    _rateFirstRun.text = _fieldStr(d['default_hourly_rate_first_run']);
    _rateProduction.text = _fieldStr(d['default_hourly_rate_production']);
    _exchangeRate.text = _fieldStr(d['exchange_rate_usd_to_cad']);
    _exchangeRateAutoUpdate = d['exchange_rate_auto_update'] == true;
    _exchangeRateLastUpdated = d['exchange_rate_last_updated']?.toString();
  }

  String _fieldStr(dynamic v) {
    if (v == null || v == '') return '';
    if (v is num) {
      return v == v.roundToDouble() ? '${v.toInt()}' : v.toString();
    }
    return v.toString();
  }

  double? _parseNum(String text) {
    final t = text.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  Map<String, dynamic> _mergeSettingsRecord(dynamic record) {
    final defaults = defaultShopSettingsBody();
    return {...defaults, ...(record.data as Map<String, dynamic>? ?? {})};
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final record = await PocketBaseService().getShopSettings();
      if (!mounted) return;
      setState(() {
        _settingsId = record.id;
        _applyFromRecord(_mergeSettingsRecord(record));
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage('Error loading settings: $e', error: true);
    }
  }

  Future<void> _reloadFromServer() async {
    try {
      final record = await PocketBaseService().getShopSettings();
      if (!mounted) return;
      setState(() {
        _settingsId = record.id;
        _applyFromRecord(_mergeSettingsRecord(record));
      });
    } catch (e) {
      if (!mounted) return;
      _showMessage('Error reloading settings: $e', error: true);
    }
  }

  void _showMessage(String text, {bool error = false}) {
    setState(() {
      _message = text;
      _messageIsError = error;
    });
  }

  void _showExchangeMessage(String text, {bool error = false}) {
    setState(() {
      _exchangeMessage = text;
      _exchangeMessageIsError = error;
    });
  }

  void _clearExchangeMessage() {
    if (_exchangeMessage == null) return;
    setState(() {
      _exchangeMessage = null;
      _exchangeMessageIsError = false;
    });
  }

  Map<String, dynamic> _buildSaveBody() {
    return {
      'default_shipping_markup_percent': _parseNum(_shippingMarkup.text) ?? 30,
      'default_final_markup_percent': _parseNum(_finalMarkup.text) ?? 0,
      'default_hourly_rate_programming': _parseNum(_rateProgramming.text) ?? 350,
      'default_hourly_rate_setup': _parseNum(_rateSetup.text) ?? 350,
      'default_hourly_rate_first_run': _parseNum(_rateFirstRun.text) ?? 350,
      'default_hourly_rate_production': _parseNum(_rateProduction.text) ?? 269,
      'exchange_rate_usd_to_cad': _parseNum(_exchangeRate.text) ?? 1.3,
      'exchange_rate_auto_update': _exchangeRateAutoUpdate,
      if (_exchangeRateLastUpdated != null && _exchangeRateLastUpdated!.isNotEmpty)
        'exchange_rate_last_updated': _exchangeRateLastUpdated,
    };
  }

  Future<void> _save() async {
    if (_settingsId == null) return;
    setState(() => _saving = true);
    try {
      await PocketBaseService().updateShopSettings(_settingsId!, _buildSaveBody());
      if (!mounted) return;

      ExchangeRateAutoUpdateResult? rateResult;
      if (_exchangeRateAutoUpdate) {
        rateResult =
            await ExchangeRateService.instance.autoUpdateShopExchangeRateIfEnabled(
          force: true,
        );
        if (!mounted) return;
      }

      await _reloadFromServer();
      if (!mounted) return;
      _clearExchangeMessage();

      var message = 'Settings saved.';
      var messageIsError = false;
      if (rateResult != null) {
        if (rateResult.failed) {
          message =
              'Settings saved, but could not fetch the latest exchange rate.';
          messageIsError = true;
        } else if (rateResult.updated && rateResult.rate != null) {
          message =
              'Settings saved. Exchange rate updated to ${rateResult.rate!.toStringAsFixed(4)}.';
        }
      }
      _showMessage(message, error: messageIsError);
    } catch (e) {
      if (!mounted) return;
      _showMessage('Failed to save. Check the console.', error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _fetchRate() async {
    setState(() {
      _fetchingRate = true;
      _exchangeMessage = null;
    });
    try {
      final rate = await fetchUsdCadExchangeRate();
      if (!mounted) return;
      if (rate != null) {
        final formatted = rate.toStringAsFixed(4);
        setState(() {
          _exchangeRate.text = formatted;
          _exchangeRateLastUpdated = DateTime.now().toUtc().toIso8601String();
        });
        _showExchangeMessage('Rate updated to $formatted. Click Save to store.');
      } else {
        _showExchangeMessage('Could not fetch rate. Try again later.', error: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showExchangeMessage('Failed to fetch rate.', error: true);
    } finally {
      if (mounted) setState(() => _fetchingRate = false);
    }
  }

  String? _formatLastUpdated(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('MMM d, yyyy HH:mm').format(dt);
    } catch (_) {
      return raw;
    }
  }

  Color _mutedTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);
  }

  Widget _cardTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : const Color(0xFF111827),
        ),
      ),
    );
  }

  Widget _cardHint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: _mutedTextColor(context)),
      ),
    );
  }

  Widget _settingsCard(BuildContext context, {required Widget child}) {
    return QuoteSidebarCard(child: child);
  }

  Widget _numField(String label, TextEditingController controller) {
    return QuoteSidebarField(
      label: label,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _exchangeRateField() {
    return QuoteSidebarField(
      label: 'Rate',
      controller: _exchangeRate,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) {
        setState(() => _clearExchangeMessage());
      },
    );
  }

  Widget _exchangeInlineMessage(BuildContext context) {
    if (_exchangeMessage == null) return const SizedBox.shrink();
    final isError = _exchangeMessageIsError;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isError
              ? (Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF7F1D1D)
                  : const Color(0xFFFEE2E2))
              : (Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E3A5F)
                  : const Color(0xFFEFF6FF)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isError
                ? (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFB91C1C)
                    : const Color(0xFFFECACA))
                : (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFBFDBFE)),
          ),
        ),
        child: Text(
          _exchangeMessage!,
          style: TextStyle(
            fontSize: 14,
            color: isError
                ? (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFFECACA)
                    : const Color(0xFF991B1B))
                : (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFDBEAFE)
                    : const Color(0xFF1E40AF)),
          ),
        ),
      ),
    );
  }

  Widget _twoFieldGrid(List<Widget> fields) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 400) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < fields.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(child: fields[i]),
              ],
            ],
          );
        }
        return Column(
          children: [
            for (var i = 0; i < fields.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              fields[i],
            ],
          ],
        );
      },
    );
  }

  Widget _markupsCard(BuildContext context) {
    return _settingsCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _cardTitle(context, 'Default markups'),
          _cardHint(context, 'Used when creating a new quote.'),
          _twoFieldGrid([
            _numField('Material markup (%)', _shippingMarkup),
            _numField('Final markup (%)', _finalMarkup),
          ]),
        ],
      ),
    );
  }

  Widget _hourlyRatesCard(BuildContext context) {
    return _settingsCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _cardTitle(context, 'Default hourly rates (CAD)'),
          _cardHint(context, 'Used when creating a new quote.'),
          _twoFieldGrid([
            _numField('Programming', _rateProgramming),
            _numField('Setup', _rateSetup),
          ]),
          const SizedBox(height: 12),
          _twoFieldGrid([
            _numField('First run', _rateFirstRun),
            _numField('Production', _rateProduction),
          ]),
        ],
      ),
    );
  }

  Widget _fetchRateButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return OutlinedButton.icon(
      onPressed: _fetchingRate ? null : _fetchRate,
      icon: _fetchingRate
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isDark ? Colors.white : const Color(0xFF374151),
              ),
            )
          : Icon(Icons.currency_exchange, size: 18, color: _mutedTextColor(context)),
      label: Text(
        _fetchingRate ? 'Fetching…' : 'Fetch latest rate',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        foregroundColor: isDark ? Colors.white : const Color(0xFF1F2937),
        backgroundColor: isDark ? const Color(0xFF4B5563) : const Color(0xFFF9FAFB),
        side: BorderSide(
          color: isDark ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _exchangeCard(BuildContext context) {
    final lastUpdated = _formatLastUpdated(_exchangeRateLastUpdated);
    return _settingsCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _cardTitle(context, 'Exchange rate (USD → CAD)'),
          _cardHint(
            context,
            'Used for converting material costs and quote totals. Fetch from Bank of Canada or enter manually.',
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 140,
                child: _exchangeRateField(),
              ),
              const SizedBox(width: 12),
              _fetchRateButton(context),
            ],
          ),
          _exchangeInlineMessage(context),
          if (lastUpdated != null) ...[
            const SizedBox(height: 8),
            Text(
              'Last updated: $lastUpdated',
              style: TextStyle(fontSize: 14, color: _mutedTextColor(context)),
            ),
          ],
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              'Auto-update rate (e.g. on app load)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFD1D5DB)
                    : const Color(0xFF374151),
              ),
            ),
            subtitle: Text(
              _exchangeRateAutoUpdate
                  ? 'On app load (and once per day when you return to the app), fetches Bank of Canada and saves when the rate changes.'
                  : 'When enabled, the app refreshes the rate on load and daily. Manual fetch still available above.',
              style: TextStyle(fontSize: 12, color: _mutedTextColor(context)),
            ),
            value: _exchangeRateAutoUpdate,
            onChanged: (v) => setState(() => _exchangeRateAutoUpdate = v ?? false),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Quote management',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  QuoteSidebarPrimaryButton(
                    label: 'Save',
                    loading: _saving,
                    onPressed: _saving ? null : _save,
                  ),
                ],
              ),
              if (_message != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: _messageIsError
                        ? (Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF7F1D1D)
                            : const Color(0xFFFEE2E2))
                        : (Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF374151)
                            : const Color(0xFFF3F4F6)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _message!,
                    style: TextStyle(
                      fontSize: 14,
                      color: _messageIsError
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFECACA)
                              : const Color(0xFF991B1B))
                          : (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFE5E7EB)
                              : const Color(0xFF374151)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final twoCol = constraints.maxWidth >= 640;
                  final leftColumn = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _markupsCard(context),
                      const SizedBox(height: 16),
                      _hourlyRatesCard(context),
                    ],
                  );
                  final rightColumn = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _exchangeCard(context),
                    ],
                  );

                  if (twoCol) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: leftColumn),
                        const SizedBox(width: 16),
                        Expanded(child: rightColumn),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      leftColumn,
                      const SizedBox(height: 16),
                      rightColumn,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = _content(context);

    return WorkspaceScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: workspaceMenuLeading(context),
        automaticallyImplyLeading: false,
      ),
      body: body,
    );
  }
}

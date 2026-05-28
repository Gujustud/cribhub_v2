import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'exchange_rate_service.dart';

/// Runs shop exchange-rate auto-update on login and when the app resumes (if stale).
class ExchangeRateAutoUpdate extends StatefulWidget {
  final Widget child;

  const ExchangeRateAutoUpdate({super.key, required this.child});

  @override
  State<ExchangeRateAutoUpdate> createState() => _ExchangeRateAutoUpdateState();
}

class _ExchangeRateAutoUpdateState extends State<ExchangeRateAutoUpdate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _runOnLoad();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runOnResume();
    }
  }

  Future<void> _runOnLoad() async {
    if (!AuthService.instance.isLoggedIn) return;
    await ExchangeRateService.instance.autoUpdateShopExchangeRateIfEnabled();
  }

  Future<void> _runOnResume() async {
    if (!AuthService.instance.isLoggedIn) return;
    await ExchangeRateService.instance.autoUpdateShopExchangeRateIfEnabled(
      respectStaleness: true,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

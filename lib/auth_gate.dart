import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

import 'auth_service.dart';
import 'drawer_data_cache.dart';
import 'exchange_rate_auto_update.dart';
import 'idle_logout_listener.dart';
import 'login_screen.dart';
import 'pocketbase_service.dart';

/// Root navigator — used to pop back to login after sign-out.
final GlobalKey<NavigatorState> dharmaCoreNavigatorKey = GlobalKey<NavigatorState>();

/// Clears auth and pops all pushed routes so [AuthGate] can show [LoginScreen].
void signOut(BuildContext? context) {
  AuthService.instance.logout();
  DrawerDataCache.reset();
  final navigator = context != null
      ? Navigator.of(context, rootNavigator: true)
      : dharmaCoreNavigatorKey.currentState;
  if (navigator != null) {
    navigator.popUntil((route) => route.isFirst);
  }
}

/// Shows [LoginScreen] until PocketBase auth is valid, then [child].
class AuthGate extends StatefulWidget {
  final Widget child;

  const AuthGate({super.key, required this.child});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final PocketBase _pb;

  @override
  void initState() {
    super.initState();
    _pb = PocketBaseService().pb;
    _pb.authStore.onChange.listen((_) async {
      if (AuthService.instance.isLoggedIn) {
        await DrawerDataCache.refresh();
      } else {
        DrawerDataCache.reset();
      }
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.instance.isLoggedIn) {
      return const LoginScreen();
    }
    return ExchangeRateAutoUpdate(
      child: IdleLogoutListener(child: widget.child),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_gate.dart';
import 'auth_service.dart';
import 'pocketbase_service.dart';

/// Notifies [IdleLogoutListener] when `auto_logout_minutes` changes in settings.
class IdleLogoutPolicy {
  IdleLogoutPolicy._();
  static final IdleLogoutPolicy instance = IdleLogoutPolicy._();

  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void notifyChanged() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }
}

/// Signs out after `settings.auto_logout_minutes` of inactivity (0 = disabled).
class IdleLogoutListener extends StatefulWidget {
  final Widget child;

  const IdleLogoutListener({super.key, required this.child});

  @override
  State<IdleLogoutListener> createState() => _IdleLogoutListenerState();
}

class _IdleLogoutListenerState extends State<IdleLogoutListener> {
  Timer? _timer;
  int _minutes = 0;
  bool _keyboardHandlerRegistered = false;

  @override
  void initState() {
    super.initState();
    IdleLogoutPolicy.instance.addListener(_reloadMinutes);
    _reloadMinutes();
  }

  @override
  void dispose() {
    IdleLogoutPolicy.instance.removeListener(_reloadMinutes);
    _timer?.cancel();
    if (_keyboardHandlerRegistered) {
      HardwareKeyboard.instance.removeHandler(_onKey);
    }
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      _resetTimer();
    }
    return false;
  }

  Future<void> _reloadMinutes() async {
    try {
      final settings = await PocketBaseService().getShopSettings();
      final raw = (settings.data['auto_logout_minutes'] as num?)?.toInt() ?? 0;
      final minutes = raw < 0 ? 0 : raw;
      if (!mounted) return;
      setState(() => _minutes = minutes);
      _syncKeyboardHandler();
      _resetTimer();
    } catch (_) {}
  }

  void _syncKeyboardHandler() {
    if (_minutes > 0 && !_keyboardHandlerRegistered) {
      HardwareKeyboard.instance.addHandler(_onKey);
      _keyboardHandlerRegistered = true;
    } else if (_minutes <= 0 && _keyboardHandlerRegistered) {
      HardwareKeyboard.instance.removeHandler(_onKey);
      _keyboardHandlerRegistered = false;
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    if (_minutes <= 0 || !AuthService.instance.isLoggedIn) return;
    _timer = Timer(Duration(minutes: _minutes), _onIdle);
  }

  void _onIdle() {
    if (!AuthService.instance.isLoggedIn) return;
    final ctx = dharmaCoreNavigatorKey.currentContext;
    signOut(ctx);
    if (ctx != null && ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Signed out due to inactivity')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _resetTimer(),
      onPointerSignal: (_) => _resetTimer(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification ||
              notification is UserScrollNotification) {
            _resetTimer();
          }
          return false;
        },
        child: widget.child,
      ),
    );
  }
}

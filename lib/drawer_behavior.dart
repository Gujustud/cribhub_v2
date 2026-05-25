import 'package:flutter/material.dart';
import 'drawer_data_cache.dart';
import 'ui_breakpoints.dart';

/// Shared behavior for screens that use `AppDrawer`.
/// When the "keep drawer open" setting is enabled and the screen is wide
/// enough (desktop-style layout), this mixin will automatically open the
/// drawer once when the screen first appears.
mixin AutoOpenDrawerMixin<T extends StatefulWidget> on State<T> {
  bool _openedDrawerInitially = false;

  /// Each screen using this mixin must provide its `ScaffoldState` key.
  GlobalKey<ScaffoldState> get scaffoldKey;

  void maybeAutoOpenDrawer() {
    if (_openedDrawerInitially) return;
    if (!DrawerDataCache.keepDrawerOpen) return;

    final width = MediaQuery.of(context).size.width;
    if (width < kWorkspaceWideBreakpointPx) return;

    _openedDrawerInitially = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldKey.currentState?.openDrawer();
    });
  }
}


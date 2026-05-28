import 'package:flutter/material.dart';

import 'workspace_layout.dart';

/// Shared behavior for screens that use `AppDrawer`.
/// When "keep drawer open" is off (or narrow layout), opens the slide-out drawer
/// once on first visit. When pinned drawer is active, does nothing — the menu
/// is already visible via [workspaceBody].
mixin AutoOpenDrawerMixin<T extends StatefulWidget> on State<T> {
  bool _openedDrawerInitially = false;

  /// Each screen using this mixin must provide its `ScaffoldState` key.
  GlobalKey<ScaffoldState> get scaffoldKey;

  void maybeAutoOpenDrawer() {
    // Pinned drawer is handled by [workspaceBody]; overlay drawer is opened via
    // the menu button only. Auto-opening caused a visible flash on navigation.
  }
}


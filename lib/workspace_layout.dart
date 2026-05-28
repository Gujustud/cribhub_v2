import 'package:flutter/material.dart';

import 'app_drawer.dart';
import 'drawer_data_cache.dart';

/// Min width for pinned side menu when [DrawerDataCache.keepDrawerOpen] is on.
const double kPinnedDrawerBreakpointPx = 900;

/// Whether the current route should show the menu as a fixed left panel.
bool usePinnedDrawer(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= kPinnedDrawerBreakpointPx &&
      DrawerDataCache.keepDrawerOpen;
}

/// AppBar leading: hidden when pinned drawer is visible; otherwise menu button.
Widget? workspaceMenuLeading(BuildContext context) {
  if (usePinnedDrawer(context)) return null;
  return Builder(
    builder: (ctx) => IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => Scaffold.of(ctx).openDrawer(),
    ),
  );
}

/// Pushed routes: menu when overlay drawer; no back button when pinned.
Widget? workspaceBackOrMenuLeading(BuildContext context) {
  return workspaceMenuLeading(context);
}

/// Wraps [body] with pinned [AppDrawer] + divider when [usePinnedDrawer].
/// Prefer [WorkspaceScaffold], which also builds [WorkspaceTopBar].
Widget workspaceBody(BuildContext context, Widget body) {
  if (!usePinnedDrawer(context)) return body;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const AppDrawer(
        asDrawer: false,
        closeOnTap: false,
        showBrandHeader: false,
      ),
      const VerticalDivider(width: 1),
      Expanded(child: body),
    ],
  );
}

/// Drawer slot for [Scaffold]: null when pinned (drawer is in [workspaceBody]).
Widget? workspaceDrawer(BuildContext context) {
  return usePinnedDrawer(context) ? null : const AppDrawer();
}

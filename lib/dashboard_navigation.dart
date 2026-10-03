import 'package:flutter/material.dart';

import 'drawer_data_cache.dart';

/// Return to the app home route (dashboard).
void goToDashboard(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  // Root dashboard stays mounted under pushed routes; force shells to rebuild
  // so pinned side menu reflects the current preference.
  DrawerDataCache.notifyKeepDrawerOpenListeners();
}

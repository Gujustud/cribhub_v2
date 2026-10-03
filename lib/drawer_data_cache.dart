// Cache for drawer menu data so it can be preloaded and shown immediately.
import 'package:flutter/foundation.dart';

import 'pocketbase_service.dart';

class DrawerDataCache {
  static List<dynamic> categories = [];
  static bool showAllInventory = true;
  static bool _loaded = false;

  /// Notifier so [WorkspaceScaffold] (including the root dashboard) rebuilds
  /// when "keep side menu open" changes.
  static final ValueNotifier<bool> keepDrawerOpenListenable =
      ValueNotifier<bool>(false);

  static bool get keepDrawerOpen => keepDrawerOpenListenable.value;

  static set keepDrawerOpen(bool value) {
    if (keepDrawerOpenListenable.value == value) return;
    keepDrawerOpenListenable.value = value;
  }

  /// Force every [WorkspaceScaffold] to re-read [keepDrawerOpen] even if the
  /// value did not change (e.g. after popping back to the root dashboard).
  static void notifyKeepDrawerOpenListeners() {
    keepDrawerOpenListenable.notifyListeners();
  }

  static bool get isLoaded => _loaded;

  /// Clear in-memory cache (e.g. on sign-out) so the next session reloads from PB.
  static void reset() {
    categories = [];
    showAllInventory = true;
    keepDrawerOpen = false;
    _loaded = false;
  }

  /// Preload categories and app settings. Call from main() so drawer opens with data ready.
  static Future<void> preload() async {
    if (_loaded) return;
    try {
      final pb = PocketBaseService();
      final results = await Future.wait([
        pb.getCategories(),
        pb.getAppSettings(),
      ]);
      categories = results[0] as List<dynamic>;
      final settings = results[1];
      showAllInventory = settings.data['show_all_inventory_in_menu'] ?? true;
      keepDrawerOpen = readKeepDrawerOpen(settings);
      _loaded = true;
    } catch (e) {
      print('DrawerDataCache preload error: $e');
    }
  }

  /// Refresh cache (e.g. after categories/settings change). Idempotent.
  static Future<void> refresh() async {
    _loaded = false;
    await preload();
  }

  /// Accept RecordModel or Map; treat true / 1 / "true" as on.
  static bool readKeepDrawerOpen(dynamic settingsOrData) {
    dynamic raw;
    if (settingsOrData is Map) {
      raw = settingsOrData['keep_drawer_open'];
    } else {
      try {
        raw = settingsOrData.data['keep_drawer_open'];
      } catch (_) {
        return false;
      }
    }
    return raw == true || raw == 1 || raw == 'true';
  }
}

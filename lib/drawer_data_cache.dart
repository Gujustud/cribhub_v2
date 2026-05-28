// Cache for drawer menu data so it can be preloaded and shown immediately.
import 'pocketbase_service.dart';

class DrawerDataCache {
  static List<dynamic> categories = [];
  static bool showAllInventory = true;
  static bool keepDrawerOpen = false;
  static bool _loaded = false;

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
      keepDrawerOpen = settings.data['keep_drawer_open'] ?? false;
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
}

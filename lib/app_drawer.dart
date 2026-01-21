// app_drawer.dart
import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'location_management_screen.dart';
import 'brands_screen.dart';
import 'suppliers_screen.dart';
import 'categories_screen.dart';
import 'settings_screen.dart';
import 'pocketbase_service.dart';
import 'main.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  List<dynamic> _categories = [];
  bool _showAllInventory = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final pbService = PocketBaseService();
      final categories = await pbService.getCategories();
      final settings = await pbService.getAppSettings();
      
      setState(() {
        _categories = categories;
        _showAllInventory = settings.data['show_all_inventory_in_menu'] ?? true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading drawer data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Cribhub',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Navigate to home, replacing current screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
          ),
          const Divider(),
          
          // All Inventory (if enabled)
          if (_showAllInventory)
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('All Inventory'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InventoryScreen(),
                  ),
                );
              },
            ),
          
          // Dynamic categories from database (sorted by sort_order, excluding 0)
          if (!_isLoading)
            ..._categories
                .where((cat) => (cat.data['sort_order'] ?? 0) > 0)
                .map((category) => ListTile(
                      leading: const Icon(Icons.build),
                      title: Text(category.data['name']),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InventoryScreen(
                              categoryFilter: category.data['name'],
                            ),
                          ),
                        );
                      },
                    )),
          
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Management',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Brands'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BrandsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Suppliers'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SuppliersScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Locations'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LocationManagementScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to about
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'pocketbase_service.dart';
import 'app_drawer.dart';
import 'categories_screen.dart';
import 'subcategories_management_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  bool _showAllInventoryInMenu = true;
  String? _settingsId;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pbService = PocketBaseService();
      final settings = await pbService.getAppSettings();
      setState(() {
        _settingsId = settings.id;
        _showAllInventoryInMenu = settings.data['show_all_inventory_in_menu'] ?? true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateShowAllInventory(bool value) async {
    if (_settingsId == null) return;

    try {
      final pbService = PocketBaseService();
      await pbService.updateAppSettings(
        settingsId: _settingsId!,
        showAllInventoryInMenu: value,
      );

      setState(() {
        _showAllInventoryInMenu = value;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value 
              ? '"All Inventory" will appear in menu' 
              : '"All Inventory" hidden from menu'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating setting: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Inventory Management Section
                const Text(
                  'INVENTORY MANAGEMENT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.category, color: Colors.blue),
                        title: const Text('Manage Inventory Categories'),
                        subtitle: const Text('Add, edit, or delete categories'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoriesScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.account_tree, color: Colors.blue),
                        title: const Text('Manage Subcategories & Attributes'),
                        subtitle: const Text('Add, edit, or delete subcategories and attribute lists'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubcategoriesManagementScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: const Icon(Icons.inventory, color: Colors.blue),
                        title: const Text('Show "All Inventory" in menu'),
                        subtitle: const Text('Display all items menu option in drawer'),
                        value: _showAllInventoryInMenu,
                        onChanged: _updateShowAllInventory,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Future sections can go here
                const Text(
                  'DISPLAY PREFERENCES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.palette, color: Colors.grey),
                    title: const Text('Theme'),
                    subtitle: const Text('Coming soon'),
                    enabled: false,
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                const SizedBox(height: 24),
                
                const Text(
                  'DATA MANAGEMENT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.backup, color: Colors.grey),
                        title: const Text('Backup & Restore'),
                        subtitle: const Text('Coming soon'),
                        enabled: false,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.sync, color: Colors.grey),
                        title: const Text('Sync Settings'),
                        subtitle: const Text('Coming soon'),
                        enabled: false,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

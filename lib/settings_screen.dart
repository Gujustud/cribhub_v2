import 'package:flutter/material.dart';
import 'pocketbase_service.dart';
import 'app_drawer.dart';
import 'category_management_screen.dart';
import 'tool_import_config_screen.dart'; // NEW
import 'theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  bool _showAllInventoryInMenu = true;
  bool _showToolDetailsInList = true;
  bool _useCategoryButtons = false;
  bool _enableToolImport = false; // NEW
  bool _darkMode = false;
  String? _settingsId;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _darkMode = ThemeController.instance.themeMode.value == ThemeMode.dark;
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
        _showToolDetailsInList = settings.data['show_tool_details_in_list'] ?? true;
        _useCategoryButtons = settings.data['use_category_buttons'] ?? false;
        _enableToolImport = settings.data['enable_tool_import'] ?? false; // NEW
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

  Future<void> _updateShowToolDetails(bool value) async {
    if (_settingsId == null) return;

    try {
      final pbService = PocketBaseService();
      await pbService.updateAppSettings(
        settingsId: _settingsId!,
        showAllInventoryInMenu: _showAllInventoryInMenu,
        showToolDetailsInList: value,
      );

      setState(() {
        _showToolDetailsInList = value;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value 
              ? 'Tool details will show in inventory lists' 
              : 'Tool details hidden from inventory lists'),
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

  Future<void> _updateUseCategoryButtons(bool value) async {
    if (_settingsId == null) return;

    try {
      final pbService = PocketBaseService();
      await pbService.updateAppSettings(
        settingsId: _settingsId!,
        showAllInventoryInMenu: _showAllInventoryInMenu,
        showToolDetailsInList: _showToolDetailsInList,
        useCategoryButtons: value,
      );

      setState(() {
        _useCategoryButtons = value;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value 
              ? 'Category selection will show as buttons' 
              : 'Category selection will show as dropdown'),
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

  // NEW: Update tool import setting
  Future<void> _updateEnableToolImport(bool value) async {
    if (_settingsId == null) return;

    try {
      final pbService = PocketBaseService();
      await pbService.updateAppSettings(
        settingsId: _settingsId!,
        showAllInventoryInMenu: _showAllInventoryInMenu,
        showToolDetailsInList: _showToolDetailsInList,
        useCategoryButtons: _useCategoryButtons,
        enableToolImport: value,
      );

      setState(() {
        _enableToolImport = value;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value 
              ? 'Auto tool import enabled' 
              : 'Auto tool import disabled'),
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
                        title: const Text('Manage Categories & Subcategories'),
                        subtitle: const Text('Add, edit, or delete categories and subcategories'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryManagementScreen(),
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

                // Appearance Section
                const Text(
                  'APPEARANCE',
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
                      SwitchListTile(
                        secondary: const Icon(Icons.dark_mode, color: Colors.blue),
                        title: const Text('Dark mode'),
                        value: _darkMode,
                        onChanged: (value) async {
                          setState(() {
                            _darkMode = value;
                          });
                          await ThemeController.instance.setDarkMode(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Display Preferences Section
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
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.info_outline, color: Colors.blue),
                        title: const Text('Show tool details in inventory lists'),
                        subtitle: const Text('Display diameter, flutes, and length info'),
                        value: _showToolDetailsInList,
                        onChanged: _updateShowToolDetails,
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: const Icon(Icons.apps, color: Colors.blue),
                        title: const Text('Use buttons for category selection'),
                        subtitle: const Text('Show categories as buttons instead of dropdown'),
                        value: _useCategoryButtons,
                        onChanged: _updateUseCategoryButtons,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.palette, color: Colors.grey),
                        title: const Text('Theme'),
                        subtitle: const Text('Coming soon'),
                        enabled: false,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Data Management Section
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
                      // NEW: Auto Tool Import
                      SwitchListTile(
                        secondary: const Icon(Icons.cloud_download, color: Colors.blue),
                        title: const Text('Enable Auto Tool Import'),
                        subtitle: const Text('Import tool specs from vendor websites'),
                        value: _enableToolImport,
                        onChanged: _updateEnableToolImport,
                      ),
                      // NEW: Show config option only when enabled
                      if (_enableToolImport) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.settings, color: Colors.blue),
                          title: const Text('Configure Tool Import'),
                          subtitle: const Text('Manage vendors and import settings'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ToolImportConfigScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                      const Divider(height: 1),
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

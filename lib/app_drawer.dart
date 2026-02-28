// app_drawer.dart
import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'location_management_screen.dart';
import 'brands_screen.dart';
import 'suppliers_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'main.dart';
import 'drawer_data_cache.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = DrawerDataCache.categories;
    final showAllInventory = DrawerDataCache.showAllInventory;
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    // Use same background as app bar so drawer header matches top bar
    final headerBg = colorScheme.inversePrimary;
    final headerFg = appBarTheme.foregroundColor ?? colorScheme.onPrimary;
    return SizedBox(
      width: 240, // Constrain drawer width
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(color: headerBg),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text(
                'Cribhub',
                style: TextStyle(
                  color: headerFg,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
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
          if (showAllInventory)
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
          ...categories
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    ), // Close Drawer
    ); // Close SizedBox
  }
}

// NEW: Wrapper widget to enable hover-to-open drawer on desktop
class DrawerWithHover extends StatefulWidget {
  final Widget child;
  final Widget drawer;

  const DrawerWithHover({
    Key? key,
    required this.child,
    required this.drawer,
  }) : super(key: key);

  @override
  State<DrawerWithHover> createState() => _DrawerWithHoverState();
}

class _DrawerWithHoverState extends State<DrawerWithHover> {
  bool _isHovering = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: widget.drawer,
      body: Stack(
        children: [
          widget.child,
          // NEW: Hover detection area on left edge (desktop only)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 20, // Hover zone width
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovering = true;
                });
                _scaffoldKey.currentState?.openDrawer();
              },
              onExit: (_) {
                setState(() {
                  _isHovering = false;
                });
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

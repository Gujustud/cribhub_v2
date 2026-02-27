import 'package:flutter/material.dart';
import 'add_tool_screen.dart';
import 'inventory_screen.dart'; // UPDATED: Changed from tool_list_screen.dart
import 'location_management_screen.dart';
import 'brands_screen.dart';
import 'suppliers_screen.dart';
import 'return_dialog.dart';
import 'app_drawer.dart';
import 'theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.load();
  runApp(const CribhubApp());
}

class CribhubApp extends StatelessWidget {
  const CribhubApp({super.key});

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Cribhub',
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: mode,
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // NEW: For hover-to-open drawer

  void _onSearch() {
    // TODO: Implement search
    print('Searching for: ${_searchController.text}');
  }

  void _onScanBarcode() {
    // TODO: Implement barcode scanning
    print('Opening camera for barcode scan');
  }

  void _onAddTool() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddToolScreen()),
    );
  }

  void _onReturnTool() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const ReturnDialog(),
    );

    // Could handle result if needed for refreshing data
    if (result == true) {
      // Refresh any necessary data if tool was returned
    }
  }

  @override
  Widget build(BuildContext context) {
    // NEW: Stack allows us to layer the hover detection over the Scaffold
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey, // NEW: Key for programmatic drawer control
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Cribhub'),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          drawer: const AppDrawer(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Search bar with camera button (constrained width)
                  SizedBox(
                    width: 500,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search tools...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _onScanBarcode,
                          tooltip: 'Scan barcode/QR',
                        ),
                      ),
                      onSubmitted: (_) => _onSearch(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Add button
                      ElevatedButton(
                        onPressed: _onAddTool,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          backgroundColor: Colors.grey[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 24),
                            SizedBox(width: 8),
                            Text('Add Tool', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Return button
                      ElevatedButton(
                        onPressed: _onReturnTool,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          backgroundColor: Colors.grey[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.keyboard_return, size: 24),
                            SizedBox(width: 8),
                            Text('Return Tool', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // NEW: Simple hover zone for auto-opening drawer (20px on left edge)
        // User manually closes by clicking outside or pressing ESC
        Positioned(
          left: 0,
          top: 56, // Start below AppBar
          bottom: 0,
          width: 20,
          child: MouseRegion(
            opaque: false, // Don't block anything
            onEnter: (_) {
              // Only open if drawer is currently closed
              if (!(_scaffoldKey.currentState?.isDrawerOpen ?? false)) {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

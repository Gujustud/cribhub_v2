// app_drawer.dart
import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'location_management_screen.dart';
import 'brands_screen.dart';
import 'suppliers_screen.dart';
import 'purchases_screen.dart';
import 'buy_list_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'customers_screen.dart';
import 'jobs_screen.dart';
import 'inventory_home_screen.dart';
import 'quotes_screen.dart';
import 'wiki_screen.dart';
import 'maintenance_screen.dart';
import 'auth_gate.dart';
import 'auth_service.dart';
import 'dashboard_navigation.dart';
import 'drawer_data_cache.dart';

/// Width of the side menu panel (pinned or slide-out).
const double kAppDrawerWidth = 240;

/// Section label in the side nav (shadcn-like muted chrome).
class DrawerSectionLabel extends StatelessWidget {
  final String label;

  const DrawerSectionLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              fontSize: 11,
            ),
      ),
    );
  }
}

/// Single nav row with hover / press chrome that matches the theme.
class DrawerNavTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool danger;

  const DrawerNavTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
  });

  @override
  State<DrawerNavTile> createState() => _DrawerNavTileState();
}

class _DrawerNavTileState extends State<DrawerNavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = widget.danger ? scheme.error : scheme.onSurface;
    final iconColor =
        widget.danger ? scheme.error : scheme.onSurfaceVariant;
    final bg = _hovered ? scheme.secondaryContainer : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(6),
            hoverColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Icon(widget.icon, size: 18, color: iconColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.5,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  /// If true, this widget is used in `Scaffold.drawer` and will
  /// render as a slide-out drawer. If false, it renders as a
  /// fixed side panel that does not slide over content.
  final bool asDrawer;

  /// If true, tapping a menu item will call `Navigator.pop(context)`
  /// first (to close the drawer). For fixed panels this should be false.
  final bool closeOnTap;

  /// When false, omits the branded header (used with [WorkspaceTopBar]).
  final bool showBrandHeader;

  const AppDrawer({
    super.key,
    this.asDrawer = true,
    this.closeOnTap = true,
    this.showBrandHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final categories = DrawerDataCache.categories;
    final showAllInventory = DrawerDataCache.showAllInventory;
    final isJobsOnly = AuthService.instance.isJobsOnly;
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    final headerBg = appBarTheme.backgroundColor ?? colorScheme.surface;
    final headerFg = appBarTheme.foregroundColor ?? colorScheme.onSurface;

    void maybeCloseDrawer(BuildContext context) {
      if (closeOnTap && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }

    final content = ColoredBox(
      color: colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          if (showBrandHeader) ...[
            Container(
              decoration: BoxDecoration(
                color: headerBg,
                border: Border(
                  bottom: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Text(
                'DharmaCore',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: headerFg,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          DrawerNavTile(
            icon: Icons.home_outlined,
            title: 'Dashboard',
            onTap: () {
              maybeCloseDrawer(context);
              goToDashboard(context);
            },
          ),
          const DrawerSectionLabel('Inventory'),
          DrawerNavTile(
            icon: Icons.search,
            title: 'Inventory home',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
          ),
          if (showAllInventory)
            DrawerNavTile(
              icon: Icons.inventory_2_outlined,
              title: 'All Inventory',
              onTap: () {
                maybeCloseDrawer(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InventoryScreen(),
                  ),
                );
              },
            ),
          ...categories
              .where((cat) => (cat.data['sort_order'] ?? 0) > 0)
              .map(
                (category) => DrawerNavTile(
                  icon: Icons.build_outlined,
                  title: '${category.data['name']}',
                  onTap: () {
                    maybeCloseDrawer(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InventoryScreen(
                          categoryFilter: category.data['name'],
                        ),
                      ),
                    );
                  },
                ),
              ),
          const DrawerSectionLabel('Shop ERP'),
          if (!isJobsOnly)
            DrawerNavTile(
              icon: Icons.request_quote_outlined,
              title: 'Quotes',
              onTap: () {
                maybeCloseDrawer(context);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const QuotesScreen(),
                  ),
                );
              },
            ),
          DrawerNavTile(
            icon: Icons.work_outline,
            title: 'Jobs',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const JobsScreen(),
                ),
              );
            },
          ),
          DrawerNavTile(
            icon: Icons.menu_book_outlined,
            title: 'Wiki',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const WikiScreen(),
                ),
              );
            },
          ),
          DrawerNavTile(
            icon: Icons.build_circle_outlined,
            title: 'Maintenance',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const MaintenanceScreen(),
                ),
              );
            },
          ),
          const DrawerSectionLabel('Management'),
          DrawerNavTile(
            icon: Icons.people_outline,
            title: 'Customers',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const CustomersScreen(),
                ),
              );
            },
          ),
          DrawerNavTile(
            icon: Icons.label_outline,
            title: 'Brands',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BrandsScreen()),
              );
            },
          ),
          DrawerNavTile(
            icon: Icons.store_outlined,
            title: 'Suppliers',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SuppliersScreen(),
                ),
              );
            },
          ),
          DrawerNavTile(
            icon: Icons.shopping_cart_outlined,
            title: 'Purchases',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PurchasesScreen(),
                ),
              );
            },
          ),
          DrawerNavTile(
            icon: Icons.playlist_add_check,
            title: 'Buy List',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuyListScreen()),
              );
            },
          ),
          DrawerNavTile(
            icon: Icons.location_on_outlined,
            title: 'Locations',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationManagementScreen(),
                ),
              );
            },
          ),
          const DrawerSectionLabel('Account'),
          DrawerNavTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          DrawerNavTile(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              maybeCloseDrawer(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          DrawerNavTile(
            icon: Icons.logout,
            title: 'Sign out',
            danger: true,
            onTap: () {
              maybeCloseDrawer(context);
              signOut(context);
            },
          ),
        ],
      ),
    );

    if (asDrawer) {
      return SizedBox(
        width: kAppDrawerWidth,
        child: Drawer(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: content,
        ),
      );
    }

    // Fixed side panel for wide layouts — flat, bordered like shadcn sidebar.
    return Material(
      color: colorScheme.surface,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        child: SizedBox(
          width: kAppDrawerWidth,
          child: content,
        ),
      ),
    );
  }
}

/// Wrapper widget to enable hover-to-open drawer on desktop.
class DrawerWithHover extends StatefulWidget {
  final Widget child;
  final Widget drawer;

  const DrawerWithHover({
    super.key,
    required this.child,
    required this.drawer,
  });

  @override
  State<DrawerWithHover> createState() => _DrawerWithHoverState();
}

class _DrawerWithHoverState extends State<DrawerWithHover> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: widget.drawer,
      body: Stack(
        children: [
          widget.child,
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 20,
            child: MouseRegion(
              onEnter: (_) {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}

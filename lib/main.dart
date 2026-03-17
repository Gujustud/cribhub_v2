import 'dart:async';
import 'package:flutter/material.dart';
import 'add_tool_screen.dart';
import 'inventory_screen.dart';
import 'location_management_screen.dart';
import 'brands_screen.dart';
import 'suppliers_screen.dart';
import 'return_dialog.dart';
import 'app_drawer.dart';
import 'theme_controller.dart';
import 'drawer_data_cache.dart';
import 'drawer_behavior.dart';
import 'models.dart';
import 'pocketbase_service.dart';
import 'http_client_factory.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpClientFactory.init;
  await ThemeController.instance.load();
  await DrawerDataCache.preload();
  runApp(const CribhubApp());
}

class CribhubApp extends StatelessWidget {
  const CribhubApp({super.key});

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ).copyWith(
        inversePrimary: Colors.grey.shade400,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.grey,
        foregroundColor: Color(0xFF1a1a1a),
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

class _MainScreenState extends State<MainScreen> with AutoOpenDrawerMixin {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Tool>? _searchSuggestions;
  List<ToolWithLocations>? _cachedToolsWithLocations;
  Timer? _searchDebounce;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    final text = _searchController.text.trim();
    if (text.length < 2) {
      setState(() => _searchSuggestions = null);
      return;
    }
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), _updateSearchSuggestions);
  }

  Future<void> _updateSearchSuggestions() async {
    final query = _searchController.text.trim().toLowerCase();
    if (query.length < 2 || !mounted) return;

    try {
      if (_cachedToolsWithLocations == null) {
        final pb = PocketBaseService();
        final records = await pb.getTools();
        if (!mounted) return;
        final tools = records.map((r) => Tool.fromRecord(r)).toList();

        final toolsWithLocs = <ToolWithLocations>[];
        for (final tool in tools) {
          final locRecords = await pb.pb
              .collection('tool_locations')
              .getFullList(
                filter: 'tool = "${tool.id}"',
                expand: 'location',
              );
          final toolLocations = locRecords.map((r) => ToolLocation.fromRecord(r)).toList();
          toolsWithLocs.add(ToolWithLocations(tool: tool, locations: toolLocations));
        }
        _cachedToolsWithLocations = toolsWithLocs;
      }

      final rawInput = query;
      final rawTokens = rawInput.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

      // Simple bin parsing: find numeric token after the word 'bin'
      final requiredBinNumbers = <String>[];
      for (var i = 0; i < rawTokens.length; i++) {
        final t = rawTokens[i];
        if (t == 'bin' && i + 1 < rawTokens.length) {
          final next = rawTokens[i + 1];
          if (RegExp(r'^\d+$').hasMatch(next)) {
            requiredBinNumbers.add(next);
            i++;
            continue;
          }
        }
      }
      final tokens = rawTokens.where((t) => t != 'bin' && !RegExp(r'^\d+$').hasMatch(t)).toList();

      final filteredTools = <Tool>[];
      for (final twl in _cachedToolsWithLocations!) {
        final tool = twl.tool;
        final locationText = twl.locations
            .map((tl) => tl.location?.name ?? '')
            .where((s) => s.isNotEmpty)
            .join(' | ')
            .toLowerCase();

        // Bin filter: all requested numbers must appear in some 'bin xx' name.
        final binsOk = requiredBinNumbers.every((n) {
          final re = RegExp(r'\bbin\s*' + RegExp.escape(n) + r'\b');
          return re.hasMatch(locationText);
        });
        if (!binsOk) continue;

        final fields = <String>[
          tool.toolName,
          tool.brand ?? '',
          tool.modelNumber ?? '',
          tool.category,
          tool.subcategory ?? '',
          locationText,
        ].join(' ').toLowerCase();

        if (tokens.isNotEmpty && !tokens.every(fields.contains)) continue;

        // Also allow pure bin queries like "bin 16" (no extra tokens).
        if (tokens.isEmpty && requiredBinNumbers.isEmpty) {
          continue;
        }

        filteredTools.add(tool);
      }

      if (filteredTools.isEmpty && requiredBinNumbers.isEmpty) {
        // Fallback to simple tool-only search if no bin terms.
        final allTools = _cachedToolsWithLocations!.map((t) => t.tool).toList();
        filteredTools.addAll(allTools.where((t) =>
            t.toolName.toLowerCase().contains(query) ||
            (t.brand?.toLowerCase().contains(query) ?? false) ||
            (t.modelNumber?.toLowerCase().contains(query) ?? false)));
      }

      filteredTools.sort((a, b) {
        final diaA = a.diameterIn ?? (a.diameterMm != null ? (a.diameterMm! / 25.4) : double.infinity);
        final diaB = b.diameterIn ?? (b.diameterMm != null ? (b.diameterMm! / 25.4) : double.infinity);
        final cmpDia = diaA.compareTo(diaB);
        if (cmpDia != 0) return cmpDia;
        final flA = a.flutes ?? 0x7fffffff;
        final flB = b.flutes ?? 0x7fffffff;
        final cmpFl = flA.compareTo(flB);
        if (cmpFl != 0) return cmpFl;
        final lenA = a.fluteLength ?? double.infinity;
        final lenB = b.fluteLength ?? double.infinity;
        return lenA.compareTo(lenB);
      });

      final matches = filteredTools.take(3).toList();
      if (mounted) setState(() => _searchSuggestions = matches);
    } catch (e) {
      if (mounted) setState(() => _searchSuggestions = null);
    }
  }

  void _openToolDetails(Tool tool) {
    _searchController.clear();
    setState(() => _searchSuggestions = null);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddToolScreen(tool: tool)),
    );
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
    maybeAutoOpenDrawer();

    final isWide = MediaQuery.of(context).size.width >= 900;
    final usePermanentDrawer = isWide && DrawerDataCache.keepDrawerOpen;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isNarrow = screenWidth < 600;

    final content = Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 420,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              // Search bar: full width on narrow screens, max 500 on wide
              SizedBox(
                width: isNarrow ? screenWidth - 48 : 500,
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
                onSubmitted: (_) {
                  final q = _searchController.text.trim();
                  if (q.isEmpty) {
                    FocusScope.of(context).unfocus();
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InventoryScreen(initialSearchQuery: q),
                    ),
                  );
                },
              ),
            ),
            if ((_searchSuggestions?.length ?? 0) > 0) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: isNarrow ? screenWidth - 48 : 500,
                child: Card(
                  elevation: 4,
                  child: Builder(
                    builder: (context) {
                      final list = _searchSuggestions!;
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final tool = list[i];
                          final category = tool.category;
                          return ListTile(
                            title: Text(tool.toolName),
                            subtitle: category.isNotEmpty
                                ? Text(category)
                                : null,
                            onTap: () => _openToolDetails(tool),
                          );
                        },
                      );
                    },
                  ),
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _onAddTool,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _onReturnTool,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        Text('Return', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cribhub'),
        leading: usePermanentDrawer
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
      ),
      drawer: usePermanentDrawer ? null : const AppDrawer(),
      body: usePermanentDrawer
          ? Row(
              children: [
                const AppDrawer(asDrawer: false, closeOnTap: false),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            )
          : content,
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}

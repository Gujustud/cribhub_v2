import 'dart:async';

import 'package:flutter/material.dart';

import 'add_tool_screen.dart';
import 'drawer_behavior.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';
import 'inventory_screen.dart';
import 'models.dart';
import 'pocketbase_service.dart';
import 'return_dialog.dart';

/// Full-screen tool search home (original DharmaCore startup screen).
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _ToolSearchIndexEntry {
  final ToolWithLocations toolWithLocations;
  final String locationTextLower;
  final String fieldsLower;

  _ToolSearchIndexEntry({
    required this.toolWithLocations,
    required this.locationTextLower,
    required this.fieldsLower,
  });
}

class _MainScreenState extends State<MainScreen> with AutoOpenDrawerMixin {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Tool>? _searchSuggestions;
  List<_ToolSearchIndexEntry>? _cachedSearchEntries;
  bool _loadingSearchCache = false;
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
      if (_cachedSearchEntries == null && !_loadingSearchCache) {
        _loadingSearchCache = true;

        final pb = PocketBaseService();
        final records = await pb.getTools();
        if (!mounted) return;
        final tools = records.map((r) => Tool.fromRecord(r)).toList();

        final allToolLocationRecords = await pb.getAllToolLocations();
        final locationsByToolId = <String, List<ToolLocation>>{};
        for (final r in allToolLocationRecords) {
          final toolId = r.data['tool']?.toString();
          if (toolId == null || toolId.isEmpty) continue;
          (locationsByToolId[toolId] ??= <ToolLocation>[]).add(
            ToolLocation.fromRecord(r),
          );
        }

        final entries = <_ToolSearchIndexEntry>[];
        for (final tool in tools) {
          final twl = ToolWithLocations(
            tool: tool,
            locations: locationsByToolId[tool.id] ?? const <ToolLocation>[],
          );

          final locationTextLower = twl.locations
              .map((tl) => tl.location?.name ?? '')
              .where((s) => s.isNotEmpty)
              .join(' | ')
              .toLowerCase();

          final fieldsLower = [
            tool.toolName,
            tool.brand ?? '',
            tool.modelNumber ?? '',
            tool.category,
            tool.subcategory ?? '',
            locationTextLower,
          ].join(' ').toLowerCase();

          entries.add(
            _ToolSearchIndexEntry(
              toolWithLocations: twl,
              locationTextLower: locationTextLower,
              fieldsLower: fieldsLower,
            ),
          );
        }

        if (!mounted) return;
        _cachedSearchEntries = entries;
        _loadingSearchCache = false;
      }

      if (_cachedSearchEntries == null) return;
      if (query != _searchController.text.trim().toLowerCase()) return;

      final rawInput = query;
      final rawTokens = rawInput.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

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
      for (final entry in _cachedSearchEntries!) {
        final tool = entry.toolWithLocations.tool;
        final locationText = entry.locationTextLower;

        final binsOk = requiredBinNumbers.every((n) {
          final re = RegExp(r'\bbin\s*' + RegExp.escape(n) + r'\b');
          return re.hasMatch(locationText);
        });
        if (!binsOk) continue;

        final fields = entry.fieldsLower;
        if (tokens.isNotEmpty && !tokens.every(fields.contains)) continue;
        if (tokens.isEmpty && requiredBinNumbers.isEmpty) continue;

        filteredTools.add(tool);
      }

      if (filteredTools.isEmpty && requiredBinNumbers.isEmpty) {
        final allTools = _cachedSearchEntries!.map((e) => e.toolWithLocations.tool).toList();
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
      if (mounted && query == _searchController.text.trim().toLowerCase()) {
        setState(() => _searchSuggestions = matches);
      }
    } catch (e) {
      _loadingSearchCache = false;
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
  }

  void _onAddTool() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddToolScreen()),
    );
  }

  void _onReturnTool() async {
    await showDialog<bool>(
      context: context,
      builder: (context) => const ReturnDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _searchSuggestions!.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final tool = _searchSuggestions![i];
                        final category = tool.category;
                        return ListTile(
                          title: Text(tool.toolName),
                          subtitle: category.isNotEmpty ? Text(category) : null,
                          onTap: () => _openToolDetails(tool),
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

    return WorkspaceScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('DharmaCore'),
        leading: workspaceMenuLeading(context),
      ),
      body: content,
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

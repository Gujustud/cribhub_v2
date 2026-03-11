// inventory_screen.dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'pocketbase_service.dart';
import 'transfer_dialog.dart';
import 'add_tool_screen.dart';
import 'return_dialog.dart';
import 'app_drawer.dart';
import 'drawer_behavior.dart';
import 'drawer_data_cache.dart';

class InventoryScreen extends StatefulWidget {
  final String? categoryFilter; // Optional category filter
  final String? initialSearchQuery; // Optional: pre-fill search (e.g. from main page)

  const InventoryScreen({
    super.key,
    this.categoryFilter,
    this.initialSearchQuery,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> with AutoOpenDrawerMixin {
  final _pbService = PocketBaseService();
  List<ToolWithLocations> _toolsWithLocations = [];
  List<ToolWithLocations> _filteredTools = [];
  List<Location> _allLocations = [];
  bool _isLoading = true;
  bool _showToolDetails = true; // NEW: Default to true
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    if (widget.initialSearchQuery != null && widget.initialSearchQuery!.trim().isNotEmpty) {
      _searchController.text = widget.initialSearchQuery!.trim();
    }
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTools = _toolsWithLocations;
      } else {
        _filteredTools = _toolsWithLocations.where((toolWithLoc) {
          final tool = toolWithLoc.tool;
          return tool.toolName.toLowerCase().contains(query) ||
                 (tool.brand?.toLowerCase().contains(query) ?? false) ||
                 (tool.modelNumber?.toLowerCase().contains(query) ?? false) ||
                 tool.category.toLowerCase().contains(query) ||
                 (tool.subcategory?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  void _navigateToAddTool() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddToolScreen(
          initialCategory: widget.categoryFilter, // Pass the category filter
        ),
      ),
    );
    if (result == true) {
      _loadData();
    }
  }

  void _navigateToEditTool(Tool tool) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddToolScreen(tool: tool),
      ),
    );
    if (result == true) {
      _loadData();
    }
  }

  void _navigateToDuplicateTool(Tool tool) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddToolScreen(tool: tool, isDuplicate: true),
      ),
    );
    if (result == true) {
      _loadData();
    }
  }

  void _navigateToReturnTool() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const ReturnDialog(),
    );
    if (result == true) {
      _loadData();
    }
  }

  Future<void> _deleteTool(Tool tool) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tool'),
        content: Text('Are you sure you want to delete "${tool.toolName}"?\n\nThis will remove all inventory records for this tool.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Delete all tool_locations first
        final toolLocationRecords = await _pbService.pb
            .collection('tool_locations')
            .getFullList(filter: 'tool = "${tool.id}"');
        
        for (final record in toolLocationRecords) {
          await _pbService.pb.collection('tool_locations').delete(record.id);
        }
        
        // Delete the tool
        await _pbService.pb.collection('inventory').delete(tool.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tool "${tool.toolName}" deleted'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
        _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting tool: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // NEW: Load app settings first
      final settings = await _pbService.getAppSettings();
      final showDetails = settings.data['show_tool_details_in_list'] ?? true;
      
      // Load all locations first
      final locationRecords = await _pbService.getLocations();
      _allLocations = locationRecords.map((r) => Location.fromRecord(r)).toList();

      // Load all tools
      final toolRecords = await _pbService.getTools();
      List<Tool> tools = toolRecords.map((r) => Tool.fromRecord(r)).toList();

      // NEW: Filter by category if specified (case-insensitive, trim)
      if (widget.categoryFilter != null) {
        final filterName = widget.categoryFilter!.trim().toLowerCase();
        tools = tools.where((tool) {
          final toolCategory = (tool.category).trim().toLowerCase();
          return toolCategory == filterName;
        }).toList();
      }

      // For each tool, load its locations with expand
      final toolsWithLocs = <ToolWithLocations>[];
      for (final tool in tools) {
        final toolLocationRecords = await _pbService.pb
            .collection('tool_locations')
            .getFullList(
              filter: 'tool = "${tool.id}"',
              expand: 'location',
            );

        final toolLocations = toolLocationRecords
            .map((r) => ToolLocation.fromRecord(r))
            .toList();

        toolsWithLocs.add(ToolWithLocations(
          tool: tool,
          locations: toolLocations,
        ));
      }

      // Sort by diameter (SMALLEST first, tools with no diameter go to end)
      toolsWithLocs.sort((a, b) {
        // Get diameter for sorting (prefer inches, fallback to mm)
        final aDia = a.tool.diameterIn ?? a.tool.diameterMm ?? 0.0;
        final bDia = b.tool.diameterIn ?? b.tool.diameterMm ?? 0.0;

        // Tools with no diameter go to the end
        if (aDia == 0.0 && bDia > 0.0) return 1;  // a goes after b
        if (bDia == 0.0 && aDia > 0.0) return -1; // a goes before b

        // Sort by diameter ASCENDING (smallest first), then by name
        if (aDia != bDia) {
          return aDia.compareTo(bDia);
        }

        return a.tool.toolName.compareTo(b.tool.toolName);
      });

      setState(() {
        _toolsWithLocations = toolsWithLocs;
        _filteredTools = toolsWithLocs;
        _showToolDetails = showDetails;
        _isLoading = false;
      });
      // Re-apply search filter when opening with initialSearchQuery (e.g. from main page)
      _onSearchChanged();
    } catch (e, stackTrace) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleTransfer({
    required Tool tool,
    required ToolLocation sourceLocation,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => TransferDialog(
        tool: tool,
        sourceLocation: sourceLocation,
        allLocations: _allLocations,
      ),
    );

    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();

    final isWide = MediaQuery.of(context).size.width >= 900;
    final usePermanentDrawer = isWide && DrawerDataCache.keepDrawerOpen;
    final isNarrow = MediaQuery.of(context).size.width < 600;

    final bodyContent = Column(
      children: [
        // Top action bar with search and buttons (centered)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isNarrow
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search tools...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _navigateToAddTool,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                                  backgroundColor: Colors.grey[700],
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, size: 24),
                                    SizedBox(width: 8),
                                    Text('Add Tool', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _navigateToReturnTool,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                                  backgroundColor: Colors.grey[700],
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.keyboard_return, size: 24),
                                    SizedBox(width: 8),
                                    Text('Return Tool', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 3,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search tools...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _navigateToAddTool,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                          onPressed: _navigateToReturnTool,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
            ),
          ),
        ),

        // Tool list (takes remaining space)
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: $_errorMessage',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _filteredTools.isEmpty && _searchController.text.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No tools found for "${_searchController.text}"',
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : _filteredTools.isEmpty
                          ? const Center(
                              child: Text(
                                'No tools found.\nAdd some tools to get started!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredTools.length,
                              itemBuilder: (context, index) {
                                return ToolCard(
                                  toolWithLocations: _filteredTools[index],
                                  allLocations: _allLocations,
                                  showToolDetails: _showToolDetails, // NEW
                                  onTap: () => _navigateToEditTool(_filteredTools[index].tool),
                                  onEdit: () => _navigateToEditTool(_filteredTools[index].tool),
                                  onDuplicate: () => _navigateToDuplicateTool(_filteredTools[index].tool),
                                  onDelete: () => _deleteTool(_filteredTools[index].tool),
                                  onTransfer: (sourceLocation) {
                                    _handleTransfer(
                                      tool: _filteredTools[index].tool,
                                      sourceLocation: sourceLocation,
                                    );
                                  },
                                );
                              },
                            ),
        ),
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.categoryFilter ?? 'All Inventory'), // UPDATED: Dynamic title
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: usePermanentDrawer
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: usePermanentDrawer ? null : const AppDrawer(),
      body: usePermanentDrawer
          ? Row(
              children: [
                const AppDrawer(asDrawer: false, closeOnTap: false),
                const VerticalDivider(width: 1),
                Expanded(child: bodyContent),
              ],
            )
          : bodyContent,
    );
  }
}

class ToolCard extends StatelessWidget {
  final ToolWithLocations toolWithLocations;
  final List<Location> allLocations;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final Function(ToolLocation) onTransfer;
  final bool showToolDetails; // NEW

  const ToolCard({
    Key? key,
    required this.toolWithLocations,
    required this.allLocations,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.onTransfer,
    required this.showToolDetails, // NEW
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tool = toolWithLocations.tool;
    final locations = toolWithLocations.sortedLocations;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column: Tool details
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.toolName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (tool.subcategory != null && tool.subcategory!.isNotEmpty) ...[
                      Text(
                        tool.subcategory!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                    ],
                    if (tool.modelNumber != null && tool.modelNumber!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Model: ${tool.modelNumber}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                    if (showToolDetails && tool.displaySpecs.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(tool.displaySpecs, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Right column: Action buttons + Location tags
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: onEdit,
                          tooltip: 'Edit',
                          color: Colors.grey[700],
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: onDuplicate,
                          tooltip: 'Duplicate',
                          color: Colors.grey[700],
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          onPressed: onDelete,
                          tooltip: 'Delete',
                          color: Colors.grey[700],
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Location tags (wrap on narrow so they don't overflow)
                    () {
                      final visibleLocations = locations.where((loc) =>
                          loc.location?.type.toLowerCase() != 'recycle').toList();
                      if (visibleLocations.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        alignment: WrapAlignment.start,
                        children: visibleLocations.map((toolLocation) {
                          return LocationTag(
                            toolLocation: toolLocation,
                            allLocations: allLocations,
                            onTap: () => onTransfer(toolLocation),
                          );
                        }).toList(),
                      );
                    }(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationTag extends StatelessWidget {
  final ToolLocation toolLocation;
  final List<Location> allLocations;
  final VoidCallback onTap;

  const LocationTag({
    Key? key,
    required this.toolLocation,
    required this.allLocations,
    required this.onTap,
  }) : super(key: key);

  // Build hierarchical path showing only names separated by dashes
  String _buildLocationPath(Location location) {
    final names = <String>[];
    var current = location;
    
    // Walk up the parent chain
    while (true) {
      names.insert(0, current.name);
      
      if (current.parentId == null || current.parentId!.isEmpty) break;
      
      // Find parent
      try {
        current = allLocations.firstWhere((loc) => loc.id == current.parentId);
      } catch (e) {
        break; // Parent not found
      }
    }
    
    return names.join('-');
  }

  @override
  Widget build(BuildContext context) {
    final location = toolLocation.location;
    final quantity = toolLocation.quantity;
    
    if (location == null) {
      return const SizedBox.shrink();
    }

    final locationPath = _buildLocationPath(location);
    final type = location.type.toLowerCase();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEmpty = quantity <= 0; // Show 0-qty as "home" location with muted style

    // Theme-aware colors: use container colors in dark mode so tags aren't overly bright
    // Empty (0-qty) uses muted outline so "home bin" stays visible
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    if (isEmpty) {
      backgroundColor = colorScheme.surfaceContainerHighest;
      borderColor = colorScheme.outline;
      textColor = colorScheme.onSurfaceVariant;
    } else if (isDark) {
      switch (type) {
        case 'toolbox':
          backgroundColor = colorScheme.errorContainer;
          borderColor = colorScheme.error;
          textColor = colorScheme.onErrorContainer;
          break;
        case 'shelf':
          backgroundColor = colorScheme.tertiaryContainer;
          borderColor = colorScheme.tertiary;
          textColor = colorScheme.onTertiaryContainer;
          break;
        case 'machine':
          backgroundColor = colorScheme.primaryContainer;
          borderColor = colorScheme.primary;
          textColor = colorScheme.onPrimaryContainer;
          break;
        default:
          backgroundColor = colorScheme.surfaceContainerHigh;
          borderColor = colorScheme.outline;
          textColor = colorScheme.onSurfaceVariant;
      }
    } else {
      switch (type) {
        case 'toolbox':
          backgroundColor = Colors.red[50]!;
          borderColor = Colors.red[300]!;
          textColor = Colors.red[900]!;
          break;
        case 'shelf':
          backgroundColor = Colors.orange[50]!;
          borderColor = Colors.orange[300]!;
          textColor = Colors.orange[900]!;
          break;
        case 'machine':
          backgroundColor = Colors.blue[50]!;
          borderColor = Colors.blue[300]!;
          textColor = Colors.blue[900]!;
          break;
        default:
          backgroundColor = Colors.grey[50]!;
          borderColor = Colors.grey[300]!;
          textColor = Colors.grey[900]!;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 280),
          child: Text(
            'Qty: $quantity • $locationPath',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

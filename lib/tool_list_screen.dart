// tool_list_screen.dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'pocketbase_service.dart';
import 'transfer_dialog.dart';
import 'add_tool_screen.dart';
import 'return_dialog.dart';

class ToolListScreen extends StatefulWidget {
  const ToolListScreen({super.key});

  @override
  State<ToolListScreen> createState() => _ToolListScreenState();
}

class _ToolListScreenState extends State<ToolListScreen> {
  final _pbService = PocketBaseService();
  List<ToolWithLocations> _toolsWithLocations = [];
  List<ToolWithLocations> _filteredTools = [];
  List<Location> _allLocations = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
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
      MaterialPageRoute(builder: (context) => const AddToolScreen()),
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
        await _pbService.pb.collection('tools').delete(tool.id);
        
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
      // Load all locations first
      final locationRecords = await _pbService.getLocations();
      _allLocations = locationRecords.map((r) => Location.fromRecord(r)).toList();

      // Load all tools
      final toolRecords = await _pbService.getTools();
      final tools = toolRecords.map((r) => Tool.fromRecord(r)).toList();

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
        _isLoading = false;
      });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tool Inventory'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Top action bar with search and buttons
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
            child: Row(
              children: [
                // Search field
                Expanded(
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

                // Add Tool button (matching main screen colors)
                ElevatedButton.icon(
                  onPressed: _navigateToAddTool,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Tool'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 8),

                // Return Tool button (matching main screen colors)
                ElevatedButton.icon(
                  onPressed: _navigateToReturnTool,
                  icon: const Icon(Icons.keyboard_return),
                  label: const Text('Return Tool'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
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
      ),
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

  const ToolCard({
    Key? key,
    required this.toolWithLocations,
    required this.allLocations,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.onTransfer,
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tool.category,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                    if (tool.subcategory != null && tool.subcategory!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(tool.subcategory!, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                    if (tool.displaySpecs.isNotEmpty) ...[
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
                          color: Colors.blue,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: onDuplicate,
                          tooltip: 'Duplicate',
                          color: Colors.green,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          onPressed: onDelete,
                          tooltip: 'Delete',
                          color: Colors.red,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Location tags
                    () {
                      // Filter out recycle locations
                      final visibleLocations = locations.where((loc) => 
                        loc.location?.type.toLowerCase() != 'recycle'
                      ).toList();
                      
                      if (visibleLocations.isEmpty) {
                        return Center(
                          child: Text(
                            'No locations',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        );
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: visibleLocations.map((toolLocation) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: LocationTag(
                              toolLocation: toolLocation,
                              allLocations: allLocations,
                              onTap: () => onTransfer(toolLocation),
                            ),
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

    if (quantity <= 0) {
      return const SizedBox.shrink();
    }

    final locationPath = _buildLocationPath(location);
    final type = location.type.toLowerCase();
    
    // Define colors based on type
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          'Qty: $quantity • $locationPath',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

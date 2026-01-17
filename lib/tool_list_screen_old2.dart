// tool_list_screen.dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'pocketbase_service.dart';
import 'transfer_dialog.dart';
import 'add_tool_screen.dart';

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
    _loadData();
    _searchController.addListener(_onSearchChanged);
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

  void _navigateToAddTool() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddToolScreen()),
    ).then((_) {
      // Refresh data after returning from add screen
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load all locations first
      final locationRecords = await _pbService.getLocations();
      print('DEBUG: locationRecords type: ${locationRecords.runtimeType}');
      print('DEBUG: locationRecords length: ${locationRecords.length}');
      if (locationRecords.isNotEmpty) {
        final firstRecord = locationRecords[0];
        print('DEBUG: first record type: ${firstRecord.runtimeType}');
        print('DEBUG: first record: $firstRecord');
        print('DEBUG: trying to access .id: ${firstRecord.id}');
        print('DEBUG: trying to access .data: ${firstRecord.data}');
      }

      _allLocations = locationRecords.map((r) {
        print('DEBUG: Converting record: ${r.id}');
        return Location.fromRecord(r);
      }).toList();

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

      setState(() {
        _toolsWithLocations = toolsWithLocs;
        _filteredTools = toolsWithLocs;
        _isLoading = false;
      });
    } catch (e) {
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
    print('🚀 _handleTransfer called with tool: ${tool.toolName}, location: ${sourceLocation.location?.name}');
    print('🚀 sourceLocation.quantity: ${sourceLocation.quantity}');
    print('🚀 sourceLocation.locationId: ${sourceLocation.locationId}');
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => TransferDialog(
        tool: tool,
        sourceLocation: sourceLocation,
        allLocations: _allLocations,
      ),
    );

    if (result == true) {
      // Refresh data after successful transfer
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
          // Search bar and Add button row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Search field (takes most space)
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
                // Add button
                ElevatedButton.icon(
                  onPressed: _navigateToAddTool,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Tool'),
                  style: ElevatedButton.styleFrom(
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
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _filteredTools.length,
                                itemBuilder: (context, index) {
                                  return ToolCard(
                                    toolWithLocations: _filteredTools[index],
                                    allLocations: _allLocations,
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
  final Function(ToolLocation) onTransfer;

  const ToolCard({
    Key? key,
    required this.toolWithLocations,
    required this.allLocations,
    required this.onTransfer,
  }) : super(key: key);

  // Helper method to get location breakdown by type
  String _getLocationBreakdown(List<ToolLocation> locations) {
    final breakdown = <String>[];

    // Group by location type
    final byType = <String, int>{};
    for (final toolLocation in locations) {
      if (toolLocation.location != null && toolLocation.quantity > 0) {
        final type = toolLocation.location!.type.toLowerCase();
        byType[type] = (byType[type] ?? 0) + toolLocation.quantity;
      }
    }

    // Create readable breakdown
    if (byType.containsKey('toolbox')) breakdown.add('TB:${byType['toolbox']}');
    if (byType.containsKey('shelf')) breakdown.add('SH:${byType['shelf']}');
    if (byType.containsKey('machine')) breakdown.add('MC:${byType['machine']}');
    if (byType.containsKey('recycle')) breakdown.add('RC:${byType['recycle']}');

    return breakdown.isEmpty ? 'No locations' : breakdown.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final tool = toolWithLocations.tool;
    final locations = toolWithLocations.sortedLocations;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),  // Add margin back for ListView
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),  // Restore larger padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: Tool details
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tool name
                  Text(
                    tool.toolName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Brand and model number
                  if (tool.brand != null || tool.modelNumber != null) ...[
                    Row(
                      children: [
                        if (tool.brand != null) ...[
                          Text(
                            tool.brand!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        if (tool.brand != null && tool.modelNumber != null) ...[
                          const Text(' • ', style: TextStyle(color: Colors.grey)),
                        ],
                        if (tool.modelNumber != null) ...[
                          Text(
                            tool.modelNumber!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Category and subcategory
                  Text(
                    tool.category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (tool.subcategory != null && tool.subcategory!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      tool.subcategory!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  // Total quantity with breakdown
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total: ${toolWithLocations.totalQuantity}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getLocationBreakdown(locations),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Right column: Location tags (inventory buttons)
            Expanded(
              flex: 2,
              child: locations.isEmpty
                  ? Center(
                      child: Text(
                        'No locations',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: locations.map((toolLocation) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: LocationTag(
                              toolLocation: toolLocation,
                              allLocations: allLocations,
                              onTap: () {
                                print('🔄 ToolCard onTap triggered for location: ${toolLocation.location?.name}');
                                print('🔄 onTransfer function: $onTransfer');
                                print('🔄 toolLocation: $toolLocation');
                                onTransfer(toolLocation);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
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

  // Helper method to build full location path
  String _getFullLocationPath(Location location, List<Location> allLocations) {
    final parts = <String>[];
    var current = location;

    // Build path by walking up parent relationships
    while (current != null) {
      parts.insert(0, current.name);
      final parentId = current.parentId;

      if (parentId == null || parentId.isEmpty) break;

      try {
        current = allLocations.firstWhere(
          (loc) => loc.id == parentId,
        );
      } catch (e) {
        break; // Parent not found
      }
    }

    return parts.join(' - ');
  }

  @override
  Widget build(BuildContext context) {
    final location = toolLocation.location;
    final quantity = toolLocation.quantity;
    final hasQuantity = quantity > 0;

    if (location == null) {
      return const SizedBox.shrink();
    }

    // Build full hierarchical location path
    final locationPath = _getFullLocationPath(location, allLocations);

    final colors = location.colors;

    if (hasQuantity) {
      // Filled style for Qty > 0
      return GestureDetector(
        onTap: () {
          print('🎯 LocationTag GestureDetector tapped (filled): $locationPath (qty: $quantity)');
          print('🎯 onTap function: $onTap');
          if (onTap != null) {
            onTap();
          } else {
            print('🎯 onTap is null!');
          }
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 32, minWidth: 60), // Ensure minimum tap area
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(colors.fillColor),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(colors.borderColor),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  locationPath,  // Now shows full path like "Toolbox A - Drawer B - Row C - Bin 27"
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(colors.textColor),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$quantity',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(colors.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Outlined style for Qty: 0
      return GestureDetector(
        onTap: () {
          print('🎯 LocationTag GestureDetector tapped (outlined): $locationPath (qty: $quantity)');
          print('🎯 onTap function: $onTap');
          if (onTap != null) {
            onTap();
          } else {
            print('🎯 onTap is null!');
          }
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 32, minWidth: 60), // Ensure minimum tap area
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[400]!,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  locationPath,  // Full path for Qty: 0 tags too
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '0',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}


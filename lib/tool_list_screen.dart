// tool_list_screen.dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'pocketbase_service.dart';
import 'transfer_dialog.dart';

class ToolListScreen extends StatefulWidget {
  const ToolListScreen({super.key});

  @override
  State<ToolListScreen> createState() => _ToolListScreenState();
}

class _ToolListScreenState extends State<ToolListScreen> {
  final _pbService = PocketBaseService();
  List<ToolWithLocations> _toolsWithLocations = [];
  List<Location> _allLocations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
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

      setState(() {
        _toolsWithLocations = toolsWithLocs;
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
              : _toolsWithLocations.isEmpty
                  ? const Center(
                      child: Text(
                        'No tools found.\nAdd some tools to get started!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _toolsWithLocations.length,
                      itemBuilder: (context, index) {
                        return ToolCard(
                          toolWithLocations: _toolsWithLocations[index],
                          allLocations: _allLocations,
                          onTransfer: (sourceLocation) {
                            _handleTransfer(
                              tool: _toolsWithLocations[index].tool,
                              sourceLocation: sourceLocation,
                            );
                          },
                        );
                      },
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

  @override
  Widget build(BuildContext context) {
    final tool = toolWithLocations.tool;
    final locations = toolWithLocations.sortedLocations;

    return Card(
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
            
            // Right column: Location tags (stacked vertically)
            Expanded(
              flex: 2,
              child: () {
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
          borderRadius: BorderRadius.circular(4), // Small rounded corners
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

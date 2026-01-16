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
      body: _isLoading
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
  final Function(ToolLocation) onTransfer;

  const ToolCard({
    Key? key,
    required this.toolWithLocations,
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
                  // Tool name
                  Text(
                    tool.toolName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Category
                  Text(
                    tool.category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  // Subcategory
                  if (tool.subcategory != null && tool.subcategory!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      tool.subcategory!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                  
                  // Specs (diameter, flutes, model)
                  if (tool.displaySpecs.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      tool.displaySpecs,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  
                  // Total quantity
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      'Total Qty: ${toolWithLocations.totalQuantity}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Right column: Location tags (stacked vertically)
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
                  : Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      alignment: WrapAlignment.end,
                      children: locations.map((toolLocation) {
                        return LocationTag(
                          toolLocation: toolLocation,
                          onTap: () => onTransfer(toolLocation),
                        );
                      }).toList(),
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
  final VoidCallback onTap;

  const LocationTag({
    Key? key,
    required this.toolLocation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = toolLocation.location;
    final quantity = toolLocation.quantity;
    final hasQuantity = quantity > 0;
    
    if (location == null) {
      return const SizedBox.shrink();
    }

    final colors = location.colors;

    if (hasQuantity) {
      // Filled style for Qty > 0
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
              Text(
                location.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(colors.textColor),
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
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
              Text(
                location.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
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

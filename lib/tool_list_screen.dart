import 'package:flutter/material.dart';
import 'pocketbase_service.dart';

class ToolListScreen extends StatefulWidget {
  const ToolListScreen({super.key});

  @override
  State<ToolListScreen> createState() => _ToolListScreenState();
}

class _ToolListScreenState extends State<ToolListScreen> {
  List<dynamic> _tools = [];
  List<dynamic> _allLocations = [];
  Map<String, String> _toolLocationTexts = {}; // Cache location texts
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pbService = PocketBaseService();
      final tools = await pbService.getTools();
      final locations = await pbService.getLocations();
      
      // Load all tool locations upfront
      final Map<String, String> locationTexts = {};
      for (var tool in tools) {
        final locationText = await _getToolLocationText(tool.id, pbService, locations);
        locationTexts[tool.id] = locationText;
        print('Cached location for ${tool.id}: $locationText');
      }
      
      print('Total cached locations: ${locationTexts.length}');
      print('Cached data: $locationTexts');
      
      setState(() {
        _tools = tools;
        _allLocations = locations;
        _toolLocationTexts = locationTexts;
        _isLoading = false;
      });
      
      print('After setState - _toolLocationTexts has ${_toolLocationTexts.length} entries');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String> _getToolLocationText(String toolId, PocketBaseService pbService, List<dynamic> locations) async {
    try {
      final toolLocations = await pbService.getToolLocations(toolId);
      
      print('Tool $toolId has ${toolLocations.length} locations');
      
      if (toolLocations.isEmpty) {
        print('Tool $toolId: Returning "Not assigned yet"');
        return 'Not assigned yet';
      }
      
      final locationTexts = <String>[];
      for (var tl in toolLocations) {
        final locationId = tl.data['location'];
        final qty = tl.data['quantity'];
        print('Tool $toolId: locationId=$locationId, qty=$qty');
        final path = pbService.getLocationPath(locationId, locations);
        print('Tool $toolId: path=$path');
        locationTexts.add('$path (Qty: $qty)');
      }
      
      final result = locationTexts.join(', ');
      print('Tool $toolId: Final result=$result');
      return result;
    } catch (e) {
      print('Error loading location for tool $toolId: $e');
      return 'Error loading';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('All Tools'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tools.isEmpty
              ? const Center(
                  child: Text(
                    'No tools yet.\nAdd some tools to get started!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _tools.length,
                  itemBuilder: (context, index) {
                    final tool = _tools[index];
                    final locationText = _toolLocationTexts[tool.id] ?? 'Loading...';
                    print('Displaying tool ${tool.id}: $locationText');
                    
                    return Card(
                      key: ValueKey(tool.id),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          tool.data['tool_name'] ?? 'Unknown Tool',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            if (tool.data['model_number'] != null && tool.data['model_number'] != '')
                              Text('Model: ${tool.data['model_number']}'),
                            Text(
                              locationText,
                              style: TextStyle(
                                color: locationText.contains('Not assigned')
                                    ? Colors.orange[700]
                                    : Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Navigate to tool detail screen
                          print('Tapped tool: ${tool.data['tool_name']}');
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
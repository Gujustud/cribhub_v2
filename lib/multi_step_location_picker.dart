// multi_step_location_picker.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pocketbase_service.dart';

class MultiStepLocationPicker extends StatefulWidget {
  final List<dynamic> allLocations;
  final Function(String locationId) onLocationSelected;
  final Future<void> Function()? onRefreshLocations; // NEW: callback to refresh
  
  const MultiStepLocationPicker({
    Key? key,
    required this.allLocations,
    required this.onLocationSelected,
    this.onRefreshLocations,
  }) : super(key: key);

  @override
  State<MultiStepLocationPicker> createState() => _MultiStepLocationPickerState();
}

class _MultiStepLocationPickerState extends State<MultiStepLocationPicker> {
  final _pbService = PocketBaseService();
  
  String? _selectedType;
  String? _selectedParentId;
  List<String> _selectedPath = []; // Track the full path of selections
  List<dynamic> _locationHierarchy = []; // Current locations to choose from
  bool _creatingNew = false;
  final _newNameController = TextEditingController();
  // When at a leaf location, cache which tools are there (for inline warning)
  String? _toolsAtLocationId;
  List<String> _toolsAtLocationNames = [];
  /// Order from "Manage Location Types" (SharedPreferences key: location_type_order)
  Map<String, int> _locationTypeOrder = {};

  @override
  void initState() {
    super.initState();
    _loadTypeOrderThenTypes();
  }

  Future<void> _loadTypeOrderThenTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final orderJson = prefs.getString('location_type_order');
    if (orderJson != null) {
      final Map<String, int> order = {};
      orderJson.split(',').forEach((pair) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          final n = int.tryParse(parts[1]);
          if (n != null) order[parts[0].toLowerCase()] = n;
        }
      });
      if (mounted) setState(() => _locationTypeOrder = order);
    }
    if (mounted) _loadTypes();
  }
  
  void _loadTypes() {
    // Get unique types from locations
    final types = widget.allLocations
        .map((loc) => loc.data['type'] as String)
        .toSet()
        .toList();
    // Sort by Manage Location Types order (1=Toolbox, 2=Machine, etc.), then alphabetically for unknowns
    types.sort((a, b) {
      final orderA = _locationTypeOrder[a.toLowerCase()] ?? 999;
      final orderB = _locationTypeOrder[b.toLowerCase()] ?? 999;
      if (orderA != orderB) return orderA.compareTo(orderB);
      return a.compareTo(b);
    });
    setState(() {
      _locationHierarchy = types.map((type) => {'type': type, 'isType': true}).toList();
    });
  }
  
  void _selectType(String type) {
    setState(() {
      _selectedType = type;
      _selectedPath = [type];
      _selectedParentId = null;
      _creatingNew = false;
      _loadLocationsForType(type);
    });
  }
  
  void _loadLocationsForType(String type) {
    // Get root locations of this type
    final locations = widget.allLocations
        .where((loc) => 
            loc.data['type'] == type && 
            (loc.data['parent'] == null || loc.data['parent'] == ''))
        .toList();
    _sortLocationsByNameNumeric(locations);
    setState(() {
      _locationHierarchy = locations;
    });
  }
  
  void _selectLocation(dynamic location) {
    setState(() {
      _selectedParentId = location.id;
      _selectedPath.add(location.data['name']);
      _creatingNew = false;
      _loadChildLocations(location.id);
    });
  }
  
  void _loadChildLocations(String parentId) {
    final children = widget.allLocations
        .where((loc) => loc.data['parent'] == parentId)
        .toList();
    _sortLocationsByNameNumeric(children);
    setState(() {
      _locationHierarchy = children;
      _toolsAtLocationId = null;
      _toolsAtLocationNames = [];
      // Don't automatically select if there are no children
      // This allows user to create new sub-locations
    });
    if (children.isEmpty) _loadToolsAtLocation(parentId);
  }

  /// Sort locations by name with numeric order: "Bin 1", "Bin 2", "Bin 14", "Bin 16".
  /// Uses trailing number if present (e.g. "Bin 14" -> 14), else full name as int, else string.
  void _sortLocationsByNameNumeric(List<dynamic> locations) {
    int? _extractNumber(String name) {
      final s = name.trim();
      final lastWord = s.split(RegExp(r'\s+')).lastOrNull;
      if (lastWord != null) {
        final n = int.tryParse(lastWord);
        if (n != null) return n;
      }
      return int.tryParse(s);
    }
    locations.sort((a, b) {
      final na = (a.data['name'] as String?) ?? '';
      final nb = (b.data['name'] as String?) ?? '';
      final ia = _extractNumber(na);
      final ib = _extractNumber(nb);
      if (ia != null && ib != null) return ia.compareTo(ib);
      return na.compareTo(nb);
    });
  }

  Future<void> _loadToolsAtLocation(String locationId) async {
    try {
      final records = await _pbService.getToolLocationsAtLocation(locationId);
      final names = <String>{};
      for (final rec in records) {
        final toolId = rec.data['tool'] as String?;
        if (toolId == null || toolId.isEmpty) continue;
        try {
          final toolRecord = await _pbService.getToolById(toolId);
          final name = toolRecord.data['tool_name'] as String?;
          if (name != null && name.trim().isNotEmpty) names.add(name.trim());
        } catch (_) {
          continue;
        }
      }
      if (mounted && _selectedParentId == locationId) {
        setState(() {
          _toolsAtLocationId = locationId;
          _toolsAtLocationNames = names.toList()..sort();
        });
      }
    } catch (_) {
      if (mounted && _selectedParentId == locationId) {
        setState(() {
          _toolsAtLocationId = locationId;
          _toolsAtLocationNames = [];
        });
      }
    }
  }
  
  void _goBack() {
    if (_selectedPath.isEmpty) return;
    
    setState(() {
      _selectedPath.removeLast();
      _creatingNew = false;
      _newNameController.clear();
      _toolsAtLocationId = null;
      _toolsAtLocationNames = [];
      
      if (_selectedPath.isEmpty) {
        // Back to type selection
        _selectedType = null;
        _selectedParentId = null;
        _loadTypes();
      } else if (_selectedPath.length == 1) {
        // Back to root locations of type
        _loadLocationsForType(_selectedPath[0]);
      } else {
        // Back to parent's parent
        final pathToParent = _selectedPath.sublist(1, _selectedPath.length);
        dynamic currentLoc;
        
        // Find the location by walking the path
        // FIXED: Removed orElse: () => null to fix type error
        for (final name in pathToParent) {
          if (currentLoc == null) {
            try {
              currentLoc = widget.allLocations.firstWhere(
                (loc) => loc.data['name'] == name && 
                         loc.data['type'] == _selectedPath[0] &&
                         (loc.data['parent'] == null || loc.data['parent'] == ''),
              );
            } catch (e) {
              // Location not found, stop searching
              break;
            }
          } else {
            try {
              currentLoc = widget.allLocations.firstWhere(
                (loc) => loc.data['name'] == name && loc.data['parent'] == currentLoc.id,
              );
            } catch (e) {
              // Location not found, stop searching
              break;
            }
          }
        }
        
        if (currentLoc != null) {
          _loadChildLocations(currentLoc.id);
          _selectedParentId = currentLoc.id;
        }
      }
    });
  }
  
  Future<void> _createNewLocation() async {
    if (_newNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }
    
    try {
      await _pbService.createLocation(
        name: _newNameController.text,
        type: _selectedType!,
        parentId: _selectedParentId,
      );
      
      // Refresh the location list in parent
      if (widget.onRefreshLocations != null) {
        await widget.onRefreshLocations!();
        // Small delay to allow parent to rebuild with new locations
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location "${_newNameController.text}" created!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Clear the text field and hide create form
      setState(() {
        _newNameController.clear();
        _creatingNew = false;
      });
      
      // Reload the current level to show the new location
      if (_selectedParentId != null) {
        _loadChildLocations(_selectedParentId!);
      } else {
        _loadLocationsForType(_selectedType!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _reloadLocations() async {
    // This would need to be passed from parent to refresh the locations list
    // For now, just close the dialog
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb path
        if (_selectedPath.isNotEmpty) ...[
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              ),
              Expanded(
                child: Text(
                  _selectedPath.join(' → '),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
        
        // Current selection options
        if (_locationHierarchy.isEmpty && !_creatingNew)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No sub-locations yet. Create one below or select this location.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              if (_toolsAtLocationId == _selectedParentId && _toolsAtLocationNames.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _toolsAtLocationNames.length <= 5
                                ? 'This location already has: ${_toolsAtLocationNames.join(', ')}. You can still select it.'
                                : 'This location already has: ${_toolsAtLocationNames.take(5).join(', ')} and ${_toolsAtLocationNames.length - 5} more. You can still select it.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_selectedParentId != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => widget.onLocationSelected(_selectedParentId!),
                      child: const Text('Select This Location'),
                    ),
                  ),
                ),
            ],
          )
        else if (!_creatingNew)
          ...(_locationHierarchy.map((item) {
            if (item is Map && item['isType'] == true) {
              // This is a type selection
              return ListTile(
                leading: Icon(_getIconForType(item['type'])),
                title: Text(item['type'].toString().toUpperCase()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectType(item['type']),
              );
            } else {
              // This is a location
              final hasChildren = widget.allLocations
                  .any((loc) => loc.data['parent'] == item.id);
              
              return ListTile(
                title: Text(item.data['name']),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectLocation(item), // Always drill into location
              );
            }
          }).toList()),
        
        const Divider(),
        
        // Create new option
        if (_selectedType != null) ...[
          if (!_creatingNew)
            ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.blue),
              title: const Text('Create New Location'),
              onTap: () {
                setState(() {
                  _creatingNew = true;
                });
              },
            )
          else ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _newNameController,
                    decoration: const InputDecoration(
                      labelText: 'New Location Name',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., Bin 5, Drawer A, Row 3',
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _creatingNew = false;
                            _newNameController.clear();
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _createNewLocation,
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }
  
  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'toolbox':
        return Icons.inbox;
      case 'machine':
        return Icons.precision_manufacturing;
      case 'shelf':
        return Icons.shelves;
      case 'recycle':
        return Icons.delete;
      default:
        return Icons.folder;
    }
  }
  
  @override
  void dispose() {
    _newNameController.dispose();
    super.dispose();
  }
}

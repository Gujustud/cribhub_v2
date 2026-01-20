// multi_step_location_picker.dart
import 'package:flutter/material.dart';
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
  
  @override
  void initState() {
    super.initState();
    _loadTypes();
  }
  
  void _loadTypes() {
    // Get unique types from locations
    final types = widget.allLocations
        .map((loc) => loc.data['type'] as String)
        .toSet()
        .toList()
      ..sort();
    
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
    
    setState(() {
      _locationHierarchy = children;
      // Don't automatically select if there are no children
      // This allows user to create new sub-locations
    });
  }
  
  void _goBack() {
    if (_selectedPath.isEmpty) return;
    
    setState(() {
      _selectedPath.removeLast();
      _creatingNew = false;
      _newNameController.clear();
      
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
        for (final name in pathToParent) {
          if (currentLoc == null) {
            currentLoc = widget.allLocations.firstWhere(
              (loc) => loc.data['name'] == name && 
                       loc.data['type'] == _selectedPath[0] &&
                       (loc.data['parent'] == null || loc.data['parent'] == ''),
              orElse: () => null,
            );
          } else {
            currentLoc = widget.allLocations.firstWhere(
              (loc) => loc.data['name'] == name && loc.data['parent'] == currentLoc.id,
              orElse: () => null,
            );
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

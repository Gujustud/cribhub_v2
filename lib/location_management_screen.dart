import 'package:flutter/material.dart';
import 'pocketbase_service.dart';

class LocationManagementScreen extends StatefulWidget {
  const LocationManagementScreen({super.key});

  @override
  State<LocationManagementScreen> createState() => _LocationManagementScreenState();
}

class _LocationManagementScreenState extends State<LocationManagementScreen> {
  List<dynamic> _locations = [];
  List<String> _locationTypes = ['toolbox', 'machine', 'shelf', 'recycle']; // Default types
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
      final locations = await pbService.getLocations();
      
      // Extract unique types from existing locations
      final existingTypes = locations
          .map((loc) => loc.data['type'] as String)
          .toSet()
          .toList();
      
      // Merge with default types
      final allTypes = {..._locationTypes, ...existingTypes}.toList();
      allTypes.sort();
      
      setState(() {
        _locations = locations;
        _locationTypes = allTypes;
        _isLoading = false;
      });
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

  void _showManageTypesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Location Types'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: _locationTypes.isEmpty
                    ? const Center(child: Text('No types yet'))
                    : ListView.builder(
                        itemCount: _locationTypes.length,
                        itemBuilder: (context, index) {
                          final type = _locationTypes[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(_getIconForType(type)),
                              title: Text(type.toUpperCase()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showEditTypeDialog(type, index);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _locationTypes.removeAt(index);
                                      });
                                      Navigator.pop(context);
                                      _showManageTypesDialog(); // Reopen to show updated list
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAddTypeDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Type'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddTypeDialog() {
    final typeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Location Type'),
        content: TextField(
          controller: typeController,
          decoration: const InputDecoration(
            labelText: 'Type Name',
            border: OutlineInputBorder(),
            hintText: 'e.g., Cart, Cabinet, Workbench',
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (typeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a type name')),
                );
                return;
              }
              
              final newType = typeController.text.toLowerCase();
              if (_locationTypes.contains(newType)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Type already exists')),
                );
                return;
              }
              
              setState(() {
                _locationTypes.add(newType);
                _locationTypes.sort();
              });
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Type "$newType" added!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditTypeDialog(String oldType, int index) {
    final typeController = TextEditingController(text: oldType);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Location Type'),
        content: TextField(
          controller: typeController,
          decoration: const InputDecoration(
            labelText: 'Type Name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (typeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a type name')),
                );
                return;
              }
              
              final newType = typeController.text.toLowerCase();
              if (_locationTypes.contains(newType) && newType != oldType) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Type already exists')),
                );
                return;
              }
              
              setState(() {
                _locationTypes[index] = newType;
                _locationTypes.sort();
              });
              
              Navigator.pop(context);
              _showManageTypesDialog(); // Reopen to show updated list
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Type renamed to "$newType"!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddLocationDialog({String? parentId, String? parentName}) {
    final nameController = TextEditingController();

    // Find parent location to inherit type for sublocations
    String locationType;
    if (parentId != null) {
      // For sublocations, inherit parent's type
      try {
        final parentLocation = _locations.firstWhere(
          (loc) => loc.id == parentId,
        );
        locationType = parentLocation.data['type'] ?? 'toolbox';
        print('Found parent: ${parentLocation.data['name']}, type: $locationType'); // Debug
      } catch (e) {
        print('Parent location not found for id: $parentId'); // Debug
        locationType = 'toolbox'; // Fallback
      }
    } else {
      // For root locations, use default
      locationType = _locationTypes.isNotEmpty ? _locationTypes.first : 'toolbox';
    }
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(parentName == null 
              ? 'Add New Location' 
              : 'Add to $parentName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (parentId == null) // Only show type for root locations
                DropdownButtonFormField<String>(
                  value: locationType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _locationTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      locationType = value!;
                    });
                  },
                ),
              if (parentId == null) const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Location Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a name')),
                  );
                  return;
                }

                try {
                  final pbService = PocketBaseService();
                  await pbService.createLocation(
                    name: nameController.text,
                    type: locationType,
                    parentId: parentId,
                  );
                  
                  Navigator.pop(context);
                  _loadData();
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location "${nameController.text}" created!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _getRootLocations() {
    return _locations.where((loc) => loc.data['parent'] == null || loc.data['parent'] == '').toList();
  }

  List<dynamic> _getChildLocations(String parentId) {
    return _locations.where((loc) => loc.data['parent'] == parentId).toList();
  }

  Widget _buildLocationTree(dynamic location, int depth) {
    final children = _getChildLocations(location.id);
    final hasChildren = children.isNotEmpty;

    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(left: depth * 16.0, top: 4, right: 4, bottom: 4),
          child: ListTile(
            leading: Icon(
              _getIconForType(location.data['type']),
              color: _getColorForType(location.data['type']),
            ),
            title: Text(
              location.data['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: depth == 0 
                ? Text(location.data['type'].toString().toUpperCase())
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    print('Add sublocation tapped for: ${location.data['name']} (id: ${location.id})');
                    _showAddLocationDialog(
                      parentId: location.id,
                      parentName: location.data['name'],
                    );
                  },
                  tooltip: 'Add sub-location',
                ),
              ],
            ),
          ),
        ),
        if (hasChildren)
          ...children.map((child) => _buildLocationTree(child, depth + 1)),
      ],
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
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

  Color _getColorForType(String type) {
    switch (type) {
      case 'toolbox':
        return Colors.blue;
      case 'machine':
        return Colors.green;
      case 'shelf':
        return Colors.orange;
      case 'recycle':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Buttons at top
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showManageTypesDialog,
                        icon: const Icon(Icons.category),
                        label: const Text('Manage Types'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showAddLocationDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Location'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // List of locations
                Expanded(
                  child: _locations.isEmpty
                      ? const Center(
                          child: Text(
                            'No locations yet.\nClick "Add Location" above to get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(8),
                          children: [
                            ..._getRootLocations().map((loc) => _buildLocationTree(loc, 0)),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
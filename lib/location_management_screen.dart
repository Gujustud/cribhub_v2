// location_management_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pocketbase_service.dart';
import 'app_drawer.dart';

class LocationManagementScreen extends StatefulWidget {
  const LocationManagementScreen({super.key});

  @override
  State<LocationManagementScreen> createState() => _LocationManagementScreenState();
}

class _LocationManagementScreenState extends State<LocationManagementScreen> {
  List<dynamic> _locations = [];
  Map<String, int> _locationTypeOrder = {
    'toolbox': 1,
    'machine': 2,
    'shelf': 3,
    'recycle': 4,
  };
  bool _isLoading = true;
  Set<String> _expandedLocations = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadExpandedState();
    _loadTypeOrder();
  }

  Future<void> _loadExpandedState() async {
    final prefs = await SharedPreferences.getInstance();
    final expanded = prefs.getStringList('expanded_locations') ?? [];
    setState(() {
      _expandedLocations = expanded.toSet();
    });
  }

  Future<void> _saveExpandedState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('expanded_locations', _expandedLocations.toList());
  }

  Future<void> _loadTypeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final orderJson = prefs.getString('location_type_order');
    if (orderJson != null) {
      final Map<String, dynamic> decoded = {};
      orderJson.split(',').forEach((pair) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          decoded[parts[0]] = int.tryParse(parts[1]) ?? 0;
        }
      });
      setState(() {
        _locationTypeOrder = decoded.map((k, v) => MapEntry(k, v as int));
      });
    }
  }

  Future<void> _saveTypeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final orderString = _locationTypeOrder.entries
        .map((e) => '${e.key}:${e.value}')
        .join(',');
    await prefs.setString('location_type_order', orderString);
  }

  void _toggleExpanded(String locationId) {
    setState(() {
      if (_expandedLocations.contains(locationId)) {
        _expandedLocations.remove(locationId);
      } else {
        _expandedLocations.add(locationId);
      }
    });
    _saveExpandedState();
  }

  List<String> get _sortedLocationTypes {
    final types = _locationTypeOrder.keys.toList();
    types.sort((a, b) => _locationTypeOrder[a]!.compareTo(_locationTypeOrder[b]!));
    return types;
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pbService = PocketBaseService();
      final locations = await pbService.getLocations();
      
      final existingTypes = locations
          .map((loc) => loc.data['type'] as String)
          .toSet()
          .toList();
      
      // Add any new types that don't have an order yet
      for (final type in existingTypes) {
        if (!_locationTypeOrder.containsKey(type)) {
          final maxOrder = _locationTypeOrder.values.isEmpty 
              ? 0 
              : _locationTypeOrder.values.reduce((a, b) => a > b ? a : b);
          _locationTypeOrder[type] = maxOrder + 1;
        }
      }
      
      setState(() {
        _locations = locations;
        _isLoading = false;
      });
      
      await _saveTypeOrder();
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
                child: _sortedLocationTypes.isEmpty
                    ? const Center(child: Text('No types yet'))
                    : ListView.builder(
                        itemCount: _sortedLocationTypes.length,
                        itemBuilder: (context, index) {
                          final type = _sortedLocationTypes[index];
                          final order = _locationTypeOrder[type]!;
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        order.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(_getIconForType(type)),
                                ],
                              ),
                              title: Text(type.toUpperCase()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showEditTypeDialog(type);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _locationTypeOrder.remove(type);
                                      });
                                      _saveTypeOrder();
                                      Navigator.pop(context);
                                      _showManageTypesDialog();
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
    final orderController = TextEditingController();
    
    // Default to next available order number
    final maxOrder = _locationTypeOrder.values.isEmpty 
        ? 0 
        : _locationTypeOrder.values.reduce((a, b) => a > b ? a : b);
    orderController.text = (maxOrder + 1).toString();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Location Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(
                labelText: 'Type Name',
                border: OutlineInputBorder(),
                hintText: 'e.g., Cart, Cabinet, Workbench',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: orderController,
              decoration: const InputDecoration(
                labelText: 'Order (lower numbers appear first)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
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
              if (_locationTypeOrder.containsKey(newType)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Type already exists')),
                );
                return;
              }
              
              final order = int.tryParse(orderController.text) ?? maxOrder + 1;
              
              setState(() {
                _locationTypeOrder[newType] = order;
              });
              
              _saveTypeOrder();
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

  void _showEditTypeDialog(String oldType) {
    final typeController = TextEditingController(text: oldType);
    final orderController = TextEditingController(
      text: _locationTypeOrder[oldType].toString()
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Location Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(
                labelText: 'Type Name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: orderController,
              decoration: const InputDecoration(
                labelText: 'Order (lower numbers appear first)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
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
              if (_locationTypeOrder.containsKey(newType) && newType != oldType) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Type already exists')),
                );
                return;
              }
              
              final order = int.tryParse(orderController.text) ?? _locationTypeOrder[oldType]!;
              
              setState(() {
                _locationTypeOrder.remove(oldType);
                _locationTypeOrder[newType] = order;
              });
              
              _saveTypeOrder();
              Navigator.pop(context);
              _showManageTypesDialog();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Type updated!'),
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

    String locationType;
    if (parentId != null) {
      try {
        final parentLocation = _locations.firstWhere(
          (loc) => loc.id == parentId,
        );
        locationType = parentLocation.data['type'] ?? _sortedLocationTypes.first;
      } catch (e) {
        locationType = _sortedLocationTypes.first;
      }
    } else {
      locationType = _sortedLocationTypes.first;
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
              if (parentId == null)
                DropdownButtonFormField<String>(
                  value: locationType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _sortedLocationTypes.map((type) {
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

  void _showEditLocationDialog(dynamic location) {
    final nameController = TextEditingController(text: location.data['name']);
    String locationType = location.data['type'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Location Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: locationType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: _sortedLocationTypes.map((type) {
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
                  await pbService.updateLocation(
                    locationId: location.id,
                    name: nameController.text,
                    type: locationType,
                    parentId: location.data['parent'],
                  );

                  Navigator.pop(context);
                  _loadData();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location "${nameController.text}" updated!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating location: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteLocationDialog(dynamic location) {
    final hasChildren = _getChildLocations(location.id).isNotEmpty;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${location.data['name']}"?'),
            if (hasChildren)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '⚠️ This location has sub-locations that will also be deleted.',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(fontStyle: FontStyle.italic),
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
              try {
                final pbService = PocketBaseService();
                await pbService.deleteLocation(location.id);

                Navigator.pop(context);
                _loadData();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Location "${location.data['name']}" deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting location: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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
    final isExpanded = _expandedLocations.contains(location.id);

    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(left: depth * 16.0, top: 4, right: 4, bottom: 4),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconForType(location.data['type']),
                  color: _getColorForType(location.data['type']),
                ),
                if (hasChildren) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _toggleExpanded(location.id),
                    child: Icon(
                      isExpanded ? Icons.expand_more : Icons.chevron_right,
                      size: 24,
                    ),
                  ),
                ],
              ],
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
                  icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  onPressed: () => _showEditLocationDialog(location),
                  tooltip: 'Edit location',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _showDeleteLocationDialog(location),
                  tooltip: 'Delete location',
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
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
        if (hasChildren && isExpanded)
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
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
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

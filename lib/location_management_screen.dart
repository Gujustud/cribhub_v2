// location_management_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pocketbase_service.dart';
import 'ui_breakpoints.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';
import 'add_tool_screen.dart';
import 'models.dart';
import 'drawer_behavior.dart';
import 'list_toolbar_widgets.dart';

class LocationManagementScreen extends StatefulWidget {
  const LocationManagementScreen({super.key});

  @override
  State<LocationManagementScreen> createState() => _LocationManagementScreenState();
}

class _LocationManagementScreenState extends State<LocationManagementScreen> with AutoOpenDrawerMixin {
  List<dynamic> _locations = [];
  Map<String, int> _locationTypeOrder = {
    'toolbox': 1,
    'machine': 2,
    'shelf': 3,
    'recycle': 4,
  };
  bool _isLoading = true;
  Set<String> _expandedLocations = {};
  String? _selectedType;
  String _searchQuery = '';
  dynamic _selectedLocation;
  List<dynamic> _contentsRecords = [];
  bool _loadingContents = false;

  final _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _panelOpen => _selectedLocation != null;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadExpandedState();
    _loadTypeOrder();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _typeLabel(String type) {
    if (type.isEmpty) return type;
    return type[0].toUpperCase() + type.substring(1);
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

        if (_selectedType == null && _sortedLocationTypes.isNotEmpty) {
          _selectedType = _sortedLocationTypes.first;
        }

        if (_selectedLocation != null) {
          final id = _selectedLocation.id;
          try {
            _selectedLocation = _locations.firstWhere((l) => l.id == id);
          } catch (_) {
            _selectedLocation = null;
            _contentsRecords = [];
            _loadingContents = false;
          }
        }
      });

      await _saveTypeOrder();
      if (_selectedLocation != null) {
        await _loadContentsFor(_selectedLocation);
      }
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

  static String _normalizeLocationName(String name) =>
      name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  /// Prevent duplicate location names under the same parent (siblings), per type.
  bool _siblingNameExists({
    required String? parentId,
    required String type,
    required String name,
    String? excludeLocationId,
  }) {
    final normalized = _normalizeLocationName(name);
    if (normalized.isEmpty) return false;

    return _locations.any((loc) {
      if (excludeLocationId != null && loc.id == excludeLocationId) return false;

      final locType = (loc.data['type'] ?? '').toString();
      if (locType != type) return false;

      final locParent = loc.data['parent'];
      final sameParent = (parentId == null || parentId.isEmpty)
          ? (locParent == null || locParent.toString().isEmpty)
          : (locParent?.toString() == parentId);
      if (!sameParent) return false;

      final locName = (loc.data['name'] ?? '').toString();
      return _normalizeLocationName(locName) == normalized;
    });
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
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Location Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Type Name',
                hintText: 'e.g., Cabinet, Drawer, etc.',
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
            onPressed: () {
              final typeName = nameController.text.toLowerCase().trim();
              if (typeName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a type name')),
                );
                return;
              }

              if (_locationTypeOrder.containsKey(typeName)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This type already exists')),
                );
                return;
              }

              setState(() {
                final maxOrder = _locationTypeOrder.values.isEmpty
                    ? 0
                    : _locationTypeOrder.values.reduce((a, b) => a > b ? a : b);
                _locationTypeOrder[typeName] = maxOrder + 1;
              });
              _saveTypeOrder();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Type "$typeName" added!'),
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
    final nameController = TextEditingController(text: oldType);
    final orderController = TextEditingController(
      text: _locationTypeOrder[oldType].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Location Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Type Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: orderController,
              decoration: const InputDecoration(
                labelText: 'Sort Order',
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
            onPressed: () async {
              final newName = nameController.text.toLowerCase().trim();
              final newOrder = int.tryParse(orderController.text) ?? 1;

              if (newName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a type name')),
                );
                return;
              }

              // Update all locations of this type to new type name
              if (oldType != newName) {
                final pbService = PocketBaseService();
                final locationsOfType = _locations.where(
                  (loc) => loc.data['type'] == oldType,
                ).toList();

                for (final loc in locationsOfType) {
                  await pbService.updateLocation(
                    locationId: loc.id,
                    name: loc.data['name'],
                    type: newName,
                    parentId: loc.data['parent'],
                  );
                }
              }

              setState(() {
                _locationTypeOrder.remove(oldType);
                _locationTypeOrder[newName] = newOrder;
              });
              _saveTypeOrder();
              await _loadData();
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Type updated to "$newName"!'),
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
    String selectedType = _selectedType ?? _sortedLocationTypes.first;
    String? nameError;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> submit() async {
            final name = nameController.text.trim();
            if (name.isEmpty) {
              setDialogState(() => nameError = 'Please enter a location name');
              return;
            }

            if (_siblingNameExists(
              parentId: parentId,
              type: selectedType,
              name: name,
            )) {
              setDialogState(() => nameError = 'A "$name" already exists here.');
              return;
            }

            try {
              final pbService = PocketBaseService();
              await pbService.createLocation(
                name: name,
                type: selectedType,
                parentId: parentId,
              );

              Navigator.pop(context);
              _loadData();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Location "$name" added!'),
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
          }

          return AlertDialog(
          title: Text(parentId == null ? 'Add Location' : 'Add Sub-Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (parentName != null) ...[
                Text(
                  'Parent: $parentName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Location Name',
                  hintText: 'e.g., Toolbox-1, Drawer-A, etc.',
                  border: OutlineInputBorder(),
                  errorText: nameError,
                ),
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => submit(),
                onChanged: (_) {
                  if (nameError != null) {
                    setDialogState(() => nameError = null);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: _sortedLocationTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getIconForType(type), color: _getColorForType(type)),
                        const SizedBox(width: 12),
                        Text(type.toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedType = value!;
                    nameError = null;
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
              onPressed: submit,
              child: const Text('Add'),
            ),
          ],
        );
        },
      ),
    );
  }

  void _showEditLocationDialog(dynamic location) {
    final nameController = TextEditingController(text: location.data['name']);
    String selectedType = location.data['type'];
    String? nameError;

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
                decoration: InputDecoration(
                  labelText: 'Location Name',
                  border: OutlineInputBorder(),
                  errorText: nameError,
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (_) {
                  if (nameError != null) {
                    setDialogState(() => nameError = null);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: _sortedLocationTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getIconForType(type), color: _getColorForType(type)),
                        const SizedBox(width: 12),
                        Text(type.toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedType = value!;
                    nameError = null;
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
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  setDialogState(() => nameError = 'Please enter a location name');
                  return;
                }

                if (_siblingNameExists(
                  parentId: location.data['parent']?.toString(),
                  type: selectedType,
                  name: name,
                  excludeLocationId: location.id,
                )) {
                  setDialogState(() => nameError = 'A "$name" already exists here.');
                  return;
                }

                try {
                  final pbService = PocketBaseService();
                  await pbService.updateLocation(
                    locationId: location.id,
                    name: name,
                    type: selectedType,
                    parentId: location.data['parent'],
                  );

                  Navigator.pop(context);
                  _loadData();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location updated to "$name"!'),
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
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteLocationDialog(dynamic location, {List<dynamic>? toolLocations}) {
    final hasChildren = _getChildLocations(location.id).isNotEmpty;
    final hasTools = toolLocations != null && toolLocations.isNotEmpty;
    final toolNames = hasTools
        ? (toolLocations!
            .map<String>((r) {
              final tool = r.expand?['tool'];
              if (tool == null) return 'Tool';
              final t = tool is List ? (tool.isNotEmpty ? tool[0] : null) : tool;
              return t?.data['tool_name'] ?? 'Tool';
            })
            .toList())
        : <String>[];

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
            if (hasTools) ...[
              const SizedBox(height: 8),
              Text(
                '⚠️ This location has ${toolNames.length} tool(s): ${toolNames.take(5).join(", ")}${toolNames.length > 5 ? "…" : ""}',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Deleting will remove tool placements here. Past history is kept but may show "Unknown location" for moves to/from this location.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
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
                await pbService.deleteToolLocationsAtLocation(location.id);
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


  void _clearSelection() {
    setState(() {
      _selectedLocation = null;
      _contentsRecords = [];
      _loadingContents = false;
    });
  }

  Future<void> _loadContentsFor(dynamic location) async {
    setState(() => _loadingContents = true);
    List<dynamic> records = [];
    try {
      records = await PocketBaseService()
          .getToolLocationsAtLocationWithTool(location.id);
    } catch (_) {}
    if (!mounted) return;
    if (_selectedLocation?.id != location.id) return;
    setState(() {
      _contentsRecords = records;
      _loadingContents = false;
    });
  }

  Future<void> _selectLocation(dynamic location) async {
    setState(() {
      _selectedLocation = location;
      _contentsRecords = [];
      _loadingContents = true;
    });
    await _loadContentsFor(location);
  }

  Future<void> _openToolFromContents(dynamic toolRecord) async {
    if (toolRecord == null) return;
    final toolModel = Tool.fromRecord(toolRecord);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddToolScreen(tool: toolModel)),
    );
    if (mounted) await _loadData();
  }

  // NEW: Get root locations filtered by selected type
  List<dynamic> _getRootLocationsByType() {
    if (_selectedType == null) return [];
    final list = _locations.where((loc) =>
      loc.data['type'] == _selectedType &&
      (loc.data['parent'] == null || loc.data['parent'] == '')
    ).toList();
    list.sort(_compareLocationRecordsByName);
    return list;
  }

  List<dynamic> _getChildLocations(String parentId) {
    final list = _locations.where((loc) => loc.data['parent'] == parentId).toList();
    list.sort(_compareLocationRecordsByName);
    return list;
  }

  /// Natural sort by location name so "Bin 2" comes before "Bin 14"; alphabetic otherwise.
  static String _nameOf(dynamic loc) =>
      (loc.data['name'] ?? '').toString().trim();

  static int _compareNatural(String a, String b) {
    final re = RegExp(r'(\d+|\D+)');
    final la = re.allMatches(a.toLowerCase()).map((m) => m.group(0)!).toList();
    final lb = re.allMatches(b.toLowerCase()).map((m) => m.group(0)!).toList();
    final len = la.length < lb.length ? la.length : lb.length;
    for (var i = 0; i < len; i++) {
      final ca = la[i], cb = lb[i];
      final na = int.tryParse(ca), nb = int.tryParse(cb);
      if (na != null && nb != null) {
        final c = na.compareTo(nb);
        if (c != 0) return c;
      } else {
        final c = ca.compareTo(cb);
        if (c != 0) return c;
      }
    }
    return la.length.compareTo(lb.length);
  }

  static int _compareLocationRecordsByName(dynamic a, dynamic b) =>
      _compareNatural(_nameOf(a), _nameOf(b));

  /// Build full hierarchical path for a location record, e.g. "Toolbox A > Drawer A > Row 2".
  String _buildLocationPathFromRecord(dynamic location) {
    final names = <String>[];
    var current = location;

    while (true) {
      final name = current.data['name']?.toString() ?? '';
      if (name.isNotEmpty) {
        names.insert(0, name);
      }

      final parentId = current.data['parent'];
      if (parentId == null || parentId.toString().isEmpty) {
        break;
      }

      try {
        current = _locations.firstWhere((loc) => loc.id == parentId);
      } catch (_) {
        break;
      }
    }

    return names.join(' > ');
  }


  bool _matchesSearch(dynamic location) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return true;
    final name = (location.data['name'] ?? '').toString().toLowerCase();
    final path = _buildLocationPathFromRecord(location).toLowerCase();
    return name.contains(q) || path.contains(q);
  }

  bool _subtreeMatches(dynamic location) {
    if (_matchesSearch(location)) return true;
    return _getChildLocations(location.id).any(_subtreeMatches);
  }

  List<dynamic> _visibleRootLocations() {
    return _getRootLocationsByType().where(_subtreeMatches).toList();
  }

  Widget _buildToolbar(bool stacked) {
    final search = InventoryListSearchField(
      controller: _searchController,
      hintText: 'Search locations…',
      onChanged: (v) => setState(() => _searchQuery = v),
      decoration: inventoryListSearchDecoration(
        context,
        hintText: 'Search locations…',
      ).copyWith(
        suffixIcon: _searchController.text.isNotEmpty
            ? inventoryListSearchClearButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
      ),
    );
    final addButton = InventoryListActionButton(
      label: 'Add Location',
      onPressed: _selectedType == null ? null : () => _showAddLocationDialog(),
    );
    final manage = TextButton(
      onPressed: _showManageTypesDialog,
      child: const Text('Manage types'),
    );
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          search,
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: addButton),
              const SizedBox(width: 8),
              manage,
            ],
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: search),
        const SizedBox(width: 12),
        addButton,
        const SizedBox(width: 8),
        manage,
      ],
    );
  }

  Widget _buildTypeChips(ColorScheme scheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final type in _sortedLocationTypes) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Icon(_getIconForType(type), size: 18),
                label: Text(_typeLabel(type)),
                selected: _selectedType == type,
                onSelected: (_) {
                  setState(() {
                    _selectedType = type;
                    if (_selectedLocation != null &&
                        '${_selectedLocation.data['type']}' != type) {
                      _selectedLocation = null;
                      _contentsRecords = [];
                      _loadingContents = false;
                    }
                  });
                },
                showCheckmark: false,
                selectedColor: scheme.secondaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _onLocationMenu(String value, dynamic location) async {
    if (value == 'edit') {
      _showEditLocationDialog(location);
    } else if (value == 'add_child') {
      _showAddLocationDialog(
        parentId: location.id,
        parentName: _buildLocationPathFromRecord(location),
      );
    } else if (value == 'delete') {
      final toolLocs = await PocketBaseService()
          .getToolLocationsAtLocationWithTool(location.id);
      if (!mounted) return;
      _showDeleteLocationDialog(location, toolLocations: toolLocs);
    }
  }

  Widget _buildLocationTree(dynamic location, int depth, {required bool usePanel}) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final titleStyle =
        textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    final muted =
        textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant);
    final children =
        _getChildLocations(location.id).where(_subtreeMatches).toList();
    final hasChildren = children.isNotEmpty;
    final isExpanded = _expandedLocations.contains(location.id) ||
        (_searchQuery.trim().isNotEmpty && hasChildren);
    final childCount = _getChildLocations(location.id).length;
    final selected = _selectedLocation?.id == location.id;

    return Column(
      children: [
        Card(
          color: selected ? scheme.secondaryContainer : null,
          margin:
              EdgeInsets.only(left: depth * 20.0, top: 4, right: 0, bottom: 4),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasChildren)
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_more : Icons.chevron_right,
                      size: 22,
                    ),
                    onPressed: () => _toggleExpanded(location.id),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                  )
                else
                  const SizedBox(width: 32),
                Icon(
                  _getIconForType(location.data['type']?.toString() ?? ''),
                  color: scheme.onSurfaceVariant,
                  size: 22,
                ),
              ],
            ),
            title: Text(
              '${location.data['name'] ?? ''}',
              style: titleStyle,
            ),
            subtitle: childCount > 0
                ? Text(
                    '$childCount sub-location${childCount == 1 ? '' : 's'}',
                    style: muted,
                  )
                : null,
            trailing: PopupMenuButton<String>(
              tooltip: 'Actions',
              onSelected: (value) => _onLocationMenu(value, location),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(
                  value: 'add_child',
                  child: Text('Add sub-location'),
                ),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
            onTap: () => _selectLocation(location),
          ),
        ),
        if (hasChildren && isExpanded)
          ...children.map(
            (child) => _buildLocationTree(child, depth + 1, usePanel: usePanel),
          ),
      ],
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'toolbox':
        return Icons.inbox_outlined;
      case 'machine':
        return Icons.precision_manufacturing_outlined;
      case 'shelf':
        return Icons.shelves;
      case 'recycle':
        return Icons.delete_outline;
      default:
        return Icons.folder_outlined;
    }
  }

  Color _getColorForType(String type) {
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  Widget _buildDetailPane(ColorScheme scheme) {
    final textTheme = Theme.of(context).textTheme;
    final muted =
        textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);

    if (_selectedLocation == null) {
      return Center(
        child: Text(
          'Select a location to see what’s inside.',
          style: muted,
        ),
      );
    }

    final loc = _selectedLocation;
    final path = _buildLocationPathFromRecord(loc);
    final name = (loc.data['name'] ?? '').toString();
    final type = (loc.data['type'] ?? '').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      path,
                      style: muted,
                    ),
                    if (type.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        _typeLabel(type),
                        style: textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Actions',
                onSelected: (value) => _onLocationMenu(value, loc),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                    value: 'add_child',
                    child: Text('Add sub-location'),
                  ),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'Tools here',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: _loadingContents
              ? const Center(child: CircularProgressIndicator())
              : _contentsRecords.isEmpty
                  ? Center(
                      child: Text(
                        'No tools at this location.',
                        style: muted,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      itemCount: _contentsRecords.length,
                      itemBuilder: (context, i) {
                        final r = _contentsRecords[i];
                        final qty = (r.data['quantity'] ?? 0).toInt();
                        final tool = r.expand?['tool'];
                        dynamic t;
                        if (tool != null) {
                          t = tool is List
                              ? (tool.isNotEmpty ? tool[0] : null)
                              : tool;
                        }
                        final toolName = t?.data['tool_name'] ?? 'Tool';
                        return Card(
                          child: ListTile(
                            title: Text(
                              '$toolName',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text('Qty: $qty', style: muted),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: scheme.onSurfaceVariant,
                            ),
                            onTap: () => _openToolFromContents(t),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted =
        textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 700;
    final usePanel = width >= kWorkspaceWideBreakpointPx;
    final roots = _visibleRootLocations();

    final listColumn = workspaceContentFrame(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(
                bottom: BorderSide(color: scheme.outlineVariant),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildToolbar(isNarrow || (usePanel && _panelOpen)),
                const SizedBox(height: 12),
                _buildTypeChips(scheme),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedType == null
                    ? Center(
                        child: Text('Select a location type', style: muted),
                      )
                    : roots.isEmpty
                        ? Center(
                            child: Text(
                              _searchQuery.trim().isNotEmpty
                                  ? 'No locations match your search.'
                                  : 'No ${_typeLabel(_selectedType!)} locations yet.\nTap Add Location above.',
                              textAlign: TextAlign.center,
                              style: muted,
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(8),
                            children: [
                              ...roots.map(
                                (loc) => _buildLocationTree(
                                  loc,
                                  0,
                                  usePanel: usePanel,
                                ),
                              ),
                            ],
                          ),
          ),
        ],
      ),
      maxWidth: usePanel && _panelOpen
          ? kWorkspacePanelContentMaxWidth
          : kWorkspaceContentMaxWidth,
    );

    final detailPane = DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: _buildDetailPane(scheme),
    );

    Widget body;
    if (usePanel && _panelOpen) {
      body = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 3, child: listColumn),
          Expanded(flex: 7, child: detailPane),
        ],
      );
    } else if (!usePanel && _panelOpen) {
      body = Column(
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: Text(
              (_selectedLocation.data['name'] ?? '').toString(),
            ),
            onTap: _clearSelection,
          ),
          const Divider(height: 1),
          Expanded(child: _buildDetailPane(scheme)),
        ],
      );
    } else {
      body = listColumn;
    }

    return WorkspaceScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Locations'),
        leading: workspaceMenuLeading(context),
      ),
      body: body,
    );
  }
}

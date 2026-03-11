// location_management_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pocketbase_service.dart';
import 'app_drawer.dart';
import 'add_tool_screen.dart';
import 'models.dart';
import 'settings_screen.dart'; // NEW: For back button
import 'drawer_behavior.dart';
import 'drawer_data_cache.dart';

/// Hover over the list icon to load and show tool names/counts at this location (cached briefly).
class _LocationContentsHoverIcon extends StatefulWidget {
  const _LocationContentsHoverIcon({
    required this.location,
    required this.onPressed,
  });

  final dynamic location;
  final VoidCallback onPressed;

  @override
  State<_LocationContentsHoverIcon> createState() => _LocationContentsHoverIconState();
}

class _LocationContentsHoverIconState extends State<_LocationContentsHoverIcon> {
  Timer? _hoverTimer;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  static final Map<String, List<dynamic>> _cache = {};
  static final Map<String, DateTime> _cacheTime = {};
  static const Duration _cacheTtl = Duration(seconds: 45);

  /// Call after location/tool data changes so hover shows fresh lists.
  static void clearCache() {
    _cache.clear();
    _cacheTime.clear();
  }

  static String _toolNameFromRecord(dynamic r) {
    final tool = r.expand?['tool'];
    if (tool == null) return 'Tool';
    final t = tool is List ? (tool.isNotEmpty ? tool[0] : null) : tool;
    return t?.data['tool_name']?.toString() ?? 'Tool';
  }

  static int _qtyFromRecord(dynamic r) {
    final q = r.data['quantity'];
    if (q is int) return q;
    return int.tryParse(q?.toString() ?? '') ?? 0;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onExit(PointerEvent event) {
    _hoverTimer?.cancel();
    _hoverTimer = null;
    _removeOverlay();
  }

  void _onEnter(PointerEvent event) {
    _hoverTimer?.cancel();
    _hoverTimer = Timer(const Duration(milliseconds: 500), _fetchAndShowOverlay);
  }

  Future<void> _fetchAndShowOverlay() async {
    if (!mounted) return;
    final id = widget.location.id as String;
    List<dynamic> records;
    final cachedAt = _cacheTime[id];
    if (cachedAt != null &&
        DateTime.now().difference(cachedAt) < _cacheTtl &&
        _cache.containsKey(id)) {
      records = List<dynamic>.from(_cache[id]!);
    } else {
      try {
        records = await PocketBaseService().getToolLocationsAtLocationWithTool(id);
      } catch (_) {
        records = [];
      }
      _cache[id] = records;
      _cacheTime[id] = DateTime.now();
    }

    if (!mounted) return;
    _removeOverlay();

    final overlay = Overlay.of(context);
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final namesWithQty = <String>[];
    for (final r in records) {
      final name = _toolNameFromRecord(r);
      final q = _qtyFromRecord(r);
      namesWithQty.add(q > 1 ? '$name (×$q)' : name);
    }

    _overlayEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        width: 320,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 36),
          followerAnchor: Alignment.topLeft,
          targetAnchor: Alignment.bottomLeft,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: namesWithQty.isEmpty
                  ? Text(
                      'No tools at this location.',
                      style: TextStyle(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${namesWithQty.length} tool${namesWithQty.length == 1 ? '' : 's'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Theme.of(ctx).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              namesWithQty.join('\n'),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        child: IconButton(
          icon: const Icon(Icons.list_alt, size: 20, color: Colors.teal),
          onPressed: widget.onPressed,
          tooltip: null, // Hover overlay shows loaded tool names/counts
        ),
      ),
    );
  }
}

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
  String? _selectedType; // NEW: Currently selected type

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

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
      
      _LocationContentsHoverIconState.clearCache();
      setState(() {
        _locations = locations;
        _isLoading = false;
        
        // Auto-select first type if none selected
        if (_selectedType == null && _sortedLocationTypes.isNotEmpty) {
          _selectedType = _sortedLocationTypes.first;
        }
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

  /// Show tools that have quantity at this location (Option B: view by location).
  Future<void> _showLocationContentsDialog(dynamic location) async {
    final path = _buildLocationPathFromRecord(location);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        content: SizedBox(
          width: 280,
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    List<dynamic> records = [];
    try {
      records = await PocketBaseService().getToolLocationsAtLocationWithTool(location.id);
    } catch (_) {}

    if (!mounted) return;
    Navigator.of(context).pop();

    if (!mounted) return;
    // Compact dialog: capped width and height so it doesn't dominate the screen.
    final listHeight = records.isEmpty
        ? 0.0
        : (records.length * 52.0 + 8).clamp(56.0, 220.0);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        titlePadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        actionsPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        title: Text(
          path,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 360,
          child: records.isEmpty
              ? const Text(
                  'No tools at this location.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                )
              : SizedBox(
                  height: listHeight,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: records.length,
                    itemBuilder: (context, i) {
                    final r = records[i];
                    final qty = (r.data['quantity'] ?? 0).toInt();
                    final tool = r.expand?['tool'];
                    dynamic t;
                    if (tool != null) {
                      t = tool is List
                          ? (tool.isNotEmpty ? tool[0] : null)
                          : tool;
                    }
                    final name = t?.data['tool_name'] ?? 'Tool';
                    return ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      title: Text(name, style: const TextStyle(fontSize: 14)),
                      subtitle: Text('Qty: $qty', style: const TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        if (t == null) return;
                        Navigator.pop(ctx);
                        final toolModel = Tool.fromRecord(t);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddToolScreen(tool: toolModel),
                          ),
                        );
                        if (mounted) _loadData();
                      },
                    );
                  },
                ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LocationContentsHoverIcon(
                  location: location,
                  onPressed: () => _showLocationContentsDialog(location),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  onPressed: () => _showEditLocationDialog(location),
                  tooltip: 'Edit location',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () async {
                    final pbService = PocketBaseService();
                    final toolLocs = await pbService.getToolLocationsAtLocationWithTool(location.id);
                    if (!mounted) return;
                    _showDeleteLocationDialog(location, toolLocations: toolLocs);
                  },
                  tooltip: 'Delete location',
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    _showAddLocationDialog(
                      parentId: location.id,
                      parentName: _buildLocationPathFromRecord(location),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerColor = theme.dividerColor;

    maybeAutoOpenDrawer();

    final isWide = MediaQuery.of(context).size.width >= 900;
    final usePermanentDrawer = isWide && DrawerDataCache.keepDrawerOpen;

    final bodyContent = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT PANEL - Location Types
              Container(
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: dividerColor)),
                    color: colorScheme.surfaceContainerLowest,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: dividerColor)),
                        ),
                        child: Text(
                          'LOCATION TYPES',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _sortedLocationTypes.length,
                          itemBuilder: (context, index) {
                            final type = _sortedLocationTypes[index];
                            final isSelected = _selectedType == type;
                            
                            return ListTile(
                              selected: isSelected,
                              selectedTileColor: colorScheme.primaryContainer,
                              leading: Icon(
                                _getIconForType(type),
                                color: _getColorForType(type),
                              ),
                              title: Text(
                                type.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedType = type;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      // Manage Types button
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: dividerColor)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _showManageTypesDialog,
                                icon: const Icon(Icons.category, size: 18),
                                label: const Text('Manage Types'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                                  );
                                },
                                icon: const Icon(Icons.arrow_back, size: 18),
                                label: const Text('Back to Settings'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // RIGHT PANEL - Locations Tree
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Add button
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: dividerColor)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedType != null
                                  ? '${_selectedType!.toUpperCase()} LOCATIONS'
                                  : 'Select a type',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_selectedType != null)
                              ElevatedButton.icon(
                                onPressed: () => _showAddLocationDialog(),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Location'),
                              ),
                          ],
                        ),
                      ),
                      
                      // Locations tree
                      Expanded(
                        child: _selectedType == null
                            ? const Center(child: Text('Select a location type'))
                            : _getRootLocationsByType().isEmpty
                                ? Center(
                                    child: Text(
                                      'No ${_selectedType!} locations yet.\nClick "Add Location" to create one.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
                                    ),
                                  )
                                : ListView(
                                    padding: const EdgeInsets.all(8),
                                    children: [
                                      ..._getRootLocationsByType().map((loc) => _buildLocationTree(loc, 0)),
                                    ],
                                  ),
                        ),
                    ],
                  ),
                ),
              ],
            );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Locations'),
        backgroundColor: colorScheme.inversePrimary,
        leading: usePermanentDrawer
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
      ),
      drawer: usePermanentDrawer ? null : const AppDrawer(),
      body: usePermanentDrawer
          ? Row(
              children: [
                const AppDrawer(asDrawer: false, closeOnTap: false),
                const VerticalDivider(width: 1),
                Expanded(child: bodyContent),
              ],
            )
          : bodyContent,
    );
  }
}

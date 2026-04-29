// add_inventory_dialog.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'multi_step_location_picker.dart';
import 'pocketbase_service.dart';
import 'models.dart';

class AddInventoryDialog extends StatefulWidget {
  final List<dynamic> allLocations;
  final List<ToolLocation>? existingLocations; // For edit mode - current locations
  final List<String>? historicalLocationIds; // NEW - IDs of past add locations
  
  const AddInventoryDialog({
    Key? key,
    required this.allLocations,
    this.existingLocations,
    this.historicalLocationIds, // NEW
  }) : super(key: key);

  @override
  State<AddInventoryDialog> createState() => _AddInventoryDialogState();
}

class _AddInventoryDialogState extends State<AddInventoryDialog> {
  final _quantityController = TextEditingController(text: '1');
  List<dynamic> _currentLocations = [];
  String? _selectedLocationId;
  String? _selectedLocationPath;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic>? _suggestions;
  Timer? _searchDebounce;
  static const int _maxSuggestions = 5;
  static const int _minSearchLength = 2;
  final GlobalKey<MultiStepLocationPickerState> _locationPickerKey =
      GlobalKey<MultiStepLocationPickerState>();

  void _submit() {
    if (_selectedLocationId == null) return;
    final qty = int.tryParse(_quantityController.text);
    if (qty == null || qty < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }
    Navigator.pop(context, {
      'quantity': qty,
      'locationId': _selectedLocationId,
    });
  }
  
  @override
  void initState() {
    super.initState();
    _currentLocations = widget.allLocations;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }
  
  Future<void> _refreshLocations() async {
    final pbService = PocketBaseService();
    final locations = await pbService.getLocations();
    setState(() {
      _currentLocations = locations;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.length < _minSearchLength) {
      setState(() => _suggestions = null);
      return;
    }
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 200), () {
      final q = query.toLowerCase();
      final paths = _currentLocations
          .map((loc) => MapEntry(loc, _buildLocationPathFromRecord(loc)))
          .where((e) => e.value.toLowerCase().contains(q))
          .toList();
      paths.sort((a, b) => a.value.compareTo(b.value));
      if (mounted) {
        setState(() {
          _suggestions = paths.take(_maxSuggestions).map((e) => e.key).toList();
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final hasExistingLocations = widget.existingLocations != null && widget.existingLocations!.isNotEmpty;
    
    // NEW: Get historical locations that don't have current inventory
    final historicalLocations = _getHistoricalLocationsWithoutInventory();
    final hasHistoricalLocations = historicalLocations.isNotEmpty;
    
    return Shortcuts(
      shortcuts: {
        // Enter confirms "Add Inventory" from anywhere in this dialog.
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              _submit();
              return null;
            },
          ),
        },
        child: AlertDialog(
          title: const Text('Add Inventory'),
          content: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Quantity input
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
                hintText: 'How many tools?',
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            
            // Quick-add section for existing locations (edit mode only)
            if (hasExistingLocations) ...[
              const Text(
                'Quick Add to Existing Location:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 150),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[200]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue[50],
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: widget.existingLocations!.map((toolLocation) {
                    final location = toolLocation.location;
                    if (location == null) return const SizedBox.shrink();
                    
                    final path = _buildLocationPathFromLocation(location);
                    final currentQty = toolLocation.quantity;
                    final isSelected = _selectedLocationId == location.id;
                    
                    return ListTile(
                      dense: true,
                      selected: isSelected,
                      selectedTileColor: Colors.green[100],
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.add_circle_outline,
                        color: isSelected ? Colors.green : Colors.blue,
                      ),
                      title: Text(path, style: const TextStyle(fontSize: 13)),
                      subtitle: Text('Currently has $currentQty', style: const TextStyle(fontSize: 11)),
                      trailing: const Icon(Icons.chevron_right, size: 16),
                      onTap: () {
                        setState(() {
                          _selectedLocationId = location.id;
                          _selectedLocationPath = path;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Historical locations section (previously used, currently empty)
            if (hasHistoricalLocations) ...[
              if (hasExistingLocations) const Divider(),
              const Text(
                'Previously Used Locations:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange[200]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.orange[50],
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: historicalLocations.map((location) {
                    final path = _buildLocationPathFromRecord(location);
                    final isSelected = _selectedLocationId == location.id;
                    
                    return ListTile(
                      dense: true,
                      selected: isSelected,
                      selectedTileColor: Colors.green[100],
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.history,
                        color: isSelected ? Colors.green : Colors.orange[700],
                      ),
                      title: Text(
                        path,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      subtitle: Text(
                        'Empty - previously used',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600], fontStyle: FontStyle.italic),
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 16),
                      onTap: () {
                        setState(() {
                          _selectedLocationId = location.id;
                          _selectedLocationPath = path;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Divider before "Select Different Location" if we have existing or historical
            if (hasExistingLocations || hasHistoricalLocations) ...[
              const Divider(),
              const Text(
                'Or Select a Different Location:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
            ],

            // Search field for destination location
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location by name or path',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (_) => _onSearchChanged(),
            ),
            if (_suggestions != null && _suggestions!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _suggestions!.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final loc = _suggestions![i];
                    final path = _buildLocationPathFromRecord(loc);
                    return ListTile(
                      dense: true,
                      title: Text(path, style: const TextStyle(fontSize: 13)),
                      onTap: () {
                        setState(() {
                          _selectedLocationId = loc.id;
                          _selectedLocationPath = path;
                          _suggestions = null;
                          _searchController.clear();
                        });
                      },
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 12),
            
            // Selected location summary
            if (_selectedLocationPath != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border.all(color: Colors.green[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Selected: $_selectedLocationPath',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      tooltip: 'Clear selection',
                      onPressed: () {
                        setState(() {
                          _selectedLocationId = null;
                          _selectedLocationPath = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            Row(
              children: [
                const Text(
                  'Select Location:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    _locationPickerKey.currentState?.openCreateNew();
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Create New'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: MultiStepLocationPicker(
                key: _locationPickerKey,
                allLocations: _currentLocations,
                onLocationSelected: (locationId) {
                  final path = _buildLocationPath(locationId);
                  setState(() {
                    _selectedLocationId = locationId;
                    _selectedLocationPath = path;
                  });
                },
                onRefreshLocations: _refreshLocations,
              ),
            ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _selectedLocationId == null ? null : _submit,
              child: const Text('Add Inventory'),
            ),
          ],
        ),
      ),
    );
  }
  
  // NEW: Get historical locations that don't have current inventory
  List<dynamic> _getHistoricalLocationsWithoutInventory() {
    if (widget.historicalLocationIds == null || widget.historicalLocationIds!.isEmpty) {
      return [];
    }
    
    final currentLocationIds = widget.existingLocations?.map((tl) => tl.locationId).toSet() ?? {};
    final historicalLocs = <dynamic>[];
    
    for (final locationId in widget.historicalLocationIds!) {
      // Skip if this location already has current inventory
      if (currentLocationIds.contains(locationId)) continue;
      
      // Find the location record
      try {
        final loc = _currentLocations.firstWhere((l) => l.id == locationId);
        historicalLocs.add(loc);
      } catch (e) {
        // Location not found, skip
        continue;
      }
    }
    
    return historicalLocs;
  }
  
  String _buildLocationPath(String locationId) {
    final names = <String>[];
    var currentId = locationId;
    
    while (currentId.isNotEmpty) {
      try {
        final loc = _currentLocations.firstWhere((l) => l.id == currentId);
        names.insert(0, loc.data['name']);
        currentId = loc.data['parent'] ?? '';
      } catch (e) {
        break;
      }
    }
    
    return names.join(' → ');
  }
  
  String _buildLocationPathFromLocation(Location location) {
    final names = <String>[];
    var currentId = location.id;
    
    while (currentId.isNotEmpty) {
      try {
        final loc = _currentLocations.firstWhere((l) => l.id == currentId);
        names.insert(0, loc.data['name']);
        currentId = loc.data['parent'] ?? '';
      } catch (e) {
        break;
      }
    }
    
    return names.join(' → ');
  }
  
  // NEW: Build path from a location record (for historical locations)
  String _buildLocationPathFromRecord(dynamic locationRecord) {
    final names = <String>[];
    var currentId = locationRecord.id;
    
    while (currentId.isNotEmpty) {
      try {
        final loc = _currentLocations.firstWhere((l) => l.id == currentId);
        names.insert(0, loc.data['name']);
        currentId = loc.data['parent'] ?? '';
      } catch (e) {
        break;
      }
    }
    
    return names.join(' → ');
  }
  
}

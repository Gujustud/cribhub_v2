// add_inventory_dialog.dart
import 'package:flutter/material.dart';
import 'multi_step_location_picker.dart';
import 'pocketbase_service.dart';
import 'models.dart';

class AddInventoryDialog extends StatefulWidget {
  final List<dynamic> allLocations;
  final List<ToolLocation>? existingLocations; // For edit mode
  
  const AddInventoryDialog({
    Key? key,
    required this.allLocations,
    this.existingLocations,
  }) : super(key: key);

  @override
  State<AddInventoryDialog> createState() => _AddInventoryDialogState();
}

class _AddInventoryDialogState extends State<AddInventoryDialog> {
  final _quantityController = TextEditingController(text: '1');
  String? _selectedLocationId;
  String? _selectedLocationPath;
  List<dynamic> _currentLocations = [];
  
  @override
  void initState() {
    super.initState();
    _currentLocations = widget.allLocations;
  }
  
  Future<void> _refreshLocations() async {
    final pbService = PocketBaseService();
    final locations = await pbService.getLocations();
    setState(() {
      _currentLocations = locations;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final hasExistingLocations = widget.existingLocations != null && widget.existingLocations!.isNotEmpty;
    
    return AlertDialog(
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
            if (hasExistingLocations && _selectedLocationId == null) ...[
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
                    
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
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
              const Divider(),
              const Text(
                'Or Select a Different Location:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
            ],
            
            // Selected location display
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
                        'Location: $_selectedLocationPath',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      onPressed: () {
                        setState(() {
                          _selectedLocationId = null;
                          _selectedLocationPath = null;
                        });
                      },
                      tooltip: 'Change location',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Location picker
            if (_selectedLocationId == null) ...[
              const Text(
                'Select Location:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: MultiStepLocationPicker(
                    allLocations: _currentLocations,
                    onLocationSelected: (locationId) {
                      // Build path for display
                      final path = _buildLocationPath(locationId);
                      setState(() {
                        _selectedLocationId = locationId;
                        _selectedLocationPath = path;
                      });
                    },
                    onRefreshLocations: _refreshLocations,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedLocationId == null
              ? null
              : () {
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
                },
          child: const Text('Add Inventory'),
        ),
      ],
    );
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
  
  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}

// transfer_dialog.dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'pocketbase_service.dart';

class TransferDialog extends StatefulWidget {
  final Tool tool;
  final ToolLocation sourceLocation;
  final List<Location> allLocations;

  const TransferDialog({
    Key? key,
    required this.tool,
    required this.sourceLocation,
    required this.allLocations,
  }) : super(key: key);

  @override
  State<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
  int _quantity = 1;
  String? _selectedDestination;
  bool _isSubmitting = false;

  // Build full hierarchical path for a location
  String _buildLocationPath(Location location) {
    final names = <String>[];
    var current = location;
    
    while (true) {
      names.insert(0, current.name);
      
      if (current.parentId == null || current.parentId!.isEmpty) break;
      
      try {
        current = widget.allLocations.firstWhere((loc) => loc.id == current.parentId);
      } catch (e) {
        break;
      }
    }
    
    return names.join(' - ');
  }

  // Get the top-level parent's type for grouping
  String _getTopLevelType(Location location) {
    var current = location;
    
    // Walk up to the root
    while (current.parentId != null && current.parentId!.isNotEmpty) {
      try {
        current = widget.allLocations.firstWhere((loc) => loc.id == current.parentId);
      } catch (e) {
        break;
      }
    }
    
    return current.type.toLowerCase();
  }

  // Group locations by their top-level parent's type
  Map<String, List<Location>> get _groupedLocations {
    final grouped = <String, List<Location>>{};
    
    for (final loc in widget.allLocations) {
      // Exclude the source location
      if (loc.id == widget.sourceLocation.locationId) continue;
      
      final topLevelType = _getTopLevelType(loc);
      if (!grouped.containsKey(topLevelType)) {
        grouped[topLevelType] = [];
      }
      grouped[topLevelType]!.add(loc);
    }
    
    // Sort each group by full path
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => _buildLocationPath(a).compareTo(_buildLocationPath(b)));
    }
    
    return grouped;
  }

  // Get display name for location type groups
  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'machine':
        return 'Machines';
      case 'shelf':
        return 'Shelves';
      case 'toolbox':
        return 'Toolboxes';
      case 'recycle':
        return 'Recycle';
      default:
        return type[0].toUpperCase() + type.substring(1);
    }
  }

  void _incrementQuantity() {
    if (_quantity < widget.sourceLocation.quantity) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _handleSubmit() async {
    // Validate destination
    if (_selectedDestination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a destination'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final pbService = PocketBaseService();
      await pbService.moveTool(
        toolId: widget.tool.id,
        fromLocationId: widget.sourceLocation.locationId,
        toLocationId: _selectedDestination!,
        quantity: _quantity,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tool transferred successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourceLoc = widget.sourceLocation.location;
    final availableQty = widget.sourceLocation.quantity;
    final sourceLocationPath = sourceLoc != null ? _buildLocationPath(sourceLoc) : 'Unknown Location';

    return AlertDialog(
      title: Text(
        'Transfer Tool: ${widget.tool.toolName}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 400, // Narrower dialog
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Source location info - just black outline, no background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'From: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            sourceLocationPath,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Available: $availableQty',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quantity selector with +/- buttons
              const Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: _isSubmitting ? null : _decrementQuantity,
                    icon: const Icon(Icons.remove, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _isSubmitting ? null : _incrementQuantity,
                    icon: const Icon(Icons.add, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Max: $availableQty',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Destination dropdown
              const Text(
                'Destination',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedDestination,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Select destination',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _buildDropdownItems(),
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        setState(() {
                          _selectedDestination = value;
                        });
                      },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 14),
          ),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Transfer',
                  style: TextStyle(fontSize: 14),
                ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    final items = <DropdownMenuItem<String>>[];
    final grouped = _groupedLocations;
    
    // Order of types - MACHINES FIRST
    final typeOrder = ['machine', 'shelf', 'toolbox', 'recycle'];
    
    for (final type in typeOrder) {
      if (!grouped.containsKey(type)) continue;
      
      final locations = grouped[type]!;
      if (locations.isEmpty) continue;
      
      // Add header (disabled item)
      items.add(
        DropdownMenuItem<String>(
          value: null,
          enabled: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Text(
              _getTypeDisplayName(type),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
      
      // Add locations in this group with full paths
      for (final loc in locations) {
        items.add(
          DropdownMenuItem<String>(
            value: loc.id,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                _buildLocationPath(loc),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        );
      }
    }
    
    return items;
  }
}
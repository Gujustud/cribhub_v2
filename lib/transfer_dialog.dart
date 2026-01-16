// transfer_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _quantityController = TextEditingController(text: '1');
  String? _selectedDestination;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  // Group locations by type for the dropdown
  Map<String, List<Location>> get _groupedLocations {
    final grouped = <String, List<Location>>{};
    
    for (final loc in widget.allLocations) {
      // Exclude the source location
      if (loc.id == widget.sourceLocation.locationId) continue;
      
      final type = loc.type.toLowerCase();
      if (!grouped.containsKey(type)) {
        grouped[type] = [];
      }
      grouped[type]!.add(loc);
    }
    
    // Sort each group by name
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => a.name.compareTo(b.name));
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

  Future<void> _handleSubmit() async {
    // Validate quantity
    final quantity = int.tryParse(_quantityController.text);
    if (quantity == null || quantity < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid quantity (minimum 1)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (quantity > widget.sourceLocation.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quantity cannot exceed available ${widget.sourceLocation.quantity}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
        quantity: quantity,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tool transferred successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Close dialog and return success
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

    return AlertDialog(
      title: Text('Transfer ${widget.tool.toolName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source location info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'From:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sourceLoc?.name ?? 'Unknown Location',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Available: $availableQty',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quantity input
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Enter quantity',
                helperText: 'Max: $availableQty',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 20),

            // Destination dropdown
            DropdownButtonFormField<String>(
              value: _selectedDestination,
              decoration: const InputDecoration(
                labelText: 'Destination',
                hintText: 'Select destination',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place),
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
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
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
              : const Text('Transfer'),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    final items = <DropdownMenuItem<String>>[];
    final grouped = _groupedLocations;
    
    // Order of types
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
          child: Text(
            _getTypeDisplayName(type),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      );
      
      // Add locations in this group
      for (final loc in locations) {
        items.add(
          DropdownMenuItem<String>(
            value: loc.id,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(loc.name),
            ),
          ),
        );
      }
    }
    
    return items;
  }
}

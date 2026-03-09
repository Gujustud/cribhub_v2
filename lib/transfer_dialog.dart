// transfer_dialog.dart
import 'dart:async';
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

  final TextEditingController _searchController = TextEditingController();
  List<Location>? _suggestions;
  Timer? _searchDebounce;
  static const int _maxSuggestions = 5;
  static const int _minSearchLength = 2;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

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

  /// All locations that are valid destinations (exclude source).
  List<Location> get _destinationLocations {
    return widget.allLocations
        .where((loc) => loc.id != widget.sourceLocation.locationId)
        .toList();
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
      final paths = _destinationLocations
          .map((loc) => MapEntry(loc, _buildLocationPath(loc)))
          .where((e) => e.value.toLowerCase().contains(q))
          .toList();
      paths.sort((a, b) => a.value.compareTo(b.value));
      if (mounted) {
        setState(() {
          _suggestions = paths
              .take(_maxSuggestions)
              .map((e) => e.key)
              .toList();
        });
      }
    });
  }

  void _selectDestination(Location loc) {
    setState(() {
      _selectedDestination = loc.id;
      _searchController.clear();
      _suggestions = null;
    });
  }

  void _clearDestination() {
    setState(() {
      _selectedDestination = null;
      _suggestions = null;
    });
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

              // Destination: search field with suggestions (or show selected)
              const Text(
                'Destination',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              if (_selectedDestination != null) ...[
                Builder(
                  builder: (context) {
                    Location? loc;
                    try {
                      loc = widget.allLocations.firstWhere(
                          (l) => l.id == _selectedDestination);
                    } catch (_) {
                      loc = null;
                    }
                    final path = loc != null ? _buildLocationPath(loc) : _selectedDestination!;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              path,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          if (!_isSubmitting)
                            TextButton(
                              onPressed: _clearDestination,
                              child: const Text('Change'),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ] else ...[
                TextField(
                  controller: _searchController,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    hintText: 'Search destination',
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        final path = _buildLocationPath(loc);
                        return ListTile(
                          dense: true,
                          title: Text(path, style: const TextStyle(fontSize: 13)),
                          onTap: () => _selectDestination(loc),
                        );
                      },
                    ),
                  ),
                ],
              ],
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

}
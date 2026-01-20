import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  late final PocketBase pb;

  factory PocketBaseService() {
    return _instance;
  }

  PocketBaseService._internal() {
    // Connect to your local PocketBase instance
    pb = PocketBase('http://127.0.0.1:8090');
  }

  // Save a new tool
  Future<void> createTool({
    required String toolName,
    required String category,
    String? subcategory,
    String? subSubcategory,
    String? modelNumber,
    double? diameterIn,
    double? diameterMm,
    int? flutes,
    double? fluteLength,
    double? cornerRad,
    double? neck,
  }) async {
    try {
      final record = await pb.collection('tools').create(body: {
        'tool_name': toolName,
        'category': category,
        'subcategory': subcategory,
        'sub_subcategory': subSubcategory,
        'model_number': modelNumber,
        'diameter_in': diameterIn,
        'diameter_mm': diameterMm,
        'flutes': flutes,
        'flute_length': fluteLength,
        'corner_rad': cornerRad,
        'neck': neck,
      });
      print('Tool created: ${record.id}');
    } catch (e) {
      print('Error creating tool: $e');
      rethrow;
    }
  }

  // Get all tools
  Future<List<dynamic>> getTools() async {
    try {
      final records = await pb.collection('tools').getFullList();
      return records;
    } catch (e) {
      print('Error getting tools: $e');
      rethrow;
    }
  }

  // Create a new location
  Future<void> createLocation({
    required String name,
    required String type,
    String? parentId,
  }) async {
    try {
      final record = await pb.collection('locations').create(body: {
        'name': name,
        'type': type,
        'parent': parentId,
      });
      print('Location created: ${record.id}');
    } catch (e) {
      print('Error creating location: $e');
      rethrow;
    }
  }

  // Get all locations
  Future<List<dynamic>> getLocations() async {
    try {
      final records = await pb.collection('locations').getFullList(
        sort: 'name',
      );
      return records;
    } catch (e) {
      print('Error getting locations: $e');
      rethrow;
    }
  }

  // Update a location
  Future<void> updateLocation({
    required String locationId,
    required String name,
    required String type,
    String? parentId,
  }) async {
    try {
      await pb.collection('locations').update(locationId, body: {
        'name': name,
        'type': type,
        if (parentId != null) 'parent': parentId,
      });
      print('Location updated: $locationId');
    } catch (e) {
      print('Error updating location: $e');
      rethrow;
    }
  }

  // Delete a location
  Future<void> deleteLocation(String locationId) async {
    try {
      await pb.collection('locations').delete(locationId);
      print('Location deleted: $locationId');
    } catch (e) {
      print('Error deleting location: $e');
      rethrow;
    }
  }

  // Get tool locations for a specific tool
  Future<List<dynamic>> getToolLocations(String toolId) async {
    try {
      final records = await pb.collection('tool_locations').getFullList(
        filter: 'tool = "$toolId"',
        expand: 'location',
      );
      return records;
    } catch (e) {
      print('Error getting tool locations: $e');
      rethrow;
    }
  }

  // Get tool locations at a specific location
  Future<List<dynamic>> getToolLocationsAtLocation(String locationId) async {
    try {
      final records = await pb.collection('tool_locations').getFullList(
        filter: 'location = "$locationId" && quantity > 0',
      );
      return records;
    } catch (e) {
      print('Error getting tool locations: $e');
      rethrow;
    }
  }

  // Get tool by ID
  Future<dynamic> getToolById(String toolId) async {
    try {
      final record = await pb.collection('tools').getOne(toolId);
      return record;
    } catch (e) {
      print('Error getting tool: $e');
      rethrow;
    }
  }

  // Move tool between locations
  Future<void> moveTool({
    required String toolId,
    required String fromLocationId,
    required String toLocationId,
    required int quantity,
  }) async {
    try {
      // Get current tool_location records
      final fromRecords = await pb.collection('tool_locations').getFullList(
        filter: 'tool = "$toolId" && location = "$fromLocationId"',
      );

      if (fromRecords.isEmpty) {
        throw Exception('Tool not found at source location');
      }

      final fromRecord = fromRecords.first;
      final currentQty = fromRecord.data['quantity'] as int;

      if (currentQty < quantity) {
        throw Exception('Not enough quantity at source location');
      }

      // Get destination quantity before transfer
      final destQtyBefore = await getCurrentQuantityAtLocation(
        toolId: toolId,
        locationId: toLocationId,
      );

      // Update source location (reduce quantity or delete if 0)
      final newSourceQty = currentQty - quantity;
      if (currentQty == quantity) {
        await pb.collection('tool_locations').delete(fromRecord.id);
      } else {
        await pb.collection('tool_locations').update(
          fromRecord.id,
          body: {'quantity': newSourceQty},
        );
      }

      // Update or create destination location
      final toRecords = await pb.collection('tool_locations').getFullList(
        filter: 'tool = "$toolId" && location = "$toLocationId"',
      );

      if (toRecords.isEmpty) {
        // Create new record
        await pb.collection('tool_locations').create(body: {
          'tool': toolId,
          'location': toLocationId,
          'quantity': quantity,
        });
      } else {
        // Update existing record
        final toRecord = toRecords.first;
        final existingQty = toRecord.data['quantity'] as int;
        await pb.collection('tool_locations').update(
          toRecord.id,
          body: {'quantity': existingQty + quantity},
        );
      }

      // Create OLD movement history record (keep for backwards compatibility)
      await pb.collection('movement_history').create(body: {
        'tool': toolId,
        'from_location': fromLocationId,
        'to_location': toLocationId,
        'quantity': quantity,
      });

      // NEW: Log to inventory_history (transfer_out from source)
      await logInventoryHistory(
        toolId: toolId,
        locationId: fromLocationId,
        action: 'transfer_out',
        quantity: quantity,
        quantityBefore: currentQty,
        quantityAfter: newSourceQty,
        relatedLocationId: toLocationId,
      );

      // NEW: Log to inventory_history (transfer_in at destination)
      await logInventoryHistory(
        toolId: toolId,
        locationId: toLocationId,
        action: 'transfer_in',
        quantity: quantity,
        quantityBefore: destQtyBefore,
        quantityAfter: destQtyBefore + quantity,
        relatedLocationId: fromLocationId,
      );

      print('Tool moved successfully');
    } catch (e) {
      print('Error moving tool: $e');
      rethrow;
    }
  }

  // Create tool_location record
  Future<void> createToolLocation({
    required String toolId,
    required String locationId,
    required int quantity,
  }) async {
    try {
      final record = await pb.collection('tool_locations').create(body: {
        'tool': toolId,
        'location': locationId,
        'quantity': quantity,
      });
      print('Tool location created: ${record.id}');
    } catch (e) {
      print('Error creating tool location: $e');
      rethrow;
    }
  }

  // Get location path (for display)
  String getLocationPath(String locationId, List<dynamic> allLocations) {
    dynamic location;
    try {
      location = allLocations.firstWhere(
        (loc) => loc.id == locationId,
      );
    } catch (e) {
      return 'Unknown';
    }
    
    final parts = <String>[];
    var current = location;
    
    while (current != null) {
      parts.insert(0, current.data['name']);
      final parentId = current.data['parent'];
      if (parentId == null || parentId == '') break;
      
      try {
        current = allLocations.firstWhere(
          (loc) => loc.id == parentId,
        );
      } catch (e) {
        break;
      }
    }
    
    return parts.join(' - ');
  }

  // Brand management
  Future<List<dynamic>> getBrands() async {
    try {
      final records = await pb.collection('brands').getFullList(sort: 'name');
      return records;
    } catch (e) {
      print('Error getting brands: $e');
      rethrow;
    }
  }

  Future<void> createBrand(String name) async {
    try {
      await pb.collection('brands').create(body: {'name': name});
    } catch (e) {
      print('Error creating brand: $e');
      rethrow;
    }
  }

  Future<void> updateBrand(String id, String name) async {
    try {
      await pb.collection('brands').update(id, body: {'name': name});
    } catch (e) {
      print('Error updating brand: $e');
      rethrow;
    }
  }

  Future<void> deleteBrand(String id) async {
    try {
      await pb.collection('brands').delete(id);
    } catch (e) {
      print('Error deleting brand: $e');
      rethrow;
    }
  }

  // Supplier management
  Future<List<dynamic>> getSuppliers() async {
    try {
      final records = await pb.collection('suppliers').getFullList(sort: 'company_name');
      return records;
    } catch (e) {
      print('Error getting suppliers: $e');
      rethrow;
    }
  }

  Future<void> createSupplier({
    required String companyName,
    String? address,
    String? tel,
    String? website,
    String? contact,
    String? directTel,
    String? email,
  }) async {
    try {
      await pb.collection('suppliers').create(body: {
        'company_name': companyName,
        'address': address,
        'tel': tel,
        'website': website,
        'contact': contact,
        'direct_tel': directTel,
        'email': email,
      });
    } catch (e) {
      print('Error creating supplier: $e');
      rethrow;
    }
  }

  Future<void> updateSupplier({
    required String id,
    required String companyName,
    String? address,
    String? tel,
    String? website,
    String? contact,
    String? directTel,
    String? email,
  }) async {
    try {
      await pb.collection('suppliers').update(id, body: {
        'company_name': companyName,
        'address': address,
        'tel': tel,
        'website': website,
        'contact': contact,
        'direct_tel': directTel,
        'email': email,
      });
    } catch (e) {
      print('Error updating supplier: $e');
      rethrow;
    }
  }

  Future<void> deleteSupplier(String id) async {
    try {
      await pb.collection('suppliers').delete(id);
    } catch (e) {
      print('Error deleting supplier: $e');
      rethrow;
    }
  }

  // ============================================================================
  // INVENTORY HISTORY LOGGING
  // ============================================================================

  /// Log an inventory history entry
  /// 
  /// [toolId] - ID of the tool
  /// [locationId] - Primary location ID for this action
  /// [action] - Type of action: 'add', 'remove', 'transfer_in', 'transfer_out', 'edit'
  /// [quantity] - Quantity involved in the action
  /// [quantityBefore] - Quantity at location before the action
  /// [quantityAfter] - Quantity at location after the action
  /// [relatedLocationId] - For transfers: the other location involved
  /// [notes] - Optional notes about the action
  /// [toolLife] - Optional tool life in hours
  Future<void> logInventoryHistory({
    required String toolId,
    required String locationId,
    required String action,
    required int quantity,
    required int quantityBefore,
    required int quantityAfter,
    String? relatedLocationId,
    String? notes,
    double? toolLife,
  }) async {
    try {
      final body = {
        'tool': toolId,
        'location': locationId,
        'action': action,
        'quantity': quantity,
        'quantity_before': quantityBefore,
        'quantity_after': quantityAfter,
      };
      
      // Add optional fields only if provided
      if (relatedLocationId != null && relatedLocationId.isNotEmpty) {
        body['related_location'] = relatedLocationId;
      }
      if (notes != null && notes.isNotEmpty) {
        body['notes'] = notes;
      }
      if (toolLife != null) {
        body['tool_life'] = toolLife;
      }
      
      print('📝 Attempting to log history:');
      print('   Action: $action');
      print('   Tool: $toolId');
      print('   Location: $locationId');
      print('   Related Location: $relatedLocationId');
      print('   Quantity: $quantity (type: ${quantity.runtimeType})');
      print('   Quantity Before: $quantityBefore (type: ${quantityBefore.runtimeType})');
      print('   Quantity After: $quantityAfter (type: ${quantityAfter.runtimeType})');
      print('   Body being sent: $body');
      
      await pb.collection('inventory_history').create(body: body);
      print('✅ History logged successfully: $action');
    } catch (e) {
      print('❌ ERROR logging inventory history:');
      print('   Action: $action');
      print('   Tool: $toolId');
      print('   Location: $locationId');
      print('   Related Location: $relatedLocationId');
      print('   Quantities: $quantityBefore → $quantityAfter');
      print('   Full error: $e');
      // Don't rethrow - we don't want history logging to break the main operation
      // But we do want to see the error clearly in console
    }
  }

  /// Get inventory history for a specific tool
  /// [limit] - Maximum number of records to return (default: 5)
  /// [sort] - Sort order (default: '-created' for newest first)
  Future<List<dynamic>> getInventoryHistory({
    required String toolId,
    int limit = 5,
    String sort = '-created',
  }) async {
    try {
      final records = await pb.collection('inventory_history').getList(
        page: 1,
        perPage: limit,
        filter: 'tool = "$toolId"',
        sort: sort,
        expand: 'location,related_location',
      );
      return records.items;
    } catch (e) {
      print('Error getting inventory history: $e');
      return [];
    }
  }

  /// Get all inventory history for a tool (for "View All" functionality)
  Future<List<dynamic>> getAllInventoryHistory({
    required String toolId,
    String sort = '-created',
  }) async {
    try {
      final records = await pb.collection('inventory_history').getFullList(
        filter: 'tool = "$toolId"',
        sort: sort,
        expand: 'location,related_location',
      );
      return records;
    } catch (e) {
      print('Error getting all inventory history: $e');
      return [];
    }
  }

  /// Helper method to get current quantity at a location before making changes
  Future<int> getCurrentQuantityAtLocation({
    required String toolId,
    required String locationId,
  }) async {
    try {
      final records = await pb.collection('tool_locations').getFullList(
        filter: 'tool = "$toolId" && location = "$locationId"',
      );
      
      if (records.isEmpty) {
        return 0;
      }
      
      return (records.first.data['quantity'] ?? 0) as int;
    } catch (e) {
      print('Error getting current quantity: $e');
      return 0;
    }
  }

  /// Get historical locations where this tool was added (for quick-add suggestions)
  /// Returns last 3 unique locations where action = 'add' from bins/shelves/toolboxes only
  Future<List<String>> getHistoricalAddLocations({
    required String toolId,
    int limit = 3,
  }) async {
    try {
      // Get history records where tool was added
      final records = await pb.collection('inventory_history').getFullList(
        filter: 'tool = "$toolId" && action = "add"',
        sort: '-created',
        expand: 'location',
      );
      
      final historicalLocationIds = <String>{};
      
      for (final record in records) {
        if (historicalLocationIds.length >= limit) break;
        
        final locationId = record.data['location'];
        if (locationId == null) continue;
        
        // Check if location is expanded
        final expandedData = record.expand?['location'];
        if (expandedData == null) continue;
        
        // Handle if expandedData is a List or single object
        dynamic locationRecord;
        if (expandedData is List && expandedData.isNotEmpty) {
          locationRecord = expandedData[0];
        } else {
          locationRecord = expandedData;
        }
        
        // Get location type
        final locationType = locationRecord.data['type']?.toString().toLowerCase() ?? '';
        
        // Only include bins, shelves, toolboxes
        if (locationType == 'toolbox' || 
            locationType == 'shelf' || 
            locationType == 'bin') {
          historicalLocationIds.add(locationId);
        }
      }
      
      return historicalLocationIds.toList();
    } catch (e) {
      print('Error getting historical add locations: $e');
      return [];
    }
  }
}

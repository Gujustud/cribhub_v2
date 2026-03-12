// models.dart
// Model classes for PocketBase records

class Tool {
  final String id;
  final String toolName;
  final String category;
  final String? subcategory;
  final String? subSubcategory;
  final String? modelNumber;
  final String? url;  // NEW
  final String? manufacturerBarcode;
  final String? brandId;  // NEW - stores the brand ID
  final String? supplierId;  // NEW - stores the supplier ID
  final bool needsRestock; // Manual buy-list flag
  final int? restockQty; // Qty to buy (manual)
  final String? restockNotes; // Optional notes for purchasing
  final double? diameterIn;
  final double? diameterMm;
  final int? flutes;
  final double? fluteLength;
  final double? cornerRad;
  final double? neck;
  final String? size;
  final String? serialNumber;
  final String? photo;  // NEW
  final String? brand;  // Display name (from expand)
  final String? supplier;  // Display name (from expand)
  final dynamic record;  // NEW - stores the original PocketBase record

  Tool({
    required this.id,
    required this.toolName,
    required this.category,
    this.subcategory,
    this.subSubcategory,
    this.modelNumber,
    this.url,
    this.manufacturerBarcode,
    this.brandId,
    this.supplierId,
    this.needsRestock = false,
    this.restockQty,
    this.restockNotes,
    this.diameterIn,
    this.diameterMm,
    this.flutes,
    this.fluteLength,
    this.cornerRad,
    this.neck,
    this.size,
    this.serialNumber,
    this.photo,
    this.brand,
    this.supplier,
    this.record,
  });

  factory Tool.fromRecord(dynamic record) {
    // RecordModel has .id and .data properties
    final data = record.data;
    
    // Helper function to safely extract expanded relation data
    String? getExpandedName(String fieldName, String nameField) {
      try {
        if (record.expand == null) return null;
        final expandedData = record.expand[fieldName];
        if (expandedData == null) return null;
        
        // Handle both single object and array (Flutter web sometimes returns arrays)
        if (expandedData is List && expandedData.isNotEmpty) {
          return expandedData[0].data?[nameField];
        } else {
          return expandedData.data?[nameField];
        }
      } catch (e) {
        print('Error extracting $fieldName: $e');
        return null;
      }
    }
    
    return Tool(
      id: record.id,
      toolName: data['tool_name'] ?? '',
      category: data['category'] ?? '',
      subcategory: data['subcategory'],
      subSubcategory: data['sub_subcategory'],
      modelNumber: data['model_number'],
      url: data['url'],  // NEW
      manufacturerBarcode: data['manufacturer_barcode'],
      brandId: data['brand'],  // NEW
      supplierId: data['supplier'],  // NEW
      needsRestock: data['needs_restock'] == true,
      restockQty: (data['restock_qty'] != null) ? (data['restock_qty'] as num).toInt() : null,
      restockNotes: data['restock_notes'],
      diameterIn: data['diameter_in']?.toDouble(),
      diameterMm: data['diameter_mm']?.toDouble(),
      flutes: data['flutes']?.toInt(),
      fluteLength: data['flute_length']?.toDouble(),
      cornerRad: data['corner_rad']?.toDouble(),
      neck: data['neck']?.toDouble(),
      size: data['size'],
      serialNumber: data['serial_number'],
      photo: data['photo'],  // NEW
      brand: getExpandedName('brand', 'name'),  // FIXED - handles both array and object
      supplier: getExpandedName('supplier', 'company_name'),  // FIXED - handles both array and object
      record: record,  // NEW - store the original record
    );
  }

  // Helper method to get display specs
  String get displaySpecs {
    final parts = <String>[];
    
    if (diameterIn != null) {
      parts.add('Ø${diameterIn}"');
    }
    if (flutes != null) {
      parts.add('${flutes}FL');
    }
    if (fluteLength != null) {
      parts.add('LOC: $fluteLength"');
    }
    if (cornerRad != null && cornerRad! > 0) {
      parts.add('CR: ${cornerRad}"');
    }
    if (neck != null && neck! > 0) {
      parts.add('Neck: ${neck}"');
    }
    
    // Fallback to model number if no specs
    if (parts.isEmpty && modelNumber != null && modelNumber!.isNotEmpty) {
      return 'Model: $modelNumber';
    }
    
    return parts.join(' • ');
  }
}

class Location {
  final String id;
  final String name;
  final String type; // machine, shelf, toolbox, recycle
  final String? qrCode;
  final String? machine; // For locations linked to machines
  final String? parentId; // For hierarchical locations

  Location({
    required this.id,
    required this.name,
    required this.type,
    this.qrCode,
    this.machine,
    this.parentId,
  });

  factory Location.fromRecord(dynamic record) {
    // RecordModel has .id and .data properties
    final data = record.data;
    return Location(
      id: record.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      qrCode: data['qr_code'],
      machine: data['machine'],
      parentId: data['parent'],
    );
  }

  // Get color based on location type
  LocationColors get colors {
    switch (type.toLowerCase()) {
      case 'machine':
        return LocationColors.machine;
      case 'shelf':
        return LocationColors.shelf;
      case 'toolbox':
        return LocationColors.toolbox;
      case 'recycle':
        return LocationColors.recycle;
      default:
        return LocationColors.unknown;
    }
  }
}

class LocationColors {
  final int fillColor;
  final int borderColor;
  final int textColor;

  const LocationColors({
    required this.fillColor,
    required this.borderColor,
    required this.textColor,
  });

  static const machine = LocationColors(
    fillColor: 0xFFFF9800, // Orange
    borderColor: 0xFFE65100,
    textColor: 0xFFFFFFFF,
  );

  static const shelf = LocationColors(
    fillColor: 0xFF4CAF50, // Green
    borderColor: 0xFF2E7D32,
    textColor: 0xFFFFFFFF,
  );

  static const toolbox = LocationColors(
    fillColor: 0xFF2196F3, // Blue
    borderColor: 0xFF1565C0,
    textColor: 0xFFFFFFFF,
  );

  static const recycle = LocationColors(
    fillColor: 0xFFF44336, // Red
    borderColor: 0xFFC62828,
    textColor: 0xFFFFFFFF,
  );

  static const unknown = LocationColors(
    fillColor: 0xFF9E9E9E, // Grey
    borderColor: 0xFF616161,
    textColor: 0xFFFFFFFF,
  );
}

class ToolLocation {
  final String id;
  final String toolId;
  final String locationId;
  final int quantity;
  final String? qrCode;
  
  // Expanded fields (if expand is used in query)
  final Location? location;

  ToolLocation({
    required this.id,
    required this.toolId,
    required this.locationId,
    required this.quantity,
    this.qrCode,
    this.location,
  });

  factory ToolLocation.fromRecord(dynamic record) {
    // RecordModel has .id and .data properties
    final data = record.data;
    
    // Check if location is expanded
    Location? expandedLocation;
    try {
      if (record.expand != null && record.expand['location'] != null) {
        final locationData = record.expand['location'];
        // The expanded location might be an array or a single object
        if (locationData is List && locationData.isNotEmpty) {
          expandedLocation = Location.fromRecord(locationData[0]);
        } else {
          expandedLocation = Location.fromRecord(locationData);
        }
      }
    } catch (e) {
      print('⚠️ Error expanding location: $e');
    }

    return ToolLocation(
      id: record.id,
      toolId: data['tool'] ?? '',
      locationId: data['location'] ?? '',
      quantity: (data['quantity'] ?? 0).toInt(),
      qrCode: data['qr_code'],
      location: expandedLocation,
    );
  }
}

class ToolWithLocations {
  final Tool tool;
  final List<ToolLocation> locations;

  ToolWithLocations({
    required this.tool,
    required this.locations,
  });

  // Get total quantity across all locations
  int get totalQuantity {
    return locations.fold(0, (sum, loc) => sum + loc.quantity);
  }

  // Get locations sorted by type order (Toolboxes -> Shelves -> Machines -> Recycle)
  List<ToolLocation> get sortedLocations {
    final order = {'toolbox': 1, 'shelf': 2, 'machine': 3, 'recycle': 4};
    final sorted = List<ToolLocation>.from(locations);
    sorted.sort((a, b) {
      final aType = a.location?.type.toLowerCase() ?? '';
      final bType = b.location?.type.toLowerCase() ?? '';
      final aOrder = order[aType] ?? 5;
      final bOrder = order[bType] ?? 5;
      
      if (aOrder != bOrder) return aOrder.compareTo(bOrder);
      // If same type, sort by name
      return (a.location?.name ?? '').compareTo(b.location?.name ?? '');
    });
    return sorted;
  }
}

// NEW: Inventory History Model
class InventoryHistory {
  final String id;
  final String toolId;
  final String locationId;
  final String action; // 'add', 'remove', 'transfer_in', 'transfer_out', 'edit'
  final int quantity;
  final int quantityBefore;
  final int quantityAfter;
  final String? relatedLocationId; // For transfers (destination or source)
  final String? notes;
  final double? toolLife; // Tool life in hours (optional)
  final DateTime created;
  
  // Expanded fields
  final Location? location;
  final Location? relatedLocation;

  InventoryHistory({
    required this.id,
    required this.toolId,
    required this.locationId,
    required this.action,
    required this.quantity,
    required this.quantityBefore,
    required this.quantityAfter,
    this.relatedLocationId,
    this.notes,
    this.toolLife,
    required this.created,
    this.location,
    this.relatedLocation,
  });

  factory InventoryHistory.fromRecord(dynamic record) {
    final data = record.data;
    
    // Parse location expansions
    Location? expandedLocation;
    Location? expandedRelatedLocation;
    
    try {
      if (record.expand != null) {
        if (record.expand['location'] != null) {
          final locationData = record.expand['location'];
          expandedLocation = locationData is List && locationData.isNotEmpty
              ? Location.fromRecord(locationData[0])
              : Location.fromRecord(locationData);
        }
        
        if (record.expand['related_location'] != null) {
          final relatedData = record.expand['related_location'];
          expandedRelatedLocation = relatedData is List && relatedData.isNotEmpty
              ? Location.fromRecord(relatedData[0])
              : Location.fromRecord(relatedData);
        }
      }
    } catch (e) {
      print('⚠️ Error expanding history locations: $e');
    }
    
    return InventoryHistory(
      id: record.id,
      toolId: data['tool'] ?? '',
      locationId: data['location'] ?? '',
      action: data['action'] ?? '',
      quantity: (data['quantity'] ?? 0).toInt(),
      quantityBefore: (data['quantity_before'] ?? 0).toInt(),
      quantityAfter: (data['quantity_after'] ?? 0).toInt(),
      relatedLocationId: data['related_location'],
      notes: data['notes'],
      toolLife: data['tool_life']?.toDouble(),
      created: DateTime.parse(data['created'] ?? record.created),
      location: expandedLocation,
      relatedLocation: expandedRelatedLocation,
    );
  }
  
  // Get a user-friendly description of the action
  String getActionDescription() {
    switch (action) {
      case 'add':
        return 'Added $quantity';
      case 'remove':
        return 'Removed $quantity';
      case 'transfer_out':
        return 'Transferred $quantity out';
      case 'transfer_in':
        return 'Transferred $quantity in';
      case 'edit':
        final diff = quantityAfter - quantityBefore;
        if (diff > 0) {
          return 'Increased by ${diff.abs()}';
        } else if (diff < 0) {
          return 'Decreased by ${diff.abs()}';
        } else {
          return 'Quantity unchanged';
        }
      default:
        return action;
    }
  }
  
  // Get icon for the action
  String getActionIcon() {
    switch (action) {
      case 'add':
        return '➕';
      case 'remove':
        return '➖';
      case 'transfer_out':
        return '📤';
      case 'transfer_in':
        return '📥';
      case 'edit':
        return '✏️';
      default:
        return '📝';
    }
  }
}

// Purchase tracking
class Purchase {
  final String id;
  final DateTime purchaseDate;
  final String? supplierId;
  final String? orderReference;
  final String? notes;
  final double? total;
  final String? supplierName;

  Purchase({
    required this.id,
    required this.purchaseDate,
    this.supplierId,
    this.orderReference,
    this.notes,
    this.total,
    this.supplierName,
  });

  factory Purchase.fromRecord(dynamic record) {
    final data = record.data;
    String? supplierName;
    try {
      if (record.expand != null && record.expand['supplier'] != null) {
        final s = record.expand['supplier'];
        if (s is List && s.isNotEmpty) {
          supplierName = s[0].data?['company_name'];
        } else {
          supplierName = s.data?['company_name'];
        }
      }
    } catch (_) {}
    return Purchase(
      id: record.id,
      purchaseDate: data['purchase_date'] != null
          ? DateTime.parse(data['purchase_date'].toString())
          : DateTime.parse(record.created),
      supplierId: data['supplier'],
      orderReference: data['order_reference'],
      notes: data['notes'],
      total: data['total']?.toDouble(),
      supplierName: supplierName,
    );
  }
}

class PurchaseItem {
  final String id;
  final String purchaseId;
  final String? toolId;       // null for tax/shipping lines
  final int quantity;
  final double? unitCost;
  final String? toolName;
  final String lineType;      // 'item' | 'tax' | 'shipping'
  final String? description;  // e.g. 'GST', 'PST', 'Shipping'

  PurchaseItem({
    required this.id,
    required this.purchaseId,
    this.toolId,
    required this.quantity,
    this.unitCost,
    this.toolName,
    this.lineType = 'item',
    this.description,
  });

  factory PurchaseItem.fromRecord(dynamic record) {
    final data = record.data;
    String? toolName;
    try {
      if (record.expand != null && record.expand['tool'] != null) {
        final t = record.expand['tool'];
        if (t is List && t.isNotEmpty) {
          toolName = t[0].data?['tool_name'];
        } else {
          toolName = t.data?['tool_name'];
        }
      }
    } catch (_) {}
    return PurchaseItem(
      id: record.id,
      purchaseId: data['purchase'] ?? '',
      toolId: data['tool'],
      quantity: (data['quantity'] ?? 0).toInt(),
      unitCost: data['unit_cost']?.toDouble(),
      toolName: toolName,
      lineType: data['line_type'] ?? 'item',
      description: data['description'],
    );
  }

  bool get isItem => lineType == 'item';
  bool get isTax => lineType == 'tax';
  bool get isShipping => lineType == 'shipping';
}

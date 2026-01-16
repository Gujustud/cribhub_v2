// models.dart
// Model classes for PocketBase records

class Tool {
  final String id;
  final String toolName;
  final String category;
  final String? subcategory;
  final String? subSubcategory;
  final String? modelNumber;
  final String? manufacturerBarcode;
  final double? diameterIn;
  final double? diameterMm;
  final int? flutes;
  final double? fluteLength;
  final double? cornerRad;
  final double? neck;
  final String? size;
  final String? serialNumber;
  final String? brand;
  final String? supplier;

  Tool({
    required this.id,
    required this.toolName,
    required this.category,
    this.subcategory,
    this.subSubcategory,
    this.modelNumber,
    this.manufacturerBarcode,
    this.diameterIn,
    this.diameterMm,
    this.flutes,
    this.fluteLength,
    this.cornerRad,
    this.neck,
    this.size,
    this.serialNumber,
    this.brand,
    this.supplier,
  });

  factory Tool.fromRecord(dynamic record) {
    // RecordModel has .id and .data properties
    final data = record.data;
    return Tool(
      id: record.id,
      toolName: data['tool_name'] ?? '',
      category: data['category'] ?? '',
      subcategory: data['subcategory'],
      subSubcategory: data['sub_subcategory'],
      modelNumber: data['model_number'],
      manufacturerBarcode: data['manufacturer_barcode'],
      diameterIn: data['diameter_in']?.toDouble(),
      diameterMm: data['diameter_mm']?.toDouble(),
      flutes: data['flutes']?.toInt(),
      fluteLength: data['flute_length']?.toDouble(),
      cornerRad: data['corner_rad']?.toDouble(),
      neck: data['neck']?.toDouble(),
      size: data['size'],
      serialNumber: data['serial_number'],
      brand: data['brand'],
      supplier: data['supplier'],
    );
  }

  // Helper method to get display specs
  String get displaySpecs {
    final parts = <String>[];
    if (diameterIn != null) parts.add('Ø${diameterIn}"');
    if (diameterMm != null) parts.add('Ø${diameterMm}mm');
    if (flutes != null) parts.add('${flutes}FL');
    if (modelNumber != null && modelNumber!.isNotEmpty) parts.add(modelNumber!);
    return parts.isEmpty ? '' : parts.join(' • ');
  }
}

class Location {
  final String id;
  final String name;
  final String type; // machine, shelf, toolbox, recycle
  final String? qrCode;
  final String? machine; // For locations linked to machines

  Location({
    required this.id,
    required this.name,
    required this.type,
    this.qrCode,
    this.machine,
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
        expandedLocation = Location.fromRecord(record.expand['location']);
      }
    } catch (e) {
      // Expand not available
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

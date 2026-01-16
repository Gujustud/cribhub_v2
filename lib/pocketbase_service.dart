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
}
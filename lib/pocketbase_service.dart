import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'app_config.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  late final PocketBase pb;

  factory PocketBaseService() {
    return _instance;
  }

  PocketBaseService._internal() {
    pb = PocketBase(AppConfig.pocketBaseUrl);
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
      final record = await pb.collection('inventory').create(body: {
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
      final records = await pb.collection('inventory').getFullList(
        expand: 'brand,supplier',
      );
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

  /// Tool locations at [locationId] with tool expanded (for checking tool_name).
  Future<List<dynamic>> getToolLocationsAtLocationWithTool(String locationId) async {
    try {
      final records = await pb.collection('tool_locations').getFullList(
        filter: 'location = "$locationId" && quantity > 0',
        expand: 'tool',
      );
      return records;
    } catch (e) {
      print('Error getting tool locations at location: $e');
      rethrow;
    }
  }

  // Get tool by ID
  Future<dynamic> getToolById(String toolId) async {
    try {
      final record = await pb.collection('inventory').getOne(
        toolId,
        expand: 'brand,supplier',
      );
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
  Future<List<dynamic>> getBrands({String? categoryId}) async {
    try {
      List<dynamic> records;
      if (categoryId != null) {
        print('DEBUG getBrands: Filtering by categoryId = $categoryId');
        records = await pb.collection('brands').getFullList(sort: 'name');
        print('DEBUG getBrands: Loaded ${records.length} total brands');
        
        // Filter: show brands with no categories OR brands that include this category
        records = records.where((brand) {
          final categories = brand.data['categories'];
          final brandName = brand.data['name'];
          print('DEBUG getBrands: Brand "$brandName" has categories = $categories (type: ${categories?.runtimeType})');
          
          // If no categories assigned, show for all (backward compatible)
          if (categories == null || categories == '' || (categories is List && categories.isEmpty)) {
            print('DEBUG getBrands: Brand "$brandName" has no categories - showing for all');
            return true;
          }
          
          // Check if this category is in the list
          if (categories is List) {
            final matches = categories.any((c) {
              String? catId;
              if (c is String) {
                catId = c;
              } else if (c is Map && c['id'] != null) {
                catId = c['id'];
              } else {
                catId = c.toString();
              }
              return catId == categoryId;
            });
            print('DEBUG getBrands: Brand "$brandName" ${matches ? "MATCHES" : "does NOT match"} category $categoryId');
            return matches;
          }
          
          // Handle single value (shouldn't happen with multiple relation, but just in case)
          if (categories is Map && categories['id'] != null) {
            final matches = categories['id'] == categoryId;
            print('DEBUG getBrands: Brand "$brandName" (single value) ${matches ? "MATCHES" : "does NOT match"}');
            return matches;
          }
          
          final matches = categories.toString() == categoryId;
          print('DEBUG getBrands: Brand "$brandName" (string) ${matches ? "MATCHES" : "does NOT match"}');
          return matches;
        }).toList();
        
        print('DEBUG getBrands: After filtering, ${records.length} brands match category $categoryId');
      } else {
        records = await pb.collection('brands').getFullList(sort: 'name');
      }
      return records;
    } catch (e) {
      print('Error getting brands: $e');
      rethrow;
    }
  }

  Future<void> createBrand(
    String name, {
    List<String>? categoryIds,
    String? urlPattern,
    bool? scraperEnabled,
    String? scraperNotes,
  }) async {
    try {
      final body = <String, dynamic>{'name': name};
      if (categoryIds != null && categoryIds.isNotEmpty) {
        body['categories'] = categoryIds;
      }
      // Add scraping fields if provided
      if (urlPattern != null && urlPattern.isNotEmpty) {
        body['url_pattern'] = urlPattern;
      }
      if (scraperEnabled != null) {
        body['scraper_enabled'] = scraperEnabled;
      }
      if (scraperNotes != null && scraperNotes.isNotEmpty) {
        body['scraper_notes'] = scraperNotes;
      }
      await pb.collection('brands').create(body: body);
    } catch (e) {
      print('Error creating brand: $e');
      rethrow;
    }
  }

  Future<void> updateBrand(
    String id,
    String name, {
    List<String>? categoryIds,
    String? urlPattern,
    bool? scraperEnabled,
    String? scraperNotes,
  }) async {
    try {
      final body = <String, dynamic>{'name': name};
      // Always set categories, even if empty (to clear existing ones)
      if (categoryIds != null) {
        body['categories'] = categoryIds;
      } else {
        // If null, set to empty array to clear all categories
        body['categories'] = [];
      }
      // Add scraping fields if provided
      if (urlPattern != null) {
        body['url_pattern'] = urlPattern;
      }
      if (scraperEnabled != null) {
        body['scraper_enabled'] = scraperEnabled;
      }
      if (scraperNotes != null) {
        body['scraper_notes'] = scraperNotes;
      }
      print('DEBUG updateBrand: Updating brand $id with categories: ${body['categories']} (type: ${body['categories'].runtimeType})');
      print('DEBUG updateBrand: Body being sent: $body');
      final result = await pb.collection('brands').update(id, body: body);
      print('DEBUG updateBrand: Successfully updated brand $id');
      print('DEBUG updateBrand: Result categories = ${result.data['categories']} (type: ${result.data['categories']?.runtimeType})');
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
  Future<List<dynamic>> getSuppliers({String? categoryId}) async {
    try {
      List<dynamic> records;
      if (categoryId != null) {
        print('DEBUG getSuppliers: Filtering by categoryId = $categoryId');
        records = await pb.collection('suppliers').getFullList(sort: 'company_name');
        print('DEBUG getSuppliers: Loaded ${records.length} total suppliers');
        
        // Filter: show suppliers with no categories OR suppliers that include this category
        records = records.where((supplier) {
          final categories = supplier.data['categories'];
          final supplierName = supplier.data['company_name'];
          print('DEBUG getSuppliers: Supplier "$supplierName" has categories = $categories (type: ${categories?.runtimeType})');
          
          // If no categories assigned, show for all (backward compatible)
          if (categories == null || categories == '' || (categories is List && categories.isEmpty)) {
            print('DEBUG getSuppliers: Supplier "$supplierName" has no categories - showing for all');
            return true;
          }
          
          // Check if this category is in the list
          if (categories is List) {
            final matches = categories.any((c) {
              String? catId;
              if (c is String) {
                catId = c;
              } else if (c is Map && c['id'] != null) {
                catId = c['id'];
              } else {
                catId = c.toString();
              }
              return catId == categoryId;
            });
            print('DEBUG getSuppliers: Supplier "$supplierName" ${matches ? "MATCHES" : "does NOT match"} category $categoryId');
            return matches;
          }
          
          // Handle single value (shouldn't happen with multiple relation, but just in case)
          if (categories is Map && categories['id'] != null) {
            final matches = categories['id'] == categoryId;
            print('DEBUG getSuppliers: Supplier "$supplierName" (single value) ${matches ? "MATCHES" : "does NOT match"}');
            return matches;
          }
          
          final matches = categories.toString() == categoryId;
          print('DEBUG getSuppliers: Supplier "$supplierName" (string) ${matches ? "MATCHES" : "does NOT match"}');
          return matches;
        }).toList();
        
        print('DEBUG getSuppliers: After filtering, ${records.length} suppliers match category $categoryId');
      } else {
        records = await pb.collection('suppliers').getFullList(sort: 'company_name');
      }
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
    List<String>? categoryIds,
  }) async {
    try {
      final body = <String, dynamic>{
        'company_name': companyName,
        'address': address,
        'tel': tel,
        'website': website,
        'contact': contact,
        'direct_tel': directTel,
        'email': email,
      };
      if (categoryIds != null && categoryIds.isNotEmpty) {
        body['categories'] = categoryIds;
      }
      await pb.collection('suppliers').create(body: body);
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
    List<String>? categoryIds,
  }) async {
    try {
      final body = <String, dynamic>{
        'company_name': companyName,
        'address': address,
        'tel': tel,
        'website': website,
        'contact': contact,
        'direct_tel': directTel,
        'email': email,
      };
      // Always set categories, even if empty (to clear existing ones)
      if (categoryIds != null) {
        body['categories'] = categoryIds;
      } else {
        // If null, set to empty array to clear all categories
        body['categories'] = [];
      }
      print('DEBUG updateSupplier: Updating supplier $id with categories: ${body['categories']}');
      await pb.collection('suppliers').update(id, body: body);
      print('DEBUG updateSupplier: Successfully updated supplier $id');
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
  // CATEGORY MANAGEMENT
  // ============================================================================

  // Get all categories (sorted by sort_order)
  Future<List<dynamic>> getCategories() async {
    try {
      final records = await pb.collection('categories').getFullList(
        sort: 'sort_order,name',
      );
      return records;
    } catch (e) {
      print('Error getting categories: $e');
      rethrow;
    }
  }

  // Create a new category
  Future<void> createCategory({
    required String name,
    required int sortOrder,
  }) async {
    try {
      await pb.collection('categories').create(body: {
        'name': name,
        'sort_order': sortOrder,
      });
      print('Category created: $name');
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }

  // Update a category
  Future<void> updateCategory({
    required String categoryId,
    required String name,
    required int sortOrder,
  }) async {
    try {
      await pb.collection('categories').update(categoryId, body: {
        'name': name,
        'sort_order': sortOrder,
      });
      print('Category updated: $categoryId');
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await pb.collection('categories').delete(categoryId);
      print('Category deleted: $categoryId');
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  // Check if category has inventory items
  Future<int> getCategoryInventoryCount(String categoryName) async {
    try {
      final records = await pb.collection('inventory').getFullList(
        filter: 'category = "$categoryName"',
      );
      return records.length;
    } catch (e) {
      print('Error checking category inventory: $e');
      return 0;
    }
  }

  // ============================================================================
  // APP SETTINGS MANAGEMENT
  // ============================================================================

  // Get app settings (creates default if doesn't exist)
  Future<dynamic> getAppSettings() async {
    try {
      // Try to get the first settings record
      try {
        final settings = await pb.collection('app_settings').getFirstListItem('');
        return settings;
      } catch (e) {
        // No settings found, create default
        final defaultSettings = await pb.collection('app_settings').create(body: {
          'show_all_inventory_in_menu': true,
        });
        return defaultSettings;
      }
    } catch (e) {
      print('Error getting app settings: $e');
      rethrow;
    }
  }

  // Update app settings
  Future<void> updateAppSettings({
    required String settingsId,
    required bool showAllInventoryInMenu,
    String? subcategoryDisplayMode,
    bool? showToolDetailsInList, // NEW
    bool? useCategoryButtons, // NEW
    bool? enableToolImport, // NEW - for tool import feature
  }) async {
    try {
      final Map<String, dynamic> body = {
        'show_all_inventory_in_menu': showAllInventoryInMenu,
      };

      if (subcategoryDisplayMode != null) {
        body['subcategory_display_mode'] = subcategoryDisplayMode;
      }
      
      if (showToolDetailsInList != null) {
        body['show_tool_details_in_list'] = showToolDetailsInList;
      }
      
      if (useCategoryButtons != null) {
        body['use_category_buttons'] = useCategoryButtons;
      }
      
      // NEW: Add tool import setting
      if (enableToolImport != null) {
        body['enable_tool_import'] = enableToolImport;
      }

      await pb.collection('app_settings').update(settingsId, body: body);
      print('App settings updated');
    } catch (e) {
      print('Error updating app settings: $e');
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

  // ============================================================================
  // SUBCATEGORY MANAGEMENT
  // ============================================================================

  // Get all subcategories (sorted by sort_order)
  Future<List<dynamic>> getSubcategories() async {
    try {
      final records = await pb.collection('subcategories').getFullList(
        sort: 'sort_order,name',
      );
      return records;
    } catch (e) {
      print('Error getting subcategories: $e');
      rethrow;
    }
  }

  // Get top-level subcategories for a category
  Future<List<dynamic>> getTopLevelSubcategories(String categoryId) async {
    try {
      final records = await pb.collection('subcategories').getFullList(
        filter: 'category = "$categoryId"',
        sort: 'sort_order,name',
      );
      return records;
    } catch (e) {
      print('Error getting top-level subcategories: $e');
      rethrow;
    }
  }

  // Get child subcategories of a parent
  Future<List<dynamic>> getChildSubcategories(String parentId) async {
    try {
      final records = await pb.collection('subcategories').getFullList(
        filter: 'parent_subcategory = "$parentId"',
        sort: 'sort_order,name',
      );
      return records;
    } catch (e) {
      print('Error getting child subcategories: $e');
      rethrow;
    }
  }

  // Create subcategory
  Future<void> createSubcategory({
    required String name,
    String? categoryId,
    String? parentSubcategoryId,
    required int sortOrder,
    String? label, // NEW: Label for this subcategory itself
    String? customLabel,
    String? attributeListId,
    String? displayMode, // dropdown or buttons
    String? fieldType, // NEW: selection, text, number
  }) async {
    try {
      final body = <String, dynamic>{
        'name': name,
        'sort_order': sortOrder,
      };
      
      // For child subcategories, only set parent_subcategory
      // For top-level subcategories, only set category
      if (parentSubcategoryId != null) {
        body['parent_subcategory'] = parentSubcategoryId;
        print('DEBUG createSubcategory: Setting parent_subcategory=$parentSubcategoryId for "$name"');
        // Don't set category for child subcategories
      } else if (categoryId != null) {
        body['category'] = categoryId;
        print('DEBUG createSubcategory: Setting category=$categoryId for "$name"');
      }
      
      if (label != null && label.isNotEmpty) {
        body['label'] = label;
      }
      
      if (customLabel != null && customLabel.isNotEmpty) {
        body['custom_label'] = customLabel;
      }
      
      if (attributeListId != null) {
        body['attribute_list'] = attributeListId;
      }
      
      if (displayMode != null) {
        body['display_mode'] = displayMode;
      }
      
      if (fieldType != null) {
        body['field_type'] = fieldType;
      }
      
      print('DEBUG createSubcategory: Creating "$name" with body: $body');
      await pb.collection('subcategories').create(body: body);
      print('Subcategory created: $name');
    } catch (e) {
      print('Error creating subcategory: $e');
      rethrow;
    }
  }

  // Update subcategory
  Future<void> updateSubcategory({
    required String subcategoryId,
    required String name,
    required int sortOrder,
    String? label, // NEW: Label for this subcategory itself
    String? customLabel,
    String? attributeListId,
    String? parentSubcategoryId,
    String? displayMode, // dropdown or buttons
    String? fieldType, // NEW: selection, text, number
  }) async {
    try {
      final body = <String, dynamic>{
        'name': name,
        'sort_order': sortOrder,
      };
      
      // Always set label and custom_label (can be null to clear)
      body['label'] = label;
      body['custom_label'] = customLabel;
      
      // Always set attribute_list (can be null to clear)
      body['attribute_list'] = attributeListId;
      
      // If setting parent_subcategory, clear category
      if (parentSubcategoryId != null) {
        body['parent_subcategory'] = parentSubcategoryId;
        body['category'] = null; // Explicitly clear category for child subcategories
      }
      
      if (displayMode != null) {
        body['display_mode'] = displayMode;
      }
      
      if (fieldType != null) {
        body['field_type'] = fieldType;
      }
      
      await pb.collection('subcategories').update(subcategoryId, body: body);
      print('Subcategory updated: $subcategoryId');
    } catch (e) {
      print('Error updating subcategory: $e');
      rethrow;
    }
  }

  // Delete subcategory
  Future<void> deleteSubcategory(String subcategoryId) async {
    try {
      await pb.collection('subcategories').delete(subcategoryId);
      print('Subcategory deleted: $subcategoryId');
    } catch (e) {
      print('Error deleting subcategory: $e');
      rethrow;
    }
  }

  // Check if subcategory has children
  Future<bool> subcategoryHasChildren(String subcategoryId) async {
    try {
      final records = await pb.collection('subcategories').getFullList(
        filter: 'parent_subcategory = "$subcategoryId"',
      );
      return records.isNotEmpty;
    } catch (e) {
      print('Error checking subcategory children: $e');
      return false;
    }
  }

  // Check if subcategory is used in inventory
  Future<int> getSubcategoryInventoryCount(String subcategoryName) async {
    try {
      final records = await pb.collection('inventory').getFullList(
        filter: 'subcategory = "$subcategoryName"',
      );
      return records.length;
    } catch (e) {
      print('Error checking subcategory inventory: $e');
      return 0;
    }
  }

  // ============================================================================
  // ATTRIBUTE LISTS MANAGEMENT
  // ============================================================================

  // Get all attribute lists
  Future<List<dynamic>> getAttributeLists() async {
    try {
      final records = await pb.collection('attribute_lists').getFullList(
        sort: 'name',
      );
      return records;
    } catch (e) {
      print('Error getting attribute lists: $e');
      rethrow;
    }
  }

  // Create attribute list
  Future<void> createAttributeList({
    required String name,
    String? displayMode, // NEW: dropdown or buttons
  }) async {
    try {
      final body = <String, dynamic>{'name': name};
      if (displayMode != null) {
        body['display_mode'] = displayMode;
      }
      await pb.collection('attribute_lists').create(body: body);
      print('Attribute list created: $name');
    } catch (e) {
      print('Error creating attribute list: $e');
      rethrow;
    }
  }

  // Update attribute list
  Future<void> updateAttributeList({
    required String listId,
    required String name,
    String? displayMode, // NEW: dropdown or buttons
  }) async {
    try {
      final body = <String, dynamic>{'name': name};
      if (displayMode != null) {
        body['display_mode'] = displayMode;
      }
      await pb.collection('attribute_lists').update(listId, body: body);
      print('Attribute list updated: $listId');
    } catch (e) {
      print('Error updating attribute list: $e');
      rethrow;
    }
  }

  // Delete attribute list
  Future<void> deleteAttributeList(String listId) async {
    try {
      await pb.collection('attribute_lists').delete(listId);
      print('Attribute list deleted: $listId');
    } catch (e) {
      print('Error deleting attribute list: $e');
      rethrow;
    }
  }

  // Get attribute values for a list
  Future<List<dynamic>> getAttributeValues(String listId) async {
    try {
      final records = await pb.collection('attribute_values').getFullList(
        filter: 'attribute_list = "$listId"',
        sort: 'sort_order,value',
      );
      return records;
    } catch (e) {
      print('Error getting attribute values: $e');
      rethrow;
    }
  }

  // Create attribute value
  Future<void> createAttributeValue({
    required String listId,
    required String value,
    required int sortOrder,
  }) async {
    try {
      await pb.collection('attribute_values').create(body: {
        'attribute_list': listId,
        'value': value,
        'sort_order': sortOrder,
      });
      print('Attribute value created: $value');
    } catch (e) {
      print('Error creating attribute value: $e');
      rethrow;
    }
  }

  // Update attribute value
  Future<void> updateAttributeValue({
    required String valueId,
    required String value,
    required int sortOrder,
  }) async {
    try {
      await pb.collection('attribute_values').update(valueId, body: {
        'value': value,
        'sort_order': sortOrder,
      });
      print('Attribute value updated: $valueId');
    } catch (e) {
      print('Error updating attribute value: $e');
      rethrow;
    }
  }

  // Delete attribute value
  Future<void> deleteAttributeValue(String valueId) async {
    try {
      await pb.collection('attribute_values').delete(valueId);
      print('Attribute value deleted: $valueId');
    } catch (e) {
      print('Error deleting attribute value: $e');
      rethrow;
    }
  }

  // ============================================================================
  // TOOL IMPORT FROM WEB (MCP Server Integration)
  // ============================================================================

  /// Import tool specifications from vendor website using MCP server
  /// 
  /// This calls the MCP server which uses Ollama/Qwen2.5 to extract tool specs
  /// from vendor websites intelligently.
  /// 
  /// Parameters:
  /// - [brand]: Brand name (for logging/display)
  /// - [urlPattern]: URL pattern with {model} placeholder (e.g., "https://example.com/{model}")
  /// - [modelNumber]: Tool model number (required if urlPattern is provided)
  /// - [url]: Direct URL to tool page (optional, overrides urlPattern)
  /// 
  /// Returns a Map with:
  /// - 'success': bool - whether the import succeeded
  /// - 'data': Map - extracted tool specs if successful
  /// - 'source_url': String - the URL that was scraped
  /// - 'error': String - error message if failed
  Future<Map<String, dynamic>?> importToolSpecs({
    required String brand,
    String? urlPattern,
    String? modelNumber,
    String? url,
  }) async {
    try {
      // MCP Server URL - change this to match your setup
      // For production, this could be loaded from app_settings
      const mcpServerUrl = AppConfig.mcpUrl;
      
      // Build URL from pattern if provided
      String? finalUrl = url;
      if (finalUrl == null && urlPattern != null && modelNumber != null) {
        finalUrl = urlPattern.replaceAll('{model}', modelNumber);
      }
      
      if (finalUrl == null) {
        return {
          'success': false,
          'error': 'No URL or URL pattern provided for import',
        };
      }
      
      final requestBody = {
        'brand': brand,
        'url': finalUrl,
      };
      
      print('🔍 Importing tool specs from MCP server...');
      print('   Brand: $brand');
      print('   URL: $finalUrl');
      
      final response = await http.post(
        Uri.parse('$mcpServerUrl/api/extract-tool-specs'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 180)); // LLM extraction can take time
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        if (data['success'] == true) {
          print('✅ Tool specs imported successfully');
          print('   Source: ${data['source_url']}');
          return {
            'success': true,
            'data': data['data'],
            'source_url': data['source_url'],
          };
        } else {
          print('❌ Import failed: ${data['error']}');
          return {
            'success': false,
            'error': data['error'] ?? 'Unknown error',
          };
        }
      } else {
        print('❌ MCP Server returned status ${response.statusCode}');
        return {
          'success': false,
          'error': 'Server returned status ${response.statusCode}',
        };
      }
    } on http.ClientException catch (e) {
      print('❌ Network error connecting to MCP server: $e');
      return {
        'success': false,
        'error': 'Cannot connect to import server. Make sure it is running.',
      };
    } on TimeoutException catch (e) {
      print('❌ Import timed out: $e');
      return {
        'success': false,
        'error': 'Import timed out. This can happen on first run while the model loads. Try again.',
      };
    } catch (e) {
      print('❌ Unexpected error during import: $e');
      return {
        'success': false,
        'error': 'Unexpected error: $e',
      };
    }
  }

 
  }

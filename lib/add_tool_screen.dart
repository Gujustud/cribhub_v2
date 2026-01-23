import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'pocketbase_service.dart';
import 'models.dart';
import 'add_inventory_dialog.dart';
import 'app_drawer.dart';
import 'package:intl/intl.dart'; // For date formatting in history

class AddToolScreen extends StatefulWidget {
  final Tool? tool; // If provided, we're in edit mode
  final bool isDuplicate; // If true, we're duplicating (don't update, create new)
  
  const AddToolScreen({
    super.key,
    this.tool,
    this.isDuplicate = false,
  });

  @override
  State<AddToolScreen> createState() => _AddToolScreenState();
}

class _AddToolScreenState extends State<AddToolScreen> {
  // Cutting Tools category ID from PocketBase
  static const String CUTTING_TOOLS_CATEGORY_ID = '0ro99ktjwyl14dc';
  
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _toolNameController = TextEditingController();
  final _modelNumberController = TextEditingController();
  final _urlController = TextEditingController();
  final _diameterInController = TextEditingController();
  final _diameterMmController = TextEditingController();
  final _flutesController = TextEditingController();
  final _fluteLengthController = TextEditingController();
  final _cornerRadController = TextEditingController();
  final _neckController = TextEditingController();
  
  // Dropdown values
  String _category = 'Cutting Tools';
  
  // Subcategories
  List<dynamic> _allSubcategories = [];
  List<String?> _selectedSubcategoryIds = []; // Stack of selections for unlimited levels
  String _subcategoryText = ''; // Combined subcategory text for saving
  
  // NEW: Store text/number input values for subcategories
  Map<int, String> _subcategoryTextValues = {}; // level → text value
  Map<int, double?> _subcategoryNumberValues = {}; // level → number value
  
  // Temporary backward compatibility variables (will be replaced with dynamic system)
  String? _subcategory = 'Endmills';
  String? _subSubcategory = 'Flat';
  
  // Attribute
  String? _selectedAttributeValue;
  
  // Categories (loaded dynamically)
  List<dynamic> _categories = [];
  String? _selectedCategoryId;
  
  // Location selection
  List<dynamic> _locations = [];
  
  // Inventory to add (for add/duplicate mode)
  Map<String, dynamic>? _inventoryToAdd; // {quantity: int, locationId: String, locationPath: String}
  
  // Brand and Supplier selection
  List<dynamic> _brands = [];
  List<dynamic> _suppliers = [];
  String? _selectedBrandId;
  String? _selectedSupplierId;
  
  // Auto-generated tool name
  String _toolName = '';
  bool _autoGenerateName = true;
  
  // Photo
  String? _photoUrl;
  Uint8List? _photoBytes;
  bool _photoChanged = false;
  
  // Tool locations (for edit mode)
  List<ToolLocation> _toolLocations = [];
  List<Location> _allLocations = [];
  
  // NEW: History tracking
  List<InventoryHistory> _recentHistory = [];
  bool _loadingHistory = false;
  
  bool get _isEditMode => widget.tool != null && !widget.isDuplicate;
  
  @override
  void initState() {
    super.initState();
    _loadLocations();
    _loadBrandsAndSuppliers();
    _loadCategories(); // Load categories dynamically
    _loadSubcategories();
    
    // If editing or duplicating, pre-fill fields
    if (widget.tool != null) {
      _prefillFields();
    }
    
    _diameterInController.addListener(_scheduleToolNameUpdate);
    _flutesController.addListener(_scheduleToolNameUpdate);
    _fluteLengthController.addListener(_scheduleToolNameUpdate);
    _cornerRadController.addListener(_scheduleToolNameUpdate);
    _neckController.addListener(_scheduleToolNameUpdate);
    
    if (_isEditMode) {
      _loadToolLocations();
      _loadRecentHistory(); // NEW: Load history for edit mode
    }
  }
  
  void _prefillFields() {
    final tool = widget.tool!;
    _toolNameController.text = widget.isDuplicate ? '${tool.toolName} (Copy)' : tool.toolName;
    _modelNumberController.text = tool.modelNumber ?? '';
    _urlController.text = tool.url ?? '';
    
    // Ensure category exists (default to Cutting Tools)
    _category = tool.category.isNotEmpty ? tool.category : 'Cutting Tools';
    
    // Load subcategories and try to match existing values
    // This will be handled after subcategories are loaded
    _subcategory = tool.subcategory;
    _subSubcategory = tool.subSubcategory;
    
    // Safely get attribute_value from record
    if (tool.record != null && tool.record.data != null) {
      _selectedAttributeValue = tool.record.data['attribute_value'];
    } else {
      _selectedAttributeValue = null;
    }
    
    // Don't set brand/supplier until they're loaded
    // Will be set in _loadBrandsAndSuppliers if valid
    if (tool.brandId != null && tool.brandId!.isNotEmpty) {
      _selectedBrandId = tool.brandId;
    }
    if (tool.supplierId != null && tool.supplierId!.isNotEmpty) {
      _selectedSupplierId = tool.supplierId;
    }
    
    if (tool.diameterIn != null) {
      _diameterInController.text = tool.diameterIn.toString();
    }
    if (tool.diameterMm != null) {
      _diameterMmController.text = tool.diameterMm.toString();
    }
    if (tool.flutes != null) {
      _flutesController.text = tool.flutes.toString();
    }
    if (tool.fluteLength != null) {
      _fluteLengthController.text = tool.fluteLength.toString();
    }
    if (tool.cornerRad != null) {
      _cornerRadController.text = tool.cornerRad.toString();
    }
    if (tool.neck != null) {
      _neckController.text = tool.neck.toString();
    }
    
    // Load photo if exists
    if (tool.photo != null && tool.photo!.isNotEmpty) {
      final pbService = PocketBaseService();
      _photoUrl = pbService.pb.files.getUrl(
        tool.record,
        tool.photo!,
      ).toString();
    }
    
    _autoGenerateName = false;
  }
  
  Future<void> _loadToolLocations() async {
    try {
      final pbService = PocketBaseService();
      final locationRecords = await pbService.getLocations();
      _allLocations = locationRecords.map((r) => Location.fromRecord(r)).toList();
      
      final toolLocationRecords = await pbService.pb
          .collection('tool_locations')
          .getFullList(
            filter: 'tool = "${widget.tool!.id}"',
            expand: 'location',
          );
      
      setState(() {
        _toolLocations = toolLocationRecords
            .map((r) => ToolLocation.fromRecord(r))
            .toList();
      });
    } catch (e) {
      print('Error loading tool locations: $e');
    }
  }
  
  // NEW: Load recent history for the tool
  Future<void> _loadRecentHistory() async {
    if (!_isEditMode) return;
    
    setState(() {
      _loadingHistory = true;
    });
    
    try {
      final pbService = PocketBaseService();
      final historyRecords = await pbService.getInventoryHistory(
        toolId: widget.tool!.id,
        limit: 5,
      );
      
      setState(() {
        _recentHistory = historyRecords
            .map((r) => InventoryHistory.fromRecord(r))
            .toList();
        _loadingHistory = false;
      });
    } catch (e) {
      print('Error loading history: $e');
      setState(() {
        _loadingHistory = false;
      });
    }
  }
  
  Future<void> _loadLocations() async {
    try {
      final pbService = PocketBaseService();
      final locations = await pbService.getLocations();
      setState(() {
        _locations = locations;
      });
    } catch (e) {
      print('Error loading locations: $e');
    }
  }
  
  Future<void> _loadSubcategories() async {
    try {
      final pbService = PocketBaseService();
      final subcategories = await pbService.getSubcategories();
      setState(() {
        _allSubcategories = subcategories;
        
        // If editing/duplicating, try to match existing subcategory names to IDs
        if (widget.tool != null && _subcategory != null && _subcategory!.isNotEmpty) {
          _matchSubcategoryNamesToIds();
        }
      });
    } catch (e) {
      print('Error loading subcategories: $e');
    }
  }

  void _matchSubcategoryNamesToIds() {
    // Try to find subcategories by name and build the selection chain
    _selectedSubcategoryIds.clear();
    
    if (_selectedCategoryId == null) return;
    
    // Find first level subcategory
    final firstLevel = _allSubcategories.where((s) =>
      s.data['category'] == _selectedCategoryId &&
      s.data['name'] == _subcategory &&
      (s.data['parent_subcategory'] == null || s.data['parent_subcategory'] == '')
    ).toList();
    
    if (firstLevel.isNotEmpty) {
      _selectedSubcategoryIds.add(firstLevel.first.id);
      
      // If there's a sub-subcategory, try to find it
      if (_subSubcategory != null && _subSubcategory!.isNotEmpty) {
        final secondLevel = _allSubcategories.where((s) =>
          s.data['parent_subcategory'] == firstLevel.first.id &&
          s.data['name'] == _subSubcategory
        ).toList();
        
        if (secondLevel.isNotEmpty) {
          _selectedSubcategoryIds.add(secondLevel.first.id);
        }
      }
      
      _updateSubcategoryText();
    }
  }

  Future<void> _loadBrandsAndSuppliers() async {
    try {
      final pbService = PocketBaseService();
      final brands = await pbService.getBrands();
      final suppliers = await pbService.getSuppliers();
      setState(() {
        _brands = brands;
        _suppliers = suppliers;
        
        // Validate selected IDs after loading
        if (widget.tool != null) {
          // Check if selected brand exists
          if (_selectedBrandId != null) {
            final brandExists = brands.any((b) => b.id == _selectedBrandId);
            if (!brandExists) {
              _selectedBrandId = null;
            }
          }
          
          // Check if selected supplier exists
          if (_selectedSupplierId != null) {
            final supplierExists = suppliers.any((s) => s.id == _selectedSupplierId);
            if (!supplierExists) {
              _selectedSupplierId = null;
            }
          }
        }
      });
    } catch (e) {
      print('Error loading brands/suppliers: $e');
    }
  }
  
  Future<void> _loadCategories() async {
    try {
      final pbService = PocketBaseService();
      final categories = await pbService.getCategories();
      setState(() {
        _categories = categories;
        
        // If editing/duplicating, find the category by name
        if (widget.tool != null && categories.isNotEmpty) {
          final toolCategory = widget.tool!.category;
          final matchingCategory = categories.where(
            (c) => c.data['name'] == toolCategory,
          );
          
          if (matchingCategory.isNotEmpty) {
            _selectedCategoryId = matchingCategory.first.id;
            _category = matchingCategory.first.data['name'];
          } else {
            // Category doesn't exist, default to Cutting Tools or first
            final cuttingTools = categories.where(
              (c) => c.data['name'] == 'Cutting Tools',
            );
            if (cuttingTools.isNotEmpty) {
              _selectedCategoryId = cuttingTools.first.id;
              _category = cuttingTools.first.data['name'];
            } else {
              _selectedCategoryId = categories.first.id;
              _category = categories.first.data['name'];
            }
          }
          
          // After setting category, try to match subcategories if they're loaded
          if (_allSubcategories.isNotEmpty) {
            _matchSubcategoryNamesToIds();
          }
        } else if (_selectedCategoryId == null && categories.isNotEmpty) {
          // New tool - default to "Cutting Tools" if it exists
          final cuttingTools = categories.where(
            (c) => c.data['name'] == 'Cutting Tools',
          );
          if (cuttingTools.isNotEmpty) {
            _selectedCategoryId = cuttingTools.first.id;
            _category = cuttingTools.first.data['name'];
          } else {
            _selectedCategoryId = categories.first.id;
            _category = categories.first.data['name'];
          }
        }
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }
  
  void _scheduleToolNameUpdate() {
    if (!_autoGenerateName) return;
    
    final newName = _generateToolName();
    if (newName != _toolName) {
      setState(() {
        _toolName = newName;
      });
      _toolNameController.text = newName;
    }
  }
  
  void _updateToolName() {
    setState(() {
      _toolName = _generateToolName();
    });
  }
  
  String _generateToolName() {
    final diaIn = double.tryParse(_diameterInController.text);
    final flutes = int.tryParse(_flutesController.text);
    final fluteLen = double.tryParse(_fluteLengthController.text);
    final cornerRad = double.tryParse(_cornerRadController.text);
    final neck = double.tryParse(_neckController.text);
    
    if (diaIn == null || flutes == null || fluteLen == null) {
      return '';
    }
    
    String diaStr = diaIn.toString();
    if (diaIn < 1 && diaStr.startsWith('0.')) {
      diaStr = diaStr.substring(1);
    }
    
    String flStr;
    if (fluteLen < 1) {
      flStr = fluteLen.toString();
      if (flStr.startsWith('0.')) {
        flStr = flStr.substring(1);
      }
    } else {
      if (fluteLen % 1 == 0) {
        flStr = fluteLen.toStringAsFixed(1);
      } else {
        flStr = fluteLen.toString();
      }
    }
    
    String name = '${diaStr}_${flutes}F_${flStr}FL';
    
    // Only include corner radius if the subcategory is CR
    if (cornerRad != null && cornerRad > 0 && _subSubcategory == 'CR') {
      String crStr = cornerRad.toString();
      if (cornerRad < 1 && crStr.startsWith('0.')) {
        crStr = crStr.substring(1);
      }
      name += '_${crStr}CR';
    }
    
    // Only include neck radius if there's a value (independent of type)
    if (neck != null && neck > 0) {
      String neckStr = neck.toString();
      if (neck < 1 && neckStr.startsWith('0.')) {
        neckStr = neckStr.substring(1);
      }
      name += '_${neckStr}NR';
    }
    
    // Add type suffix for Ball and Tslot
    if (_subSubcategory == 'Ball') {
      name += '_BALL';
    } else if (_subSubcategory == 'Tslot') {
      name += '_TSLOT';
    }
    
    return name;
  }
  
  void _onDiameterInChanged(String value) {
    final diaIn = double.tryParse(value);
    if (diaIn != null) {
      _diameterMmController.text = (diaIn * 25.4).toStringAsFixed(2);
    }
  }
  
  void _onDiameterMmChanged(String value) {
    final diaMm = double.tryParse(value);
    if (diaMm != null) {
      _diameterInController.text = (diaMm / 25.4).toStringAsFixed(3);
    }
  }
  
  Future<void> _pickPhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      
      if (result != null) {
        setState(() {
          _photoBytes = result.files.first.bytes;
          _photoChanged = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking photo: $e')),
      );
    }
  }
  
  void _extractFromUrl() {
    // Placeholder for future implementation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
        content: Text('Extract from URL feature coming soon!'),
            backgroundColor: Colors.orange,
          ),
        );
  }
  
  Future<void> _showAddInventoryDialog() async {
    print('DEBUG: _showAddInventoryDialog called');
    print('DEBUG: _isEditMode = $_isEditMode');
    print('DEBUG: widget.tool = ${widget.tool?.toolName}');
    print('DEBUG: widget.isDuplicate = ${widget.isDuplicate}');
    
    final pbService = PocketBaseService();
    
    // For edit mode, get existing locations
    List<ToolLocation>? existingLocations;
    List<String>? historicalLocationIds;
    
    if (_isEditMode) {
      existingLocations = _toolLocations;
      print('DEBUG: _toolLocations count: ${_toolLocations.length}');
      for (var tl in _toolLocations) {
        print('DEBUG: Location ${tl.location?.name ?? "null"}, qty: ${tl.quantity}');
      }
      
      // NEW: Get historical add locations
      historicalLocationIds = await pbService.getHistoricalAddLocations(
        toolId: widget.tool!.id,
        limit: 3,
      );
      print('DEBUG: Historical location IDs: $historicalLocationIds');
    } else {
      print('DEBUG: NOT in edit mode - no existing locations');
    }
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddInventoryDialog(
        allLocations: _locations,
        existingLocations: existingLocations,
        historicalLocationIds: historicalLocationIds, // NEW
      ),
    );
    
    if (result != null) {
      if (_isEditMode) {
        // Edit mode: Add inventory immediately WITH HISTORY LOGGING
        try {
          final pbService = PocketBaseService();
          
          // Get current quantity before adding
          final quantityBefore = await pbService.getCurrentQuantityAtLocation(
            toolId: widget.tool!.id,
            locationId: result['locationId'],
          );
          
          // Check if tool_location already exists at this location
          final existingRecords = await pbService.pb
              .collection('tool_locations')
              .getFullList(
                filter: 'tool = "${widget.tool!.id}" && location = "${result['locationId']}"',
              );
          
          if (existingRecords.isNotEmpty) {
            // Update existing record
            final existingRecord = existingRecords.first;
            final newQuantity = quantityBefore + (result['quantity'] as int);
            await pbService.pb.collection('tool_locations').update(
              existingRecord.id,
              body: {'quantity': newQuantity},
            );
          } else {
            // Create new record
            await pbService.createToolLocation(
              toolId: widget.tool!.id,
              locationId: result['locationId'],
              quantity: result['quantity'] as int,
            );
          }
          
          // Log history
          await pbService.logInventoryHistory(
            toolId: widget.tool!.id,
            locationId: result['locationId'],
            action: 'add',
            quantity: result['quantity'] as int,
            quantityBefore: quantityBefore,
            quantityAfter: quantityBefore + (result['quantity'] as int),
          );
          
          await _loadToolLocations();
          await _loadRecentHistory(); // Refresh history
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inventory added!'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Add/duplicate mode: Store for later when tool is saved
        setState(() {
          _inventoryToAdd = {
            'quantity': result['quantity'],
            'locationId': result['locationId'],
            'locationPath': _buildLocationPath(result['locationId']),
          };
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inventory of ${result['quantity']} will be added when tool is saved'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }
  
  String _buildLocationPath(String locationId) {
    final names = <String>[];
    var currentId = locationId;
    
    while (currentId.isNotEmpty) {
      try {
        final loc = _locations.firstWhere((l) => l.id == currentId);
        names.insert(0, loc.data['name']);
        currentId = loc.data['parent'] ?? '';
      } catch (e) {
        break;
      }
    }
    
    return names.join(' → ');
  }

  // Build dynamic cascading subcategory selectors
  List<Widget> _buildSubcategorySelectors() {
    if (_selectedCategoryId == null) return [];

    final widgets = <Widget>[];

    // Get top-level subcategories for selected category
    final topLevel = _allSubcategories.where((s) =>
      s.data['category'] == _selectedCategoryId &&
      (s.data['parent_subcategory'] == null || s.data['parent_subcategory'] == '')
    ).toList();

    if (topLevel.isEmpty) return widgets;

    // Build selector for level 0
    widgets.add(_buildSubcategorySelector(topLevel, 0));

    // Build selectors for nested levels
    for (int i = 0; i < _selectedSubcategoryIds.length; i++) {
      if (_selectedSubcategoryIds[i] == null) break;

      final children = _allSubcategories.where((s) =>
        s.data['parent_subcategory'] == _selectedSubcategoryIds[i]
      ).toList();

      if (children.isNotEmpty) {
        widgets.add(const SizedBox(height: 16));
        widgets.add(_buildSubcategorySelector(children, i + 1));
      }
    }

    // Check if deepest selected subcategory has attribute list
    if (_selectedSubcategoryIds.isNotEmpty) {
      final deepestId = _selectedSubcategoryIds.last;
      if (deepestId != null) {
        try {
          final deepest = _allSubcategories.firstWhere((s) => s.id == deepestId);
          final attrListId = deepest.data['attribute_list'];
          if (attrListId != null && attrListId.toString().isNotEmpty) {
            widgets.add(const SizedBox(height: 16));
            widgets.add(_buildAttributeSelector(attrListId));
          }
        } catch (e) {
          // Deepest subcategory not found, skip attribute list
          print('Deepest subcategory not found: $e');
        }
      }
    }

    return widgets;
  }

  Widget _buildSubcategorySelector(List<dynamic> options, int level) {
    // Get label, display_mode, and field_type from parent or first option
    String label = 'Subcategory';
    String displayMode = 'dropdown'; // Default
    String fieldType = 'selection'; // Default
    
    if (level > 0 && _selectedSubcategoryIds.length >= level) {
      final parentId = _selectedSubcategoryIds[level - 1];
      if (parentId != null) {
        try {
          final parent = _allSubcategories.firstWhere((s) => s.id == parentId);
          // For children, use parent's custom_label (label for children)
          label = parent.data['custom_label'] ?? 'Type';
          // Read display_mode and field_type from parent
          displayMode = parent.data['display_mode'] ?? 'dropdown';
          fieldType = parent.data['field_type'] ?? 'selection';
        } catch (e) {
          // Parent not found, use default label
        }
      }
    } else if (level == 0 && _selectedCategoryId != null) {
      // For first level, use the subcategory's own label field
      if (options.isNotEmpty) {
        final firstSub = options.first;
        // NEW: Use 'label' field for this subcategory's own label
        label = firstSub.data['label'] ?? 'Subcategory';
        displayMode = firstSub.data['display_mode'] ?? 'dropdown';
        fieldType = firstSub.data['field_type'] ?? 'selection';
      }
    }

    // Check field type FIRST
    if (fieldType == 'text') {
      return _buildTextInputSelector(level, label);
    } else if (fieldType == 'number') {
      return _buildNumberInputSelector(level, label);
    }
    
    // For 'selection' type, use display mode
    if (displayMode == 'buttons') {
      return _buildButtonSelector(options, level, label);
    } else {
      return _buildDropdownSelector(options, level, label);
    }
  }

  Widget _buildDropdownSelector(List<dynamic> options, int level, String label) {
    // Ensure _selectedSubcategoryIds has enough slots
    while (_selectedSubcategoryIds.length <= level) {
      _selectedSubcategoryIds.add(null);
    }

    return DropdownButtonFormField<String>(
      value: _selectedSubcategoryIds[level],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options.map<DropdownMenuItem<String>>((sub) {
        return DropdownMenuItem<String>(
          value: sub.id,
          child: Text(sub.data['name']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSubcategoryIds[level] = value;
          // Clear selections beyond this level
          _selectedSubcategoryIds = _selectedSubcategoryIds.sublist(0, level + 1);
          _selectedAttributeValue = null;
          _updateSubcategoryText();
          _updateToolName();
        });
      },
    );
  }

  Widget _buildButtonSelector(List<dynamic> options, int level, String label) {
    // Ensure _selectedSubcategoryIds has enough slots
    while (_selectedSubcategoryIds.length <= level) {
      _selectedSubcategoryIds.add(null);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((sub) {
            final isSelected = _selectedSubcategoryIds[level] == sub.id;
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedSubcategoryIds[level] = sub.id;
                  // Clear selections beyond this level
                  _selectedSubcategoryIds = _selectedSubcategoryIds.sublist(0, level + 1);
                  _selectedAttributeValue = null;
                  _updateSubcategoryText();
                  _updateToolName();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                foregroundColor: isSelected ? Colors.white : Colors.black,
              ),
              child: Text(sub.data['name']),
            );
          }).toList(),
        ),
      ],
    );
  }

  // NEW: Build text input selector for text field type
  Widget _buildTextInputSelector(int level, String label) {
    return TextFormField(
      initialValue: _subcategoryTextValues[level] ?? '',
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _subcategoryTextValues[level] = value;
          // Text inputs don't have children, so clear beyond this level
          _selectedSubcategoryIds = _selectedSubcategoryIds.sublist(0, level);
          _selectedAttributeValue = null;
          _updateSubcategoryText();
        });
      },
    );
  }

  // NEW: Build number input selector for number field type
  Widget _buildNumberInputSelector(int level, String label) {
    return TextFormField(
      initialValue: _subcategoryNumberValues[level]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        setState(() {
          _subcategoryNumberValues[level] = double.tryParse(value);
          // Number inputs don't have children, so clear beyond this level
          _selectedSubcategoryIds = _selectedSubcategoryIds.sublist(0, level);
          _selectedAttributeValue = null;
          _updateSubcategoryText();
        });
      },
    );
  }

  Widget _buildAttributeSelector(String attrListId) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadAttributeListAndValues(attrListId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!;
        final values = data['values'] as List<dynamic>;
        final displayMode = data['display_mode'] as String;
        
        if (values.isEmpty) return const SizedBox.shrink();

        // Use a generic label (could be enhanced to use attribute list name)
        const String label = 'Attribute';

        if (displayMode == 'buttons') {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: values.map((value) {
                  final isSelected = _selectedAttributeValue == value.data['value'];
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedAttributeValue = value.data['value'];
                        _updateToolName();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                    ),
                    child: Text(value.data['value']),
                  );
                }).toList(),
              ),
            ],
          );
        } else {
          return DropdownButtonFormField<String>(
            value: _selectedAttributeValue,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            items: values.map<DropdownMenuItem<String>>((val) {
              return DropdownMenuItem<String>(
                value: val.data['value'],
                child: Text(val.data['value']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAttributeValue = value;
                _updateToolName();
              });
            },
          );
        }
      },
    );
  }
  
  // Helper method to load both attribute list and its values
  Future<Map<String, dynamic>> _loadAttributeListAndValues(String attrListId) async {
    final pbService = PocketBaseService();
    final attributeLists = await pbService.getAttributeLists();
    final values = await pbService.getAttributeValues(attrListId);
    
    // Find the attribute list to get its display_mode
    dynamic attributeList;
    try {
      attributeList = attributeLists.firstWhere((al) => al.id == attrListId);
    } catch (e) {
      // If not found, use default
      return {
        'values': values,
        'display_mode': 'dropdown',
      };
    }
    
    return {
      'values': values,
      'display_mode': attributeList.data['display_mode'] ?? 'dropdown',
    };
  }

  void _updateSubcategoryText() {
    // Build subcategory text from selected IDs and text/number inputs
    final subcategoryNames = <String>[];
    
    for (int i = 0; i < _selectedSubcategoryIds.length; i++) {
      final id = _selectedSubcategoryIds[i];
      if (id != null) {
        try {
          final sub = _allSubcategories.firstWhere((s) => s.id == id);
          subcategoryNames.add(sub.data['name']);
        } catch (e) {
          // Subcategory not found, skip it
          print('Subcategory with id $id not found: $e');
        }
      }
    }
    
    // Add text/number values
    _subcategoryTextValues.forEach((level, value) {
      if (value.isNotEmpty) {
        subcategoryNames.add(value);
      }
    });
    
    _subcategoryNumberValues.forEach((level, value) {
      if (value != null) {
        subcategoryNames.add(value.toString());
      }
    });

    // Update backward compatibility variables
    _subcategory = subcategoryNames.isNotEmpty ? subcategoryNames[0] : null;
    _subSubcategory = subcategoryNames.length > 1 ? subcategoryNames[1] : null;
    _subcategoryText = subcategoryNames.join(' > ');
    
    // Clear corner radius field if not CR type (prevents stale CR values in tool name)
    if (_subSubcategory != 'CR' && _cornerRadController.text.isNotEmpty) {
      _cornerRadController.clear();
    }
    
    // Update tool name to reflect subcategory changes (fixes Ball/CR suffix sticking)
    if (_autoGenerateName) {
      _updateToolName();
    }
  }

  void _saveTool() async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        final pbService = PocketBaseService();
        
        // Build subcategory strings from selected IDs
        String subcategoryStr = '';
        String subSubcategoryStr = '';
        if (_selectedSubcategoryIds.isNotEmpty) {
          try {
            final firstSub = _allSubcategories.firstWhere(
              (s) => s.id == _selectedSubcategoryIds[0],
            );
            subcategoryStr = firstSub.data['name'];
            
            if (_selectedSubcategoryIds.length > 1) {
              try {
                final secondSub = _allSubcategories.firstWhere(
                  (s) => s.id == _selectedSubcategoryIds[1],
                );
                subSubcategoryStr = secondSub.data['name'];
              } catch (e) {
                // Second subcategory not found
                print('Second subcategory not found: $e');
              }
            }
          } catch (e) {
            // First subcategory not found
            print('First subcategory not found: $e');
          }
        }
        
        final body = {
          'tool_name': _toolNameController.text,
          'category': _category,
          'subcategory': subcategoryStr.isNotEmpty ? subcategoryStr : (_subcategory ?? ''),
          'sub_subcategory': subSubcategoryStr.isNotEmpty ? subSubcategoryStr : (_subSubcategory ?? ''),
          'attribute_value': _selectedAttributeValue,
          'model_number': _modelNumberController.text.isEmpty 
              ? null 
              : _modelNumberController.text,
          'url': _urlController.text.isEmpty 
              ? null 
              : _urlController.text,
          'brand': _selectedBrandId,
          'supplier': _selectedSupplierId,
          'diameter_in': double.tryParse(_diameterInController.text),
          'diameter_mm': double.tryParse(_diameterMmController.text),
          'flutes': int.tryParse(_flutesController.text),
          'flute_length': double.tryParse(_fluteLengthController.text),
          'corner_rad': double.tryParse(_cornerRadController.text),
          'neck': double.tryParse(_neckController.text),
        };
        
        dynamic toolRecord;
        
        if (_isEditMode) {
          // Update existing tool
          if (_photoChanged && _photoBytes != null) {
            toolRecord = await pbService.pb.collection('inventory').update(
              widget.tool!.id,
              body: body,
              files: [
                http.MultipartFile.fromBytes(
                  'photo',
                  _photoBytes!,
                  filename: 'tool_photo.jpg',
                ),
              ],
            );
          } else {
            toolRecord = await pbService.pb.collection('inventory').update(
              widget.tool!.id,
              body: body,
            );
          }
        } else {
          // Create new tool
          if (_photoBytes != null) {
            toolRecord = await pbService.pb.collection('inventory').create(
              body: body,
              files: [
                http.MultipartFile.fromBytes(
                  'photo',
                  _photoBytes!,
                  filename: 'tool_photo.jpg',
                ),
              ],
            );
          } else {
            toolRecord = await pbService.pb.collection('inventory').create(body: body);
          }
          
          // Create tool_location record if inventory was added
          if (_inventoryToAdd != null) {
        await pbService.createToolLocation(
          toolId: toolRecord.id,
              locationId: _inventoryToAdd!['locationId'],
              quantity: _inventoryToAdd!['quantity'] as int,
            );
            
            // Log initial inventory add
            await pbService.logInventoryHistory(
              toolId: toolRecord.id,
              locationId: _inventoryToAdd!['locationId'],
              action: 'add',
              quantity: _inventoryToAdd!['quantity'] as int,
              quantityBefore: 0,
              quantityAfter: _inventoryToAdd!['quantity'] as int,
            );
          }
        }

        if (context.mounted) Navigator.pop(context);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditMode 
                  ? 'Tool updated successfully!' 
                  : 'Tool "${_toolNameController.text}" saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Pop back to tool list with refresh indicator
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (context.mounted) Navigator.pop(context);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving tool: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Tool' : widget.isDuplicate ? 'Duplicate Tool' : 'Add Tool'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
      ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT COLUMN - Tool Details
            Expanded(
              flex: 3,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
                  // Tool Name
              TextFormField(
                controller: _toolNameController,
                    decoration: InputDecoration(
                  labelText: 'Tool Name',
                      border: const OutlineInputBorder(),
                      suffixIcon: _selectedCategoryId == CUTTING_TOOLS_CATEGORY_ID
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _autoGenerateName,
                                  onChanged: (value) {
                                    setState(() {
                                      _autoGenerateName = value ?? true;
                                      if (_autoGenerateName) {
                                        _toolName = _generateToolName();
                                        _toolNameController.text = _toolName;
                                      }
                                    });
                                  },
                                ),
                                const Text('Auto'),
                                const SizedBox(width: 8),
                              ],
                            )
                          : null,
                    ),
                    enabled: _selectedCategoryId == CUTTING_TOOLS_CATEGORY_ID 
                        ? !_autoGenerateName 
                        : true,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tool name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
            
            // Model Number
            TextFormField(
              controller: _modelNumberController,
              decoration: const InputDecoration(
                labelText: 'Model Number (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Brand and Supplier row
            Row(
              children: [
                // BRAND - Searchable Autocomplete
                Expanded(
                  child: Autocomplete<String>(
                    initialValue: _selectedBrandId != null && _brands.any((b) => b.id == _selectedBrandId)
                        ? TextEditingValue(
                            text: _brands.firstWhere((b) => b.id == _selectedBrandId).data['name'],
                          )
                        : const TextEditingValue(),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return _brands.map((brand) => brand.data['name'] as String);
                      }
                      return _brands
                          .where((brand) => (brand.data['name'] as String)
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()))
                          .map((brand) => brand.data['name'] as String);
                    },
                    onSelected: (String selectedName) {
                      final brand = _brands.firstWhere((b) => b.data['name'] == selectedName);
                      setState(() {
                        _selectedBrandId = brand.id;
                      });
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Brand (optional)',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clear();
                              setState(() {
                                _selectedBrandId = null;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          // Clear selection if text doesn't match any brand
                          if (!_brands.any((b) => b.data['name'] == value)) {
                            setState(() {
                              _selectedBrandId = null;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // SUPPLIER - Searchable Autocomplete
                Expanded(
                  child: Autocomplete<String>(
                    initialValue: _selectedSupplierId != null && _suppliers.any((s) => s.id == _selectedSupplierId)
                        ? TextEditingValue(
                            text: _suppliers.firstWhere((s) => s.id == _selectedSupplierId).data['company_name'],
                          )
                        : const TextEditingValue(),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return _suppliers.map((supplier) => supplier.data['company_name'] as String);
                      }
                      return _suppliers
                          .where((supplier) => (supplier.data['company_name'] as String)
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()))
                          .map((supplier) => supplier.data['company_name'] as String);
                    },
                    onSelected: (String selectedName) {
                      final supplier = _suppliers.firstWhere((s) => s.data['company_name'] == selectedName);
                      setState(() {
                        _selectedSupplierId = supplier.id;
                      });
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Supplier (optional)',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clear();
                              setState(() {
                                _selectedSupplierId = null;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          // Clear selection if text doesn't match any supplier
                          if (!_suppliers.any((s) => s.data['company_name'] == value)) {
                            setState(() {
                              _selectedSupplierId = null;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
                  const SizedBox(height: 16),
                  
                  // URL
                  TextFormField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'URL (optional)',
                      border: OutlineInputBorder(),
                      hintText: 'Product URL',
                    ),
            ),
            const SizedBox(height: 16),
            
            // CATEGORY - Searchable Autocomplete
            Autocomplete<String>(
              initialValue: _selectedCategoryId != null && _categories.any((c) => c.id == _selectedCategoryId)
                  ? TextEditingValue(
                      text: _categories.firstWhere((c) => c.id == _selectedCategoryId).data['name'],
                    )
                  : const TextEditingValue(),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return _categories.map((cat) => cat.data['name'] as String);
                }
                return _categories
                    .where((cat) => (cat.data['name'] as String)
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()))
                    .map((cat) => cat.data['name'] as String);
              },
              onSelected: (String selectedName) {
                final category = _categories.firstWhere((c) => c.data['name'] == selectedName);
                setState(() {
                  _selectedCategoryId = category.id;
                  _category = category.data['name'];
                  // Clear subcategory selections when category changes
                  _selectedSubcategoryIds.clear();
                  _selectedAttributeValue = null;
                  _updateSubcategoryText();
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    if (!_categories.any((c) => c.data['name'] == value)) {
                      return 'Please select a valid category from the list';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Clear selection if text doesn't match any category
                    if (!_categories.any((c) => c.data['name'] == value)) {
                      setState(() {
                        _selectedCategoryId = null;
                        _category = '';
                        _selectedSubcategoryIds.clear();
                        _selectedAttributeValue = null;
                        _updateSubcategoryText();
                      });
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Dynamic Cascading Subcategories
            ..._buildSubcategorySelectors(),
            
            const SizedBox(height: 16),
            
            // Hardcoded Fields - Only show for Cutting Tools category
            if (_selectedCategoryId == CUTTING_TOOLS_CATEGORY_ID) ...[
              // Diameter row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _diameterInController,
                    decoration: const InputDecoration(
                      labelText: 'Diameter (in)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: _onDiameterInChanged,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _diameterMmController,
                    decoration: const InputDecoration(
                      labelText: 'Diameter (mm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: _onDiameterMmChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Flutes
            TextFormField(
              controller: _flutesController,
              decoration: const InputDecoration(
                labelText: 'Number of Flutes',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (int.tryParse(value) == null) {
                  return 'Must be a whole number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Flute Length
            TextFormField(
              controller: _fluteLengthController,
              decoration: const InputDecoration(
                labelText: 'Flute Length',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (double.tryParse(value) == null) {
                  return 'Invalid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
                  // Corner Radius
            if (_subSubcategory == 'CR')
              Column(
                children: [
                  TextFormField(
                    controller: _cornerRadController,
                    decoration: const InputDecoration(
                      labelText: 'Corner Radius',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            
            // Neck
            TextFormField(
              controller: _neckController,
              decoration: const InputDecoration(
                labelText: 'Neck (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            ], // End of hardcoded Cutting Tools fields
                  
            const SizedBox(height: 24),
                  
            // Save button
            SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveTool,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        _isEditMode ? 'UPDATE TOOL' : 'SAVE TOOL',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
                ],
              ),
            ),
            
            // RIGHT COLUMN - Photo & Inventory
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.grey[100],
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Photo
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _photoBytes != null
                          ? Image.memory(_photoBytes!, fit: BoxFit.contain)
                          : _photoUrl != null
                              ? Image.network(_photoUrl!, fit: BoxFit.contain)
                              : const Center(
                                  child: Icon(Icons.image_outlined, size: 64, color: Colors.grey),
                                ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Upload Photo button
                    ElevatedButton.icon(
                      onPressed: _pickPhoto,
                      icon: const Icon(Icons.upload),
                      label: const Text('Upload Photo'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Extract from URL button (placeholder)
                    ElevatedButton.icon(
                      onPressed: _extractFromUrl,
                      icon: const Icon(Icons.link),
                      label: const Text('Extract from URL'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Inventory section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Inventory',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: _showAddInventoryDialog,
                          icon: const Icon(Icons.add_circle),
                          color: Colors.blue,
                          tooltip: 'Add Inventory',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Show pending inventory for add/duplicate mode
                    if (!_isEditMode && _inventoryToAdd != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          border: Border.all(color: Colors.blue[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Qty: ${_inventoryToAdd!['quantity']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _inventoryToAdd!['locationPath'],
                                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () {
                      setState(() {
                                  _inventoryToAdd = null;
                      });
                    },
                            ),
                          ],
                        ),
                      ),
                    
                    // Location tags for edit mode
                    if (_isEditMode) ...[
                      if (_toolLocations.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No inventory',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ..._getSortedToolLocations().map((toolLocation) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InventoryLocationTag(
                              toolLocation: toolLocation,
                              allLocations: _allLocations,
                              onChanged: () {
                                _loadToolLocations();
                                _loadRecentHistory(); // Refresh history when inventory changes
                              },
                            ),
                          );
                        }),
                    ],
                    
                    // NEW: History section (edit mode only)
                    if (_isEditMode) ...[
                      const SizedBox(height: 32),
                      const Divider(),
            const SizedBox(height: 16),
            
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent History',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (_recentHistory.isNotEmpty)
                            TextButton.icon(
                              onPressed: () {
                                _showAllHistory();
                              },
                              icon: const Icon(Icons.history, size: 18),
                              label: const Text('View All'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      if (_loadingHistory)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_recentHistory.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No history yet',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        )
                      else
                        ..._buildHistoryItems(_recentHistory),
                      
                      // NEW: Performance Stats placeholder
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Performance Stats',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                          Tooltip(
                            message: 'Performance tracking coming soon',
                            child: Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  icon: Icons.access_time,
                                  label: 'Avg Tool Life',
                                  value: '-- hrs',
                                  color: Colors.blue,
                                ),
                                _buildStatItem(
                                  icon: Icons.inventory_2,
                                  label: 'Total Used',
                                  value: '--',
                                  color: Colors.orange,
                                ),
                              ],
            ),
            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  icon: Icons.trending_up,
                                  label: 'Best Location',
                                  value: '--',
                                  color: Colors.green,
                                ),
                                _buildStatItem(
                                  icon: Icons.trending_down,
                                  label: 'Worst Location',
                                  value: '--',
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // NEW: Get sorted tool locations by type order (matches location types order)
  List<ToolLocation> _getSortedToolLocations() {
    final typeOrder = {
      'toolbox': 1,
      'machine': 2,
      'shelf': 3,
      'recycle': 4,
      'bin': 5,      // fallback
      'worn': 6,     // fallback
      'broken': 7,   // fallback
    };
    
    final sorted = List<ToolLocation>.from(_toolLocations);
    sorted.sort((a, b) {
      final typeA = a.location?.type.toLowerCase() ?? 'unknown';
      final typeB = b.location?.type.toLowerCase() ?? 'unknown';
      
      final orderA = typeOrder[typeA] ?? 99;
      final orderB = typeOrder[typeB] ?? 99;
      
      // First sort by type
      if (orderA != orderB) {
        return orderA.compareTo(orderB);
      }
      
      // Then sort by location name within same type
      final nameA = a.location?.name ?? '';
      final nameB = b.location?.name ?? '';
      return nameA.compareTo(nameB);
    });
    
    return sorted;
  }
  
  // NEW: Build history items with smart transfer pairing
  List<Widget> _buildHistoryItems(List<InventoryHistory> historyList) {
    final widgets = <Widget>[];
    final processedIndices = <int>{};
    
    for (int i = 0; i < historyList.length; i++) {
      if (processedIndices.contains(i)) continue;
      
      final current = historyList[i];
      
      // Check if this is a transfer_out with a matching transfer_in
      if (current.action == 'transfer_out' && i + 1 < historyList.length) {
        final next = historyList[i + 1];
        
        // Check if next entry is the matching transfer_in
        // (same time within 1 second, related locations match)
        if (next.action == 'transfer_in' &&
            current.created.difference(next.created).inSeconds.abs() <= 1 &&
            current.relatedLocationId == next.locationId &&
            next.relatedLocationId == current.locationId) {
          
          // Found a pair! Create combined widget
          widgets.add(_buildCombinedTransferItem(current, next));
          processedIndices.add(i);
          processedIndices.add(i + 1);
          continue;
        }
      }
      
      // Check if this is a transfer_in with a matching transfer_out before it
      if (current.action == 'transfer_in' && i > 0) {
        final prev = historyList[i - 1];
        
        if (prev.action == 'transfer_out' &&
            prev.created.difference(current.created).inSeconds.abs() <= 1 &&
            prev.relatedLocationId == current.locationId &&
            current.relatedLocationId == prev.locationId) {
          
          // Already handled by the previous iteration
          if (!processedIndices.contains(i - 1)) {
            widgets.add(_buildCombinedTransferItem(prev, current));
            processedIndices.add(i - 1);
            processedIndices.add(i);
          }
          continue;
        }
      }
      
      // Not part of a pair, show as individual entry
      widgets.add(_buildHistoryItem(current));
    }
    
    return widgets;
  }
  
  // NEW: Build combined transfer widget (single box for both transfer_out and transfer_in)
  Widget _buildCombinedTransferItem(InventoryHistory transferOut, InventoryHistory transferIn) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    
    // Get location names
    String sourceLocationName = 'Unknown';
    if (transferOut.location != null) {
      sourceLocationName = transferOut.location!.name;
    } else {
      try {
        final loc = _allLocations.firstWhere((l) => l.id == transferOut.locationId);
        sourceLocationName = loc.name;
      } catch (e) {}
    }
    
    String destLocationName = 'Unknown';
    if (transferIn.location != null) {
      destLocationName = transferIn.location!.name;
    } else {
      try {
        final loc = _allLocations.firstWhere((l) => l.id == transferIn.locationId);
        destLocationName = loc.name;
      } catch (e) {}
    }
    
    final locationDisplay = '$sourceLocationName → $destLocationName';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                '↔️',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 10),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action description
                Text(
                  'Transferred ${transferOut.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                
                // Location with arrow
                Text(
                  locationDisplay,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Date and quantity change on right
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateFormat.format(transferOut.created),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                '${transferOut.quantityBefore} → ${transferOut.quantityAfter}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // NEW: Build history item widget
  Widget _buildHistoryItem(InventoryHistory history) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    
    // Try to get location name, with fallback
    String locationName = 'Unknown Location';
    if (history.location != null) {
      locationName = history.location!.name;
    } else {
      // Fallback: try to find location in _allLocations
      try {
        final loc = _allLocations.firstWhere((l) => l.id == history.locationId);
        locationName = loc.name;
      } catch (e) {
        // Keep 'Unknown Location'
      }
    }
    
    // Get related location name
    String? relatedLocationName;
    if (history.relatedLocation != null) {
      relatedLocationName = history.relatedLocation!.name;
    } else if (history.relatedLocationId != null) {
      // Fallback: try to find in _allLocations
      try {
        final loc = _allLocations.firstWhere((l) => l.id == history.relatedLocationId);
        relatedLocationName = loc.name;
      } catch (e) {
        relatedLocationName = 'Unknown';
      }
    }
    
    // Build location display with arrow for transfers
    String locationDisplay;
    if (relatedLocationName != null) {
      if (history.action == 'transfer_out') {
        locationDisplay = '$locationName → $relatedLocationName';
      } else if (history.action == 'transfer_in') {
        locationDisplay = '$relatedLocationName → $locationName';
      } else {
        locationDisplay = locationName;
      }
    } else {
      locationDisplay = locationName;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                history.getActionIcon(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 10),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action description
                Text(
                  history.getActionDescription(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                
                // Location with arrow
                Text(
                  locationDisplay,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Date and quantity change on right
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateFormat.format(history.created),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                '${history.quantityBefore} → ${history.quantityAfter}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // NEW: Build stat item widget for performance stats
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
  
  // NEW: Show all history dialog
  Future<void> _showAllHistory() async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Complete History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: PocketBaseService().getAllInventoryHistory(
                    toolId: widget.tool!.id,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading history: ${snapshot.error}'),
                      );
                    }
                    
                    final allHistory = snapshot.data
                        ?.map((r) => InventoryHistory.fromRecord(r))
                        .toList() ?? [];
                    
                    if (allHistory.isEmpty) {
                      return const Center(
                        child: Text('No history found'),
                      );
                    }
                    
                    // Use smart pairing for all history too
                    final historyWidgets = _buildHistoryItems(allHistory);
                    
                    return ListView.builder(
                      itemCount: historyWidgets.length,
                      itemBuilder: (context, index) {
                        return historyWidgets[index];
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _toolNameController.dispose();
    _modelNumberController.dispose();
    _urlController.dispose();
    _diameterInController.dispose();
    _diameterMmController.dispose();
    _flutesController.dispose();
    _fluteLengthController.dispose();
    _cornerRadController.dispose();
    _neckController.dispose();
    super.dispose();
  }
}

// Keep the InventoryLocationTag widget exactly as it was (from previous version)
class InventoryLocationTag extends StatelessWidget {
  final ToolLocation toolLocation;
  final List<Location> allLocations;
  final VoidCallback onChanged;

  const InventoryLocationTag({
    Key? key,
    required this.toolLocation,
    required this.allLocations,
    required this.onChanged,
  }) : super(key: key);

  String _buildLocationPath(Location location) {
    final names = <String>[];
    var current = location;
    
    while (true) {
      names.insert(0, current.name);
      
      if (current.parentId == null || current.parentId!.isEmpty) break;
      
      try {
        current = allLocations.firstWhere((loc) => loc.id == current.parentId);
      } catch (e) {
        break;
      }
    }
    
    return names.join('-');
  }

  @override
  Widget build(BuildContext context) {
    final location = toolLocation.location;
    final quantity = toolLocation.quantity;
    
    if (location == null) {
      return const SizedBox.shrink();
    }

    final locationPath = _buildLocationPath(location);
    final type = location.type.toLowerCase();
    
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    
    switch (type) {
      case 'toolbox':
        backgroundColor = Colors.red[50]!;
        borderColor = Colors.red[300]!;
        textColor = Colors.red[900]!;
        break;
      case 'shelf':
        backgroundColor = Colors.orange[50]!;
        borderColor = Colors.orange[300]!;
        textColor = Colors.orange[900]!;
        break;
      case 'machine':
        backgroundColor = Colors.blue[50]!;
        borderColor = Colors.blue[300]!;
        textColor = Colors.blue[900]!;
        break;
      case 'recycle':
        backgroundColor = Colors.grey[200]!;
        borderColor = Colors.grey[400]!;
        textColor = Colors.grey[800]!;
        break;
      default:
        backgroundColor = Colors.grey[50]!;
        borderColor = Colors.grey[300]!;
        textColor = Colors.grey[900]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Qty: $quantity • $locationPath',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          // Transfer icon
          IconButton(
            icon: const Icon(Icons.swap_horiz, size: 18),
            color: Colors.orange[700],
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Transfer',
            onPressed: () => _showTransferDialog(context),
          ),
          const SizedBox(width: 8),
          // Delete icon
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            color: Colors.red[700],
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Remove from location',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }
  
  // Delete confirmation and execution
  Future<void> _confirmDelete(BuildContext context) async {
    final location = toolLocation.location;
    if (location == null) return;
    
    final locationPath = _buildLocationPath(location);
    final quantity = toolLocation.quantity;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Location'),
        content: Text('Remove this tool from $locationPath?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      try {
        final pbService = PocketBaseService();
        
        // Log before deleting
        await pbService.logInventoryHistory(
          toolId: toolLocation.toolId,
          locationId: toolLocation.locationId,
          action: 'remove',
          quantity: quantity,
          quantityBefore: quantity,
          quantityAfter: 0,
        );
        
        await pbService.pb.collection('tool_locations').delete(toolLocation.id);
        onChanged();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from location!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  Future<void> _showTransferDialog(BuildContext context) async {
    final pbService = PocketBaseService();
    final allLocs = await pbService.getLocations();
    final availableLocations = allLocs.where((loc) => loc.id != toolLocation.locationId).toList();
    
    String? selectedLocationId;
    final quantityController = TextEditingController(text: toolLocation.quantity.toString());
    
    if (!context.mounted) return;
    
    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Transfer Tool'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity to Transfer',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedLocationId,
                decoration: const InputDecoration(
                  labelText: 'To Location',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select destination'),
                items: {
                  for (var loc in availableLocations) loc.id: loc
                }.values.map((loc) {
                  final path = pbService.getLocationPath(loc.id, allLocs);
                  return DropdownMenuItem<String>(
                    value: loc.id,
                    child: Text(path),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedLocationId = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedLocationId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a destination')),
                  );
                  return;
                }
                
                final transferQty = int.tryParse(quantityController.text);
                if (transferQty == null || transferQty < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid quantity')),
                  );
                  return;
                }
                
                if (transferQty > toolLocation.quantity) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot transfer more than available')),
                  );
                  return;
                }
                
                try {
                  final sourceQtyBefore = toolLocation.quantity;
                  final destQtyBefore = await pbService.getCurrentQuantityAtLocation(
                    toolId: toolLocation.toolId,
                    locationId: selectedLocationId!,
                  );
                  
                  final newSourceQty = toolLocation.quantity - transferQty;
                  if (newSourceQty == 0) {
                    await pbService.pb.collection('tool_locations').delete(toolLocation.id);
                  } else {
                    await pbService.pb.collection('tool_locations').update(
                      toolLocation.id,
                      body: {'quantity': newSourceQty},
                    );
                  }
                  
                  final existingAtDest = await pbService.pb
                      .collection('tool_locations')
                      .getFullList(
                        filter: 'tool = "${toolLocation.toolId}" && location = "$selectedLocationId"',
                      );
                  
                  if (existingAtDest.isNotEmpty) {
                    final existing = existingAtDest.first;
                    final currentQty = existing.data['quantity'] as int;
                    await pbService.pb.collection('tool_locations').update(
                      existing.id,
                      body: {'quantity': currentQty + transferQty},
                    );
                  } else {
                    await pbService.createToolLocation(
                      toolId: toolLocation.toolId,
                      locationId: selectedLocationId!,
                      quantity: transferQty,
                    );
                  }
                  
                  // Log transfer_out from source location
                  await pbService.logInventoryHistory(
                    toolId: toolLocation.toolId,
                    locationId: toolLocation.locationId,
                    action: 'transfer_out',
                    quantity: transferQty,
                    quantityBefore: sourceQtyBefore,
                    quantityAfter: newSourceQty,
                    relatedLocationId: selectedLocationId,
                  );
                  
                  // Log transfer_in at destination location
                  await pbService.logInventoryHistory(
                    toolId: toolLocation.toolId,
                    locationId: selectedLocationId!,
                    action: 'transfer_in',
                    quantity: transferQty,
                    quantityBefore: destQtyBefore,
                    quantityAfter: destQtyBefore + transferQty,
                    relatedLocationId: toolLocation.locationId,
                  );
                  
                  Navigator.pop(dialogContext);
                  onChanged();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transfer complete!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}

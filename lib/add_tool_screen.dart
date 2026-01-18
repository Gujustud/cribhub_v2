import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'pocketbase_service.dart';
import 'models.dart';

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
  final _quantityController = TextEditingController(text: '1');
  
  // Dropdown values
  String _category = 'Cutting Tools';
  String _subcategory = 'Endmills';
  String _subSubcategory = 'Flat';
  
  // Location selection
  List<dynamic> _locations = [];
  String? _selectedLocationId;
  bool _loadingLocations = true;
  
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
  
  bool get _isEditMode => widget.tool != null && !widget.isDuplicate;
  
  @override
  void initState() {
    super.initState();
    _loadLocations();
    _loadBrandsAndSuppliers();
    
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
    }
  }
  
  void _prefillFields() {
    final tool = widget.tool!;
    _toolNameController.text = widget.isDuplicate ? '${tool.toolName} (Copy)' : tool.toolName;
    _modelNumberController.text = tool.modelNumber ?? '';
    _urlController.text = tool.url ?? '';
    
    // Ensure category exists
    final validCategories = ['Cutting Tools', 'Workholding', 'Inspection', 'Misc'];
    _category = validCategories.contains(tool.category) ? tool.category : 'Cutting Tools';
    
    // Ensure subcategory exists
    final validSubcategories = ['Endmills', 'Threading'];
    _subcategory = validSubcategories.contains(tool.subcategory) ? tool.subcategory! : 'Endmills';
    
    // Ensure sub-subcategory exists
    final validSubSubcategories = ['Flat', 'CR', 'Ball', 'Tslot', 'Misc'];
    _subSubcategory = validSubSubcategories.contains(tool.subSubcategory) ? tool.subSubcategory! : 'Flat';
    
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
  
  Future<void> _loadLocations() async {
    try {
      final pbService = PocketBaseService();
      final locations = await pbService.getLocations();
      setState(() {
        _locations = locations;
        _loadingLocations = false;
      });
    } catch (e) {
      setState(() {
        _loadingLocations = false;
      });
      print('Error loading locations: $e');
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
    
    if (cornerRad != null && cornerRad > 0) {
      String crStr = cornerRad.toString();
      if (cornerRad < 1 && crStr.startsWith('0.')) {
        crStr = crStr.substring(1);
      }
      name += '_${crStr}CR';
    }
    
    if (neck != null && neck > 0) {
      String neckStr = neck.toString();
      if (neck < 1 && neckStr.startsWith('0.')) {
        neckStr = neckStr.substring(1);
      }
      name += '_${neckStr}NR';
    }
    
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
  
  Future<void> _showAddToLocationDialog() async {
    String? selectedLocationId;
    final quantityController = TextEditingController(text: '1');
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add to Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedLocationId,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select location'),
                items: [
                  // Deduplicate locations by ID first
                  ...{
                    for (var loc in _locations) loc.id: loc
                  }.values.map((loc) {
                    final pbService = PocketBaseService();
                    final path = pbService.getLocationPath(loc.id, _locations);
                    return DropdownMenuItem<String>(
                      value: loc.id,
                      child: Text(path),
                    );
                  }),
                  const DropdownMenuItem<String>(
                    value: '__create_new__',
                    child: Text('+ Create New Location'),
                  ),
                ],
                onChanged: (value) async {
                  if (value == '__create_new__') {
                    Navigator.pop(context);
                    await _showCreateLocationDialog();
                    await _loadLocations();
                    _showAddToLocationDialog();
                  } else {
                    setDialogState(() {
                      selectedLocationId = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedLocationId == null || selectedLocationId == '__create_new__') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a location')),
                  );
                  return;
                }
                
                final quantity = int.tryParse(quantityController.text);
                if (quantity == null || quantity < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid quantity')),
                  );
                  return;
                }
                
                try {
                  final pbService = PocketBaseService();
                  await pbService.createToolLocation(
                    toolId: widget.tool!.id,
                    locationId: selectedLocationId!,
                    quantity: quantity,
                  );
                  
                  Navigator.pop(context);
                  await _loadToolLocations();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to location!'),
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
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _showCreateLocationDialog() async {
    final nameController = TextEditingController();
    String? selectedType;
    String? selectedParentId;
    
    // Load location types from existing locations
    final existingTypes = _locations
        .map((loc) => loc.data['type'] as String)
        .toSet()
        .toList();
    final defaultTypes = ['toolbox', 'machine', 'shelf', 'recycle'];
    final allTypes = {...defaultTypes, ...existingTypes}.toList()..sort();
    
    // Don't set a default if list is empty
    if (allTypes.isNotEmpty) {
      selectedType = allTypes.first;
    }
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create New Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: allTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Location Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedParentId,
                decoration: const InputDecoration(
                  labelText: 'Parent Location (optional)',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('None (root location)'),
                items: {
                  for (var loc in _locations) loc.id: loc
                }.values.map((loc) {
                  final pbService = PocketBaseService();
                  final path = pbService.getLocationPath(loc.id, _locations);
                  return DropdownMenuItem<String>(
                    value: loc.id,
                    child: Text(path),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedParentId = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a name')),
                  );
                  return;
                }
                
                try {
                  final pbService = PocketBaseService();
                  await pbService.createLocation(
                    name: nameController.text,
                    type: selectedType!,
                    parentId: selectedParentId,
                  );
                  
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Location "${nameController.text}" created!'),
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
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _updateLocationQuantity(ToolLocation toolLocation, int newQuantity) async {
    try {
      final pbService = PocketBaseService();
      
      if (newQuantity <= 0) {
        // Delete the location
        await pbService.pb.collection('tool_locations').delete(toolLocation.id);
      } else {
        // Update quantity
        await pbService.pb.collection('tool_locations').update(
          toolLocation.id,
          body: {'quantity': newQuantity},
        );
      }
      
      await _loadToolLocations();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quantity updated!'),
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
  }
  
  void _saveTool() async {
    if (_formKey.currentState!.validate()) {
      // For add mode (not edit), check location is selected
      if (!_isEditMode && _selectedLocationId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a location'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        final pbService = PocketBaseService();
        
        final body = {
          'tool_name': _toolNameController.text,
          'category': _category,
          'subcategory': _subcategory,
          'sub_subcategory': _subSubcategory,
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
            toolRecord = await pbService.pb.collection('tools').update(
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
            toolRecord = await pbService.pb.collection('tools').update(
              widget.tool!.id,
              body: body,
            );
          }
        } else {
          // Create new tool
          if (_photoBytes != null) {
            toolRecord = await pbService.pb.collection('tools').create(
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
            toolRecord = await pbService.pb.collection('tools').create(body: body);
          }
          
          // Create the tool_location record
          await pbService.createToolLocation(
            toolId: toolRecord.id,
            locationId: _selectedLocationId!,
            quantity: int.parse(_quantityController.text),
          );
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
      ),
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
                      suffixIcon: Row(
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
                      ),
                    ),
                    enabled: !_autoGenerateName,
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
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedBrandId,
                          decoration: const InputDecoration(
                            labelText: 'Brand (optional)',
                            border: OutlineInputBorder(),
                          ),
                          hint: const Text('Select brand'),
                          items: _brands.map((brand) {
                            return DropdownMenuItem<String>(
                              value: brand.id,
                              child: Text(brand.data['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBrandId = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedSupplierId,
                          decoration: const InputDecoration(
                            labelText: 'Supplier (optional)',
                            border: OutlineInputBorder(),
                          ),
                          hint: const Text('Select supplier'),
                          items: _suppliers.map((supplier) {
                            return DropdownMenuItem<String>(
                              value: supplier.id,
                              child: Text(supplier.data['company_name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSupplierId = value;
                            });
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
                  
                  // Category
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Cutting Tools', child: Text('Cutting Tools')),
                      DropdownMenuItem(value: 'Workholding', child: Text('Workholding')),
                      DropdownMenuItem(value: 'Inspection', child: Text('Inspection')),
                      DropdownMenuItem(value: 'Misc', child: Text('Misc')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _category = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Subcategory
                  DropdownButtonFormField<String>(
                    value: _subcategory,
                    decoration: const InputDecoration(
                      labelText: 'Subcategory',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Endmills', child: Text('Endmills')),
                      DropdownMenuItem(value: 'Threading', child: Text('Threading')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _subcategory = value!;
                        _updateToolName();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Sub-subcategory
                  DropdownButtonFormField<String>(
                    value: _subSubcategory,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Flat', child: Text('Flat')),
                      DropdownMenuItem(value: 'CR', child: Text('Corner Radius')),
                      DropdownMenuItem(value: 'Ball', child: Text('Ball')),
                      DropdownMenuItem(value: 'Tslot', child: Text('T-Slot')),
                      DropdownMenuItem(value: 'Misc', child: Text('Misc')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _subSubcategory = value!;
                        _updateToolName();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
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
                  const SizedBox(height: 16),
                  
                  // Location (only for add/duplicate mode)
                  if (!_isEditMode) ...[
                    DropdownButtonFormField<String>(
                      value: _selectedLocationId,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select location'),
                      items: [
                        // Deduplicate locations by ID first
                        ...{
                          for (var loc in _locations) loc.id: loc
                        }.values.map((loc) {
                          final pbService = PocketBaseService();
                          final path = pbService.getLocationPath(loc.id, _locations);
                          return DropdownMenuItem<String>(
                            value: loc.id,
                            child: Text(path),
                          );
                        }),
                        const DropdownMenuItem<String>(
                          value: '__create_new__',
                          child: Text('+ Create New Location'),
                        ),
                      ],
                      onChanged: _loadingLocations
                          ? null
                          : (value) async {
                              if (value == '__create_new__') {
                                await _showCreateLocationDialog();
                                await _loadLocations();
                              } else {
                                setState(() {
                                  _selectedLocationId = value;
                                });
                              }
                            },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == '__create_new__') {
                          return 'Please select a location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Quantity
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final qty = int.tryParse(value);
                        if (qty == null || qty < 1) {
                          return 'Must be at least 1';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  
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
                    
                    // Inventory section (only in edit mode)
                    if (_isEditMode) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Inventory',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: _showAddToLocationDialog,
                            icon: const Icon(Icons.add_circle),
                            color: Colors.blue,
                            tooltip: 'Add to location',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Location tags
                      if (_toolLocations.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No locations yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ..._toolLocations.map((toolLocation) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InventoryLocationTag(
                              toolLocation: toolLocation,
                              allLocations: _allLocations,
                              onChanged: () {
                                _loadToolLocations();
                              },
                            ),
                          );
                        }),
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
    _quantityController.dispose();
    super.dispose();
  }
}

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

    return GestureDetector(
      onTap: () async {
        final action = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(locationPath),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('Edit Quantity'),
                  subtitle: Text('Current: $quantity'),
                  onTap: () => Navigator.pop(context, 'edit'),
                ),
                ListTile(
                  leading: const Icon(Icons.swap_horiz, color: Colors.orange),
                  title: const Text('Transfer'),
                  subtitle: const Text('Move to another location'),
                  onTap: () => Navigator.pop(context, 'transfer'),
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove from Location'),
                  subtitle: const Text('Delete this inventory record'),
                  onTap: () => Navigator.pop(context, 'delete'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
        
        if (action == 'edit') {
          // Edit quantity
          final controller = TextEditingController(text: quantity.toString());
          final newQty = await showDialog<int>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Edit Quantity - $locationPath'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final qty = int.tryParse(controller.text);
                    if (qty != null && qty > 0) {
                      Navigator.pop(context, qty);
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          );
          
          if (newQty != null) {
            // Update quantity in database
            try {
              final pbService = PocketBaseService();
              await pbService.pb.collection('tool_locations').update(
                toolLocation.id,
                body: {'quantity': newQty},
              );
              onChanged();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quantity updated!'),
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
          }
        } else if (action == 'transfer') {
          // Transfer to another location
          _showTransferDialog(context);
        } else if (action == 'delete') {
          // Confirm delete
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
              await pbService.pb.collection('tool_locations').delete(toolLocation.id);
              onChanged();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Removed from location!'),
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
          }
        }
      },
      child: Container(
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
            Icon(Icons.more_horiz, size: 16, color: textColor),
          ],
        ),
      ),
    );
  }
  
  Future<void> _showTransferDialog(BuildContext context) async {
    // Get PocketBase service to load all locations
    final pbService = PocketBaseService();
    final allLocs = await pbService.getLocations();
    
    // Filter out current location
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
                  // Reduce quantity at source
                  final newSourceQty = toolLocation.quantity - transferQty;
                  if (newSourceQty == 0) {
                    await pbService.pb.collection('tool_locations').delete(toolLocation.id);
                  } else {
                    await pbService.pb.collection('tool_locations').update(
                      toolLocation.id,
                      body: {'quantity': newSourceQty},
                    );
                  }
                  
                  // Add to destination (or update if exists)
                  final existingAtDest = await pbService.pb
                      .collection('tool_locations')
                      .getFullList(
                        filter: 'tool = "${toolLocation.toolId}" && location = "$selectedLocationId"',
                      );
                  
                  if (existingAtDest.isNotEmpty) {
                    // Update existing
                    final existing = existingAtDest.first;
                    final currentQty = existing.data['quantity'] as int;
                    await pbService.pb.collection('tool_locations').update(
                      existing.id,
                      body: {'quantity': currentQty + transferQty},
                    );
                  } else {
                    // Create new
                    await pbService.createToolLocation(
                      toolId: toolLocation.toolId,
                      locationId: selectedLocationId!,
                      quantity: transferQty,
                    );
                  }
                  
                  Navigator.pop(dialogContext);
                  
                  // Trigger refresh
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

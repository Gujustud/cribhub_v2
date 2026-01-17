import 'package:flutter/material.dart';
import 'pocketbase_service.dart';

class AddToolScreen extends StatefulWidget {
  const AddToolScreen({super.key});

  @override
  State<AddToolScreen> createState() => _AddToolScreenState();
}

class _AddToolScreenState extends State<AddToolScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _toolNameController = TextEditingController();
  final _modelNumberController = TextEditingController();
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
  bool _autoGenerateName = true; // Checkbox state for auto-generation
  
  @override
  void initState() {
    super.initState();
    _loadLocations();
    _loadBrandsAndSuppliers();
    // Listen to changes and update tool name (debounced)
    _diameterInController.addListener(_scheduleToolNameUpdate);
    _flutesController.addListener(_scheduleToolNameUpdate);
    _fluteLengthController.addListener(_scheduleToolNameUpdate);
    _cornerRadController.addListener(_scheduleToolNameUpdate);
    _neckController.addListener(_scheduleToolNameUpdate);
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
      });
    } catch (e) {
      print('Error loading brands/suppliers: $e');
    }
  }
  
  void _scheduleToolNameUpdate() {
    // Only auto-update if checkbox is checked
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
    // Get values
    final diaIn = double.tryParse(_diameterInController.text);
    final flutes = int.tryParse(_flutesController.text);
    final fluteLen = double.tryParse(_fluteLengthController.text);
    final cornerRad = double.tryParse(_cornerRadController.text);
    final neck = double.tryParse(_neckController.text);
    
    if (diaIn == null || flutes == null || fluteLen == null) {
      return '';
    }
    
    // Format diameter - remove leading 0 if less than 1
    String diaStr = diaIn.toString();
    if (diaIn < 1 && diaStr.startsWith('0.')) {
      diaStr = diaStr.substring(1); // Remove the "0" to get ".25"
    }
    
    // Format flute length
    String flStr;
    if (fluteLen < 1) {
      // Less than 1: remove leading 0 (.56)
      flStr = fluteLen.toString();
      if (flStr.startsWith('0.')) {
        flStr = flStr.substring(1);
      }
    } else {
      // >= 1: ensure it has .0 if it's a whole number
      if (fluteLen % 1 == 0) {
        flStr = fluteLen.toStringAsFixed(1); // 2 → 2.0
      } else {
        flStr = fluteLen.toString(); // 1.5 → 1.5
      }
    }
    
    // Build name: .187_3F_.56FL or .25_3F_2.0FL
    String name = '${diaStr}_${flutes}F_${flStr}FL';
    
    // Add corner radius if present: .25_4F_.1FL_.02CR
    if (cornerRad != null && cornerRad > 0) {
      String crStr = cornerRad.toString();
      if (cornerRad < 1 && crStr.startsWith('0.')) {
        crStr = crStr.substring(1);
      }
      name += '_${crStr}CR';
    }
    
    // Add neck if present: .187_3F_.56FL_.14NR
    if (neck != null && neck > 0) {
      String neckStr = neck.toString();
      if (neck < 1 && neckStr.startsWith('0.')) {
        neckStr = neckStr.substring(1);
      }
      name += '_${neckStr}NR';
    }
    
    // Add suffix based on sub-subcategory
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
      // Auto-convert to mm
      _diameterMmController.text = (diaIn * 25.4).toStringAsFixed(2);
    }
  }
  
  void _onDiameterMmChanged(String value) {
    final diaMm = double.tryParse(value);
    if (diaMm != null) {
      // Auto-convert to inches
      _diameterInController.text = (diaMm / 25.4).toStringAsFixed(3);
    }
  }
  
  void _saveTool() async {
    if (_formKey.currentState!.validate()) {
      // Check if location is selected
      if (_selectedLocationId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a location'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        final pbService = PocketBaseService();
        
        // Create the tool
        final toolRecord = await pbService.pb.collection('tools').create(body: {
          'tool_name': _toolNameController.text, // Use the field value (auto or manual)
          'category': _category,
          'subcategory': _subcategory,
          'sub_subcategory': _subSubcategory,
          'model_number': _modelNumberController.text.isEmpty 
              ? null 
              : _modelNumberController.text,
          'brand': _selectedBrandId,
          'supplier': _selectedSupplierId,
          'diameter_in': double.tryParse(_diameterInController.text),
          'diameter_mm': double.tryParse(_diameterMmController.text),
          'flutes': int.tryParse(_flutesController.text),
          'flute_length': double.tryParse(_fluteLengthController.text),
          'corner_rad': double.tryParse(_cornerRadController.text),
          'neck': double.tryParse(_neckController.text),
        });
        
        // Create the tool_location record
        await pbService.createToolLocation(
          toolId: toolRecord.id,
          locationId: _selectedLocationId!,
          quantity: int.parse(_quantityController.text),
        );

        // Close loading dialog
        if (context.mounted) Navigator.pop(context);
        
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tool "${_toolNameController.text}" saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Go back to main screen
          Navigator.pop(context);
        }
      } catch (e) {
        // Close loading dialog
        if (context.mounted) Navigator.pop(context);
        
        // Show error message
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
        title: const Text('Add Tool'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tool Name field - always visible with auto-generate checkbox
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
                            // Overwrite with auto-generated name
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
              enabled: !_autoGenerateName, // Disabled when auto-generating
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
            
            // Diameter row (inches and mm)
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
            
            // Corner Radius (only show if CR selected)
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
            
            // Location picker
            DropdownButtonFormField<String>(
              value: _selectedLocationId,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Select location'),
              items: _loadingLocations
                  ? <DropdownMenuItem<String>>[]
                  : _locations.map((loc) {
                      final pbService = PocketBaseService();
                      final path = pbService.getLocationPath(loc.id, _locations);
                      return DropdownMenuItem<String>(
                        value: loc.id,
                        child: Text(path),
                      );
                    }).toList(),
              onChanged: _loadingLocations
                  ? null
                  : (value) {
                      setState(() {
                        _selectedLocationId = value;
                      });
                    },
              validator: (value) {
                if (value == null || value.isEmpty) {
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
            const SizedBox(height: 24),
            
            // Save button at bottom
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTool,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'SAVE TOOL',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _toolNameController.dispose();
    _modelNumberController.dispose();
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
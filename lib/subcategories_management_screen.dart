// lib/subcategories_management_screen.dart
import 'package:flutter/material.dart';
import 'pocketbase_service.dart';
import 'app_drawer.dart';

class SubcategoriesManagementScreen extends StatefulWidget {
  const SubcategoriesManagementScreen({super.key});

  @override
  State<SubcategoriesManagementScreen> createState() => _SubcategoriesManagementScreenState();
}

class _SubcategoriesManagementScreenState extends State<SubcategoriesManagementScreen>
    with SingleTickerProviderStateMixin {
  final _pbService = PocketBaseService();

  // Data
  List<dynamic> _categories = [];
  List<dynamic> _subcategories = [];
  List<dynamic> _attributeLists = [];
  Map<String, List<dynamic>> _attributeValues = {};
  Map<String, bool> _expandedSubcategories = {};

  // Selection
  String? _selectedCategoryId;

  // Loading
  bool _isLoading = true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all data in parallel
      final results = await Future.wait([
        _pbService.getCategories(),
        _pbService.getSubcategories(),
        _pbService.getAttributeLists(),
      ]);

      final categories = results[0] as List<dynamic>;
      final subcategories = results[1] as List<dynamic>;
      final attributeLists = results[2] as List<dynamic>;

      // Load attribute values for each list
      final attributeValues = <String, List<dynamic>>{};
      for (final list in attributeLists) {
        try {
          final values = await _pbService.getAttributeValues(list.id);
          attributeValues[list.id] = values;
        } catch (e) {
          print('Error loading values for list ${list.id}: $e');
          attributeValues[list.id] = [];
        }
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _subcategories = subcategories;
          _attributeLists = attributeLists;
          _attributeValues = attributeValues;
          _isLoading = false;
          
          // Auto-select first category if none selected
          if (_selectedCategoryId == null && categories.isNotEmpty) {
            _selectedCategoryId = categories.first.id;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subcategories & Attributes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Subcategories'),
            Tab(text: 'Attribute Lists'),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSubcategoriesTab(),
                _buildAttributeListsTab(),
              ],
            ),
    );
  }

  Widget _buildSubcategoriesTab() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT PANEL - Categories
        Container(
          width: 250,
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey[300]!)),
            color: Colors.grey[50],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: const Text(
                  'CATEGORIES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategoryId == category.id;
                    
                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: Colors.blue[50],
                      title: Text(
                        category.data['name'],
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = category.id;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // RIGHT PANEL - Subcategories Tree
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Add button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategoryId != null
                          ? _categories.firstWhere((c) => c.id == _selectedCategoryId).data['name']
                          : 'Select a category',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedCategoryId != null)
                      ElevatedButton.icon(
                        onPressed: () => _showAddSubcategoryDialog(_selectedCategoryId, null),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Subcategory'),
                      ),
                  ],
                ),
              ),
              
              // Subcategories tree
              Expanded(
                child: _selectedCategoryId == null
                    ? const Center(child: Text('Select a category to manage subcategories'))
                    : _buildSubcategoryTree(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubcategoryTree() {
    // Get top-level subcategories for selected category
    final topLevelSubcategories = _subcategories.where((s) =>
      s.data['category'] == _selectedCategoryId &&
      (s.data['parent_subcategory'] == null || s.data['parent_subcategory'].toString().isEmpty)
    ).toList();
    
    if (topLevelSubcategories.isEmpty) {
      return const Center(
        child: Text('No subcategories yet. Click "Add Subcategory" to create one.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: topLevelSubcategories.length,
      itemBuilder: (context, index) {
        return _buildSubcategoryTile(topLevelSubcategories[index], 0);
      },
    );
  }

  Widget _buildSubcategoryTile(dynamic subcategory, int level) {
    final isExpanded = _expandedSubcategories[subcategory.id] ?? false;
    final children = _subcategories.where((s) =>
      s.data['parent_subcategory'] == subcategory.id
    ).toList();
    
    final hasChildren = children.isNotEmpty;
    final fieldType = subcategory.data['field_type'] ?? 'selection';
    final displayMode = subcategory.data['display_mode'] ?? 'dropdown';

    return Card(
      margin: EdgeInsets.only(left: level * 24.0, bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: hasChildren
                ? IconButton(
                    icon: Icon(isExpanded ? Icons.expand_more : Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        _expandedSubcategories[subcategory.id] = !isExpanded;
                      });
                    },
                  )
                : const SizedBox(width: 48),
            title: Row(
              children: [
                Text(
                  subcategory.data['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                _buildFieldTypeBadge(fieldType, displayMode),
              ],
            ),
            subtitle: subcategory.data['custom_label'] != null
                ? Text('Child Label: ${subcategory.data['custom_label']}')
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onPressed: () => _showAddSubcategoryDialog(null, subcategory.id),
                  tooltip: 'Add Child',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => _showEditSubcategoryDialog(subcategory),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteSubcategoryDialog(subcategory),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
          
          // Child subcategories
          if (hasChildren && isExpanded)
            ...children.map((child) => _buildSubcategoryTile(child, level + 1)),
        ],
      ),
    );
  }

  Widget _buildFieldTypeBadge(String fieldType, String displayMode) {
    String label;
    Color color;
    
    switch (fieldType) {
      case 'text':
        label = 'Text Input';
        color = Colors.green;
        break;
      case 'number':
        label = 'Number Input';
        color = Colors.purple;
        break;
      case 'selection':
      default:
        label = displayMode == 'buttons' ? 'Buttons' : 'Dropdown';
        color = Colors.blue;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAddSubcategoryDialog(String? categoryId, String? parentId) {
    final nameController = TextEditingController();
    final labelController = TextEditingController();
    final sortController = TextEditingController(text: '1');
    String? selectedAttrListId;
    String selectedDisplayMode = 'dropdown';
    String selectedFieldType = 'selection'; // NEW

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(parentId != null ? 'Add Child Subcategory' : 'Add Subcategory'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: labelController,
                  decoration: const InputDecoration(labelText: 'Custom Label for Children (optional)'),
                ),
                TextField(
                  controller: sortController,
                  decoration: const InputDecoration(labelText: 'Sort Order'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                
                // NEW: Field Type selector
                DropdownButtonFormField<String>(
                  value: selectedFieldType,
                  decoration: const InputDecoration(labelText: 'Field Type'),
                  items: const [
                    DropdownMenuItem(value: 'selection', child: Text('Selection (from list)')),
                    DropdownMenuItem(value: 'text', child: Text('Text Input')),
                    DropdownMenuItem(value: 'number', child: Text('Number Input')),
                  ],
                  onChanged: (value) => setDialogState(() {
                    selectedFieldType = value ?? 'selection';
                    // Clear attribute list if switching to text/number
                    if (selectedFieldType != 'selection') {
                      selectedAttrListId = null;
                    }
                  }),
                ),
                const SizedBox(height: 16),
                
                // Only show display mode and attribute list for selection type
                if (selectedFieldType == 'selection') ...[
                  DropdownButtonFormField<String>(
                    value: selectedDisplayMode,
                    decoration: const InputDecoration(labelText: 'Display Mode'),
                    items: const [
                      DropdownMenuItem(value: 'dropdown', child: Text('Dropdown')),
                      DropdownMenuItem(value: 'buttons', child: Text('Buttons')),
                    ],
                    onChanged: (value) => setDialogState(() => selectedDisplayMode = value ?? 'dropdown'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String?>(
                    value: selectedAttrListId,
                    decoration: const InputDecoration(labelText: 'Attribute List (optional)'),
                    items: [
                      const DropdownMenuItem<String?>(value: null, child: Text('None')),
                      ..._attributeLists.map((list) => DropdownMenuItem<String?>(
                        value: list.id,
                        child: Text(list.data['name']),
                      )).toList(),
                    ],
                    onChanged: (value) => setDialogState(() => selectedAttrListId = value),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  try {
                    await _pbService.createSubcategory(
                      name: nameController.text,
                      categoryId: parentId != null ? null : categoryId,
                      parentSubcategoryId: parentId,
                      sortOrder: int.tryParse(sortController.text) ?? 1,
                      customLabel: labelController.text.isEmpty ? null : labelController.text,
                      attributeListId: selectedFieldType == 'selection' ? selectedAttrListId : null,
                      displayMode: selectedFieldType == 'selection' ? selectedDisplayMode : null,
                      fieldType: selectedFieldType,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      if (parentId != null) {
                        _expandedSubcategories[parentId] = true;
                      }
                      _loadData();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSubcategoryDialog(dynamic subcategory) {
    final nameController = TextEditingController(text: subcategory.data['name']);
    final labelController = TextEditingController(text: subcategory.data['custom_label'] ?? '');
    final sortController = TextEditingController(text: subcategory.data['sort_order'].toString());
    String? selectedAttrListId = subcategory.data['attribute_list'];
    
    // Handle display_mode
    String selectedDisplayMode = 'dropdown';
    final rawDisplayMode = subcategory.data['display_mode'];
    if (rawDisplayMode != null && rawDisplayMode.toString().isNotEmpty) {
      selectedDisplayMode = rawDisplayMode.toString();
    }
    
    // Handle field_type (NEW)
    String selectedFieldType = 'selection';
    final rawFieldType = subcategory.data['field_type'];
    if (rawFieldType != null && rawFieldType.toString().isNotEmpty) {
      selectedFieldType = rawFieldType.toString();
    }
    
    // Validate attribute list
    if (selectedAttrListId != null && selectedAttrListId.toString().isNotEmpty) {
      final exists = _attributeLists.any((list) => list.id == selectedAttrListId);
      if (!exists) {
        selectedAttrListId = null;
      }
    } else {
      selectedAttrListId = null;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Subcategory'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: labelController,
                  decoration: const InputDecoration(labelText: 'Custom Label for Children (optional)'),
                ),
                TextField(
                  controller: sortController,
                  decoration: const InputDecoration(labelText: 'Sort Order'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                
                // Field Type selector
                DropdownButtonFormField<String>(
                  value: selectedFieldType,
                  decoration: const InputDecoration(labelText: 'Field Type'),
                  items: const [
                    DropdownMenuItem(value: 'selection', child: Text('Selection (from list)')),
                    DropdownMenuItem(value: 'text', child: Text('Text Input')),
                    DropdownMenuItem(value: 'number', child: Text('Number Input')),
                  ],
                  onChanged: (value) => setDialogState(() {
                    selectedFieldType = value ?? 'selection';
                    if (selectedFieldType != 'selection') {
                      selectedAttrListId = null;
                    }
                  }),
                ),
                const SizedBox(height: 16),
                
                // Only show for selection type
                if (selectedFieldType == 'selection') ...[
                  DropdownButtonFormField<String>(
                    value: selectedDisplayMode,
                    decoration: const InputDecoration(labelText: 'Display Mode'),
                    items: const [
                      DropdownMenuItem(value: 'dropdown', child: Text('Dropdown')),
                      DropdownMenuItem(value: 'buttons', child: Text('Buttons')),
                    ],
                    onChanged: (value) => setDialogState(() => selectedDisplayMode = value ?? 'dropdown'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String?>(
                    value: selectedAttrListId,
                    decoration: const InputDecoration(labelText: 'Attribute List (optional)'),
                    items: [
                      const DropdownMenuItem<String?>(value: null, child: Text('None')),
                      ..._attributeLists.map((list) => DropdownMenuItem<String?>(
                        value: list.id,
                        child: Text(list.data['name']),
                      )).toList(),
                    ],
                    onChanged: (value) => setDialogState(() => selectedAttrListId = value),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  try {
                    await _pbService.updateSubcategory(
                      subcategoryId: subcategory.id,
                      name: nameController.text,
                      sortOrder: int.tryParse(sortController.text) ?? 1,
                      customLabel: labelController.text.isEmpty ? null : labelController.text,
                      attributeListId: selectedFieldType == 'selection' ? selectedAttrListId : null,
                      displayMode: selectedFieldType == 'selection' ? selectedDisplayMode : null,
                      fieldType: selectedFieldType,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      _loadData();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteSubcategoryDialog(dynamic subcategory) async {
    final hasChildren = await _pbService.subcategoryHasChildren(subcategory.id);
    final count = await _pbService.getSubcategoryInventoryCount(subcategory.data['name']);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subcategory'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${subcategory.data['name']}"?'),
            if (hasChildren) ...[
              const SizedBox(height: 16),
              const Text(
                'WARNING: This subcategory has child subcategories.',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
            if (count > 0) ...[
              const SizedBox(height: 16),
              Text(
                'WARNING: This subcategory is used in $count inventory item(s).',
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          if (!hasChildren)
            ElevatedButton(
              onPressed: () async {
                try {
                  await _pbService.deleteSubcategory(subcategory.id);
                  if (mounted) {
                    Navigator.pop(context);
                    _loadData();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
        ],
      ),
    );
  }

  // ATTRIBUTE LISTS TAB (keep existing implementation)
  Widget _buildAttributeListsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Attribute Lists', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: _showAddAttributeListDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add List'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._attributeLists.map((list) => Card(
          child: ExpansionTile(
            title: Row(
              children: [
                Text(list.data['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                _buildFieldTypeBadge('selection', list.data['display_mode'] ?? 'dropdown'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => _showEditAttributeListDialog(list),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteAttributeListDialog(list),
                ),
              ],
            ),
            children: [
              ..._attributeValues[list.id]?.map((value) => ListTile(
                title: Text(value.data['value']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Sort: ${value.data['sort_order']}'),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => _showEditAttributeValueDialog(list.id, value),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                      onPressed: () => _showDeleteAttributeValueDialog(value),
                    ),
                  ],
                ),
              )) ?? [],
              ListTile(
                leading: const Icon(Icons.add, color: Colors.blue),
                title: const Text('Add Value', style: TextStyle(color: Colors.blue)),
                onTap: () => _showAddAttributeValueDialog(list.id),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  // Attribute list dialogs (keep existing with display_mode)
  void _showAddAttributeListDialog() {
    final controller = TextEditingController();
    String selectedDisplayMode = 'dropdown';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Attribute List'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDisplayMode,
                decoration: const InputDecoration(labelText: 'Display Mode'),
                items: const [
                  DropdownMenuItem(value: 'dropdown', child: Text('Dropdown')),
                  DropdownMenuItem(value: 'buttons', child: Text('Buttons')),
                ],
                onChanged: (value) => setDialogState(() => selectedDisplayMode = value ?? 'dropdown'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  try {
                    await _pbService.createAttributeList(
                      name: controller.text,
                      displayMode: selectedDisplayMode,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      _loadData();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAttributeListDialog(dynamic list) {
    final controller = TextEditingController(text: list.data['name']);
    
    String selectedDisplayMode = 'dropdown';
    final rawDisplayMode = list.data['display_mode'];
    if (rawDisplayMode != null && rawDisplayMode.toString().isNotEmpty) {
      selectedDisplayMode = rawDisplayMode.toString();
    }
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Attribute List'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDisplayMode,
                decoration: const InputDecoration(labelText: 'Display Mode'),
                items: const [
                  DropdownMenuItem(value: 'dropdown', child: Text('Dropdown')),
                  DropdownMenuItem(value: 'buttons', child: Text('Buttons')),
                ],
                onChanged: (value) => setDialogState(() => selectedDisplayMode = value ?? 'dropdown'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  try {
                    await _pbService.updateAttributeList(
                      listId: list.id,
                      name: controller.text,
                      displayMode: selectedDisplayMode,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      _loadData();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAttributeListDialog(dynamic list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attribute List'),
        content: Text('Delete "${list.data['name']}"? This will affect any subcategories using this list.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _pbService.deleteAttributeList(list.id);
                if (mounted) {
                  Navigator.pop(context);
                  _loadData();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddAttributeValueDialog(String listId) {
    final controller = TextEditingController();
    final sortController = TextEditingController(text: '1');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Value'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: controller, decoration: const InputDecoration(labelText: 'Value')),
            TextField(
              controller: sortController,
              decoration: const InputDecoration(labelText: 'Sort Order'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await _pbService.createAttributeValue(
                    listId: listId,
                    value: controller.text,
                    sortOrder: int.tryParse(sortController.text) ?? 1,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    _loadData();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditAttributeValueDialog(String listId, dynamic value) {
    final controller = TextEditingController(text: value.data['value']);
    final sortController = TextEditingController(text: value.data['sort_order'].toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Value'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: controller, decoration: const InputDecoration(labelText: 'Value')),
            TextField(
              controller: sortController,
              decoration: const InputDecoration(labelText: 'Sort Order'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await _pbService.updateAttributeValue(
                    valueId: value.id,
                    value: controller.text,
                    sortOrder: int.tryParse(sortController.text) ?? 1,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    _loadData();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAttributeValueDialog(dynamic value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Value'),
        content: Text('Delete "${value.data['value']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _pbService.deleteAttributeValue(value.id);
                if (mounted) {
                  Navigator.pop(context);
                  _loadData();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

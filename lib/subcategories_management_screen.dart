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
        });
        
        // DEBUG: Print all subcategories and their parent_subcategory values
        print('DEBUG: Loaded ${subcategories.length} subcategories:');
        for (final sub in subcategories) {
          print('DEBUG:   "${sub.data['name']}" (id: ${sub.id})');
          print('DEBUG:     category: ${sub.data['category']}');
          print('DEBUG:     parent_subcategory: ${sub.data['parent_subcategory']} (type: ${sub.data['parent_subcategory']?.runtimeType})');
        }
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

  void _toggleSubcategoryExpansion(String subcategoryId) {
    setState(() {
      _expandedSubcategories[subcategoryId] = !(_expandedSubcategories[subcategoryId] ?? false);
    });
  }

  Future<void> _fixOrphanedSubcategories() async {
    // Find subcategories that have no category and no parent_subcategory (orphaned children)
    final orphaned = _subcategories.where((s) {
      final catId = s.data['category'];
      final parentId = s.data['parent_subcategory'];
      final catIdStr = catId?.toString();
      final parentIdStr = parentId?.toString();
      return (catIdStr == null || catIdStr.isEmpty) && 
             (parentIdStr == null || parentIdStr.isEmpty);
    }).toList();

    if (orphaned.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No orphaned subcategories found')),
        );
      }
      return;
    }

    // Show dialog to assign parent
    final parentOptions = _subcategories.where((s) {
      final catId = s.data['category'];
      final parentId = s.data['parent_subcategory'];
      final catIdStr = catId?.toString();
      final parentIdStr = parentId?.toString();
      return (catIdStr != null && catIdStr.isNotEmpty) && 
             (parentIdStr == null || parentIdStr.isEmpty);
    }).toList();

    if (parentOptions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No parent subcategories available')),
        );
      }
      return;
    }

    // For each orphaned subcategory, try to match by name to a likely parent
    // "Flat", "CR", "Ball" are likely children of "Endmills"
    final endmills = parentOptions.firstWhere(
      (s) => s.data['name'] == 'Endmills',
      orElse: () => parentOptions.first,
    );

    if (mounted) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Fix Orphaned Subcategories'),
          content: Text(
            'Found ${orphaned.length} orphaned subcategory(ies):\n'
            '${orphaned.map((s) => s.data['name']).join(", ")}\n\n'
            'Assign them all to "${endmills.data['name']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Fix'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        try {
          for (final orphan in orphaned) {
            await _pbService.updateSubcategory(
              subcategoryId: orphan.id,
              name: orphan.data['name'],
              sortOrder: orphan.data['sort_order'] ?? 1,
              customLabel: orphan.data['custom_label'],
              attributeListId: orphan.data['attribute_list'],
              parentSubcategoryId: endmills.id,
            );
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fixed ${orphaned.length} orphaned subcategory(ies)'),
                backgroundColor: Colors.green,
              ),
            );
            _loadData();
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error fixing orphans: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSubcategoriesTab(),
          _buildAttributeListsTab(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "fix_orphans",
            onPressed: _fixOrphanedSubcategories,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.build),
            tooltip: 'Fix orphaned child subcategories',
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "add",
            onPressed: _showAddDialog,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoriesTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_categories.isEmpty) {
      return const Center(
        child: Text('No categories found. Create categories first.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final topLevelSubs = _subcategories.where((s) {
            final catId = s.data['category'];
            final parentId = s.data['parent_subcategory'];
            // Handle relation fields - could be ID string or relation object
            final catIdStr = catId?.toString();
            final parentIdStr = parentId?.toString();
            return catIdStr == category.id && (parentIdStr == null || parentIdStr.isEmpty);
          }).toList();

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text(
                category.data['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${topLevelSubs.length} subcategories'),
              children: [
                if (topLevelSubs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No subcategories yet'),
                  )
                else
                  ...topLevelSubs.map((sub) => _buildSubcategoryTile(sub, category.id, 0)).toList(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddSubcategoryDialog(category.id, null),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Subcategory'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubcategoryTile(dynamic subcategory, String categoryId, int depth) {
    print('DEBUG: Building tile for "${subcategory.data['name']}" (id: ${subcategory.id})');
    
    // Handle relation field - could be ID string or relation object
    final children = _subcategories.where((s) {
      final parentId = s.data['parent_subcategory'];
      final parentIdStr = parentId?.toString();
      final subId = subcategory.id.toString();
      
      // More detailed debug
      if (parentId != null) {
        print('DEBUG:   Checking "${s.data['name']}": parent_subcategory=$parentIdStr vs subcategory.id=$subId');
      }
      
      final matches = parentIdStr == subId;
      if (matches) {
        print('DEBUG: ✓ MATCH! Found child "${s.data['name']}"');
      }
      return matches;
    }).toList();
    
    print('DEBUG: _buildSubcategoryTile for "${subcategory.data['name']}" found ${children.length} children');
    
    final isExpanded = _expandedSubcategories[subcategory.id] ?? false;

    return Container(
      margin: EdgeInsets.only(left: depth * 20.0, right: 16, bottom: 4),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey.shade300, width: 2)),
      ),
      child: ExpansionTile(
        key: PageStorageKey(subcategory.id),
        initiallyExpanded: isExpanded,
        title: Text(subcategory.data['name']),
        subtitle: subcategory.data['custom_label'] != null && subcategory.data['custom_label'].isNotEmpty
            ? Text('Child Label: ${subcategory.data['custom_label']}')
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sort: ${subcategory.data['sort_order']}'),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditSubcategoryDialog(subcategory),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _showDeleteSubcategoryDialog(subcategory),
            ),
          ],
        ),
        onExpansionChanged: (expanded) {
          _toggleSubcategoryExpansion(subcategory.id);
        },
        children: [
          ...children.map((child) => _buildSubcategoryTile(child, categoryId, depth + 1)).toList(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showAddSubcategoryDialog(null, subcategory.id),
              icon: const Icon(Icons.add),
              label: const Text('Add Child Subcategory'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeListsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _attributeLists.length,
        itemBuilder: (context, index) {
          final list = _attributeLists[index];
          final values = _attributeValues[list.id] ?? [];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text(list.data['name']),
              subtitle: Text('${values.length} values'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _showEditAttributeListDialog(list),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => _showDeleteAttributeListDialog(list),
                  ),
                ],
              ),
              children: [
                if (values.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No values yet'),
                  )
                else
                  ...values.map((value) => _buildAttributeValueTile(value, list.id)).toList(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddAttributeValueDialog(list.id),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Value'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttributeValueTile(dynamic value, String listId) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32, right: 16),
      title: Text(value.data['value']),
      subtitle: Text('Sort: ${value.data['sort_order']}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _showEditAttributeValueDialog(value),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: () => _showDeleteAttributeValueDialog(value),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    if (_tabController.index == 0) {
      _showCategoryPickerForSubcategory();
    } else {
      _showAddAttributeListDialog();
    }
  }

  void _showCategoryPickerForSubcategory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Top-Level Subcategory'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select a category to add the subcategory to:'),
            const SizedBox(height: 16),
            ..._categories.map((cat) => ListTile(
              title: Text(cat.data['name']),
              onTap: () {
                Navigator.pop(context);
                _showAddSubcategoryDialog(cat.id, null);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _showAddSubcategoryDialog(String? categoryId, String? parentId) {
    final nameController = TextEditingController();
    final labelController = TextEditingController();
    final sortController = TextEditingController(text: '1');
    String? selectedAttrListId;

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
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  try {
                    print('DEBUG: Creating subcategory "${nameController.text}"');
                    print('DEBUG:   categoryId: ${parentId != null ? null : categoryId}');
                    print('DEBUG:   parentSubcategoryId: $parentId');
                    print('DEBUG:   parentId is null: ${parentId == null}');
                    
                    await _pbService.createSubcategory(
                      name: nameController.text,
                      categoryId: parentId != null ? null : categoryId, // Only set category if not a child
                      parentSubcategoryId: parentId,
                      sortOrder: int.tryParse(sortController.text) ?? 1,
                      customLabel: labelController.text.isEmpty ? null : labelController.text,
                      attributeListId: selectedAttrListId,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      // If creating a child, expand the parent so it's visible
                      if (parentId != null) {
                        _expandedSubcategories[parentId] = true;
                      }
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

  void _showEditSubcategoryDialog(dynamic subcategory) {
    final nameController = TextEditingController(text: subcategory.data['name']);
    final labelController = TextEditingController(text: subcategory.data['custom_label'] ?? '');
    final sortController = TextEditingController(text: subcategory.data['sort_order'].toString());
    String? selectedAttrListId = subcategory.data['attribute_list'];
    
    // Validate that selectedAttrListId exists in the attribute lists
    if (selectedAttrListId != null && selectedAttrListId.toString().isNotEmpty) {
      final exists = _attributeLists.any((list) => list.id == selectedAttrListId);
      if (!exists) {
        selectedAttrListId = null; // Reset to null if the attribute list doesn't exist
      }
    } else {
      selectedAttrListId = null; // Ensure empty strings become null
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
                      attributeListId: selectedAttrListId,
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

  void _showDeleteSubcategoryDialog(dynamic subcategory) async {
    final hasChildren = await _pbService.subcategoryHasChildren(subcategory.id);
    final count = await _pbService.getSubcategoryInventoryCount(subcategory.data['name']);

    if (!mounted) return;

    if (hasChildren || count > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete "${subcategory.data['name']}"?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasChildren) const Text('• This subcategory has child subcategories.', style: TextStyle(color: Colors.red)),
              if (count > 0) Text('• There are $count inventory items in this subcategory.', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              const Text('Deleting this will also delete all children. Please type DELETE to confirm.'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () => _showFinalDeleteConfirm(subcategory),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } else {
      _showFinalDeleteConfirm(subcategory);
    }
  }

  void _showFinalDeleteConfirm(dynamic subcategory) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Permanent Deletion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Type DELETE to confirm deleting "${subcategory.data['name']}"'),
            TextField(controller: controller, decoration: const InputDecoration(hintText: 'DELETE')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text == 'DELETE') {
                try {
                  await _pbService.deleteSubcategory(subcategory.id);
                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context); // Close the warning dialog too if open
                    _loadData();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
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

  // Attribute Lists Dialogs
  void _showAddAttributeListDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Attribute List'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await _pbService.createAttributeList(name: controller.text);
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
    );
  }

  void _showEditAttributeListDialog(dynamic list) {
    final controller = TextEditingController(text: list.data['name']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Attribute List'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await _pbService.updateAttributeList(listId: list.id, name: controller.text);
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
    );
  }

  void _showDeleteAttributeListDialog(dynamic list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attribute List?'),
        content: Text('Delete "${list.data['name']}"? This will also delete all its values.'),
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
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
    final valueController = TextEditingController();
    final sortController = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Attribute Value'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: valueController, decoration: const InputDecoration(labelText: 'Value')),
            TextField(controller: sortController, decoration: const InputDecoration(labelText: 'Sort Order'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (valueController.text.isNotEmpty) {
                try {
                  await _pbService.createAttributeValue(
                    listId: listId,
                    value: valueController.text,
                    sortOrder: int.tryParse(sortController.text) ?? 1,
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
    );
  }

  void _showEditAttributeValueDialog(dynamic value) {
    final valueController = TextEditingController(text: value.data['value']);
    final sortController = TextEditingController(text: value.data['sort_order'].toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Attribute Value'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: valueController, decoration: const InputDecoration(labelText: 'Value')),
            TextField(controller: sortController, decoration: const InputDecoration(labelText: 'Sort Order'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (valueController.text.isNotEmpty) {
                try {
                  await _pbService.updateAttributeValue(
                    valueId: value.id,
                    value: valueController.text,
                    sortOrder: int.tryParse(sortController.text) ?? 1,
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
    );
  }

  void _showDeleteAttributeValueDialog(dynamic value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attribute Value?'),
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
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

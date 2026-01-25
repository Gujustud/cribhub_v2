import 'package:flutter/material.dart';
import 'pocketbase_service.dart';
import 'app_drawer.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  List<dynamic> _brands = [];
  List<dynamic> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pbService = PocketBaseService();
      final results = await Future.wait([
        pbService.getBrands(),
        pbService.getCategories(),
      ]);
      
      setState(() {
        _brands = results[0] as List<dynamic>;
        _categories = results[1] as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadBrands() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pbService = PocketBaseService();
      final brands = await pbService.getBrands();
      setState(() {
        _brands = brands;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading brands: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddBrandDialog() {
    final nameController = TextEditingController();
    final selectedCategoryIds = <String>{};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Brand'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                if (_categories.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Used in Categories (leave unchecked to show for all):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._categories.map((category) {
                    final isSelected = selectedCategoryIds.contains(category.id);
                    return CheckboxListTile(
                      title: Text(category.data['name']),
                      value: isSelected,
                      onChanged: (value) {
                        setDialogState(() {
                          if (value == true) {
                            selectedCategoryIds.add(category.id);
                          } else {
                            selectedCategoryIds.remove(category.id);
                          }
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ],
            ),
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
                    const SnackBar(content: Text('Please enter a brand name')),
                  );
                  return;
                }

                try {
                  final pbService = PocketBaseService();
                  await pbService.createBrand(
                    nameController.text,
                    categoryIds: selectedCategoryIds.isEmpty ? null : selectedCategoryIds.toList(),
                  );

                  Navigator.pop(context);
                  _loadData();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Brand "${nameController.text}" added!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
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

  void _showEditBrandDialog(dynamic brand) {
    final nameController = TextEditingController(text: brand.data['name']);
    // Get current categories (handle both List and single value, and expanded objects)
    final currentCategories = brand.data['categories'];
    print('DEBUG _showEditBrandDialog: Brand ${brand.id} categories = $currentCategories (type: ${currentCategories?.runtimeType})');
    final selectedCategoryIds = <String>{};
    if (currentCategories != null) {
      if (currentCategories is List) {
        // Handle both expanded objects and IDs
        for (var c in currentCategories) {
          if (c is String) {
            selectedCategoryIds.add(c);
          } else if (c is Map && c['id'] != null) {
            selectedCategoryIds.add(c['id']);
          } else {
            selectedCategoryIds.add(c.toString());
          }
        }
      } else {
        // Single value - PocketBase might be storing as single string instead of array
        if (currentCategories is Map && currentCategories['id'] != null) {
          selectedCategoryIds.add(currentCategories['id']);
        } else {
          // It's a string, add it directly
          selectedCategoryIds.add(currentCategories.toString());
        }
      }
    }
    print('DEBUG _showEditBrandDialog: Parsed category IDs = $selectedCategoryIds');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Brand'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                if (_categories.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Used in Categories (leave unchecked to show for all):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._categories.map((category) {
                    final isSelected = selectedCategoryIds.contains(category.id);
                    return CheckboxListTile(
                      title: Text(category.data['name']),
                      value: isSelected,
                      onChanged: (value) {
                        setDialogState(() {
                          if (value == true) {
                            selectedCategoryIds.add(category.id);
                          } else {
                            selectedCategoryIds.remove(category.id);
                          }
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ],
            ),
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
                    const SnackBar(content: Text('Please enter a brand name')),
                  );
                  return;
                }

                try {
                  final pbService = PocketBaseService();
                  print('DEBUG: Updating brand ${brand.id} with categories: ${selectedCategoryIds.toList()}');
                  await pbService.updateBrand(
                    brand.id,
                    nameController.text,
                    categoryIds: selectedCategoryIds.toList(),
                  );

                  Navigator.pop(context);
                  // Reload data to get fresh brand with updated categories
                  await _loadData();
                  
                  // Debug: Check if categories were saved
                  try {
                    final updatedBrand = _brands.firstWhere((b) => b.id == brand.id);
                    print('DEBUG after save: Brand ${updatedBrand.id} categories = ${updatedBrand.data['categories']}');
                  } catch (e) {
                    print('DEBUG after save: Could not find updated brand');
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Brand updated to "${nameController.text}"!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
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

  void _deleteBrand(dynamic brand) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Brand'),
        content: Text('Are you sure you want to delete "${brand.data['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final pbService = PocketBaseService();
        await pbService.deleteBrand(brand.id);
        _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Brand "${brand.data['name']}" deleted'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brands'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _showAddBrandDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Brand'),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _brands.isEmpty
                      ? const Center(
                          child: Text(
                            'No brands yet.\nClick "Add Brand" above to get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _brands.length,
                          itemBuilder: (context, index) {
                            final brand = _brands[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.label, color: Colors.blue),
                                title: Text(
                                  brand.data['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showEditBrandDialog(brand),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteBrand(brand),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
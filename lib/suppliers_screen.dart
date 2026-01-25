import 'package:flutter/material.dart';
import 'pocketbase_service.dart';
import 'app_drawer.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List<dynamic> _suppliers = [];
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
        pbService.getSuppliers(),
        pbService.getCategories(),
      ]);
      
      setState(() {
        _suppliers = results[0] as List<dynamic>;
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

  Future<void> _loadSuppliers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pbService = PocketBaseService();
      final suppliers = await pbService.getSuppliers();
      setState(() {
        _suppliers = suppliers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading suppliers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddSupplierDialog() {
    final companyNameController = TextEditingController();
    final addressController = TextEditingController();
    final telController = TextEditingController();
    final websiteController = TextEditingController();
    final contactController = TextEditingController();
    final directTelController = TextEditingController();
    final emailController = TextEditingController();
    final selectedCategoryIds = <String>{};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Supplier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: companyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name *',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: telController,
                  decoration: const InputDecoration(
                    labelText: 'Telephone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: directTelController,
                  decoration: const InputDecoration(
                    labelText: 'Direct Tel',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                if (companyNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter company name')),
                  );
                  return;
                }

                try {
                  final pbService = PocketBaseService();
                  await pbService.createSupplier(
                    companyName: companyNameController.text,
                    address: addressController.text,
                    tel: telController.text,
                    website: websiteController.text,
                    contact: contactController.text,
                    directTel: directTelController.text,
                    email: emailController.text,
                    categoryIds: selectedCategoryIds.isEmpty ? null : selectedCategoryIds.toList(),
                  );

                  Navigator.pop(context);
                  _loadData();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Supplier "${companyNameController.text}" added!'),
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

  void _showEditSupplierDialog(dynamic supplier) {
    final companyNameController = TextEditingController(text: supplier.data['company_name']);
    final addressController = TextEditingController(text: supplier.data['address'] ?? '');
    final telController = TextEditingController(text: supplier.data['tel'] ?? '');
    final websiteController = TextEditingController(text: supplier.data['website'] ?? '');
    final contactController = TextEditingController(text: supplier.data['contact'] ?? '');
    final directTelController = TextEditingController(text: supplier.data['direct_tel'] ?? '');
    final emailController = TextEditingController(text: supplier.data['email'] ?? '');
    // Get current categories (handle both List and single value, and expanded objects)
    final currentCategories = supplier.data['categories'];
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
        // Single value (shouldn't happen, but handle it)
        if (currentCategories is Map && currentCategories['id'] != null) {
          selectedCategoryIds.add(currentCategories['id']);
        } else {
          selectedCategoryIds.add(currentCategories.toString());
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Supplier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: companyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name *',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: telController,
                  decoration: const InputDecoration(
                    labelText: 'Telephone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: directTelController,
                  decoration: const InputDecoration(
                    labelText: 'Direct Tel',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                if (companyNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter company name')),
                  );
                  return;
                }

                try {
                  final pbService = PocketBaseService();
                  print('DEBUG: Updating supplier ${supplier.id} with categories: ${selectedCategoryIds.toList()}');
                  await pbService.updateSupplier(
                    id: supplier.id,
                    companyName: companyNameController.text,
                    address: addressController.text,
                    tel: telController.text,
                    website: websiteController.text,
                    contact: contactController.text,
                    directTel: directTelController.text,
                    email: emailController.text,
                    categoryIds: selectedCategoryIds.toList(),
                  );

                  Navigator.pop(context);
                  _loadData();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Supplier "${companyNameController.text}" updated!'),
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

  void _deleteSupplier(dynamic supplier) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Supplier'),
        content: Text('Are you sure you want to delete "${supplier.data['company_name']}"?'),
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
        await pbService.deleteSupplier(supplier.id);
                _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Supplier "${supplier.data['company_name']}" deleted'),
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
        title: const Text('Suppliers'),
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
                    onPressed: _showAddSupplierDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Supplier'),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _suppliers.isEmpty
                      ? const Center(
                          child: Text(
                            'No suppliers yet.\nClick "Add Supplier" above to get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _suppliers.length,
                          itemBuilder: (context, index) {
                            final supplier = _suppliers[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.store, color: Colors.green),
                                title: Text(
                                  supplier.data['company_name'] ?? 'Unknown',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (supplier.data['contact'] != null && supplier.data['contact'] != '')
                                      Text('Contact: ${supplier.data['contact']}'),
                                    if (supplier.data['tel'] != null && supplier.data['tel'] != '')
                                      Text('Tel: ${supplier.data['tel']}'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showEditSupplierDialog(supplier),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteSupplier(supplier),
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
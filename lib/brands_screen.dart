import 'package:flutter/material.dart';
import 'pocketbase_service.dart';
import 'list_toolbar_widgets.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';
import 'drawer_behavior.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> with AutoOpenDrawerMixin {
  List<dynamic> _brands = [];
  List<dynamic> _categories = [];
  List<dynamic> _suppliers = [];
  bool _isLoading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

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
      final brands = await pbService.getBrands();
      final categories = await pbService.getCategories();
      final suppliers = await pbService.getSuppliers();
      
      setState(() {
        _brands = brands;
        _categories = categories;
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
            content: Text('Error loading brands: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showAddEditBrandDialog({dynamic brand}) async {
    final isEdit = brand != null;
    final nameController = TextEditingController(
      text: brand?.data['name'] ?? '',
    );
    final urlPatternController = TextEditingController(
      text: brand?.data['url_pattern'] ?? '',
    );
    final scraperNotesController = TextEditingController(
      text: brand?.data['scraper_notes'] ?? '',
    );
    
    bool scraperEnabled = brand?.data['scraper_enabled'] ?? false;
    List<String> selectedCategoryIds = [];
    String? selectedSupplierId;

    // Parse existing default supplier relation robustly
    if (brand != null) {
      final ds = brand.data['default_supplier'];
      if (ds is String) {
        selectedSupplierId = ds;
      } else if (ds is Map && ds['id'] != null) {
        selectedSupplierId = ds['id'] as String;
      } else {
        try {
          final dynamic dyn = ds;
          if (dyn != null && dyn.id is String) {
            selectedSupplierId = dyn.id as String;
          }
        } catch (_) {}
      }
    }
    
    // Parse existing categories
    if (brand != null) {
      final existingCategories = brand.data['categories'];
      if (existingCategories is List) {
        selectedCategoryIds = existingCategories.map((c) => c.toString()).toList();
      }
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Brand' : 'Add Brand'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Name *',
                    hintText: 'e.g., Harvey Tool',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: !isEdit,
                ),
                const SizedBox(height: 16),

                // Default Supplier (optional)
                const Text(
                  'Default Supplier (optional)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  value: selectedSupplierId != null &&
                          _suppliers.any((s) => s.id == selectedSupplierId)
                      ? selectedSupplierId
                      : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('— None —'),
                    ),
                    ..._suppliers.map((s) {
                      return DropdownMenuItem<String?>(
                        value: s.id as String,
                        child: Text(s.data['company_name'] ?? s.id),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedSupplierId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Categories
                const Text(
                  'Categories (optional)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    final categoryId = category.id;
                    final categoryName = category.data['name'];
                    final isSelected = selectedCategoryIds.contains(categoryId);
                    
                    return FilterChip(
                      label: Text(categoryName),
                      selected: isSelected,
                      onSelected: (selected) {
                        setDialogState(() {
                          if (selected) {
                            selectedCategoryIds.add(categoryId);
                          } else {
                            selectedCategoryIds.remove(categoryId);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                // Scraper Configuration Section
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Auto-Import Configuration',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                
                // Enable Auto-Import Toggle
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Enable Auto-Import'),
                  subtitle: const Text('Allow importing tool specs from this brand'),
                  value: scraperEnabled,
                  onChanged: (value) {
                    setDialogState(() {
                      scraperEnabled = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                
                // URL Pattern (only show if enabled)
                if (scraperEnabled) ...[
                  TextField(
                    controller: urlPatternController,
                    decoration: const InputDecoration(
                      labelText: 'URL Pattern *',
                      hintText: 'https://example.com/tool/{model}',
                      helperText: 'Use {model} where model number goes',
                      helperMaxLines: 2,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: scraperNotesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText: 'e.g., Model numbers must be numeric only',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Brand name is required')),
                  );
                  return;
                }
                
                if (scraperEnabled) {
                  if (urlPatternController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL pattern is required when auto-import is enabled')),
                    );
                    return;
                  }
                  if (!urlPatternController.text.contains('{model}')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL pattern must contain {model} placeholder')),
                    );
                    return;
                  }
                }

                try {
                  final pbService = PocketBaseService();

                  if (isEdit) {
                    await pbService.updateBrand(
                      brand.id,
                      nameController.text.trim(),
                      categoryIds: selectedCategoryIds.isEmpty ? [] : selectedCategoryIds,
                      urlPattern: scraperEnabled ? urlPatternController.text.trim() : '',
                      scraperEnabled: scraperEnabled,
                      scraperNotes: scraperEnabled ? scraperNotesController.text.trim() : '',
                      defaultSupplierId: selectedSupplierId,
                    );
                  } else {
                    await pbService.createBrand(
                      nameController.text.trim(),
                      categoryIds: selectedCategoryIds.isEmpty ? [] : selectedCategoryIds,
                      urlPattern: scraperEnabled ? urlPatternController.text.trim() : null,
                      scraperEnabled: scraperEnabled,
                      scraperNotes: scraperEnabled ? scraperNotesController.text.trim() : null,
                      defaultSupplierId: selectedSupplierId,
                    );
                  }

                  Navigator.pop(context, true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      _loadData();
    }
  }

  Future<void> _deleteBrand(dynamic brand) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Brand'),
        content: Text('Delete "${brand.data['name']}"?'),
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
            const SnackBar(
              content: Text('Brand deleted'),
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
    maybeAutoOpenDrawer();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted = textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);
    final titleStyle = textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

    return WorkspaceScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Brand Management'),
        leading: workspaceMenuLeading(context),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    border: Border(
                      bottom: BorderSide(color: scheme.outlineVariant),
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InventoryListActionButton(
                          label: 'Add Brand',
                          onPressed: () => _showAddEditBrandDialog(),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _brands.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.factory,
                                size: 48,
                                color: scheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 12),
                              Text('No brands yet', style: titleStyle),
                              const SizedBox(height: 4),
                              Text(
                                'Click "Add Brand" above to get started.',
                                style: muted,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _brands.length,
                          itemBuilder: (context, index) {
                            final brand = _brands[index];
                            final name = brand.data['name'] ?? 'Unknown';
                            final scraperEnabled = brand.data['scraper_enabled'] == true;
                            final urlPattern = brand.data['url_pattern'] ?? '';

                            return Card(
                              child: ListTile(
                                title: Text(name, style: titleStyle),
                                subtitle: scraperEnabled && urlPattern.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          urlPattern,
                                          style: textTheme.bodySmall?.copyWith(
                                            fontFamily: 'monospace',
                                            color: scheme.onSurfaceVariant,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : null,
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 20),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, size: 20, color: scheme.error),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Delete',
                                            style: TextStyle(color: scheme.error),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showAddEditBrandDialog(brand: brand);
                                    } else if (value == 'delete') {
                                      _deleteBrand(brand);
                                    }
                                  },
                                ),
                                onTap: () => _showAddEditBrandDialog(brand: brand),
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

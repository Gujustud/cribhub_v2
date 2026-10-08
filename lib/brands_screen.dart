import 'package:flutter/material.dart';

import 'drawer_behavior.dart';
import 'list_toolbar_widgets.dart';
import 'pocketbase_service.dart';
import 'ui_breakpoints.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> with AutoOpenDrawerMixin {
  List<dynamic> _brands = [];
  List<dynamic> _filteredBrands = [];
  List<dynamic> _categories = [];
  List<dynamic> _suppliers = [];
  bool _isLoading = true;
  dynamic _selectedBrand;
  bool _creatingNew = false;
  String _searchQuery = '';

  final _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool get _panelOpen => _creatingNew || _selectedBrand != null;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final pbService = PocketBaseService();
      final brands = await pbService.getBrands();
      final categories = await pbService.getCategories();
      final suppliers = await pbService.getSuppliers();

      setState(() {
        _brands = brands;
        _categories = categories;
        _suppliers = suppliers;
        _filteredBrands = _applySearchFilter(brands);
        if (_selectedBrand != null) {
          final id = _selectedBrand.id;
          dynamic still;
          for (final b in brands) {
            if (b.id == id) {
              still = b;
              break;
            }
          }
          _selectedBrand = still;
          if (_selectedBrand == null) _creatingNew = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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

  List<dynamic> _applySearchFilter(List<dynamic> source) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return source;
    return source.where((b) {
      final name = (b.data['name'] ?? '').toString().toLowerCase();
      final url = (b.data['url_pattern'] ?? '').toString().toLowerCase();
      return name.contains(q) || url.contains(q);
    }).toList();
  }

  void _closePanel() {
    setState(() {
      _selectedBrand = null;
      _creatingNew = false;
    });
  }

  void _onPanelClosed(bool saved) {
    _closePanel();
    if (saved) _loadData();
  }

  Future<void> _openBrand(dynamic brand, {required bool usePanel}) async {
    if (usePanel) {
      setState(() {
        _selectedBrand = brand;
        _creatingNew = false;
      });
      return;
    }
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => BrandEditorScreen(
          brand: brand,
          categories: _categories,
          suppliers: _suppliers,
        ),
      ),
    );
    if (changed == true) _loadData();
  }

  Future<void> _openAdd({required bool usePanel}) async {
    if (usePanel) {
      setState(() {
        _selectedBrand = null;
        _creatingNew = true;
      });
      return;
    }
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => BrandEditorScreen(
          categories: _categories,
          suppliers: _suppliers,
        ),
      ),
    );
    if (changed == true) _loadData();
  }

  Widget _buildToolbar(bool stacked, {required bool usePanel}) {
    final search = InventoryListSearchField(
      controller: _searchController,
      hintText: 'Search brands…',
      onChanged: (v) {
        setState(() {
          _searchQuery = v;
          _filteredBrands = _applySearchFilter(_brands);
        });
      },
      decoration: inventoryListSearchDecoration(
        context,
        hintText: 'Search brands…',
      ).copyWith(
        suffixIcon: _searchController.text.isNotEmpty
            ? inventoryListSearchClearButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _filteredBrands = _brands;
                  });
                },
              )
            : null,
      ),
    );
    final addButton = InventoryListActionButton(
      label: 'Add Brand',
      onPressed: () => _openAdd(usePanel: usePanel),
    );
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          search,
          const SizedBox(height: 12),
          addButton,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: search),
        const SizedBox(width: 12),
        addButton,
      ],
    );
  }

  Widget _buildDetailPanel() {
    if (!_panelOpen) return const SizedBox.shrink();
    return BrandEditorScreen(
      key: ValueKey(
        _creatingNew ? 'brand-new' : 'brand-${_selectedBrand!.id}',
      ),
      brand: _creatingNew ? null : _selectedBrand,
      categories: _categories,
      suppliers: _suppliers,
      embedded: true,
      onClosed: _onPanelClosed,
    );
  }

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted =
        textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);
    final titleStyle =
        textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 700;
    final usePanel = width >= kWorkspaceWideBreakpointPx;

    final listColumn = workspaceContentFrame(
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(
                bottom: BorderSide(color: scheme.outlineVariant),
              ),
            ),
            child: _buildToolbar(
              isNarrow || (usePanel && _panelOpen),
              usePanel: usePanel,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBrands.isEmpty
                    ? Center(
                        child: Text(
                          _brands.isEmpty
                              ? 'No brands yet.\nClick "Add Brand" above to get started.'
                              : 'No brands match your search.',
                          textAlign: TextAlign.center,
                          style: muted,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _filteredBrands.length,
                        itemBuilder: (context, index) {
                          final brand = _filteredBrands[index];
                          final name = brand.data['name'] ?? 'Unknown';
                          final scraperEnabled =
                              brand.data['scraper_enabled'] == true;
                          final urlPattern =
                              (brand.data['url_pattern'] ?? '').toString();
                          final selected = usePanel &&
                              !_creatingNew &&
                              _selectedBrand?.id == brand.id;

                          return Card(
                            color: selected ? scheme.secondaryContainer : null,
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
                              trailing: Icon(
                                Icons.chevron_right,
                                color: scheme.onSurfaceVariant,
                              ),
                              onTap: () =>
                                  _openBrand(brand, usePanel: usePanel),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      maxWidth: usePanel && _panelOpen
          ? kWorkspacePanelContentMaxWidth
          : kWorkspaceContentMaxWidth,
    );

    return WorkspaceScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Brands'),
        leading: workspaceMenuLeading(context),
      ),
      body: usePanel && _panelOpen
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 3, child: listColumn),
                Expanded(flex: 7, child: _buildDetailPanel()),
              ],
            )
          : listColumn,
    );
  }
}

/// Add/edit brand form — full route or Purchases-style side panel.
class BrandEditorScreen extends StatefulWidget {
  final dynamic brand;
  final List<dynamic> categories;
  final List<dynamic> suppliers;
  final bool embedded;
  final ValueChanged<bool>? onClosed;

  const BrandEditorScreen({
    super.key,
    this.brand,
    required this.categories,
    required this.suppliers,
    this.embedded = false,
    this.onClosed,
  });

  @override
  State<BrandEditorScreen> createState() => _BrandEditorScreenState();
}

class _BrandEditorScreenState extends State<BrandEditorScreen>
    with AutoOpenDrawerMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _urlPatternController;
  late final TextEditingController _scraperNotesController;
  late bool _scraperEnabled;
  late List<String> _selectedCategoryIds;
  String? _selectedSupplierId;
  bool _isSaving = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool get _isEdit => widget.brand != null;

  String get _title {
    if (!_isEdit) return 'Add Brand';
    final name = _nameController.text.trim();
    return name.isEmpty ? 'Edit Brand' : name;
  }

  @override
  void initState() {
    super.initState();
    final brand = widget.brand;
    _nameController = TextEditingController(
      text: brand?.data['name'] ?? '',
    );
    _urlPatternController = TextEditingController(
      text: brand?.data['url_pattern'] ?? '',
    );
    _scraperNotesController = TextEditingController(
      text: brand?.data['scraper_notes'] ?? '',
    );
    _scraperEnabled = brand?.data['scraper_enabled'] ?? false;
    _selectedCategoryIds = [];
    _selectedSupplierId = null;

    if (brand != null) {
      final ds = brand.data['default_supplier'];
      if (ds is String) {
        _selectedSupplierId = ds;
      } else if (ds is Map && ds['id'] != null) {
        _selectedSupplierId = ds['id'] as String;
      } else {
        try {
          final dynamic dyn = ds;
          if (dyn != null && dyn.id is String) {
            _selectedSupplierId = dyn.id as String;
          }
        } catch (_) {}
      }

      final existingCategories = brand.data['categories'];
      if (existingCategories is List) {
        _selectedCategoryIds =
            existingCategories.map((c) => c.toString()).toList();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlPatternController.dispose();
    _scraperNotesController.dispose();
    super.dispose();
  }

  void _close({required bool saved}) {
    if (widget.embedded) {
      widget.onClosed?.call(saved);
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context, saved);
    }
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brand name is required')),
      );
      return;
    }

    if (_scraperEnabled) {
      if (_urlPatternController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('URL pattern is required when auto-import is enabled'),
          ),
        );
        return;
      }
      if (!_urlPatternController.text.contains('{model}')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('URL pattern must contain {model} placeholder'),
          ),
        );
        return;
      }
    }

    setState(() => _isSaving = true);
    try {
      final pbService = PocketBaseService();
      if (_isEdit) {
        await pbService.updateBrand(
          widget.brand.id,
          _nameController.text.trim(),
          categoryIds:
              _selectedCategoryIds.isEmpty ? [] : _selectedCategoryIds,
          urlPattern:
              _scraperEnabled ? _urlPatternController.text.trim() : '',
          scraperEnabled: _scraperEnabled,
          scraperNotes:
              _scraperEnabled ? _scraperNotesController.text.trim() : '',
          defaultSupplierId: _selectedSupplierId,
        );
      } else {
        await pbService.createBrand(
          _nameController.text.trim(),
          categoryIds:
              _selectedCategoryIds.isEmpty ? [] : _selectedCategoryIds,
          urlPattern: _scraperEnabled
              ? _urlPatternController.text.trim()
              : null,
          scraperEnabled: _scraperEnabled,
          scraperNotes: _scraperEnabled
              ? _scraperNotesController.text.trim()
              : null,
          defaultSupplierId: _selectedSupplierId,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEdit ? 'Brand updated' : 'Brand created'),
            backgroundColor: Colors.green,
          ),
        );
        _close(saved: true);
      }
    } catch (e) {
      setState(() => _isSaving = false);
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

  Future<void> _delete() async {
    final name = _nameController.text.trim().isEmpty
        ? (widget.brand.data['name'] ?? 'this brand')
        : _nameController.text.trim();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Brand'),
        content: Text('Delete "$name"?'),
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
    if (confirm != true || !mounted) return;
    try {
      await PocketBaseService().deleteBrand(widget.brand.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Brand deleted'),
            backgroundColor: Colors.green,
          ),
        );
        _close(saved: true);
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

  Widget _buildEmbeddedHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  _title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Close',
              onPressed: () => _close(saved: false),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormBody() {
    final supplierValue = _selectedSupplierId != null &&
            widget.suppliers.any((s) => s.id == _selectedSupplierId)
        ? _selectedSupplierId
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.embedded ? kWorkspaceContentMaxWidth : 720,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Brand Name *',
                  hintText: 'e.g., Harvey Tool',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                autofocus: !_isEdit,
                onChanged: (_) {
                  if (widget.embedded) setState(() {});
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Default Supplier (optional)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                key: ValueKey(supplierValue ?? 'none'),
                initialValue: supplierValue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('— None —'),
                  ),
                  ...widget.suppliers.map((s) {
                    return DropdownMenuItem<String?>(
                      value: s.id as String,
                      child: Text(s.data['company_name'] ?? s.id),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() => _selectedSupplierId = value);
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Categories (optional)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              if (widget.categories.isEmpty)
                Text(
                  'No categories yet.',
                  style: TextStyle(color: Colors.grey[600]),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.categories.map((category) {
                    final categoryId = category.id as String;
                    final categoryName = category.data['name'];
                    final isSelected =
                        _selectedCategoryIds.contains(categoryId);
                    return FilterChip(
                      label: Text(categoryName),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategoryIds.add(categoryId);
                          } else {
                            _selectedCategoryIds.remove(categoryId);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Auto-Import Configuration',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable Auto-Import'),
                subtitle: const Text(
                  'Allow importing tool specs from this brand',
                ),
                value: _scraperEnabled,
                onChanged: (value) {
                  setState(() => _scraperEnabled = value);
                },
              ),
              if (_scraperEnabled) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _urlPatternController,
                  decoration: const InputDecoration(
                    labelText: 'URL Pattern *',
                    hintText: 'https://example.com/tool/{model}',
                    helperText: 'Use {model} where model number goes',
                    helperMaxLines: 2,
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _scraperNotesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    hintText: 'e.g., Model numbers must be numeric only',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: 3,
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isEdit ? 'Save brand' : 'Create brand'),
                  ),
                  if (_isEdit) ...[
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isSaving ? null : _delete,
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.error,
                        foregroundColor:
                            Theme.of(context).colorScheme.onError,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = _buildFormBody();

    if (widget.embedded) {
      final scheme = Theme.of(context).colorScheme;
      return Material(
        color: scheme.surface,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: scheme.outlineVariant),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildEmbeddedHeader(context),
              Expanded(child: form),
            ],
          ),
        ),
      );
    }

    return WorkspaceScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        title: Text(_title),
        leading: workspaceMenuLeading(context),
      ),
      body: form,
    );
  }
}

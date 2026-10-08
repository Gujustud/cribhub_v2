import 'package:flutter/material.dart';

import 'drawer_behavior.dart';
import 'list_toolbar_widgets.dart';
import 'pocketbase_service.dart';
import 'supplier_detail_screen.dart';
import 'ui_breakpoints.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen>
    with AutoOpenDrawerMixin {
  List<dynamic> _suppliers = [];
  List<dynamic> _filteredSuppliers = [];
  bool _isLoading = true;
  dynamic _selectedSupplier;
  bool _creatingNew = false;
  String _searchQuery = '';

  final _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool get _panelOpen => _creatingNew || _selectedSupplier != null;

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
      final suppliers = await PocketBaseService().getSuppliers();
      setState(() {
        _suppliers = suppliers;
        _filteredSuppliers = _applySearchFilter(suppliers);
        if (_selectedSupplier != null) {
          final id = _selectedSupplier.id;
          dynamic still;
          for (final s in suppliers) {
            if (s.id == id) {
              still = s;
              break;
            }
          }
          _selectedSupplier = still;
          if (_selectedSupplier == null) _creatingNew = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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

  List<dynamic> _applySearchFilter(List<dynamic> source) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return source;
    return source.where((s) {
      final data = s.data as Map<String, dynamic>? ?? {};
      for (final key in [
        'company_name',
        'contact',
        'tel',
        'email',
        'website',
        'address',
      ]) {
        if ((data[key] ?? '').toString().toLowerCase().contains(q)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  void _closePanel() {
    setState(() {
      _selectedSupplier = null;
      _creatingNew = false;
    });
  }

  void _onPanelClosed(bool saved) {
    _closePanel();
    if (saved) _loadData();
  }

  Future<void> _openSupplier(dynamic supplier, {required bool usePanel}) async {
    if (usePanel) {
      setState(() {
        _selectedSupplier = supplier;
        _creatingNew = false;
      });
      return;
    }
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => SupplierDetailScreen(supplier: supplier),
      ),
    );
    if (changed == true) _loadData();
  }

  Future<void> _openAdd({required bool usePanel}) async {
    if (usePanel) {
      setState(() {
        _selectedSupplier = null;
        _creatingNew = true;
      });
      return;
    }
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const SupplierDetailScreen(),
      ),
    );
    if (changed == true) _loadData();
  }

  Widget _buildToolbar(bool stacked, {required bool usePanel}) {
    final search = InventoryListSearchField(
      controller: _searchController,
      hintText: 'Search suppliers…',
      onChanged: (v) {
        setState(() {
          _searchQuery = v;
          _filteredSuppliers = _applySearchFilter(_suppliers);
        });
      },
      decoration: inventoryListSearchDecoration(
        context,
        hintText: 'Search suppliers…',
      ).copyWith(
        suffixIcon: _searchController.text.isNotEmpty
            ? inventoryListSearchClearButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _filteredSuppliers = _suppliers;
                  });
                },
              )
            : null,
      ),
    );
    final addButton = InventoryListActionButton(
      label: 'Add Supplier',
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
    return SupplierDetailScreen(
      key: ValueKey(
        _creatingNew ? 'supplier-new' : 'supplier-${_selectedSupplier!.id}',
      ),
      supplier: _creatingNew ? null : _selectedSupplier,
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
                : _filteredSuppliers.isEmpty
                    ? Center(
                        child: Text(
                          _suppliers.isEmpty
                              ? 'No suppliers yet.\nClick "Add Supplier" above to get started.'
                              : 'No suppliers match your search.',
                          textAlign: TextAlign.center,
                          style: muted,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _filteredSuppliers.length,
                        itemBuilder: (context, index) {
                          final supplier = _filteredSuppliers[index];
                          final selected = usePanel &&
                              !_creatingNew &&
                              _selectedSupplier?.id == supplier.id;
                          final contact = (supplier.data['contact'] ?? '')
                              .toString()
                              .trim();
                          final tel =
                              (supplier.data['tel'] ?? '').toString().trim();
                          return Card(
                            color: selected ? scheme.secondaryContainer : null,
                            child: ListTile(
                              title: Text(
                                supplier.data['company_name'] ?? 'Unknown',
                                style: titleStyle,
                              ),
                              subtitle: (contact.isEmpty && tel.isEmpty)
                                  ? null
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (contact.isNotEmpty)
                                          Text('Contact: $contact',
                                              style: muted),
                                        if (tel.isNotEmpty)
                                          Text('Tel: $tel', style: muted),
                                      ],
                                    ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: scheme.onSurfaceVariant,
                              ),
                              onTap: () =>
                                  _openSupplier(supplier, usePanel: usePanel),
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
        title: const Text('Suppliers'),
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

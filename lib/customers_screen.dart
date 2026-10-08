import 'package:flutter/material.dart';

import 'customer_detail_screen.dart';
import 'customer_labels.dart';
import 'drawer_behavior.dart';
import 'list_toolbar_widgets.dart';
import 'pocketbase_service.dart';
import 'ui_breakpoints.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';

/// List of CRM customers (`customers` collection).
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen>
    with AutoOpenDrawerMixin {
  List<dynamic> _customers = [];
  List<dynamic> _filteredCustomers = [];
  bool _isLoading = true;
  dynamic _selectedCustomer;
  bool _creatingNew = false;

  final _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool get _panelOpen => _creatingNew || _selectedCustomer != null;

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
      final customers = await PocketBaseService().getCustomers();
      if (!mounted) return;
      setState(() {
        _customers = customers;
        _filteredCustomers = _applySearchFilter(customers);
        if (_selectedCustomer != null) {
          final id = _selectedCustomer.id;
          dynamic still;
          for (final c in customers) {
            if (c.id == id) {
              still = c;
              break;
            }
          }
          _selectedCustomer = still;
          if (_selectedCustomer == null) _creatingNew = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading customers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<dynamic> _applySearchFilter(List<dynamic> source) {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return source;

    return source.where((c) {
      final data = c.data as Map<String, dynamic>? ?? {};
      final fields = [
        data['company'],
        data['name'],
        data['email'],
        data['phone'],
        data['address'],
      ];
      return fields.any((v) => _str(v).toLowerCase().contains(q));
    }).toList();
  }

  void _onSearchChanged(String _) {
    setState(() {
      _filteredCustomers = _applySearchFilter(_customers);
    });
  }

  void _closePanel() {
    setState(() {
      _selectedCustomer = null;
      _creatingNew = false;
    });
  }

  void _onPanelClosed(bool saved) {
    _closePanel();
    if (saved) _loadData();
  }

  Future<void> _openCustomer(dynamic customer, {required bool usePanel}) async {
    if (usePanel) {
      setState(() {
        _selectedCustomer = customer;
        _creatingNew = false;
      });
      return;
    }
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailScreen(customer: customer),
      ),
    );
    if (changed == true) _loadData();
  }

  Future<void> _openAdd({required bool usePanel}) async {
    if (usePanel) {
      setState(() {
        _selectedCustomer = null;
        _creatingNew = true;
      });
      return;
    }
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerDetailScreen(),
      ),
    );
    if (changed == true) _loadData();
  }

  String _str(dynamic v) {
    if (v == null) return '';
    return v.toString().trim();
  }

  Widget _buildToolbar(bool stacked, {required bool usePanel}) {
    final search = InventoryListSearchField(
      controller: _searchController,
      hintText: 'Search customers…',
      onChanged: _onSearchChanged,
      decoration: inventoryListSearchDecoration(
        context,
        hintText: 'Search customers…',
      ).copyWith(
        suffixIcon: _searchController.text.isNotEmpty
            ? inventoryListSearchClearButton(
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
              )
            : null,
      ),
    );
    final addButton = InventoryListActionButton(
      label: 'Add Customer',
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
    return CustomerDetailScreen(
      key: ValueKey(
        _creatingNew ? 'customer-new' : 'customer-${_selectedCustomer!.id}',
      ),
      customer: _creatingNew ? null : _selectedCustomer,
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
                : _filteredCustomers.isEmpty
                    ? Center(
                        child: Text(
                          _customers.isEmpty
                              ? 'No customers yet.\nTap Add Customer above.'
                              : 'No customers match your search.',
                          textAlign: TextAlign.center,
                          style: muted,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final c = _filteredCustomers[index];
                          final data =
                              c.data as Map<String, dynamic>? ?? {};
                          final title = customerDisplayLabel(data);
                          final contact = customerContactLine(data);
                          final selected = usePanel &&
                              !_creatingNew &&
                              _selectedCustomer?.id == c.id;
                          return Card(
                            color: selected ? scheme.secondaryContainer : null,
                            child: ListTile(
                              title: Text(title, style: titleStyle),
                              subtitle: contact == null
                                  ? null
                                  : Text(contact, style: muted),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: scheme.onSurfaceVariant,
                              ),
                              onTap: () =>
                                  _openCustomer(c, usePanel: usePanel),
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
        title: const Text('Customers'),
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

import 'package:flutter/material.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';
import 'customer_detail_screen.dart';
import 'customer_labels.dart';
import 'drawer_behavior.dart';
import 'list_toolbar_widgets.dart';
import 'pocketbase_service.dart';

/// List of CRM customers (`customers` collection).
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> with AutoOpenDrawerMixin {
  List<dynamic> _customers = [];
  List<dynamic> _filteredCustomers = [];
  bool _isLoading = true;

  final _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

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
      if (mounted) {
        setState(() {
          _customers = customers;
          _filteredCustomers = _applySearchFilter(customers);
          _isLoading = false;
        });
      }
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

  Future<void> _openAddCustomer() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const CustomerDetailScreen()),
    );
    if (changed == true) _loadData();
  }

  Future<void> _deleteCustomer(dynamic customer) async {
    final data = customer.data as Map<String, dynamic>? ?? {};
    final label = customerDisplayLabel(data, fallback: 'this customer');
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete customer'),
        content: Text('Delete "$label"?'),
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
    if (confirm != true) return;
    try {
      await PocketBaseService().deleteCustomer(customer.id);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer deleted'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  String _str(dynamic v) {
    if (v == null) return '';
    final s = v.toString().trim();
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted = textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);
    final titleStyle = textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    final isNarrow = MediaQuery.of(context).size.width < 700;

    return WorkspaceScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Customers'),
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
                      child: isNarrow
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: _searchController,
                                  decoration: inventoryListSearchDecoration(
                                    context,
                                    hintText: 'Search customers...',
                                  ),
                                  onChanged: _onSearchChanged,
                                ),
                                const SizedBox(height: 12),
                                InventoryListActionButton(
                                  label: 'Add Customer',
                                  onPressed: _openAddCustomer,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: inventoryListSearchDecoration(
                                      context,
                                      hintText: 'Search customers...',
                                    ),
                                    onChanged: _onSearchChanged,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InventoryListActionButton(
                                  label: 'Add Customer',
                                  onPressed: _openAddCustomer,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    child: _customers.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 80),
                              Center(
                                child: Text(
                                  'No customers yet.\nTap Add Customer above.',
                                  textAlign: TextAlign.center,
                                  style: muted,
                                ),
                              ),
                            ],
                          )
                        : _filteredCustomers.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 80),
                                  Center(
                                    child: Text(
                                      'No customers match "${_searchController.text}".',
                                      textAlign: TextAlign.center,
                                      style: muted,
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(8),
                                itemCount: _filteredCustomers.length,
                                itemBuilder: (context, index) {
                                  final c = _filteredCustomers[index];
                                  final data = c.data as Map<String, dynamic>? ?? {};
                                  final title = customerDisplayLabel(data);
                                  final contact = customerContactLine(data);
                                  final address = _str(data['address']);
                                  final email = _str(data['email']);
                                  final phone = _str(data['phone']);
                                  final lines = <Widget>[
                                    if (contact != null) Text(contact, style: muted),
                                    if (address.isNotEmpty) Text(address, style: muted),
                                    if (email.isNotEmpty) Text(email, style: muted),
                                    if (phone.isNotEmpty) Text(phone, style: muted),
                                  ];

                                  return Card(
                                    child: ListTile(
                                      title: Text(title, style: titleStyle),
                                      subtitle: lines.isEmpty
                                          ? null
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: lines,
                                            ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete, color: scheme.error),
                                            onPressed: () => _deleteCustomer(c),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: scheme.onSurfaceVariant,
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        final changed = await Navigator.push<bool>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CustomerDetailScreen(customer: c),
                                          ),
                                        );
                                        if (changed == true) _loadData();
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
    );
  }
}

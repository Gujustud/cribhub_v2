import 'package:flutter/material.dart';
import 'pocketbase_service.dart';
import 'list_toolbar_widgets.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';
import 'drawer_behavior.dart';
import 'supplier_detail_screen.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> with AutoOpenDrawerMixin {
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
    setState(() => _isLoading = true);
    try {
      final suppliers = await PocketBaseService().getSuppliers();
      setState(() {
        _suppliers = suppliers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading suppliers: $e'), backgroundColor: Colors.red),
        );
      }
    }
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
        await PocketBaseService().deleteSupplier(supplier.id);
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
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
        title: const Text('Suppliers'),
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
                          label: 'Add Supplier',
                          onPressed: () async {
                            final changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SupplierDetailScreen(),
                              ),
                            );
                            if (changed == true) _loadData();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _suppliers.isEmpty
                      ? Center(
                          child: Text(
                            'No suppliers yet.\nClick "Add Supplier" above to get started.',
                            textAlign: TextAlign.center,
                            style: muted,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _suppliers.length,
                          itemBuilder: (context, index) {
                            final supplier = _suppliers[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  supplier.data['company_name'] ?? 'Unknown',
                                  style: titleStyle,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (supplier.data['contact'] != null &&
                                        supplier.data['contact'] != '')
                                      Text(
                                        'Contact: ${supplier.data['contact']}',
                                        style: muted,
                                      ),
                                    if (supplier.data['tel'] != null &&
                                        supplier.data['tel'] != '')
                                      Text(
                                        'Tel: ${supplier.data['tel']}',
                                        style: muted,
                                      ),
                                  ],
                                ),
                                onTap: () async {
                                  final changed = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SupplierDetailScreen(supplier: supplier),
                                    ),
                                  );
                                  if (changed == true) _loadData();
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete, color: scheme.error),
                                      onPressed: () => _deleteSupplier(supplier),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: scheme.onSurfaceVariant,
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

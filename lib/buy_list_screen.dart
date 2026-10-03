import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';
import 'models.dart';
import 'pocketbase_service.dart';
import 'drawer_behavior.dart';
import 'list_toolbar_widgets.dart';
import 'add_tool_screen.dart';

class BuyListScreen extends StatefulWidget {
  const BuyListScreen({super.key});

  @override
  State<BuyListScreen> createState() => _BuyListScreenState();
}

class _BuyListScreenState extends State<BuyListScreen> with AutoOpenDrawerMixin {
  final _pb = PocketBaseService();
  bool _loading = true;
  String? _error;
  List<Tool> _tools = [];
  List<ManualBuyItem> _manualItems = [];
  List<RecordModel> _suppliers = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final records = await _pb.pb.collection('inventory').getFullList(
        filter: 'needs_restock = true',
        expand: 'brand,supplier',
        sort: 'tool_name',
      );
      final manual = await _pb.getManualBuyItems();
      final supplierRecords = await _pb.pb.collection('suppliers').getFullList(
        sort: 'company_name',
      );
      setState(() {
        _tools = records.map((r) => Tool.fromRecord(r)).toList();
        _manualItems = manual;
        _suppliers = supplierRecords;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error =
            'Could not load Buy List. Make sure the `inventory` collection has fields `needs_restock` (bool) and `restock_qty` (number/int).\n\n$e';
        _loading = false;
      });
    }
  }

  Future<void> _openTool(Tool tool) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddToolScreen(tool: tool)),
    );
    if (result == true) _load();
  }

  Future<void> _updateRestock({
    required Tool tool,
    required bool needsRestock,
    required int? qty,
  }) async {
    try {
      await _pb.pb.collection('inventory').update(
        tool.id,
        body: {
          'needs_restock': needsRestock,
          'restock_qty': needsRestock ? (qty ?? 1) : null,
        },
      );
      if (!mounted) return;
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating buy list: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showManualItemDialog({ManualBuyItem? existing}) async {
    final descController = TextEditingController(text: existing?.description ?? '');
    final qtyController = TextEditingController(text: (existing?.qty ?? 1).toString());
    final notesController = TextEditingController(text: existing?.notes ?? '');

    String? selectedSupplierId = existing?.supplier;
    String initialSupplierName = '';
    if (existing?.supplier != null) {
      try {
        final sup = _suppliers.firstWhere((s) => s.id == existing!.supplier);
        initialSupplierName =
            (sup.data['company_name'] ?? sup.id).toString();
      } catch (_) {
        initialSupplierName = existing!.supplier ?? '';
      }
    }
    final supplierTextController = TextEditingController(text: initialSupplierName);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add custom item' : 'Edit custom item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Qty'),
              ),
              const SizedBox(height: 8),
              Autocomplete<RecordModel>(
                optionsBuilder: (textValue) {
                  final query = textValue.text.trim().toLowerCase();
                  if (query.isEmpty) return _suppliers;
                  return _suppliers.where((s) {
                    final name =
                        (s.data['company_name'] ?? s.id).toString().toLowerCase();
                    return name.contains(query);
                  });
                },
                displayStringForOption: (s) =>
                    (s.data['company_name'] ?? s.id).toString(),
                initialValue: initialSupplierName.isNotEmpty
                    ? TextEditingValue(text: initialSupplierName)
                    : null,
                onSelected: (record) {
                  selectedSupplierId = record.id;
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  controller.text = supplierTextController.text;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Supplier (optional)',
                    ),
                    onChanged: (value) {
                      supplierTextController.text = value;
                      if (value.trim().isEmpty) {
                        selectedSupplierId = null;
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      final desc = descController.text.trim();
      final qty = int.tryParse(qtyController.text.trim()) ?? 1;
      final notes = notesController.text.trim().isEmpty ? null : notesController.text.trim();
      if (desc.isEmpty) return;

      if (existing == null) {
        await _pb.createManualBuyItem(
          description: desc,
          qty: qty,
          supplier: selectedSupplierId,
          notes: notes,
        );
      } else {
        await _pb.updateManualBuyItem(
          id: existing.id,
          description: desc,
          qty: qty,
          supplier: selectedSupplierId,
          notes: notes,
        );
      }
      await _load();
    }
  }

  Widget _qtyChip(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.onPrimaryContainer,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted = textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);
    final titleStyle = textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    final sectionStyle = textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);

    return WorkspaceScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Buy List'),
        leading: workspaceMenuLeading(context),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: TextStyle(color: scheme.error),
                  ),
                )
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
                              label: 'Add custom item',
                              onPressed:
                                  _loading ? null : () => _showManualItemDialog(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _tools.isEmpty && _manualItems.isEmpty
                          ? Center(
                              child: Text(
                                'No items in the Buy List.',
                                style: muted,
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.all(8),
                              children: [
                                if (_tools.isNotEmpty) ...[
                                  Text('Inventory tools', style: sectionStyle),
                                  const SizedBox(height: 8),
                                  ..._tools.map((t) {
                                    final qtyToBuy = t.restockQty ?? 1;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(t.toolName, style: titleStyle),
                                          subtitle: Text(
                                            [
                                              if (t.modelNumber != null &&
                                                  t.modelNumber!.isNotEmpty)
                                                'Model: ${t.modelNumber}',
                                              if (t.brand != null && t.brand!.isNotEmpty)
                                                'Brand: ${t.brand}',
                                              if (t.supplier != null &&
                                                  t.supplier!.isNotEmpty)
                                                'Supplier: ${t.supplier}',
                                              if (t.restockNotes != null &&
                                                  t.restockNotes!
                                                      .toString()
                                                      .trim()
                                                      .isNotEmpty)
                                                'Notes: ${t.restockNotes}',
                                            ].join(' • '),
                                            style: muted,
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _qtyChip(context, 'Qty: $qtyToBuy'),
                                              const SizedBox(width: 8),
                                              IconButton(
                                                tooltip: 'Remove from Buy List',
                                                icon: Icon(
                                                  Icons.check_circle,
                                                  color: scheme.primary,
                                                ),
                                                onPressed: () => _updateRestock(
                                                  tool: t,
                                                  needsRestock: false,
                                                  qty: null,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Edit tool',
                                                icon: const Icon(Icons.edit),
                                                onPressed: () => _openTool(t),
                                              ),
                                            ],
                                          ),
                                          onTap: () => _openTool(t),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                                if (_manualItems.isNotEmpty) ...[
                                  if (_tools.isNotEmpty) const SizedBox(height: 16),
                                  Text('Custom items', style: sectionStyle),
                                  const SizedBox(height: 8),
                                  ..._manualItems.map((m) => Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Card(
                                          child: ListTile(
                                            title: Text(
                                              m.description,
                                              style: titleStyle,
                                            ),
                                            subtitle: Builder(
                                              builder: (context) {
                                                final supplierId = m.supplier;
                                                String supplierName = '';
                                                if (supplierId != null &&
                                                    supplierId.trim().isNotEmpty) {
                                                  try {
                                                    final sup = _suppliers
                                                        .firstWhere((s) => s.id == supplierId);
                                                    supplierName =
                                                        (sup.data['company_name'] ??
                                                                sup.id)
                                                            .toString();
                                                  } catch (_) {
                                                    supplierName = supplierId;
                                                  }
                                                }
                                                final notes = (m.notes ?? '').toString();
                                                final parts = <String>[
                                                  'Qty: ${m.qty}',
                                                  if (supplierName.trim().isNotEmpty)
                                                    'Supplier: $supplierName',
                                                  if (notes.trim().isNotEmpty)
                                                    'Notes: $notes',
                                                ];
                                                return Text(
                                                  parts.join(' • '),
                                                  style: muted,
                                                );
                                              },
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                _qtyChip(context, 'Qty: ${m.qty}'),
                                                const SizedBox(width: 8),
                                                IconButton(
                                                  tooltip: 'Remove from Buy List',
                                                  icon: Icon(
                                                    Icons.check_circle,
                                                    color: scheme.primary,
                                                  ),
                                                  onPressed: () async {
                                                    await _pb.deleteManualBuyItem(m.id);
                                                    await _load();
                                                  },
                                                ),
                                                IconButton(
                                                  tooltip: 'Edit item',
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () =>
                                                      _showManualItemDialog(existing: m),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ],
                            ),
                    ),
                  ],
                ),
    );
  }
}


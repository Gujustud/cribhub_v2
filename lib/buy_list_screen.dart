import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'models.dart';
import 'pocketbase_service.dart';
import 'drawer_behavior.dart';
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
      setState(() {
        _tools = records.map((r) => Tool.fromRecord(r)).toList();
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

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Buy List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _tools.isEmpty
                  ? const Center(
                      child: Text(
                        'No tools in the Buy List.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _tools.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final t = _tools[i];
                        final qtyToBuy = t.restockQty ?? 1;
                        return Card(
                          child: ListTile(
                            title: Text(
                              t.toolName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              [
                                if (t.modelNumber != null && t.modelNumber!.isNotEmpty)
                                  'Model: ${t.modelNumber}',
                                if (t.brand != null && t.brand!.isNotEmpty) 'Brand: ${t.brand}',
                                if (t.supplier != null && t.supplier!.isNotEmpty)
                                  'Supplier: ${t.supplier}',
                              ].join(' • '),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Qty: $qtyToBuy',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  tooltip: 'Remove from Buy List',
                                  icon: const Icon(Icons.check_circle, color: Colors.green),
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
                        );
                      },
                    ),
    );
  }
}


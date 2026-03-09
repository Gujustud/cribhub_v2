import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pocketbase_service.dart';
import 'models.dart';
import 'app_drawer.dart';
import 'add_purchase_screen.dart';
import 'drawer_behavior.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> with AutoOpenDrawerMixin {
  List<Purchase> _purchases = [];
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    setState(() => _isLoading = true);
    try {
      final pbService = PocketBaseService();
      final records = await pbService.getPurchases();
      setState(() {
        _purchases = records.map((r) => Purchase.fromRecord(r)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading purchases: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Purchases'),
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
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPurchaseScreen()),
                      );
                      _loadPurchases();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Purchase'),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _purchases.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No purchases yet.\nClick "Add Purchase" above to get started.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _purchases.length,
                          itemBuilder: (context, index) {
                            final p = _purchases[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  p.supplierName ?? 'No supplier',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(DateFormat.yMMMd().format(p.purchaseDate)),
                                    if (p.orderReference != null && p.orderReference!.isNotEmpty)
                                      Text('Ref: ${p.orderReference}'),
                                    if (p.total != null) Text('Total: \$${p.total!.toStringAsFixed(2)}'),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddPurchaseScreen(purchase: p),
                                    ),
                                  );
                                  _loadPurchases();
                                },
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

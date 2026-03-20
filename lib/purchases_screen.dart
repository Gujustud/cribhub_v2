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
  List<Purchase> _filteredPurchases = [];
  final TextEditingController _purchaseSearchController = TextEditingController();
  String _purchaseSearchQuery = '';
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  @override
  void dispose() {
    _purchaseSearchController.dispose();
    super.dispose();
  }

  List<Purchase> _applyPurchaseSearchFilter(List<Purchase> source) {
    final q = _purchaseSearchQuery.trim().toLowerCase();
    if (q.isEmpty) return source;

    return source.where((p) {
      final supplier = (p.supplierName ?? '').toLowerCase();
      final ref = (p.orderReference ?? '').toLowerCase();
      return supplier.contains(q) || ref.contains(q);
    }).toList();
  }

  Future<void> _loadPurchases() async {
    setState(() => _isLoading = true);
    try {
      final pbService = PocketBaseService();
      final records = await pbService.getPurchases();
      setState(() {
        _purchases = records.map((r) => Purchase.fromRecord(r)).toList();
        _filteredPurchases = _applyPurchaseSearchFilter(_purchases);
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
    final isNarrow = MediaQuery.of(context).size.width < 700;
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
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
                                  controller: _purchaseSearchController,
                                  onChanged: (v) {
                                    setState(() {
                                      _purchaseSearchQuery = v;
                                      _filteredPurchases = _applyPurchaseSearchFilter(_purchases);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search supplier or invoice #...',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: _purchaseSearchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              _purchaseSearchController.clear();
                                              setState(() {
                                                _purchaseSearchQuery = '';
                                                _filteredPurchases = _purchases;
                                              });
                                            },
                                          )
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AddPurchaseScreen(),
                                      ),
                                    );
                                    _loadPurchases();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 14,
                                    ),
                                    backgroundColor: Colors.grey[700],
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 52),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, size: 24),
                                      SizedBox(width: 8),
                                      Text('Add Purchase', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _purchaseSearchController,
                                    onChanged: (v) {
                                      setState(() {
                                        _purchaseSearchQuery = v;
                                        _filteredPurchases = _applyPurchaseSearchFilter(_purchases);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search supplier or invoice #...',
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: _purchaseSearchController.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                _purchaseSearchController.clear();
                                                setState(() {
                                                  _purchaseSearchQuery = '';
                                                  _filteredPurchases = _purchases;
                                                });
                                              },
                                            )
                                          : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AddPurchaseScreen(),
                                      ),
                                    );
                                    _loadPurchases();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 14,
                                    ),
                                    backgroundColor: Colors.grey[700],
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 52),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add, size: 24),
                                      SizedBox(width: 8),
                                      Text('Add Purchase', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredPurchases.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                _purchaseSearchQuery.trim().isNotEmpty
                                    ? 'No purchases match your search.'
                                    : 'No purchases yet.\nClick "Add Purchase" above to get started.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _filteredPurchases.length,
                          itemBuilder: (context, index) {
                            final p = _filteredPurchases[index];
                            final supplier = p.supplierName ?? 'No supplier';
                            final dateText = DateFormat.yMMMd().format(p.purchaseDate);
                            final refText = (p.orderReference != null && p.orderReference!.isNotEmpty)
                                ? 'Ref: ${p.orderReference}'
                                : null;
                            final totalText =
                                p.total != null ? 'Total: \$${p.total!.toStringAsFixed(2)}' : null;

                            return Card(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWideCard = constraints.maxWidth >= 560;
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddPurchaseScreen(purchase: p),
                                        ),
                                      );
                                      _loadPurchases();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      child: isWideCard
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    supplier,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Text(
                                                  dateText,
                                                  style: TextStyle(color: Colors.grey[700]),
                                                ),
                                                if (refText != null) ...[
                                                  const SizedBox(width: 20),
                                                  Text(
                                                    refText,
                                                    style: TextStyle(color: Colors.grey[700]),
                                                  ),
                                                ],
                                                if (totalText != null) ...[
                                                  const SizedBox(width: 20),
                                                  Text(
                                                    totalText,
                                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                                const SizedBox(width: 10),
                                                const Icon(Icons.chevron_right),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        supplier,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(dateText),
                                                      if (refText != null) Text(refText),
                                                      if (totalText != null) Text(totalText),
                                                    ],
                                                  ),
                                                ),
                                                const Icon(Icons.chevron_right),
                                              ],
                                            ),
                                    ),
                                  );
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pocketbase_service.dart';
import 'models.dart';
import 'add_purchase_screen.dart';
import 'drawer_behavior.dart';
import 'list_toolbar_widgets.dart';
import 'ui_breakpoints.dart';
import 'workspace_layout.dart';
import 'workspace_scaffold.dart';

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

  /// Wide layout: selected purchase shown in the right panel (null when closed / new).
  Purchase? _selectedPurchase;

  /// Wide layout: right panel is creating a new purchase.
  bool _creatingNew = false;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool get _panelOpen => _creatingNew || _selectedPurchase != null;

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
        // Keep selection if the purchase still exists after reload.
        if (_selectedPurchase != null) {
          final id = _selectedPurchase!.id;
          Purchase? stillThere;
          for (final p in _purchases) {
            if (p.id == id) {
              stillThere = p;
              break;
            }
          }
          _selectedPurchase = stillThere;
          if (_selectedPurchase == null) _creatingNew = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading purchases: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _closePanel() {
    setState(() {
      _selectedPurchase = null;
      _creatingNew = false;
    });
  }

  void _onPanelClosed(bool saved) {
    _closePanel();
    if (saved) _loadPurchases();
  }

  Future<void> _openPurchase(Purchase purchase, {required bool usePanel}) async {
    if (usePanel) {
      setState(() {
        _selectedPurchase = purchase;
        _creatingNew = false;
      });
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPurchaseScreen(purchase: purchase),
      ),
    );
    _loadPurchases();
  }

  Future<void> _openAddPurchase({required bool usePanel}) async {
    if (usePanel) {
      setState(() {
        _selectedPurchase = null;
        _creatingNew = true;
      });
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPurchaseScreen(),
      ),
    );
    _loadPurchases();
  }

  Widget _buildToolbar(bool isNarrow, {required bool usePanel}) {
    final search = TextField(
      controller: _purchaseSearchController,
      onChanged: (v) {
        setState(() {
          _purchaseSearchQuery = v;
          _filteredPurchases = _applyPurchaseSearchFilter(_purchases);
        });
      },
      decoration: inventoryListSearchDecoration(
        context,
        hintText: 'Search supplier or invoice #...',
      ).copyWith(
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
      ),
    );
    final addButton = InventoryListActionButton(
      label: 'Add Purchase',
      onPressed: () => _openAddPurchase(usePanel: usePanel),
    );

    if (isNarrow) {
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

  Widget _buildPurchaseList({
    required bool usePanel,
    required TextStyle? titleStyle,
    required TextStyle? muted,
  }) {
    final scheme = Theme.of(context).colorScheme;

    if (_filteredPurchases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              _purchaseSearchQuery.trim().isNotEmpty
                  ? 'No purchases match your search.'
                  : 'No purchases yet.\nClick "Add Purchase" above to get started.',
              textAlign: TextAlign.center,
              style: muted,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _filteredPurchases.length,
      itemBuilder: (context, index) {
        final p = _filteredPurchases[index];
        final supplier = p.supplierName ?? 'No supplier';
        final dateText = DateFormat.yMMMd().format(p.purchaseDate);
        final refText =
            (p.orderReference != null && p.orderReference!.isNotEmpty)
                ? 'Ref: ${p.orderReference}'
                : null;
        final totalText =
            p.total != null ? 'Total: \$${p.total!.toStringAsFixed(2)}' : null;
        final selected = usePanel &&
            !_creatingNew &&
            _selectedPurchase?.id == p.id;

        return Card(
          color: selected ? scheme.secondaryContainer : null,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideCard = constraints.maxWidth >= 560;
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _openPurchase(p, usePanel: usePanel),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: isWideCard
                      ? Row(
                          children: [
                            Expanded(
                              child: Text(
                                supplier,
                                style: titleStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(dateText, style: muted),
                            if (refText != null) ...[
                              const SizedBox(width: 20),
                              Text(refText, style: muted),
                            ],
                            if (totalText != null) ...[
                              const SizedBox(width: 20),
                              Text(totalText, style: titleStyle),
                            ],
                            const SizedBox(width: 10),
                            Icon(
                              Icons.chevron_right,
                              color: scheme.onSurfaceVariant,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(supplier, style: titleStyle),
                                  const SizedBox(height: 4),
                                  Text(dateText, style: muted),
                                  if (refText != null)
                                    Text(refText, style: muted),
                                  if (totalText != null)
                                    Text(totalText, style: titleStyle),
                                ],
                              ),
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
        );
      },
    );
  }

  Widget _buildDetailPanel() {
    if (!_panelOpen) {
      return const SizedBox.shrink();
    }
    return AddPurchaseScreen(
      key: ValueKey(
        _creatingNew ? 'purchase-new' : 'purchase-${_selectedPurchase!.id}',
      ),
      purchase: _creatingNew ? null : _selectedPurchase,
      embedded: true,
      onClosed: _onPanelClosed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted = textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);
    final titleStyle = textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 700;
    // Master/detail needs room for list + form (and optional pinned drawer).
    final usePanel = width >= kWorkspaceWideBreakpointPx;

    final listColumn = Column(
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
              constraints: BoxConstraints(
                maxWidth: usePanel && _panelOpen ? 900 : 1200,
              ),
              child: _buildToolbar(isNarrow, usePanel: usePanel),
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildPurchaseList(
                  usePanel: usePanel,
                  titleStyle: titleStyle,
                  muted: muted,
                ),
        ),
      ],
    );

    return WorkspaceScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Purchases'),
        leading: workspaceMenuLeading(context),
      ),
      body: usePanel && _panelOpen
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 5, child: listColumn),
                Expanded(flex: 6, child: _buildDetailPanel()),
              ],
            )
          : listColumn,
    );
  }
}

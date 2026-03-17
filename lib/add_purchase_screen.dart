import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pocketbase_service.dart';
import 'models.dart';
import 'app_drawer.dart';
import 'drawer_behavior.dart';

class AddPurchaseScreen extends StatefulWidget {
  /// When non-null, opens in edit mode for this purchase.
  final Purchase? purchase;

  const AddPurchaseScreen({super.key, this.purchase});

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> with AutoOpenDrawerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  List<dynamic> _suppliers = [];
  List<Tool> _tools = [];
  bool _isLoadingData = true;

  DateTime _purchaseDate = DateTime.now();
  String? _supplierId;
  final _orderRefController = TextEditingController();
  final _notesController = TextEditingController();
  late final TextEditingController _dateController;

  // Line items: type 'item'|'shipping' only (tax is GST/PST checkboxes below)
  final List<Map<String, dynamic>> _lineItems = [];

  bool _gstChecked = false;
  bool _pstChecked = false;

  static const double _gstRate = 0.05; // 5%
  static const double _pstRate = 0.07; // 7%

  @override
  void initState() {
    super.initState();
    final p = widget.purchase;
    if (p != null) {
      _purchaseDate = p.purchaseDate;
      _supplierId = p.supplierId;
      _orderRefController.text = p.orderReference ?? '';
      _notesController.text = p.notes ?? '';
    }
    _dateController = TextEditingController(text: DateFormat.yMMMd().format(_purchaseDate));
    _loadData();
    if (p == null) {
      _lineItems.add({
        'type': 'item',
        'toolId': null as String?,
        'toolName': '',
        'quantity': 1,
        'unitCost': null as double?,
        'description': '',
      });
    }
  }

  @override
  void dispose() {
    _orderRefController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    // Dispose any per-line TextEditingControllers we created
    for (final item in _lineItems) {
      final qtyCtrl = item['quantityController'];
      if (qtyCtrl is TextEditingController) {
        qtyCtrl.dispose();
      }
      final unitCtrl = item['unitCostController'];
      if (unitCtrl is TextEditingController) {
        unitCtrl.dispose();
      }
    }
    super.dispose();
  }

  void _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _purchaseDate = picked;
        _dateController.text = DateFormat.yMMMd().format(_purchaseDate);
      });
    }
  }

  void _parseDateFromField() {
    final text = _dateController.text.trim();
    if (text.isEmpty) return;
    DateTime? parsed;
    try {
      parsed = DateFormat.yMMMd().parse(text);
    } catch (_) {}
    if (parsed == null) {
      try {
        parsed = DateFormat('M/d/yyyy').parse(text);
      } catch (_) {}
    }
    if (parsed == null) {
      parsed = DateTime.tryParse(text);
    }
    if (parsed != null) {
      setState(() {
        _purchaseDate = parsed!;
        _dateController.text = DateFormat.yMMMd().format(_purchaseDate);
      });
    } else {
      _dateController.text = DateFormat.yMMMd().format(_purchaseDate);
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoadingData = true);
    try {
      final pbService = PocketBaseService();
      final p = widget.purchase;
      final futures = [
        pbService.getSuppliers(),
        pbService.getTools(),
        if (p != null) pbService.getPurchaseItems(p.id),
      ];
      final results = await Future.wait(futures);
      final suppliers = results[0] as List<dynamic>;
      final toolRecords = results[1] as List<dynamic>;
      List<PurchaseItem> existingItems = [];
      if (p != null && results.length > 2) {
        existingItems = (results[2] as List<dynamic>).map((r) => PurchaseItem.fromRecord(r)).toList();
      }
      setState(() {
        _suppliers = suppliers;
        _tools = toolRecords.map((r) => Tool.fromRecord(r)).toList();
        if (p != null && existingItems.isNotEmpty) {
          _lineItems.clear();
          bool gst = false, pst = false;
          for (final item in existingItems) {
            if (item.lineType == 'tax') {
              if (item.description == 'GST') gst = true;
              if (item.description == 'PST') pst = true;
              continue;
            }
            final type = item.lineType == 'shipping' ? 'shipping' : 'item';
            _lineItems.add({
              'type': type,
              'toolId': item.toolId,
              'toolName': item.toolName ?? '',
              'quantity': item.quantity,
              'unitCost': item.unitCost,
              'description': item.description ?? '',
              // Text shown in the Item field; prefer saved description, else tool name.
              'itemText': (item.description?.isNotEmpty == true)
                  ? item.description
                  : (item.toolName ?? ''),
            });
          }
          _gstChecked = gst;
          _pstChecked = pst;
          if (_lineItems.isEmpty) {
            _lineItems.add({
              'type': 'item',
              'toolId': null as String?,
              'toolName': '',
              'quantity': 1,
              'unitCost': null as double?,
              'description': '',
              'itemText': '',
            });
          }
        } else if (p == null) {
          // Ensure the starter line has an itemText slot.
          if (_lineItems.isNotEmpty) {
            _lineItems[0]['itemText'] ??= '';
          }
        }
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _addLine() {
    setState(() {
      _lineItems.add({
        'type': 'item',
        'toolId': null as String?,
        'toolName': '',
        'quantity': 1,
        'unitCost': null as double?,
        'description': '',
      });
    });
  }

  static const int _toolSuggestionsMax = 5;

  String _lineTotal(int index) {
    final item = _lineItems[index];
    if ((item['type'] as String? ?? 'item') != 'item') return '';
    final qty = (item['quantity'] as int?) ?? 0;
    final unit = (item['unitCost'] as double?) ?? 0;
    if (qty <= 0 || unit <= 0) return '';
    return '\$${(qty * unit).toStringAsFixed(2)}';
  }

  double _subtotalItems() {
    double sum = 0;
    for (final item in _lineItems) {
      if ((item['type'] as String? ?? 'item') != 'item') continue;
      final qty = (item['quantity'] as int?) ?? 0;
      final unit = (item['unitCost'] as double?) ?? 0;
      sum += qty * unit;
    }
    return sum;
  }

  double _shippingTotal() {
    double shipping = 0;
    for (final item in _lineItems) {
      final type = item['type'] as String? ?? 'item';
      if (type == 'shipping') {
        shipping += (item['unitCost'] as double?) ?? 0;
      }
    }
    return shipping;
  }

  double _taxableBase() {
    return _subtotalItems() + _shippingTotal();
  }

  double _totalTaxAndShipping() {
    double sum = 0;
    final shipping = _shippingTotal();
    sum += shipping;
    final taxableBase = _taxableBase();
    if (_gstChecked) sum += taxableBase * _gstRate;
    if (_pstChecked) sum += taxableBase * _pstRate;
    return sum;
  }

  Iterable<Tool> _filterTools(String text) {
    if (text.trim().isEmpty) return _tools.take(_toolSuggestionsMax);
    final lower = text.toLowerCase();
    return _tools.where((t) {
      final nameMatch = t.toolName.toLowerCase().contains(lower);
      final modelMatch = t.modelNumber?.toLowerCase().contains(lower) ?? false;
      return nameMatch || modelMatch;
    }).take(_toolSuggestionsMax);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete purchase?'),
        content: const Text('This will delete the purchase and all its line items.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || widget.purchase == null) return;
    try {
      await PocketBaseService().deletePurchase(widget.purchase!.id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase deleted'), backgroundColor: Colors.green),
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

  Future<void> _save() async {
    final validLines = _lineItems.where((e) {
      final type = e['type'] as String? ?? 'item';
      if (type == 'item') {
        return e['toolId'] != null && (e['quantity'] as int) > 0;
      }
      if (type == 'shipping') {
        final amount = (e['unitCost'] as double?) ?? 0;
        return amount > 0;
      }
      return false;
    }).toList();
    if (validLines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one line (item with tool + quantity, or shipping)')),
      );
      return;
    }

    try {
      final pbService = PocketBaseService();
      String id;
      // Compute the grand total upfront so it can be saved to the record
      final subtotal = _subtotalItems();
      final gstAmt = _gstChecked ? subtotal * _gstRate : 0.0;
      final pstAmt = _pstChecked ? subtotal * _pstRate : 0.0;
      final grandTotal = subtotal + _totalTaxAndShipping();
      if (widget.purchase != null) {
        id = widget.purchase!.id;
        await pbService.updatePurchase(id,
          purchaseDate: _purchaseDate,
          supplierId: _supplierId,
          orderReference: _orderRefController.text.isEmpty ? null : _orderRefController.text,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          total: grandTotal,
        );
        final existing = await pbService.getPurchaseItems(id);
        for (final item in existing) {
          await pbService.deletePurchaseItem(item.id);
        }
      } else {
        final record = await pbService.createPurchase(
          purchaseDate: _purchaseDate,
          supplierId: _supplierId,
          orderReference: _orderRefController.text.isEmpty ? null : _orderRefController.text,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          total: grandTotal,
        );
        id = record.id;
      }
      for (final line in validLines) {
        final type = line['type'] as String? ?? 'item';
        final desc = (line['description'] as String?)?.trim();
        await pbService.createPurchaseItem(
          purchaseId: id,
          toolId: type == 'item' ? (line['toolId'] as String?) : null,
          quantity: type == 'item' ? (line['quantity'] as int) : 1,
          unitCost: line['unitCost'] as double?,
          lineType: type,
          description: desc?.isEmpty == true ? 'Shipping' : desc,
        );
      }
      if (gstAmt > 0) {
        await pbService.createPurchaseItem(
          purchaseId: id,
          toolId: null,
          quantity: 1,
          unitCost: gstAmt,
          lineType: 'tax',
          description: 'GST',
        );
      }
      if (pstAmt > 0) {
        await pbService.createPurchaseItem(
          purchaseId: id,
          toolId: null,
          quantity: 1,
          unitCost: pstAmt,
          lineType: 'tax',
          description: 'PST',
        );
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.purchase != null ? 'Purchase updated' : 'Purchase added'),
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

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.purchase != null ? 'Edit Purchase' : 'Add Purchase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (widget.purchase != null)
            TextButton(
              onPressed: _isLoadingData ? null : _delete,
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  // Date: type or tap calendar
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Date',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _openDatePicker,
                        tooltip: 'Pick date',
                      ),
                    ),
                    onSubmitted: (_) => _parseDateFromField(),
                    onEditingComplete: _parseDateFromField,
                  ),
                  const SizedBox(height: 16),
                  // Supplier + Order reference on same row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Supplier: type to search or pick from dropdown
                      Expanded(
                        flex: 3,
                        child: Autocomplete<Object>(
                    initialValue: widget.purchase != null &&
                            widget.purchase!.supplierName != null &&
                            widget.purchase!.supplierName!.isNotEmpty
                        ? TextEditingValue(text: widget.purchase!.supplierName!)
                        : null,
                    optionsBuilder: (textValue) {
                      final query = textValue.text.trim().toLowerCase();
                      if (query.isEmpty) {
                        return List<Object>.from([const _SupplierNone(), ..._suppliers]);
                      }
                      return List<Object>.from(_suppliers.where((s) {
                        final name = (s.data['company_name'] ?? '').toString().toLowerCase();
                        return name.contains(query);
                      }));
                    },
                    displayStringForOption: (option) {
                      if (option is _SupplierNone) return '— None —';
                      final s = option as dynamic;
                      return (s.data['company_name'] ?? s.id) as String;
                    },
                    onSelected: (option) {
                      setState(() {
                        _supplierId = option is _SupplierNone ? null : (option as dynamic).id as String;
                      });
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Supplier',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(4),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 240),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final opt = options.elementAt(index);
                                final label = opt is _SupplierNone
                                    ? '— None —'
                                    : ((opt as dynamic).data['company_name'] ?? (opt as dynamic).id) as String;
                                return ListTile(
                                  dense: true,
                                  title: Text(label),
                                  onTap: () => onSelected(opt),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                      ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _orderRefController,
                          decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Order reference',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Line items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_lineItems.length, (i) {
                    final item = _lineItems[i];
                    final rawType = item['type'] as String? ?? 'item';
                    final lineType = rawType == 'tax' ? 'item' : rawType;
                    // Lazily ensure the visible text backing field exists.
                    item['itemText'] ??= item['toolName'] ?? '';
                    // Lazily create controllers per line so typing doesn't fight rebuilds.
                    if (lineType == 'item') {
                      item['quantityController'] ??=
                          TextEditingController(text: '${item['quantity']}');
                      item['unitCostController'] ??= TextEditingController(
                        text: item['unitCost'] != null
                            ? (item['unitCost'] as double).toString()
                            : '',
                      );
                    } else {
                      // Shipping: only unit cost controller is used
                      item['unitCostController'] ??= TextEditingController(
                        text: item['unitCost'] != null
                            ? (item['unitCost'] as double).toString()
                            : '',
                      );
                    }
                    return Padding(
                      key: ValueKey('line_$i'),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 115,
                            child: DropdownButtonFormField<String>(
                              value: lineType,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'item', child: Text('Item')),
                                DropdownMenuItem(value: 'shipping', child: Text('Shipping')),
                              ],
                              onChanged: (v) {
                                if (v != null) setState(() => _lineItems[i]['type'] = v);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (lineType == 'item') ...[
                            Expanded(
                              flex: 2,
                              child: Autocomplete<Tool>(
                                key: ValueKey('tool_autocomplete_$i'),
                                optionsBuilder: (textValue) =>
                                    _filterTools(textValue.text),
                                displayStringForOption: (t) => t.toolName,
                                onSelected: (tool) {
                                  setState(() {
                                    _lineItems[i]['toolId'] = tool.id;
                                    _lineItems[i]['toolName'] = tool.toolName;
                                    // Show "Tool Name (MODEL)" in the field so it matches the tool
                                    // but still surfaces the model number from the invoice.
                                    final model = tool.modelNumber;
                                    _lineItems[i]['itemText'] = (model != null && model.isNotEmpty)
                                        ? '${tool.toolName} ($model)'
                                        : tool.toolName;
                                  });
                                },
                                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                  // Keep the text field showing whatever the user typed
                                  // (invoice description / model), not the internal tool name.
                                  final desiredText = (item['itemText'] as String?) ?? '';
                                  if (controller.text != desiredText) {
                                    controller.text = desiredText;
                                    controller.selection = TextSelection.fromPosition(
                                      TextPosition(offset: controller.text.length),
                                    );
                                  }
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: 'Item',
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.search, size: 20),
                                    ),
                                    onChanged: (value) {
                                      // Remember the raw invoice text the user wants to see.
                                      item['itemText'] = value;
                                    },
                                  );
                                },
                                optionsViewBuilder: (context, onSelected, options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(4),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(maxHeight: 220),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          itemBuilder: (context, index) {
                                            final t = options.elementAt(index);
                                            return ListTile(
                                              dense: true,
                                              title: Text(
                                                t.toolName,
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                              subtitle: t.modelNumber != null
                                                  ? Text(
                                                      t.modelNumber!,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    )
                                                  : null,
                                              onTap: () => onSelected(t),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 70,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Qty',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                controller: item['quantityController'] as TextEditingController,
                                onChanged: (v) {
                                  _lineItems[i]['quantity'] = int.tryParse(v) ?? 1;
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 90,
                              child: TextField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Unit',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                controller: item['unitCostController'] as TextEditingController,
                                onChanged: (v) {
                                  _lineItems[i]['unitCost'] = double.tryParse(v);
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 110,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Subtotal',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                child: Text(
                                  _lineTotal(i),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ] else ...[
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Shipping',
                                  border: OutlineInputBorder(),
                                ),
                                controller: TextEditingController(
                                  text: item['description'] as String? ?? '',
                                ),
                                onChanged: (v) {
                                  _lineItems[i]['description'] = v;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 110,
                              child: TextField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Subtotal',
                                  prefixText: '\$',
                                  border: OutlineInputBorder(),
                                ),
                                controller: item['unitCostController'] as TextEditingController,
                                onChanged: (v) {
                                  _lineItems[i]['unitCost'] = double.tryParse(v);
                                  _lineItems[i]['quantity'] = 1;
                                  setState(() {});
                                },
                                onEditingComplete: () {
                                  final ctrl = item['unitCostController'] as TextEditingController;
                                  final parsed = double.tryParse(ctrl.text);
                                  if (parsed != null) {
                                    final formatted = parsed.toStringAsFixed(2);
                                    if (ctrl.text != formatted) {
                                      ctrl.text = formatted;
                                      ctrl.selection = TextSelection.fromPosition(
                                        TextPosition(offset: ctrl.text.length),
                                      );
                                    }
                                  }
                                },
                                onSubmitted: (_) {
                                  final ctrl = item['unitCostController'] as TextEditingController;
                                  final parsed = double.tryParse(ctrl.text);
                                  if (parsed != null) {
                                    final formatted = parsed.toStringAsFixed(2);
                                    if (ctrl.text != formatted) {
                                      ctrl.text = formatted;
                                      ctrl.selection = TextSelection.fromPosition(
                                        TextPosition(offset: ctrl.text.length),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          // Fixed-width button column: always reserves space for both icons
                          SizedBox(
                            width: 52,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 18),
                                  onPressed: () {
                                    // Clean up controllers for this line before removing it
                                    final removed = _lineItems.removeAt(i);
                                    final qtyCtrl = removed['quantityController'];
                                    if (qtyCtrl is TextEditingController) {
                                      qtyCtrl.dispose();
                                    }
                                    final unitCtrl = removed['unitCostController'];
                                    if (unitCtrl is TextEditingController) {
                                      unitCtrl.dispose();
                                    }
                                    setState(() {});
                                  },
                                  tooltip: 'Remove line',
                                  color: Colors.grey[700],
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 8),
                                Opacity(
                                  opacity: i == _lineItems.length - 1 ? 1.0 : 0.0,
                                  child: IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    onPressed: i == _lineItems.length - 1 ? _addLine : null,
                                    tooltip: 'Add line item',
                                    color: Colors.grey[700],
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // Summary row: right-aligned, shows item subtotal, shipping, GST/PST, and total (no box).
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _gstChecked == true,
                                onChanged: (v) => setState(() => _gstChecked = v == true),
                              ),
                              Text(
                                'GST${_gstChecked ? ' \$${(_taxableBase() * _gstRate).toStringAsFixed(2)}' : ''}',
                              ),
                              const SizedBox(width: 16),
                              Checkbox(
                                value: _pstChecked == true,
                                onChanged: (v) => setState(() => _pstChecked = v == true),
                              ),
                              Text(
                                'PST${_pstChecked ? ' \$${(_taxableBase() * _pstRate).toStringAsFixed(2)}' : ''}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Items: \$${_subtotalItems().toStringAsFixed(2)}'),
                          Text('Shipping: \$${_shippingTotal().toStringAsFixed(2)}'),
                          const SizedBox(height: 4),
                          Text(
                            'Total: \$${(_subtotalItems() + _totalTaxAndShipping()).toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(width: 52),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isLoadingData ? null : _save,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'SAVE PURCHASE',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _SupplierNone {
  const _SupplierNone();
}

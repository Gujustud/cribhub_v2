import 'package:flutter/material.dart';
import 'pocketbase_service.dart';

/// Add or edit one `quote_line_items` row for a quote.
class QuoteLineItemDetailScreen extends StatefulWidget {
  final String quoteId;
  final dynamic lineItem;
  /// Suggested next line # when adding (e.g. existing count + 1).
  final String? initialLineNumber;

  const QuoteLineItemDetailScreen({
    super.key,
    required this.quoteId,
    this.lineItem,
    this.initialLineNumber,
  });

  @override
  State<QuoteLineItemDetailScreen> createState() => _QuoteLineItemDetailScreenState();
}

class _QuoteLineItemDetailScreenState extends State<QuoteLineItemDetailScreen> {
  final _lineNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _partQuantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _lineTotalController = TextEditingController();

  bool _isSaving = false;

  bool get _isNew => widget.lineItem == null;

  @override
  void initState() {
    super.initState();
    if (!_isNew) {
      final d = widget.lineItem.data as Map<String, dynamic>? ?? {};
      _lineNumberController.text = '${d['line_number'] ?? ''}';
      _descriptionController.text = '${d['description'] ?? ''}';
      _setNum(_partQuantityController, d['part_quantity'] ?? d['quantity'], fallback: '1');
      _setNum(_unitPriceController, d['unit_price'], fallback: '0');
      _setNum(_lineTotalController, d['line_total']);
    } else {
      _lineNumberController.text = widget.initialLineNumber ?? '1';
      _partQuantityController.text = '1';
      _unitPriceController.text = '0';
    }
  }

  void _setNum(TextEditingController c, dynamic v, {String? fallback}) {
    if (v is num) {
      c.text = v == v.roundToDouble() ? '${v.toInt()}' : v.toString();
    } else if (v != null && v.toString().isNotEmpty) {
      c.text = v.toString();
    } else if (fallback != null) {
      c.text = fallback;
    }
  }

  @override
  void dispose() {
    _lineNumberController.dispose();
    _descriptionController.dispose();
    _partQuantityController.dispose();
    _unitPriceController.dispose();
    _lineTotalController.dispose();
    super.dispose();
  }

  double _parse(TextEditingController c, {double fallback = 0}) {
    return double.tryParse(c.text.trim()) ?? fallback;
  }

  void _recalcLineTotal() {
    final qty = _parse(_partQuantityController, fallback: 1);
    final unit = _parse(_unitPriceController);
    _lineTotalController.text = (qty * unit).toStringAsFixed(2);
  }

  Future<void> _save() async {
    final lineNumber = _lineNumberController.text.trim();
    if (lineNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Line number is required')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final pb = PocketBaseService();
      final partQty = _parse(_partQuantityController, fallback: 1);
      final unit = _parse(_unitPriceController);
      final lineTotalText = _lineTotalController.text.trim();
      final lineTotal = lineTotalText.isEmpty ? partQty * unit : _parse(_lineTotalController);
      final desc = _descriptionController.text.trim();

      if (_isNew) {
        await pb.createQuoteLineItem(
          quoteId: widget.quoteId,
          lineNumber: lineNumber,
          partQuantity: partQty,
          description: desc.isEmpty ? null : desc,
          unitPrice: unit,
          lineTotal: lineTotal,
        );
      } else {
        await pb.updateQuoteLineItem(
          id: widget.lineItem.id,
          lineNumber: lineNumber,
          partQuantity: partQty,
          description: desc.isEmpty ? null : desc,
          unitPrice: unit,
          lineTotal: lineTotal,
        );
      }
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isNew ? 'Line item added' : 'Line item updated'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    VoidCallback? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged != null ? (_) => onChanged() : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'Add line item' : 'Edit line item'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(controller: _lineNumberController, label: 'Line number *'),
                _field(controller: _descriptionController, label: 'Description'),
                _field(
                  controller: _partQuantityController,
                  label: 'Part quantity *',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: _recalcLineTotal,
                ),
                _field(
                  controller: _unitPriceController,
                  label: 'Unit price',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: _recalcLineTotal,
                ),
                _field(
                  controller: _lineTotalController,
                  label: 'Line total',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                TextButton(
                  onPressed: _recalcLineTotal,
                  child: const Text('Recalculate line total (qty × unit price)'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          _isNew ? 'ADD LINE' : 'SAVE LINE',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

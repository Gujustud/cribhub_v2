import 'package:flutter/material.dart';
import 'quote_calculations.dart';

class _QuoteSection extends StatefulWidget {
  final String title;
  final bool initiallyOpen;
  final Widget child;

  const _QuoteSection({
    required this.title,
    this.initiallyOpen = false,
    required this.child,
  });

  @override
  State<_QuoteSection> createState() => _QuoteSectionState();
}

class _QuoteSectionState extends State<_QuoteSection> {
  late bool _open;

  @override
  void initState() {
    super.initState();
    _open = widget.initiallyOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(_open ? '▼' : '▶', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ),
        if (_open) Padding(padding: const EdgeInsets.only(bottom: 12), child: widget.child),
        const Divider(height: 1),
      ],
    );
  }
}

/// One quote part / line item (DharmaCore `LineItemCard.jsx`).
class QuoteLineItemCard extends StatefulWidget {
  final Map<String, dynamic> lineItem;
  final Map<String, dynamic> quoteSettings;
  final Map<String, dynamic>? calculated;
  final List<dynamic> suppliers;
  final List<String> alloySuggestions;
  final int lineIndex;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final VoidCallback onDelete;
  final VoidCallback? onDuplicate;
  final VoidCallback? onAddPart;

  const QuoteLineItemCard({
    super.key,
    required this.lineItem,
    required this.quoteSettings,
    required this.calculated,
    required this.suppliers,
    required this.alloySuggestions,
    required this.lineIndex,
    required this.onChanged,
    required this.onDelete,
    this.onDuplicate,
    this.onAddPart,
  });

  @override
  State<QuoteLineItemCard> createState() => _QuoteLineItemCardState();
}

class _QuoteLineItemCardState extends State<QuoteLineItemCard> {
  bool _detailsOpen = false;

  void _patch(Map<String, dynamic> updates) {
    widget.onChanged({...widget.lineItem, ...updates});
  }

  String _str(dynamic v) => v == null ? '' : v.toString();

  double? _dollarFromInput(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final n = double.tryParse(raw.trim());
    if (n == null || n.isNaN) return null;
    return quoteRound2(n);
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      );

  @override
  Widget build(BuildContext context) {
    final item = widget.lineItem;
    final calc = widget.calculated;
    final exchangeRate =
        double.tryParse('${widget.quoteSettings['exchange_rate_usd_to_cad'] ?? 1.3}') ?? 1.3;

    String supplierLabel(dynamic s) {
      final d = s.data as Map<String, dynamic>? ?? {};
      return '${d['company_name'] ?? d['name'] ?? s.id}'.trim();
    }

    Widget supplierDropdown(String field, String label) {
      final current = _relationId(item[field]);
      return DropdownButtonFormField<String>(
        value: current != null &&
                widget.suppliers.any((s) => s.id == current)
            ? current
            : null,
        decoration: _dec(label),
        items: [
          const DropdownMenuItem(value: null, child: Text('— Select —')),
          ...widget.suppliers.map(
            (s) => DropdownMenuItem(
              value: s.id as String,
              child: Text(supplierLabel(s)),
            ),
          ),
        ],
        onChanged: (id) => _patch({field: id}),
      );
    }

    final qppDisplay = item['quote_part_price_cad'] != null &&
            item['quote_part_price_cad'] != ''
        ? quoteRound2(_num(item['quote_part_price_cad']))
        : calc?['quoted_price_per_part_cad'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Part ${widget.lineIndex + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: _str(item['part_number']),
                    decoration: _dec('Part number'),
                    onChanged: (v) => _patch({'part_number': v}),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: TextFormField(
                    initialValue: item['part_quantity'] == null
                        ? ''
                        : '${item['part_quantity']}',
                    decoration: _dec('Qty'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      if (v.isEmpty) {
                        _patch({'part_quantity': null});
                        return;
                      }
                      final n = int.tryParse(v) ?? double.tryParse(v);
                      if (n != null && n >= 0) _patch({'part_quantity': n});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: qppDisplay == null ? '' : '$qppDisplay',
                    decoration: _dec('QPP'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) {
                      if (v.trim().isEmpty) {
                        _patch({'quote_part_price_cad': null});
                        return;
                      }
                      final n = double.tryParse(v);
                      if (n != null && n >= 0) {
                        _patch({'quote_part_price_cad': quoteRound2(n)});
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(_detailsOpen ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _detailsOpen = !_detailsOpen),
                  tooltip: _detailsOpen ? 'Hide details' : 'Show details',
                ),
              ],
            ),
            if (_detailsOpen) ...[
              const SizedBox(height: 8),
              _QuoteSection(
                title: 'Materials',
                initiallyOpen: true,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMaterialCadField(calc),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: _dec('Actual cost (USD)'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            controller: TextEditingController(
                              text: item['usd_cost'] == null || item['usd_cost'] == ''
                                  ? ''
                                  : '${item['usd_cost']}',
                            ),
                            onChanged: (v) {
                              final usd = _dollarFromInput(v);
                              final cad = usd != null && exchangeRate > 0
                                  ? quoteRound2(usd * exchangeRate)
                                  : null;
                              _patch({
                                'usd_cost': usd ?? '',
                                'material_cost_cad': cad,
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: _dec('Shipping cost'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => _patch({
                              'material_shipping_cost': _dollarFromInput(v) ?? '',
                            }),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: _dec('Testing cost'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) =>
                                _patch({'testing_cost': _dollarFromInput(v) ?? ''}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: _dec('Alloy'),
                      controller: TextEditingController(text: _str(item['alloy'])),
                      onChanged: (v) => _patch({'alloy': v}),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: _dec('Stock size per part'),
                            controller: TextEditingController(
                              text: _str(item['stock_size_per_part']),
                            ),
                            onChanged: (v) => _patch({'stock_size_per_part': v}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: _dec('Pieces'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              final n = int.tryParse(v);
                              _patch({'pieces': n});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: _dec('Ordered length'),
                      controller: TextEditingController(text: _str(item['ordered_length'])),
                      onChanged: (v) => _patch({'ordered_length': v}),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: supplierDropdown('material_vendor', 'Material supplier')),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vendor supplied', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                ChoiceChip(
                                  label: const Text('Yes'),
                                  selected: _str(item['vendor_supplied']).toLowerCase() == 'yes',
                                  onSelected: (_) => _patch({'vendor_supplied': 'yes'}),
                                ),
                                const SizedBox(width: 4),
                                ChoiceChip(
                                  label: const Text('No'),
                                  selected: _str(item['vendor_supplied']).toLowerCase() == 'no',
                                  onSelected: (_) => _patch({'vendor_supplied': 'no'}),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: _dec('Material note'),
                      onChanged: (v) => _patch({'material_note': v}),
                    ),
                  ],
                ),
              ),
              _QuoteSection(
                title: 'Tooling',
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextField(
                        decoration: _dec('Total cost'),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (v) =>
                            _patch({'tooling_total_cost': _dollarFromInput(v) ?? ''}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: _dec('Description'),
                        controller: TextEditingController(
                          text: _str(item['tooling_description']),
                        ),
                        onChanged: (v) => _patch({'tooling_description': v}),
                      ),
                    ),
                  ],
                ),
              ),
              _QuoteSection(
                title: 'Labor',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: _dec('Programming (hrs)'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => _patch({
                              'programming_hours': v.isEmpty ? null : v,
                            }),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: _dec('Setup (hrs)'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => _patch({'setup_hours': v.isEmpty ? null : v}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: _dec('First run (hrs)'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) =>
                                _patch({'first_run_hours': v.isEmpty ? null : v}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: _dec('Production total (hrs)'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => _patch({
                              'production_hours_total': v.isEmpty ? null : v,
                            }),
                          ),
                        ),
                      ],
                    ),
                    if (calc != null && calc['labor_cost'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '→ Labor total: \$${formatQuoteMoney(_num(calc['labor_cost']))}',
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        ),
                      ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: _dec('Note'),
                      maxLines: 2,
                      controller: TextEditingController(text: _str(item['labor_note'])),
                      onChanged: (v) => _patch({'labor_note': v}),
                    ),
                  ],
                ),
              ),
              _QuoteSection(
                title: 'Subcontractors',
                child: Column(
                  children: [
                    _subcontractorBlock(item, 1, supplierDropdown),
                    const SizedBox(height: 12),
                    _subcontractorBlock(item, 2, supplierDropdown),
                    if (calc != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '→ Subcontractor total: \$${formatQuoteMoney(_num(calc['subcontractor_1_total']) + _num(calc['subcontractor_2_total']))}',
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ),
              _QuoteSection(
                title: 'Post-processing',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: _dec('Inspection'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) =>
                                _patch({'inspection_cost': _dollarFromInput(v) ?? ''}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            decoration: _dec('Packaging'),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) =>
                                _patch({'packaging_cost': _dollarFromInput(v) ?? ''}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: _dec('Shipping'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (v) =>
                          _patch({'shipping_cost': _dollarFromInput(v) ?? ''}),
                    ),
                  ],
                ),
              ),
              _QuoteSection(
                title: 'Reference',
                child: TextField(
                  decoration: _dec('Previous quote reference'),
                  controller: TextEditingController(
                    text: _str(item['previous_quote_reference']),
                  ),
                  onChanged: (v) => _patch({'previous_quote_reference': v}),
                ),
              ),
            ],
            const Divider(height: 24),
            if (calc != null) ...[
              Text(
                'Total (CAD): \$${formatQuoteMoney(_num(calc['line_total_cad']))}',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                'Per part (CAD): \$${formatQuoteMoney(_num(calc['price_per_part_cad']))} | '
                'Per part (USD): \$${formatQuoteMoney(_num(calc['price_per_part_usd']))}',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                'Quoted per part (CAD): \$${formatQuoteMoney(_num(calc['quoted_price_per_part_cad']))} | '
                'Quoted per part (USD): \$${formatQuoteMoney(_num(calc['quoted_price_per_part_usd']))}',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                if (widget.onAddPart != null)
                  OutlinedButton(
                    onPressed: widget.onAddPart,
                    child: const Text('Add part'),
                  ),
                if (widget.onDuplicate != null)
                  OutlinedButton(
                    onPressed: widget.onDuplicate,
                    child: const Text('Duplicate part'),
                  ),
                OutlinedButton(
                  onPressed: widget.onDelete,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete part'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialCadField(Map<String, dynamic>? calc) {
    final item = widget.lineItem;
    final markup = calc?['material_with_markup'];
    final label = markup != null
        ? 'Actual cost (CAD) (Markup cost (CAD): \$${formatQuoteMoney(_num(markup))})'
        : 'Actual cost (CAD)';

    final usdSet = item['usd_cost'] != null &&
        item['usd_cost'] != '' &&
        item['usd_cost'] != 0;
    final cadEmpty = item['material_cost_cad'] == null ||
        item['material_cost_cad'] == '' ||
        item['material_cost_cad'] == 0;

    dynamic display;
    if (usdSet && cadEmpty && calc?['material_actual_cost_cad'] != null) {
      display = calc!['material_actual_cost_cad'];
    } else if (item['material_cost_cad'] != null &&
        item['material_cost_cad'] != '' &&
        item['material_cost_cad'] != 0) {
      display = item['material_cost_cad'];
    } else {
      display = '';
    }

    return TextFormField(
      initialValue: display == '' ? '' : '$display',
      decoration: _dec(label),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (v) {
        if (v.trim().isEmpty) {
          _patch({'material_cost_cad': null});
        } else {
          final n = double.tryParse(v);
          if (n != null) _patch({'material_cost_cad': quoteRound2(n)});
        }
      },
    );
  }

  Widget _subcontractorBlock(
    Map<String, dynamic> item,
    int n,
    Widget Function(String field, String label) supplierDropdown,
  ) {
    final prefix = 'subcontractor_$n';
    return Column(
      children: [
        supplierDropdown(prefix, 'Subcontractor $n'),
        const SizedBox(height: 8),
        TextField(
          decoration: _dec('Service'),
          controller: TextEditingController(text: _str(item['${prefix}_service'])),
          onChanged: (v) => _patch({'${prefix}_service': v}),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: _dec('Cost'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => _patch({'${prefix}_cost': _dollarFromInput(v) ?? ''}),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: _dec('Shipping'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) =>
                    _patch({'${prefix}_shipping': _dollarFromInput(v) ?? ''}),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String? _relationId(dynamic v) {
    if (v == null || v.toString().isEmpty) return null;
    if (v is String) return v;
    if (v is Map && v['id'] != null) return v['id'].toString();
    return v.toString();
  }

  double _num(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }
}

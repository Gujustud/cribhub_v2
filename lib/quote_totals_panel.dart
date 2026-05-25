import 'package:flutter/material.dart';
import 'quote_calculations.dart';
import 'quote_sidebar.dart';

/// Right-sidebar quote totals (DharmaCore `QuoteTotals.jsx`).
class QuoteTotalsPanel extends StatelessWidget {
  final Map<String, dynamic> quote;

  const QuoteTotalsPanel({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final materialsTotal = _num(quote['materials_total']);
    final toolingTotal = _num(quote['tooling_total']);
    final laborTotal = _num(quote['labor_total']);
    final subcontractorTotal = _num(quote['subcontractor_total']);
    final subtotal = _num(quote['subtotal']);
    final finalMarkupPercent = _num(quote['final_markup_percent']);
    final finalTotalCad = _num(quote['final_total_cad']);
    final finalTotalUsd = _num(quote['final_total_usd']);

    final markupAmount = subtotal * (finalMarkupPercent / 100);
    final directCostCad = materialsTotal + toolingTotal + subcontractorTotal;
    final marginPercent = finalTotalCad > 0 && finalTotalCad > directCostCad
        ? ((finalTotalCad - directCostCad) / finalTotalCad) * 100
        : 0.0;

    final titleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF111827);

    return QuoteSidebarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'QUOTE TOTALS',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          _row(context, 'Materials', materialsTotal),
          _row(context, 'Tooling', toolingTotal),
          _row(context, 'Labor', laborTotal),
          _row(context, 'Subcontractors', subcontractorTotal),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _row(context, 'Subtotal', subtotal, bold: true),
          if (finalMarkupPercent > 0)
            _row(
              context,
              'Final Markup (${finalMarkupPercent.toStringAsFixed(0)}%)',
              markupAmount,
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _row(context, 'TOTAL (CAD)', finalTotalCad, bold: true),
          const SizedBox(height: 4),
          _row(context, 'TOTAL (USD)', finalTotalUsd),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Divider(height: 1),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'REVENUE',
                  style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                ),
                Flexible(
                  child: Text(
                    '(${formatQuoteMoney(marginPercent)}% margin) '
                    '\$${formatQuoteMoney(finalTotalCad)}',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _num(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }

  Widget _row(
    BuildContext context,
    String label,
    double amount, {
    bool bold = false,
  }) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFD1D5DB)
        : const Color(0xFF4B5563);
    final strong = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF111827);
    final style = TextStyle(
      fontSize: 14,
      fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
      color: bold ? strong : muted,
    );
    final valueStyle = TextStyle(
      fontSize: 14,
      fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
      color: strong,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${formatQuoteMoney(amount)}', style: valueStyle),
        ],
      ),
    );
  }
}

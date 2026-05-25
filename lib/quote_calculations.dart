// Quote and line item calculations (ported from DharmaCore calculations.js).

double? quoteRound2(num? n) {
  if (n == null) return null;
  final v = n.toDouble();
  if (v.isNaN) return null;
  return (v * 100).roundToDouble() / 100;
}

double _num(dynamic v, [double fallback = 0]) {
  if (v == null || v == '') return fallback;
  final n = double.tryParse(v.toString());
  return n ?? fallback;
}

Map<String, dynamic> getQuoteSettings(Map<String, dynamic>? quote) {
  return {
    'exchange_rate_usd_to_cad': quote?['exchange_rate_usd_to_cad'] ?? 1.3,
    'final_markup_percent': quote?['final_markup_percent'] ?? 0,
    'shipping_markup_percent': quote?['shipping_markup_percent'] ?? 30,
    'subcontractor_markup_percent': quote?['subcontractor_markup_percent'] ?? 0,
    'hourly_rate_programming': quote?['hourly_rate_programming'] ?? 350,
    'hourly_rate_setup': quote?['hourly_rate_setup'] ?? 350,
    'hourly_rate_first_run': quote?['hourly_rate_first_run'] ?? 350,
    'hourly_rate_production': quote?['hourly_rate_production'] ?? 269,
  };
}

/// Returns [lineItem] merged with calculated fields.
Map<String, dynamic> calculateLineItem(
  Map<String, dynamic> lineItem,
  Map<String, dynamic> quoteSettings,
) {
  final usdCost = _num(lineItem['usd_cost']);
  final materialCostCadRaw = lineItem['material_cost_cad'];
  final materialShippingCost = _num(lineItem['material_shipping_cost']);
  final testingCost = _num(lineItem['testing_cost']);
  final toolingTotalCost = _num(lineItem['tooling_total_cost']);
  final programmingHours = _num(lineItem['programming_hours']);
  final setupHours = _num(lineItem['setup_hours']);
  final firstRunHours = _num(lineItem['first_run_hours']);
  final productionHoursTotal = _num(lineItem['production_hours_total']);
  final subcontractor1Cost = _num(lineItem['subcontractor_1_cost']);
  final subcontractor1Shipping = _num(lineItem['subcontractor_1_shipping']);
  final subcontractor2Cost = _num(lineItem['subcontractor_2_cost']);
  final subcontractor2Shipping = _num(lineItem['subcontractor_2_shipping']);
  final heatTreatCost = _num(lineItem['heat_treat_cost']);
  final inspectionCost = _num(lineItem['inspection_cost']);
  final packagingCost = _num(lineItem['packaging_cost']);
  final shippingCost = _num(lineItem['shipping_cost']);
  final partQuantity = _num(lineItem['part_quantity'], 1);
  if (partQuantity <= 0) {
    return {...lineItem};
  }

  final exchangeRate = _num(quoteSettings['exchange_rate_usd_to_cad']);
  final finalMarkupPercent = _num(quoteSettings['final_markup_percent']);
  final shippingMarkupPercent = _num(quoteSettings['shipping_markup_percent']);
  final subcontractorMarkupPercent = _num(quoteSettings['subcontractor_markup_percent']);
  final hourlyProgramming = _num(quoteSettings['hourly_rate_programming']);
  final hourlySetup = _num(quoteSettings['hourly_rate_setup']);
  final hourlyFirstRun = _num(quoteSettings['hourly_rate_first_run']);
  final hourlyProduction = _num(quoteSettings['hourly_rate_production']);

  double? manualCad;
  if (materialCostCadRaw != null && materialCostCadRaw != '') {
    final n = double.tryParse(materialCostCadRaw.toString());
    if (n != null && !n.isNaN) manualCad = n;
  }
  final materialActualCostCad =
      manualCad ?? (usdCost * exchangeRate);

  final materialWithMarkup = (testingCost + materialActualCostCad) *
          (1 + shippingMarkupPercent / 100) +
      materialShippingCost;

  final toolingTotal = toolingTotalCost;

  final laborCost = programmingHours * hourlyProgramming +
      setupHours * hourlySetup +
      firstRunHours * hourlyFirstRun +
      productionHoursTotal * hourlyProduction;

  final sub1Base = subcontractor1Cost + subcontractor1Shipping;
  final sub2Base = subcontractor2Cost + subcontractor2Shipping;
  final subcontractor1Total = sub1Base * (1 + subcontractorMarkupPercent / 100);
  final subcontractor2Total = sub2Base * (1 + subcontractorMarkupPercent / 100);

  final lineTotalCad = materialWithMarkup +
      toolingTotal +
      laborCost +
      subcontractor1Total +
      subcontractor2Total +
      heatTreatCost +
      inspectionCost +
      packagingCost +
      shippingCost;

  final pricePerPartCad = partQuantity > 0 ? lineTotalCad / partQuantity : 0.0;
  final pricePerPartUsd =
      exchangeRate > 0 ? pricePerPartCad / exchangeRate : 0.0;

  double? overrideCad;
  final qpp = lineItem['quote_part_price_cad'];
  if (qpp != null && qpp != '') {
    final n = double.tryParse(qpp.toString());
    if (n != null && !n.isNaN && n >= 0) overrideCad = n;
  }
  final quotedPricePerPartCad = overrideCad ??
      pricePerPartCad * (1 + finalMarkupPercent / 100);
  final quotedPricePerPartUsd =
      exchangeRate > 0 ? quotedPricePerPartCad / exchangeRate : 0.0;

  return {
    ...lineItem,
    'material_actual_cost_cad': quoteRound2(materialActualCostCad),
    'material_with_markup': quoteRound2(materialWithMarkup),
    'labor_cost': quoteRound2(laborCost),
    'subcontractor_1_total': quoteRound2(subcontractor1Total),
    'subcontractor_2_total': quoteRound2(subcontractor2Total),
    'line_total_cad': quoteRound2(lineTotalCad),
    'price_per_part_cad': quoteRound2(pricePerPartCad),
    'price_per_part_usd': quoteRound2(pricePerPartUsd),
    'quoted_price_per_part_cad': quoteRound2(quotedPricePerPartCad),
    'quoted_price_per_part_usd': quoteRound2(quotedPricePerPartUsd),
  };
}

Map<String, dynamic> calculateQuoteTotals(
  Map<String, dynamic> quote,
  List<Map<String, dynamic>> lineItems,
) {
  final exchangeRate = _num(quote['exchange_rate_usd_to_cad']);

  double sumMaterials() => lineItems.fold(0.0, (s, i) => s + _num(i['material_with_markup']));
  double sumTooling() => lineItems.fold(0.0, (s, i) => s + _num(i['tooling_total_cost']));
  double sumLabor() => lineItems.fold(0.0, (s, i) => s + _num(i['labor_cost']));
  double sumSubcontractors() => lineItems.fold(
        0.0,
        (s, i) => s + _num(i['subcontractor_1_total']) + _num(i['subcontractor_2_total']),
      );
  double sumSubtotal() => lineItems.fold(0.0, (s, i) => s + _num(i['line_total_cad']));
  double sumFinalCad() => lineItems.fold(
        0.0,
        (s, i) =>
            s +
            _num(i['quoted_price_per_part_cad']) * _num(i['part_quantity'], 1),
      );

  final finalTotalCad = quoteRound2(sumFinalCad()) ?? 0;
  final finalTotalUsd = quoteRound2(
        exchangeRate > 0 ? finalTotalCad / exchangeRate : 0,
      ) ??
      0;

  return {
    ...quote,
    'materials_total': quoteRound2(sumMaterials()),
    'tooling_total': quoteRound2(sumTooling()),
    'labor_total': quoteRound2(sumLabor()),
    'subcontractor_total': quoteRound2(sumSubcontractors()),
    'subtotal': quoteRound2(sumSubtotal()),
    'final_total_cad': finalTotalCad,
    'final_total_usd': finalTotalUsd,
  };
}

String generateJobNumber([DateTime? date]) {
  final d = date ?? DateTime.now();
  final month = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  final year = d.year.toString();
  return '$month$day$year';
}

String generatePartsDescription(List<Map<String, dynamic>> lineItems) {
  if (lineItems.isEmpty) return '';
  return lineItems.map((item) {
    final partNum = '${item['part_number'] ?? ''}'.trim();
    final label = partNum.isEmpty ? 'Unnamed Part' : partNum;
    final qty = item['part_quantity'] ?? 1;
    return '• $label (qty $qty)';
  }).join('\n');
}

String formatQuoteMoney(num? n) {
  final v = (n ?? 0).toDouble();
  return v.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

/// Shop ERP quote defaults (PocketBase `settings` collection — DharmaCore parity).

Map<String, dynamic> defaultShopSettingsBody() => {
      'default_shipping_markup_percent': 30,
      'default_final_markup_percent': 0,
      'default_hourly_rate_programming': 350,
      'default_hourly_rate_setup': 350,
      'default_hourly_rate_first_run': 350,
      'default_hourly_rate_production': 269,
      'exchange_rate_usd_to_cad': 1.3,
      'exchange_rate_auto_update': false,
      'auto_logout_minutes': 0,
    };

double _shopNum(dynamic v, double fallback) {
  if (v == null || v == '') return fallback;
  final n = double.tryParse(v.toString());
  return n ?? fallback;
}

/// Fields for a new quote record from shop `settings` row data.
Map<String, dynamic> newQuoteFieldsFromShopSettings(Map<String, dynamic>? shop) {
  final d = shop ?? {};
  return {
    'shipping_markup_percent': _shopNum(d['default_shipping_markup_percent'], 30),
    'final_markup_percent': _shopNum(d['default_final_markup_percent'], 0),
    'subcontractor_markup_percent': 0,
    'exchange_rate_usd_to_cad': _shopNum(d['exchange_rate_usd_to_cad'], 1.3),
    'hourly_rate_programming': _shopNum(d['default_hourly_rate_programming'], 350),
    'hourly_rate_setup': _shopNum(d['default_hourly_rate_setup'], 350),
    'hourly_rate_first_run': _shopNum(d['default_hourly_rate_first_run'], 350),
    'hourly_rate_production': _shopNum(d['default_hourly_rate_production'], 269),
  };
}

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Bank of Canada USD→CAD rate (same source as DharmaCore).
Future<double?> fetchUsdCadExchangeRate() async {
  try {
    final res = await http.get(
      Uri.parse(
        'https://www.bankofcanada.ca/valet/observations/FXUSDCAD/json?recent=1',
      ),
    );
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final observations = data['observations'] as List<dynamic>?;
    if (observations == null || observations.isEmpty) return null;
    final fx = observations.first['FXUSDCAD'] as Map<String, dynamic>?;
    final v = fx?['v'];
    if (v == null) return null;
    return double.tryParse(v.toString());
  } catch (_) {
    return null;
  }
}

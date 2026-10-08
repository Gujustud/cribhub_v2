import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';

/// Column types supported by wiki tables.
const kWikiTableColumnTypes = [
  'text',
  'number',
  'checkbox',
  'date',
  'formula',
];

class WikiTableColumn {
  final String id;
  final String name;
  final String type;
  /// For [type] == formula: expression using other column ids, e.g. `c1-c2`.
  final String? formula;

  const WikiTableColumn({
    required this.id,
    required this.name,
    required this.type,
    this.formula,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        if (formula != null && formula!.trim().isNotEmpty) 'formula': formula,
      };

  factory WikiTableColumn.fromJson(Map<String, dynamic> json) {
    return WikiTableColumn(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      type: (json['type'] ?? 'text').toString(),
      formula: json['formula']?.toString(),
    );
  }

  WikiTableColumn copyWith({
    String? id,
    String? name,
    String? type,
    String? formula,
  }) {
    return WikiTableColumn(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      formula: formula ?? this.formula,
    );
  }
}

List<WikiTableColumn> parseWikiTableColumns(String? raw) {
  if (raw == null || raw.trim().isEmpty) return [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((e) => WikiTableColumn.fromJson(Map<String, dynamic>.from(e)))
        .where((c) => c.id.isNotEmpty)
        .toList();
  } catch (_) {
    return [];
  }
}

String encodeWikiTableColumns(List<WikiTableColumn> columns) {
  return jsonEncode(columns.map((c) => c.toJson()).toList());
}

Map<String, dynamic> parseWikiTableValues(String? raw) {
  if (raw == null || raw.trim().isEmpty) return {};
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
  } catch (_) {}
  return {};
}

String encodeWikiTableValues(Map<String, dynamic> values) {
  return jsonEncode(values);
}

String wikiTableTitle(RecordModel table) {
  return (table.data['title'] ?? 'Table').toString().trim();
}

String wikiTableEmbedToken(String tableId) => '{{table:$tableId}}';

final _wikiTableEmbedRe = RegExp(r'\{\{table:([a-zA-Z0-9]+)\}\}');

/// Splits wiki markdown into text segments and embedded table ids.
List<WikiBodyPart> splitWikiBodyWithTables(String body) {
  final parts = <WikiBodyPart>[];
  var start = 0;
  for (final m in _wikiTableEmbedRe.allMatches(body)) {
    if (m.start > start) {
      parts.add(WikiBodyPart.text(body.substring(start, m.start)));
    }
    parts.add(WikiBodyPart.table(m.group(1)!));
    start = m.end;
  }
  if (start < body.length) {
    parts.add(WikiBodyPart.text(body.substring(start)));
  }
  if (parts.isEmpty) {
    parts.add(WikiBodyPart.text(body));
  }
  return parts;
}

class WikiBodyPart {
  final String? markdown;
  final String? tableId;

  const WikiBodyPart._({this.markdown, this.tableId});

  factory WikiBodyPart.text(String markdown) =>
      WikiBodyPart._(markdown: markdown);
  factory WikiBodyPart.table(String id) => WikiBodyPart._(tableId: id);

  bool get isTable => tableId != null;
}

/// Evaluate a simple formula over numeric/bool cell values.
/// Supports + - * / ( ), column ids, and numbers. Bool → 1/0.
num? evalWikiTableFormula(
  String expression,
  Map<String, dynamic> values,
) {
  final src = expression.trim();
  if (src.isEmpty) return null;
  try {
    return _WikiFormulaParser(src, values).parse();
  } catch (_) {
    return null;
  }
}

class _WikiFormulaParser {
  _WikiFormulaParser(String src, this.values)
      : tokens = _tokenizeFormula(src);

  final Map<String, dynamic> values;
  final List<String> tokens;
  var i = 0;

  num? parse() {
    final result = _expr();
    if (i != tokens.length) return null;
    return result;
  }

  num? _expr() {
    final first = _term();
    if (first == null) return null;
    var v = first;
    while (i < tokens.length && (tokens[i] == '+' || tokens[i] == '-')) {
      final op = tokens[i++];
      final r = _term();
      if (r == null) return null;
      v = op == '+' ? v + r : v - r;
    }
    return v;
  }

  num? _term() {
    final first = _factor();
    if (first == null) return null;
    var v = first;
    while (i < tokens.length && (tokens[i] == '*' || tokens[i] == '/')) {
      final op = tokens[i++];
      final r = _factor();
      if (r == null) return null;
      if (op == '*') {
        v = v * r;
      } else {
        if (r == 0) return null;
        v = v / r;
      }
    }
    return v;
  }

  num? _factor() {
    if (i >= tokens.length) return null;
    final t = tokens[i];
    if (t == '(') {
      i++;
      final v = _expr();
      if (i >= tokens.length || tokens[i] != ')') return null;
      i++;
      return v;
    }
    if (t == '-') {
      i++;
      final v = _factor();
      return v == null ? null : -v;
    }
    i++;
    final asNum = num.tryParse(t);
    if (asNum != null) return asNum;
    final raw = values[t];
    if (raw == null) return 0;
    if (raw is bool) return raw ? 1 : 0;
    if (raw is num) return raw;
    return num.tryParse(raw.toString()) ?? 0;
  }
}

List<String> _tokenizeFormula(String src) {
  final out = <String>[];
  final re = RegExp(r'[A-Za-z_][A-Za-z0-9_]*|\d+\.?\d*|[+\-*/()]');
  for (final m in re.allMatches(src.replaceAll(' ', ''))) {
    out.add(m.group(0)!);
  }
  return out;
}

dynamic wikiTableCellDisplay(
  WikiTableColumn col,
  Map<String, dynamic> values,
) {
  if (col.type == 'formula') {
    final v = evalWikiTableFormula(col.formula ?? '', values);
    if (v == null) return '';
    if (v == v.roundToDouble()) return v.toInt();
    // Keep a few decimals for calibration-style numbers.
    return num.parse(v.toStringAsFixed(6));
  }
  return values[col.id];
}

String newWikiTableColumnId(List<WikiTableColumn> existing) {
  var n = existing.length + 1;
  while (existing.any((c) => c.id == 'c$n')) {
    n++;
  }
  return 'c$n';
}

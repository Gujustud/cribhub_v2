import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models.dart';
import 'pocketbase_service.dart';

/// One selectable purchase line with heat/lot (+ mill certs).
class MaterialLotPick {
  final String purchaseItemId;
  final String heatLot;
  final String materialLabel;
  final String supplierName;
  final DateTime? purchaseDate;
  final String? supplierId;
  final List<String> millCertNames;
  final dynamic record;

  const MaterialLotPick({
    required this.purchaseItemId,
    required this.heatLot,
    required this.materialLabel,
    required this.supplierName,
    required this.millCertNames,
    required this.record,
    this.purchaseDate,
    this.supplierId,
  });

  String get searchBlob => [
        heatLot,
        materialLabel,
        supplierName,
        if (purchaseDate != null) DateFormat.yMMMd().format(purchaseDate!),
        ...millCertNames,
      ].join(' ').toLowerCase();

  factory MaterialLotPick.fromRecord(dynamic record) {
    final item = PurchaseItem.fromRecord(record);
    final heat = (item.heatLot ?? '').trim();

    String materialLabel = (item.materialLabel ?? '').trim();
    if (materialLabel.isEmpty) {
      try {
        final m = record.expand?['material'];
        final raw = (m is List && m.isNotEmpty) ? m.first : m;
        if (raw != null) {
          materialLabel = ShopMaterial.fromRecord(raw).displayLabel;
        }
      } catch (_) {}
    }

    Map<String, dynamic>? purchaseData;
    Map<String, dynamic>? supplierData;
    String? supplierId;
    try {
      final p = record.expand?['purchase'];
      final purchaseRec = (p is List && p.isNotEmpty) ? p.first : p;
      purchaseData = purchaseRec?.data as Map<String, dynamic>?;
      final s = purchaseRec?.expand?['supplier'];
      final supplierRec = (s is List && s.isNotEmpty) ? s.first : s;
      supplierData = supplierRec?.data as Map<String, dynamic>?;
      supplierId = supplierRec?.id?.toString();
    } catch (_) {}

    DateTime? date;
    final rawDate = purchaseData?['purchase_date'];
    if (rawDate != null) {
      date = DateTime.tryParse(rawDate.toString());
    }

    return MaterialLotPick(
      purchaseItemId: record.id as String,
      heatLot: heat,
      materialLabel: materialLabel.isEmpty ? 'Material' : materialLabel,
      supplierName: (supplierData?['company_name'] ?? '').toString().trim(),
      purchaseDate: date,
      supplierId: supplierId,
      millCertNames: item.millCertNames,
      record: record,
    );
  }
}

/// Searchable dialog: filter by heat/lot, material, or supplier.
Future<MaterialLotPick?> showMaterialLotPicker(
  BuildContext context, {
  String? selectedPurchaseItemId,
}) {
  return showDialog<MaterialLotPick>(
    context: context,
    builder: (ctx) => _MaterialLotPickerDialog(
      selectedPurchaseItemId: selectedPurchaseItemId,
    ),
  );
}

class _MaterialLotPickerDialog extends StatefulWidget {
  final String? selectedPurchaseItemId;

  const _MaterialLotPickerDialog({this.selectedPurchaseItemId});

  @override
  State<_MaterialLotPickerDialog> createState() =>
      _MaterialLotPickerDialogState();
}

class _MaterialLotPickerDialogState extends State<_MaterialLotPickerDialog> {
  final _searchController = TextEditingController();
  List<MaterialLotPick> _all = [];
  List<MaterialLotPick> _filtered = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final records = await PocketBaseService().getMaterialLotsForPicker();
      final picks = <MaterialLotPick>[];
      for (final r in records) {
        final pick = MaterialLotPick.fromRecord(r);
        if (pick.heatLot.isEmpty) continue;
        picks.add(pick);
      }
      if (!mounted) return;
      setState(() {
        _all = picks;
        _applyFilter(_searchController.text);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '$e';
      });
    }
  }

  void _applyFilter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(_all);
      } else {
        _filtered = _all.where((p) => p.searchBlob.contains(q)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select material lot',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search heat/lot, material, or supplier…',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _applyFilter('');
                          },
                        )
                      : null,
                ),
                onChanged: _applyFilter,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Text(
                              'Could not load lots:\n$_error',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: scheme.error),
                            ),
                          )
                        : _filtered.isEmpty
                            ? Center(
                                child: Text(
                                  _all.isEmpty
                                      ? 'No purchase lines with a heat/lot yet.\nAdd heat/lot on a material purchase line first.'
                                      : 'No lots match your search.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: _filtered.length,
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final p = _filtered[index];
                                  final selected =
                                      p.purchaseItemId ==
                                      widget.selectedPurchaseItemId;
                                  final dateText = p.purchaseDate != null
                                      ? DateFormat.yMMMd()
                                          .format(p.purchaseDate!)
                                      : null;
                                  final meta = [
                                    ?dateText,
                                    if (p.supplierName.isNotEmpty)
                                      p.supplierName,
                                  ].join(' · ');
                                  return ListTile(
                                    selected: selected,
                                    leading: Icon(
                                      selected
                                          ? Icons.check_circle
                                          : Icons.qr_code_2_outlined,
                                      color: selected
                                          ? scheme.primary
                                          : scheme.onSurfaceVariant,
                                    ),
                                    title: Text(
                                      p.heatLot,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      [
                                        p.materialLabel,
                                        if (meta.isNotEmpty) meta,
                                        if (p.millCertNames.isNotEmpty)
                                          '${p.millCertNames.length} cert'
                                              '${p.millCertNames.length == 1 ? '' : 's'}',
                                      ].join('\n'),
                                    ),
                                    isThreeLine: true,
                                    onTap: () => Navigator.pop(context, p),
                                  );
                                },
                              ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

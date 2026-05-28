import 'package:flutter/material.dart';

/// Type-to-search supplier picker (PocketBase `suppliers` records).
class SupplierSearchField extends StatelessWidget {
  final List<dynamic> suppliers;
  final String? selectedSupplierId;
  final String? selectedLabelFallback;
  final ValueChanged<String?> onSupplierSelected;
  final InputDecoration decoration;
  final String noneOptionLabel;

  const SupplierSearchField({
    super.key,
    required this.suppliers,
    required this.selectedSupplierId,
    required this.onSupplierSelected,
    required this.decoration,
    this.selectedLabelFallback,
    this.noneOptionLabel = '— None —',
  });

  static String labelFor(dynamic supplier) {
    final data = supplier.data as Map<String, dynamic>? ?? {};
    final name = '${data['company_name'] ?? ''}'.trim();
    if (name.isNotEmpty) return name;
    return supplier.id.toString();
  }

  String _displayForSelected() {
    if (selectedSupplierId == null) return '';
    for (final s in suppliers) {
      if (s.id == selectedSupplierId) return labelFor(s);
    }
    return selectedLabelFallback ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<_SupplierOption>(
      key: ValueKey('supplier_search_$selectedSupplierId'),
      initialValue: TextEditingValue(text: _displayForSelected()),
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        final Iterable<dynamic> matches = query.isEmpty
            ? suppliers
            : suppliers.where((s) => labelFor(s).toLowerCase().contains(query));
        return [
          _SupplierOption.none(noneOptionLabel),
          ...matches.map(_SupplierOption.supplier),
        ];
      },
      displayStringForOption: (opt) => opt.display,
      onSelected: (opt) {
        if (opt.isNone) {
          onSupplierSelected(null);
        } else {
          onSupplierSelected(opt.supplier!.id as String);
        }
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: const TextStyle(fontSize: 14),
          decoration: decoration.copyWith(
            hintText: 'Search suppliers…',
            suffixIcon: const Icon(Icons.search, size: 20),
          ),
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260, minWidth: 220),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final opt = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    title: Text(opt.display, style: const TextStyle(fontSize: 14)),
                    onTap: () => onSelected(opt),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SupplierOption {
  final String display;
  final dynamic supplier;
  final bool isNone;

  const _SupplierOption._({
    required this.display,
    this.supplier,
    this.isNone = false,
  });

  factory _SupplierOption.none(String label) =>
      _SupplierOption._(display: label, isNone: true);

  factory _SupplierOption.supplier(dynamic s) =>
      _SupplierOption._(display: SupplierSearchField.labelFor(s), supplier: s);
}

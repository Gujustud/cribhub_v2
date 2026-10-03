import 'package:flutter/material.dart';

/// Shared height for list-toolbar search fields and [InventoryListActionButton].
/// See SHOP_NEXT.md → Workspace layout tokens.
const double kListToolbarControlHeight = 48;

/// Search field styling shared with inventory list pages.
/// Pair with a [SizedBox] height of [kListToolbarControlHeight], or use
/// [InventoryListSearchField].
InputDecoration inventoryListSearchDecoration(
  BuildContext context, {
  required String hintText,
}) {
  return InputDecoration(
    hintText: hintText,
    isDense: true,
    prefixIcon: const Icon(Icons.search, size: 20),
    prefixIconConstraints: const BoxConstraints(
      minWidth: kListToolbarControlHeight,
      minHeight: kListToolbarControlHeight,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
  );
}

/// Clear (X) control for list search fields — same height as the field.
Widget inventoryListSearchClearButton({required VoidCallback onPressed}) {
  return IconButton(
    tooltip: 'Clear',
    onPressed: onPressed,
    icon: const Icon(Icons.clear, size: 20),
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(
      minWidth: kListToolbarControlHeight,
      minHeight: kListToolbarControlHeight,
    ),
    visualDensity: VisualDensity.standard,
    splashRadius: 20,
  );
}

/// Search [TextField] locked to [kListToolbarControlHeight].
class InventoryListSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final InputDecoration? decoration;
  final bool enabled;

  const InventoryListSearchField({
    super.key,
    this.controller,
    this.onChanged,
    required this.hintText,
    this.decoration,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kListToolbarControlHeight,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        enabled: enabled,
        style: const TextStyle(fontSize: 14, height: 1.2),
        decoration: decoration ??
            inventoryListSearchDecoration(context, hintText: hintText),
      ),
    );
  }
}

/// Primary action button (Add Tool, New Quote, New Job, etc.).
/// Matches [kListToolbarControlHeight] so it lines up with search fields.
class InventoryListActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const InventoryListActionButton({
    super.key,
    required this.label,
    this.icon = Icons.add,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: kListToolbarControlHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, kListToolbarControlHeight),
          maximumSize: const Size(double.infinity, kListToolbarControlHeight),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 14, height: 1.2)),
          ],
        ),
      ),
    );
  }
}

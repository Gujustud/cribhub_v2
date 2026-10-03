import 'package:flutter/material.dart';
/// DharmaCore quote right sidebar (cards, compact fields, actions).

class QuoteSidebarTheme {
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  /// Theme-aware primary for call sites that previously used a fixed gradient color.
  static Color primaryFrom(BuildContext context) => primary(context);
  static BoxDecoration cardDecoration(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? scheme.surfaceContainerHighest : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: scheme.outlineVariant),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
    );
  }
  static InputDecoration fieldDecoration(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: isDark ? scheme.surfaceContainerHighest : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.outline, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.outline, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    );
  }
}

class QuoteSidebarCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const QuoteSidebarCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: QuoteSidebarTheme.cardDecoration(context),
      padding: padding,
      child: child,
    );
  }
}

/// Label above input (DharmaCore `Input.jsx` style).

class QuoteSidebarField extends StatelessWidget {
  final String label;
  final String? value;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  const QuoteSidebarField({
    super.key,
    required this.label,
    this.value,
    this.controller,
    this.onChanged,
    this.keyboardType,
  }) : assert(
          controller != null || (value != null && onChanged != null),
          'Provide controller or both value and onChanged',
        );
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? value : null,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: QuoteSidebarTheme.fieldDecoration(context),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class QuoteSidebarPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  const QuoteSidebarPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    return Material(
      color: enabled ? scheme.primary : scheme.outline,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.onPrimary,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: enabled
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Compact row action (View / Copy / Delete on quotes table).

class QuoteTableActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool danger;
  const QuoteTableActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.danger = false,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: scheme.outline),
        backgroundColor: scheme.surfaceContainerHighest,
        foregroundColor: danger ? scheme.error : scheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class QuoteSidebarSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const QuoteSidebarSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: scheme.outline, width: 1.5),
        backgroundColor: scheme.surfaceContainerHighest,
        foregroundColor: scheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }
}

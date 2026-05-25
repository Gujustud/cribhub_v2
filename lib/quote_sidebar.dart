import 'package:flutter/material.dart';

/// DharmaCore-aligned quote right sidebar (cards, compact fields, actions).
class QuoteSidebarTheme {
  static const Color primaryFrom = Color(0xFF667EEA);
  static const Color primaryTo = Color(0xFF764BA2);

  static BoxDecoration cardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
      ),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
    );
  }

  static InputDecoration fieldDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB);
    final fill = isDark ? const Color(0xFF374151) : Colors.white;
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryFrom, width: 2),
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
  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  const QuoteSidebarField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFD1D5DB)
        : const Color(0xFF374151);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: onPressed == null
            ? null
            : const LinearGradient(
                colors: [QuoteSidebarTheme.primaryFrom, QuoteSidebarTheme.primaryTo],
              ),
        color: onPressed == null ? Colors.grey.shade400 : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF),
        ),
        backgroundColor: isDark ? const Color(0xFF6B7280) : const Color(0xFFE5E7EB),
        foregroundColor: danger
            ? (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626))
            : (isDark ? Colors.white : const Color(0xFF1F2937)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF),
          width: 1.5,
        ),
        backgroundColor: isDark ? const Color(0xFF6B7280) : const Color(0xFFE5E7EB),
        foregroundColor: isDark ? Colors.white : const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }
}

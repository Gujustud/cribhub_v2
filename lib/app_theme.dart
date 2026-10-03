import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Named visual skins for DharmaCore (theme tokens, not a UI-kit rewrite).
enum AppSkin {
  /// Charcoal / zinc surfaces + amber safety accent (shop-floor default).
  graphite,

  /// Zinc surfaces + steel-blue primary (clean ops).
  precision,

  /// Zinc surfaces + teal primary.
  mint,
}

extension AppSkinLabel on AppSkin {
  String get label {
    switch (this) {
      case AppSkin.graphite:
        return 'Machine Shop Graphite';
      case AppSkin.precision:
        return 'Precision Cool';
      case AppSkin.mint:
        return 'Cool Mint';
    }
  }

  String get subtitle {
    switch (this) {
      case AppSkin.graphite:
        return 'Zinc chrome, amber accent';
      case AppSkin.precision:
        return 'Zinc chrome, steel blue accent';
      case AppSkin.mint:
        return 'Zinc chrome, teal accent';
    }
  }
}

/// Builds Material 3 [ThemeData] tuned toward a shadcn-like look:
/// flat surfaces, 1px borders, outline inputs, no elevation chrome.
class AppTheme {
  AppTheme._();

  static const _radius = 8.0;

  static ThemeData of(AppSkin skin, Brightness brightness) {
    switch (skin) {
      case AppSkin.graphite:
        return _build(_zincScheme(brightness, accent: const Color(0xFFD97706)));
      case AppSkin.precision:
        return _build(_zincScheme(brightness, accent: const Color(0xFF3B82A0)));
      case AppSkin.mint:
        return _build(_zincScheme(brightness, accent: const Color(0xFF0D9488)));
    }
  }

  /// Shared zinc/slate neutrals; only [accent] changes per skin.
  static ColorScheme _zincScheme(
    Brightness brightness, {
    required Color accent,
  }) {
    final isDark = brightness == Brightness.dark;
    return ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.white,
      primaryContainer:
          isDark ? _mix(accent, const Color(0xFF09090B), 0.55) : _mix(accent, Colors.white, 0.82),
      onPrimaryContainer:
          isDark ? _mix(accent, Colors.white, 0.75) : _mix(accent, const Color(0xFF09090B), 0.55),
      secondary: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
      onSecondary: isDark ? const Color(0xFF09090B) : Colors.white,
      secondaryContainer: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
      onSecondaryContainer: isDark ? const Color(0xFFE4E4E7) : const Color(0xFF3F3F46),
      tertiary: isDark ? const Color(0xFF71717A) : const Color(0xFF52525B),
      onTertiary: Colors.white,
      error: const Color(0xFFDC2626),
      onError: Colors.white,
      errorContainer: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2),
      onErrorContainer: isDark ? const Color(0xFFFECACA) : const Color(0xFF7F1D1D),
      surface: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      onSurface: isDark ? const Color(0xFFFAFAFA) : const Color(0xFF09090B),
      surfaceContainerLowest: isDark ? const Color(0xFF09090B) : Colors.white,
      surfaceContainerLow: isDark ? const Color(0xFF0C0C0E) : const Color(0xFFFFFFFF),
      surfaceContainer: isDark ? const Color(0xFF18181B) : Colors.white,
      surfaceContainerHigh: isDark ? const Color(0xFF1C1C1F) : const Color(0xFFF4F4F5),
      surfaceContainerHighest: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
      onSurfaceVariant: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
      outline: isDark ? const Color(0xFF3F3F46) : const Color(0xFFE4E4E7),
      outlineVariant: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? const Color(0xFFFAFAFA) : const Color(0xFF18181B),
      onInverseSurface: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      // Older screens still pass inversePrimary on AppBars — match surface for flat chrome.
      inversePrimary: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
    );
  }

  static Color _mix(Color a, Color b, double t) {
    return Color.lerp(a, b, t)!;
  }

  static ThemeData _build(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(_radius);
    final cardColor = isDark ? scheme.surfaceContainer : Colors.white;
    final baseText = ThemeData(brightness: scheme.brightness).textTheme;
    final textTheme = GoogleFonts.interTextTheme(baseText).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    final thinBorder = BorderSide(color: scheme.outline);
    final outlineInput = OutlineInputBorder(
      borderRadius: radius,
      borderSide: thinBorder,
    );
    final focusedInput = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.primary, width: 1.5),
    );
    final errorInput = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.error, width: 1.5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      splashFactory: InkRipple.splashFactory,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface, size: 22),
        actionsIconTheme: IconThemeData(color: scheme.onSurface, size: 22),
        shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: thinBorder,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: thinBorder,
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        showDragHandle: true,
        dragHandleColor: scheme.outline,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: cardColor,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
        floatingLabelStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: outlineInput,
        enabledBorder: outlineInput,
        disabledBorder: outlineInput.copyWith(
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: focusedInput,
        errorBorder: errorInput,
        focusedErrorBorder: errorInput,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.secondaryContainer,
          disabledForegroundColor: scheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(64, 36),
          tapTargetSize: MaterialTapTargetSize.padded,
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.secondaryContainer,
          disabledForegroundColor: scheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(64, 36),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: scheme.onSurface,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: scheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(64, 36),
          side: thinBorder,
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(48, 32),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurface,
          disabledForegroundColor: scheme.onSurfaceVariant,
          hoverColor: scheme.secondaryContainer,
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.secondaryContainer,
        selectedColor: scheme.primaryContainer,
        disabledColor: scheme.secondaryContainer,
        labelStyle: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
        secondaryLabelStyle:
            textTheme.labelMedium?.copyWith(color: scheme.onSurface),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: thinBorder,
        ),
        side: thinBorder,
        showCheckmark: false,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: radius),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: cardColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: thinBorder,
        ),
        textStyle: textTheme.bodyMedium,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          fillColor: cardColor,
          border: outlineInput,
          enabledBorder: outlineInput,
          focusedBorder: focusedInput,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(cardColor),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: radius, side: thinBorder),
          ),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(cardColor),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: radius, side: thinBorder),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: scheme.outline),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: scheme.onInverseSurface),
        waitDuration: const Duration(milliseconds: 400),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: scheme.outline, width: 1.5),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(scheme.onPrimary),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.outline;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.onPrimary;
          return scheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.secondaryContainer;
        }),
        trackOutlineColor: WidgetStatePropertyAll(scheme.outline),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.secondaryContainer,
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: scheme.outlineVariant,
        indicatorColor: scheme.primary,
        labelColor: scheme.onSurface,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(scheme.secondaryContainer),
        dividerThickness: 1,
        headingTextStyle: textTheme.labelLarge?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        dataTextStyle: textTheme.bodyMedium,
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outline),
          borderRadius: radius,
        ),
      ),
    );
  }
}

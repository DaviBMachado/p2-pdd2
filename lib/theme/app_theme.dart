import 'package:flutter/material.dart';

/// Paleta de cores usada em todo o aplicativo.
abstract final class AppColors {
  static const Color background = Color(0xFFF4EBD8);
  static const Color surface = Color(0xFFFFF9ED);
  static const Color secondary = Color(0xFFE8D7B5);
  static const Color primary = Color(0xFFD96C3B);
  static const Color accent = Color(0xFF68734B);
  static const Color text = Color(0xFF293B35);
  static const Color border = Color(0xFFB8A98E);
}

/// Tokens de espaçamento, estilos compartilhados e tema Material 3 do app.
abstract final class AppTheme {
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double radiusMd = 10.0;
  static const double radiusLg = 12.0;

  static final BoxDecoration paperCardDecoration = BoxDecoration(
    color: AppColors.surface,
    border: Border.all(color: AppColors.border),
    borderRadius: BorderRadius.circular(radiusLg),
  );

  static final ButtonStyle solidRetroButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.surface,
    elevation: 0,
    minimumSize: const Size(48, 48),
    padding: const EdgeInsets.symmetric(horizontal: spacingMd, vertical: spacingSm),
    textStyle: const TextStyle(
      fontFamily: 'DMSans',
      fontWeight: FontWeight.w700,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
  );

  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.surface,
    secondary: AppColors.secondary,
    onSecondary: AppColors.text,
    tertiary: AppColors.accent,
    onTertiary: AppColors.surface,
    error: AppColors.primary,
    onError: AppColors.surface,
    surface: AppColors.surface,
    onSurface: AppColors.text,
    outline: AppColors.border,
    surfaceContainerHighest: AppColors.secondary,
  );

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700, color: AppColors.text),
    displayMedium: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700, color: AppColors.text),
    displaySmall: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700, color: AppColors.text),
    headlineLarge: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700, color: AppColors.text),
    headlineMedium: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700, color: AppColors.text),
    headlineSmall: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700, color: AppColors.text),
    titleLarge: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700, color: AppColors.text),
    titleMedium: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w500, color: AppColors.text),
    titleSmall: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w500, color: AppColors.text),
    bodyLarge: TextStyle(fontFamily: 'DMSans', fontWeight: FontWeight.w400, color: AppColors.text),
    bodyMedium: TextStyle(fontFamily: 'DMSans', fontWeight: FontWeight.w400, color: AppColors.text),
    bodySmall: TextStyle(fontFamily: 'DMSans', fontWeight: FontWeight.w400, color: AppColors.text),
    labelLarge: TextStyle(fontFamily: 'DMSans', fontWeight: FontWeight.w700, color: AppColors.text),
    labelMedium: TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.w700, color: AppColors.text),
    labelSmall: TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.w400, color: AppColors.text),
  );

  /// Tema principal aplicado ao [MaterialApp].
  static ThemeData get retroAnalog {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: _colorScheme,
      textTheme: _textTheme,
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: spacingSm / 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: solidRetroButtonStyle),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingSm * 1.5,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'DMSans',
          color: AppColors.text,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'DMSans',
          color: AppColors.text,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      appBarTheme: const AppBarThemeData(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'BricolageGrotesque',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.text,
        contentTextStyle: const TextStyle(
          fontFamily: 'DMSans',
          color: AppColors.surface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
    );
  }
}

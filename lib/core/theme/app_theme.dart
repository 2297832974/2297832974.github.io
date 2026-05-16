import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const background = Color(0xFFFAFAFB);
    const panel = Colors.white;
    const border = Color(0xFFE5E5E8);
    const accent = Color(0xFF3A63F3);
    const text = Color(0xFF20232B);
    const muted = Color(0xFF7B8190);

    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
    ).copyWith(
      primary: accent,
      surface: panel,
      outline: border,
      onSurface: text,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Montserrat',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: text),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: muted),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: muted,
        ),
      ),
    );
  }

  static ThemeData dark() {
    const background = Color(0xFF07070A);
    const panel = Color(0xFF11131A);
    const border = Color(0xFF232634);
    const accent = Color(0xFF5865F2);
    const text = Color(0xFFF4F7FB);
    const muted = Color(0xFF9CA3B7);

    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
    ).copyWith(
      primary: accent,
      surface: panel,
      outline: border,
      onSurface: text,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Montserrat',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: text),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: muted),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: muted,
        ),
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: border),
        ),
      ),
    );
  }
}

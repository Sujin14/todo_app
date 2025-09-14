import 'package:flutter/material.dart';

// Theme configuration for the app.
class AppTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E6F9F),
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF1A1A1A),
          onSurface: Colors.white,
          secondary: Colors.green,
          onSecondary: Colors.black,
          tertiary: Colors.orange,
          onTertiary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      elevation: 0.5,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2D2D2D),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3D3D3D)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    cardTheme: CardThemeData(
      color: const Color(0xFF2D2D2D),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xFF1E6F9F),
    ),
  );
}

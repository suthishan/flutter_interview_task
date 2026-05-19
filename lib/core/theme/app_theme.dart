import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF1A3C6E);
  static const secondaryColor = Color(0xFFE87722);
  static const surfaceColor = Color(0xFFF5F5F5);
  static const errorColor = Color(0xFFC62828);
  static const successColor = Color(0xFF2E7D32);
  static const warningColor = Color(0xFFF9A825);
  static const onPrimaryColor = Color(0xFFFFFFFF);
  static const leadHotColor = Color(0xFFB71C1C);
  static const leadWarmColor = Color(0xFFE65100);
  static const leadColdColor = Color(0xFF1565C0);
  static const segmentPoultry = Color(0xFFE65100);
  static const segmentAqua = Color(0xFF0277BD);
  static const segmentCattle = Color(0xFF2E7D32);
  static const segmentPig = Color(0xFF6A1B9A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: onPrimaryColor,
      ),
      scaffoldBackgroundColor: surfaceColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
        ),
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

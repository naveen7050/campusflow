import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Light Theme Palette (Design Specification)
  static const Color primary = Color(0xFF0F5132);
  static const Color secondary = Color(0xFF2E7D32);
  static const Color background = Color(0xFFEBF5E9);
  static const Color text = Color(0xFF1F2937);
  static const Color surface = Color(0xFFF1F5F9);

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightAccent = Color(0xFF0F5132);
  static const Color lightAccentSubtle = Color(0xFFEBF5E9);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightSecondarySurface = Color(0xFFF3F4F6);

  // Dark Theme Palette (Clean Neutral Dark)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
  static const Color darkAccent = Color(0xFF22C55E);
  static const Color darkAccentSubtle = Color(0xFF1E3A2B);
  static const Color darkBorder = Color(0xFF2C2C2C);
  static const Color darkSecondarySurface = Color(0xFF262626);

  // Status Colors
  static const Color success = Color(0xFF387653);
  static const Color warning = Color(0xFFA56A22);
  static const Color error = Color(0xFFB7473D);
}

extension AppThemeContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  Color get scaffoldBg => isDarkMode ? const Color(0xFF121212) : Colors.white;
  Color get cardBg => isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF9FAFB);
  Color get cardBorder => isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE5E7EB);
  Color get textPrimary => isDarkMode ? Colors.white : const Color(0xFF1F2937);
  Color get textSecondary => isDarkMode ? const Color(0xFF9E9E9E) : const Color(0xFF6B7280);
  Color get iconContainerBg => isDarkMode ? const Color(0xFF262626) : const Color(0xFFEBF5E9);
  Color get primaryAccent => isDarkMode ? const Color(0xFF22C55E) : const Color(0xFF0F5132);
}

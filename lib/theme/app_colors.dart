import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette (from Lovable design)
  static const Color cream = Color(0xFFFFF8F0);
  static const Color saffron = Color(0xFFE8922D);
  static const Color saffronLight = Color(0xFFF5C882);
  static const Color maroon = Color(0xFF5B1A1A);
  static const Color maroonLight = Color(0xFF8B3A3A);
  static const Color gold = Color(0xFFD4A843);

  // Backgrounds
  static const Color scaffoldBg = Color(0xFFFFF8F0);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE8E0D8);
  static const Color inputBg = Color(0xFFF5F0EA);
  static const Color inputBorder = Color(0xFFD4CCC2);

  // Text
  static const Color textPrimary = Color(0xFF2D1B0E);
  static const Color textSecondary = Color(0xFF8B7B6B);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnSaffron = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color pending = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Shadows
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1A000000);

  // Gradient for background
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF8F0),
      Color(0xFFF0E8F8),
      Color(0xFFFFF0E8),
    ],
  );
}

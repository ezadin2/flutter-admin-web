import 'package:flutter/material.dart';

class TColors {
  // App theme colors
  static const Color primary = Color(0xFF7F7442); // Rich modern gold
  static const Color secondary = Color(0xFFE6BE4C); // Brighter gold accent
  static const Color accent = Color(0xFF232323); // Deep black-accent

  // Icon colors
  static const Color iconPrimary = Color(0xFF888888);

  // Text colors
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color(0xFFF5F5F5); // light background for readability
  static const Color dark = Color(0xFF121212);  // dark mode base
  static const Color primaryBackground = Color(0xFFFFFDF4); // warm golden-white background

  // Background Container colors
  static const Color lightContainer = Color(0xFFFFFFFF); // card/container base
  static Color darkContainer = TColors.white.withOpacity(0.05); // subtle overlay

  // Button colors
  static const Color buttonPrimary = Color(0xFFBFA437); // same as primary
  static const Color buttonSecondary = Color(0xFF313131); // dark grey-black
  static const Color buttonDisabled = Color(0xFFD1CFC7); // muted beige/gold-gray

  // Border colors
  static const Color borderPrimary = Color(0xFFDDC87C); // subtle gold edge
  static const Color borderSecondary = Color(0xFF3D3D3D); // darker border

  // Error and validation colors
  static const Color error = Color(0xFFCC3333);
  static const Color success = Color(0xFF5CB85C);
  static const Color warning = Color(0xFFF0AD4E);
  static const Color info = Color(0xFF5BC0DE);

  // Neutral Shades
  static const Color black = Color(0xFF000000);
  static const Color darkerGrey = Color(0xFF444444);
  static const Color darkGrey = Color(0xFF7D7D7D);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF3F3F3);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}

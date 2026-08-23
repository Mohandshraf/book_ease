import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF0B9B7B);
  static const Color primaryDark = Color(0xFF0A846A);
  static const Color primaryLight = Color(0xFFEAFDF6);
  static const Color primaryPale = Color(0xFFDDFBF0);
  
  // Legacy Aliases for backwards compatibility
  static const Color kprimaryColor = Colors.white;
  static const Color ksecondColor = Color(0xFF0B9B7B);

  // Neutral & Surface Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0B1F44);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textSubtle = Color(0xFFAEB8CC);

  // Border & Divider Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color inputFill = Color(0xFFF7FAFC);

  // State & Feedback Colors
  static const Color success = Color(0xFF34D399);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color star = Colors.amber;

  // Dark Panel & Admin Colors
  static const Color darkSurface = Color(0xFF1C2740);
  static const Color darkCard = Color(0xFF2B354D);
  static const Color darkTextMuted = Color(0xFF6E7C99);
}

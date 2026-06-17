import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens taken directly from the Google Stitch design (design/ folder).
class AppColors {
  static const background = Color(0xFF131313);
  static const surface = Color(0xFF1C1B1B);
  static const surfaceHigh = Color(0xFF2A2A2A);
  static const surfaceHighest = Color(0xFF353534);
  static const primary = Color(0xFFFF6A00); // orange accent
  static const onPrimary = Color(0xFF571F00);
  static const tertiary = Color(0xFF00E475); // connected green
  static const error = Color(0xFFFFB4AB);
  static const onSurface = Color(0xFFE5E2E1);
  static const onSurfaceVariant = Color(0xFFE2BFB0);
  static const outline = Color(0xFF5A4136);
}

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.background,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.tertiary,
        error: AppColors.error,
        onSurface: AppColors.onSurface,
      ),
      textTheme: GoogleFonts.montserratTextTheme(base.textTheme).apply(
        bodyColor: AppColors.onSurface,
        displayColor: AppColors.onSurface,
      ),
    );
  }

  static TextStyle labelCaps({double size = 12, Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.6,
        color: color ?? AppColors.onSurfaceVariant,
      );

  static TextStyle stat({double size = 36, Color? color}) => GoogleFonts.montserrat(
        fontSize: size,
        fontWeight: FontWeight.w800,
        height: 1.0,
        color: color ?? AppColors.onSurface,
      );
}

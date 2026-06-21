import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens taken directly from the Google Stitch "Kinetic Bright" design
/// (design/ folder). Light-mode, high-clarity athletic aesthetic.
class AppColors {
  static const background = Color(0xFFF9F9F9);
  static const surface = Color(0xFFFFFFFF); // card / container-lowest
  static const surfaceLow = Color(0xFFF3F3F3);
  static const surfaceHigh = Color(0xFFEEEEEE); // container
  static const surfaceHighest = Color(0xFFE2E2E2);
  static const primary = Color(0xFFFF6600); // energetic action orange
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryDeep = Color(0xFFA33E00); // brand wordmark / headers
  static const tertiary = Color(0xFF16A34A); // connected / signal green
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1A1C1C);
  static const onSurfaceVariant = Color(0xFF636262); // muted meta text
  static const outline = Color(0xFF8E7164);
  static const outlineVariant = Color(0xFFE3BFB1);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        surface: AppColors.background,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.tertiary,
        error: AppColors.error,
        onError: AppColors.onError,
        onSurface: AppColors.onSurface,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
        bodyColor: AppColors.onSurface,
        displayColor: AppColors.onSurface,
      ),
    );
  }

  static TextStyle labelCaps({double size = 12, Color? color}) => GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: color ?? AppColors.onSurfaceVariant,
      );

  static TextStyle stat({double size = 36, Color? color}) => GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -0.5,
        color: color ?? AppColors.onSurface,
      );

  /// Soft ambient elevation used by every card in the light design system.
  static BoxDecoration card({Color? accentLeft, double radius = 16}) => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: accentLeft != null
            ? Border(left: BorderSide(color: accentLeft, width: 3))
            : Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      );
}

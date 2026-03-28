import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color Tokens ─────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Brand
  static const indigo600 = Color(0xFF4F46E5);
  static const indigo500 = Color(0xFF6366F1);
  static const indigo400 = Color(0xFF818CF8);
  static const indigoLight = Color(0xFFE0E7FF);
  static const purple400 = Color(0xFFC084FC);

  // Slate scale
  static const slate50  = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);

  // Semantic
  static const emerald500 = Color(0xFF10B981);
  static const emerald100 = Color(0xFFD1FAE5);
  static const amber500   = Color(0xFFF59E0B);
  static const amber100   = Color(0xFFFEF3C7);
  static const red500     = Color(0xFFEF4444);
  static const red100     = Color(0xFFFEE2E2);
  static const blue500    = Color(0xFF3B82F6);
  static const blue100    = Color(0xFFDBEAFE);
  static const green100   = Color(0xFFDCFCE7);
  static const green700   = Color(0xFF15803D);
}

// ─── Spacing ──────────────────────────────────────────────────────────────────
class AppSpacing {
  AppSpacing._();
  static const xs  = 4.0;
  static const sm  = 8.0;
  static const md  = 16.0;
  static const lg  = 24.0;
  static const xl  = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;
}

// ─── Breakpoints ─────────────────────────────────────────────────────────────
class AppBreakpoints {
  AppBreakpoints._();
  static const mobile  = 600.0;
  static const tablet  = 1024.0;
  static const desktop = 1280.0;
}

extension BreakpointX on double {
  bool get isMobile  => this < AppBreakpoints.mobile;
  bool get isTablet  => this >= AppBreakpoints.mobile && this < AppBreakpoints.tablet;
  bool get isDesktop => this >= AppBreakpoints.tablet;
}

// ─── Theme ────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.indigo600,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.slate50,
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge:  GoogleFonts.inter(fontSize: 72, fontWeight: FontWeight.w900, letterSpacing: -2, color: AppColors.slate900),
      displayMedium: GoogleFonts.inter(fontSize: 56, fontWeight: FontWeight.w900, letterSpacing: -1.5, color: AppColors.slate900),
      displaySmall:  GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1, color: AppColors.slate900),
      headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: AppColors.slate900),
      headlineMedium:GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: AppColors.slate900),
      headlineSmall: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.slate900),
      titleLarge:    GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.slate900),
      titleMedium:   GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.slate800),
      titleSmall:    GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slate700),
      bodyLarge:     GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.slate700, height: 1.6),
      bodyMedium:    GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.slate600, height: 1.5),
      bodySmall:     GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.slate500, height: 1.4),
      labelLarge:    GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.2),
      labelMedium:   GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      labelSmall:    GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.slate200,
      titleTextStyle: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.slate900),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.slate100),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.indigo600,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.slate700,
        side: const BorderSide(color: AppColors.slate200, width: 1.5),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.slate50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.slate200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.slate200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.indigo600, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.slate400),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.indigo600,
      unselectedItemColor: AppColors.slate400,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.slate100, space: 1),
  );
}

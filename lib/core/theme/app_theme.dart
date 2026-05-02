import 'package:flutter/material.dart';
import '../models/enums.dart';

class AppTheme {
  AppTheme._();

  // ─── BRAND COLORS ────────────────────────────────────────────────────────
  static const Color primary    = Color(0xFF1A3C6E);
  static const Color secondary  = Color(0xFFE87722);
  static const Color surface    = Color(0xFFF5F5F5);
  static const Color error      = Color(0xFFC62828);
  static const Color success    = Color(0xFF2E7D32);
  static const Color warning    = Color(0xFFF9A825);
  static const Color onPrimary  = Color(0xFFFFFFFF);

  // ─── LEAD CLASSIFICATION ─────────────────────────────────────────────────
  static const Color leadHot    = Color(0xFFB71C1C);
  static const Color leadWarm   = Color(0xFFE65100);
  static const Color leadCold   = Color(0xFF1565C0);
  static const Color leadHotBg  = Color(0xFFFFEBEE);
  static const Color leadWarmBg = Color(0xFFFFF3E0);
  static const Color leadColdBg = Color(0xFFE3F2FD);

  // ─── FEED SEGMENT COLORS ─────────────────────────────────────────────────
  static const Color segmentPoultry   = Color(0xFF6A1B9A);
  static const Color segmentAqua      = Color(0xFF0277BD);
  static const Color segmentCattle    = Color(0xFF558B2F);
  static const Color segmentPig       = Color(0xFFAD1457);
  static const Color segmentPoultryBg = Color(0xFFF3E5F5);
  static const Color segmentAquaBg    = Color(0xFFE1F5FE);
  static const Color segmentCattleBg  = Color(0xFFF1F8E9);
  static const Color segmentPigBg     = Color(0xFFFCE4EC);

  // ─── NEUTRAL / UI ────────────────────────────────────────────────────────
  static const Color border         = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFEEEEEE); // card borders
  static const Color disabled       = Color(0xFFBDBDBD);
  static const Color textPrimary    = Color(0xFF212121);
  static const Color textSecondary  = Color(0xFF757575);
  static const Color cardBg         = Colors.white;

  // ─── SHAPE & SPACING ─────────────────────────────────────────────────────
  static const BorderRadius defaultRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius chipRadius    = BorderRadius.all(Radius.circular(20));
  static const EdgeInsets screenPadding   = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS COLOR HELPERS  (used by StatusChip, SummaryChips, VisitCard)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Foreground / icon color for a given [VisitStatus].
  static Color statusColor(VisitStatus status) => switch (status) {
    VisitStatus.pending    => warning,
    VisitStatus.inProgress => secondary,
    VisitStatus.completed  => success,
    VisitStatus.cancelled  => error,
  };

  /// Light background tint paired with [statusColor].
  static Color statusBgColor(VisitStatus status) => switch (status) {
    VisitStatus.pending    => const Color(0xFFFFF8E1),
    VisitStatus.inProgress => const Color(0xFFFFF3E0),
    VisitStatus.completed  => const Color(0xFFE8F5E9),
    VisitStatus.cancelled  => const Color(0xFFFFEBEE),
  };

  /// Human-readable label for a [VisitStatus].
  static String statusLabel(VisitStatus status) => switch (status) {
    VisitStatus.pending    => 'Pending',
    VisitStatus.inProgress => 'In Progress',
    VisitStatus.completed  => 'Completed',
    VisitStatus.cancelled  => 'Cancelled',
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SEGMENT COLOR HELPERS  (used by SegmentBadge, LeadClassificationBadge)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Foreground color for a [FeedSegment] badge.
  static Color segmentColor(FeedSegment segment) => switch (segment) {
    FeedSegment.poultry => segmentPoultry,
    FeedSegment.aqua    => segmentAqua,
    FeedSegment.cattle  => segmentCattle,
    FeedSegment.pig     => segmentPig,
  };

  /// Background tint paired with [segmentColor].
  static Color segmentBgColor(FeedSegment segment) => switch (segment) {
    FeedSegment.poultry => segmentPoultryBg,
    FeedSegment.aqua    => segmentAquaBg,
    FeedSegment.cattle  => segmentCattleBg,
    FeedSegment.pig     => segmentPigBg,
  };

  /// Human-readable label for a [FeedSegment].
  static String segmentLabel(FeedSegment segment) => switch (segment) {
    FeedSegment.poultry => 'Poultry',
    FeedSegment.aqua    => 'Aqua',
    FeedSegment.cattle  => 'Cattle',
    FeedSegment.pig     => 'Pig',
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // THEME DATA
  // ═══════════════════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',

      colorScheme: const ColorScheme(
        brightness:     Brightness.light,
        primary:        primary,
        onPrimary:      onPrimary,
        secondary:      secondary,
        onSecondary:    Colors.white,
        error:          error,
        onError:        Colors.white,
        surface:        surface,
        onSurface:      textPrimary,
        // M3 semantic extras — fixes colorScheme.outlineVariant usage in cards
        outline:        border,
        outlineVariant: outlineVariant,
        surfaceContainerHighest: Color(0xFFECECEC),
      ),

      scaffoldBackgroundColor: surface,

      // ── APP BAR ──────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 0,
        scrolledUnderElevation: 0, // no color shift when list scrolls under bar
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onPrimary,
        ),
      ),

      // ── TYPOGRAPHY ───────────────────────────────────────────────────────
      textTheme: const TextTheme(
        displaySmall:   TextStyle(fontSize: 36, fontWeight: FontWeight.bold,   color: textPrimary),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,   color: textPrimary),
        titleLarge:     TextStyle(fontSize: 20, fontWeight: FontWeight.w600,   color: textPrimary),
        titleMedium:    TextStyle(fontSize: 16, fontWeight: FontWeight.w500,   color: textPrimary),
        bodyLarge:      TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: textPrimary),
        bodyMedium:     TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textSecondary),
        labelLarge:     TextStyle(fontSize: 14, fontWeight: FontWeight.w500,   color: textPrimary),
        labelSmall:     TextStyle(fontSize: 11, fontWeight: FontWeight.w500,   color: textSecondary, letterSpacing: 0.5),
      ),

      // ── BUTTONS ──────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: disabled,
          disabledForegroundColor: Colors.white70,
          minimumSize: const Size(double.infinity, 48),
          shape: const RoundedRectangleBorder(borderRadius: defaultRadius),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          minimumSize: const Size(double.infinity, 48),
          shape: const RoundedRectangleBorder(borderRadius: defaultRadius),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),

      // ── INPUT ────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border:             OutlineInputBorder(borderRadius: defaultRadius, borderSide: const BorderSide(color: border)),
        enabledBorder:      OutlineInputBorder(borderRadius: defaultRadius, borderSide: const BorderSide(color: border)),
        focusedBorder:      OutlineInputBorder(borderRadius: defaultRadius, borderSide: const BorderSide(color: primary, width: 1.5)),
        errorBorder:        OutlineInputBorder(borderRadius: defaultRadius, borderSide: const BorderSide(color: error)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: defaultRadius, borderSide: const BorderSide(color: error, width: 1.5)),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle:  const TextStyle(color: disabled, fontSize: 14),
        errorStyle: const TextStyle(color: error, fontSize: 12),
      ),

      // ── CHIP ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: primary.withValues(alpha: 0.12),
        labelStyle: const TextStyle(color: textPrimary, fontSize: 13),
        side: const BorderSide(color: border),
        shape: const RoundedRectangleBorder(borderRadius: chipRadius),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // ── CARD ─────────────────────────────────────────────────────────────
      cardTheme: const CardThemeData(
        color: cardBg,
        elevation: 1,
        shadowColor: Color(0x1A000000),
        shape: RoundedRectangleBorder(borderRadius: defaultRadius),
        margin: EdgeInsets.zero,
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // ── DIVIDER ──────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 1),

      // ── BOTTOM SHEET ─────────────────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }
}
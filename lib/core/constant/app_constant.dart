import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../theme/app_theme.dart';

class AppConstants {
  AppConstants._();

  // ─── LAYOUT ──────────────────────────────────────────────────────────────
  static const double horizontalPadding = 16.0;
  static const double verticalSpacing   = 8.0;
  static const double height10=10.0;
  static const double cardRadius        = 12.0;
  static const double chipRadius        = 20.0;

  // ─── GEOFENCE (Task 2) ───────────────────────────────────────────────────
  static const double geofenceRadius    = 100.0; // metres
  static const double mockDistanceIn    = 45.0;  // metres – within range
  static const double mockDistanceOut   = 320.0; // metres – out of range

  // ─── FORM LIMITS (Task 3 & 4) ────────────────────────────────────────────
  static const int remarksMaxLength = 300;

  // ─── FILE UPLOAD (Task 4) ────────────────────────────────────────────────
  static const int maxFileSizeMB   = 5;
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf'];

  // ─── SEGMENT COLORS ──────────────────────────────────────────────────────
  static Color segmentColor(FeedSegment segment) {
    return switch (segment) {
      FeedSegment.poultry => AppTheme.segmentPoultry,
      FeedSegment.aqua    => AppTheme.segmentAqua,
      FeedSegment.cattle  => AppTheme.segmentCattle,
      FeedSegment.pig     => AppTheme.segmentPig,
    };
  }

  static Color segmentBgColor(FeedSegment segment) {
    return switch (segment) {
      FeedSegment.poultry => AppTheme.segmentPoultryBg,
      FeedSegment.aqua    => AppTheme.segmentAquaBg,
      FeedSegment.cattle  => AppTheme.segmentCattleBg,
      FeedSegment.pig     => AppTheme.segmentPigBg,
    };
  }
}
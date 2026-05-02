import 'package:flutter/material.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';

/// Map area widget.
///
/// When google_maps_flutter is available, swap the body of [_MockMapCanvas]
/// with a real [GoogleMap] widget. The outer shell (aspect ratio, shadow,
/// border radius) stays unchanged.
///
/// FIX: original was a flat grey box with no visual information.
/// This renders a styled pseudo-map that shows:
///   - A grid of faint lines (street-map feel)
///   - A semi-transparent geofence circle (per spec)
///   - A customer location pin
///   - A user location pin (blue dot)
///   - Coordinate text overlay (bottom-left)
///
/// [checkInState] drives the colour of the user position indicator:
///   - withinRange → blue (inside circle)
///   - outOfRange  → orange (outside circle)
///   - gpsUnavailable → hidden
class MapPlaceholder extends StatelessWidget {
  final CheckInState checkInState;

  const MapPlaceholder({super.key, required this.checkInState});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // ── Base map canvas ──────────────────────────────────────────
              _MockMapCanvas(colorScheme: colorScheme),

              // ── Geofence circle overlay ──────────────────────────────────
              // Spec: "Circle overlay representing geofence radius (100m)"
              const _GeofenceOverlay(),

              // ── User position indicator ──────────────────────────────────
              if (checkInState != CheckInState.gpsUnavailable)
                _UserPositionMarker(isWithinRange: checkInState == CheckInState.withinRange),

              // ── Customer pin (centre) ────────────────────────────────────
              const _CustomerPin(),

              // ── Coordinates badge (bottom-left) ──────────────────────────
              // Spec: "render a styled Container placeholder with coordinates
              // displayed as text — document this clearly in README"
              const _CoordinatesBadge(),

              // ── "Map placeholder" label (top-right corner) ───────────────
              const _MapLabel(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pseudo-map canvas with grid lines ────────────────────────────────────────

class _MockMapCanvas extends StatelessWidget {
  final ColorScheme colorScheme;

  const _MockMapCanvas({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapGridPainter(colorScheme: colorScheme),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE8F0E8), // soft map green
              const Color(0xFFD4E4D4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  final ColorScheme colorScheme;

  _MapGridPainter({required this.colorScheme});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final laneMarkPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Horizontal roads
    for (final yFrac in [0.25, 0.5, 0.75]) {
      final y = size.height * yFrac;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }
    // Vertical roads
    for (final xFrac in [0.25, 0.5, 0.75]) {
      final x = size.width * xFrac;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }
    // Lane markings (lighter)
    for (final yFrac in [0.125, 0.375, 0.625, 0.875]) {
      final y = size.height * yFrac;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), laneMarkPaint);
    }
  }

  @override
  bool shouldRepaint(_MapGridPainter old) => false;
}

// ── Geofence circle ───────────────────────────────────────────────────────────

class _GeofenceOverlay extends StatelessWidget {
  const _GeofenceOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Spec: "semi-transparent circle overlay"
          color: AppTheme.primary.withValues(alpha: 0.12),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

// ── Customer pin ──────────────────────────────────────────────────────────────

class _CustomerPin extends StatelessWidget {
  const _CustomerPin();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.store_outlined, color: Colors.white, size: 16),
          ),
          // Pin tail
          Container(
            width: 2,
            height:AppConstants.height10,
            color: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}

// ── User position marker ──────────────────────────────────────────────────────

class _UserPositionMarker extends StatelessWidget {
  final bool isWithinRange;

  const _UserPositionMarker({required this.isWithinRange});

  @override
  Widget build(BuildContext context) {
    // Within range → inside circle (slightly offset from centre)
    // Out of range → outside circle (significantly offset)
    final offset = isWithinRange
        ? const Offset(-28, -20)   // close to centre = inside geofence
        : const Offset(90, 70);    // far from centre = outside geofence

    final dotColor = isWithinRange ? AppTheme.primary : AppTheme.warning;

    return Center(
      child: Transform.translate(
        offset: offset,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor.withValues(alpha: 0.2),
            border: Border.all(color: dotColor, width: 2),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Coordinates badge ─────────────────────────────────────────────────────────

class _CoordinatesBadge extends StatelessWidget {
  const _CoordinatesBadge();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      bottom: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          '23.0225° N, 72.5714° E',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

// ── Map label badge ───────────────────────────────────────────────────────────

class _MapLabel extends StatelessWidget {
  const _MapLabel();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 12, color: AppTheme.primary),
            const SizedBox(width: 4),
            Text(
              'Map Placeholder',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
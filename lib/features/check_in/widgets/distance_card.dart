import 'package:flutter/material.dart';

import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';

/// Shows current distance from the user to the customer location.
///
/// FIX: original used [Colors.white] (hardcoded). Now uses [colorScheme.surface].
///
/// The card colour and icon change based on [checkInState]:
///   - withinRange   → success green — user is inside the geofence
///   - outOfRange    → error red     — user is outside the geofence
///   - gpsUnavailable → neutral grey  — no GPS signal
class DistanceCard extends StatelessWidget {
  final String distance;
  final CheckInState checkInState;

  const DistanceCard({
    super.key,
    required this.distance,
    required this.checkInState,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final config = _configFor(checkInState);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: config.bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: config.borderColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: config.borderColor.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: config.iconBg,
              ),
              child: Icon(config.icon, color: config.iconColor, size: 20),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distance from customer',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    config.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: config.iconColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Distance value — animates when state changes
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Text(
                distance,
                key: ValueKey(distance),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: config.iconColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _DistanceConfig _configFor(CheckInState state) => switch (state) {
    CheckInState.withinRange => _DistanceConfig(
      label: 'Within check-in zone ✓',
      icon: Icons.my_location_rounded,
      iconColor: AppTheme.success,
      iconBg: AppTheme.success.withValues(alpha: 0.12),
      bgColor: AppTheme.success.withValues(alpha: 0.06),
      borderColor: AppTheme.success.withValues(alpha: 0.4),
    ),
    CheckInState.outOfRange => _DistanceConfig(
      label: 'Outside check-in zone',
      icon: Icons.location_off_outlined,
      iconColor: AppTheme.error,
      iconBg: AppTheme.error.withValues(alpha: 0.12),
      bgColor: AppTheme.error.withValues(alpha: 0.05),
      borderColor: AppTheme.error.withValues(alpha: 0.35),
    ),
    CheckInState.gpsUnavailable => _DistanceConfig(
      label: 'GPS signal unavailable',
      icon: Icons.gps_off_outlined,
      iconColor: AppTheme.warning,
      iconBg: AppTheme.warning.withValues(alpha: 0.12),
      bgColor: AppTheme.warning.withValues(alpha: 0.05),
      borderColor: AppTheme.warning.withValues(alpha: 0.35),
    ),
  };
}

class _DistanceConfig {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color bgColor;
  final Color borderColor;

  const _DistanceConfig({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.bgColor,
    required this.borderColor,
  });
}
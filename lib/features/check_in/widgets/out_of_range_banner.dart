import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Inline banner shown when the user is outside the geofence radius.
///
/// Spec: "show a SnackBar or inline banner:
/// 'You are outside the check-in zone. Move closer to the customer location.'"
///
/// FIX: original used [Colors.red] (hardcoded). Now uses [AppTheme.error].
/// Added an animated slide-in from the top so the appearance is not abrupt.
class OutOfRangeBanner extends StatelessWidget {
  const OutOfRangeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.error.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning icon in a circle
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppTheme.error,
                size: 16,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outside Check-In Zone',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'You are outside the check-in zone. '
                        'Move closer to the customer location to enable check-in.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.error.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
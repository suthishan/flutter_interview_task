import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PulsingStatusIcon extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> pulseAnimation;

  const PulsingStatusIcon({super.key, 
    required this.scaleAnimation,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) => Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            Transform.scale(
              scale: pulseAnimation.value,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.warning.withValues(alpha: 0.06),
                  border: Border.all(
                    color: AppTheme.warning.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Middle ring
            Container(
              width: 100,
              height:100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.warning.withValues(alpha: 0.1),
              ),
            ),
            // Inner icon container
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.warning.withValues(alpha: 0.15),
                border: Border.all(
                  color: AppTheme.warning.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.pending_actions_outlined,
                size: 36,
                color: AppTheme.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
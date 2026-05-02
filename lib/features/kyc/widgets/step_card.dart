import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class StepCard extends StatelessWidget {
  final Animation<double> animation;
  final int step;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;

  const StepCard({super.key,
    required this.animation,
    required this.step,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final Color stateColor = isCompleted
        ? AppTheme.success
        : isActive
        ? AppTheme.warning
        : AppTheme.disabled;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - animation.value)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: stateColor.withValues(alpha: isActive ? 0.4 : 0.2),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Step indicator circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: stateColor.withValues(alpha: 0.12),
              ),
              child: isCompleted
                  ? Icon(Icons.check_rounded, color: stateColor, size: 20)
                  : isActive
                  ? SizedBox(
                width: 18,
                height: 18,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(stateColor),
                  ),
                ),
              )
                  : Center(
                child: Text(
                  '$step',
                  style: TextStyle(
                    color: stateColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isActive || isCompleted
                          ? AppTheme.textPrimary
                          : AppTheme.disabled,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: isActive || isCompleted
                          ? AppTheme.textSecondary
                          : AppTheme.disabled,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // State badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: stateColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isCompleted
                    ? 'Done'
                    : isActive
                    ? 'Pending'
                    : 'Waiting',
                style: TextStyle(
                  color: stateColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
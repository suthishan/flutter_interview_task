import 'package:flutter/material.dart';
import '../../core/models/enums.dart';
import '../../core/theme/app_theme.dart';

/// A reusable chip that renders a [VisitStatus] with a distinct
/// label, background, and text color derived from [AppTheme] tokens.
/// No hardcoded hex values — all colors come from AppTheme.
class StatusChip extends StatelessWidget {
  final VisitStatus status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final config = _configFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        // Subtle border reinforces the chip shape on pale backgrounds
        border: Border.all(
          color: config.textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 12,
            color: config.textColor,
          ),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: config.textColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _configFor(VisitStatus status) {
    switch (status) {
      case VisitStatus.pending:
        return _StatusConfig(
          label: 'Pending',
          backgroundColor: AppTheme.warning.withValues(alpha: 0.15),
          textColor: AppTheme.warning,
          icon: Icons.schedule_outlined,
        );
      case VisitStatus.inProgress:
        return _StatusConfig(
          label: 'In Progress',
          backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
          textColor: AppTheme.primary,
          icon: Icons.directions_walk_outlined,
        );
      case VisitStatus.completed:
        return _StatusConfig(
          label: 'Completed',
          backgroundColor: AppTheme.success.withValues(alpha: 0.12),
          textColor: AppTheme.success,
          icon: Icons.check_circle_outline,
        );
      case VisitStatus.cancelled:
        return _StatusConfig(
          label: 'Cancelled',
          backgroundColor: AppTheme.error.withValues(alpha: 0.12),
          textColor: AppTheme.error,
          icon: Icons.cancel_outlined,
        );
    }
  }
}

/// Private config holder — keeps [StatusChip.build] clean.
class _StatusConfig {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });
}
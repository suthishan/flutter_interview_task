import 'package:flutter/material.dart';
import '../../core/models/enums.dart';
import '../../core/theme/app_theme.dart';

class LeadClassificationBadge extends StatelessWidget {
  final LeadClassification classification;
  final bool compact;

  const LeadClassificationBadge({
    super.key,
    required this.classification,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = _config(classification);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: cfg.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(compact ? 20 : 10),
        border: Border.all(color: cfg.color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(cfg.icon, size: compact ? 11 : 14, color: cfg.color),
          const SizedBox(width: 4),
          Text(
            cfg.label,
            style: TextStyle(
              color: cfg.color,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  static _BadgeConfig _config(LeadClassification c) => switch (c) {
    LeadClassification.hot => _BadgeConfig(
      label: 'HOT',
      icon: Icons.local_fire_department_rounded,
      color: AppTheme.leadHot,
    ),
    LeadClassification.warm => _BadgeConfig(
      label: 'WARM',
      icon: Icons.trending_up_rounded,
      color: AppTheme.leadWarm,
    ),
    LeadClassification.cold => _BadgeConfig(
      label: 'COLD',
      icon: Icons.ac_unit_rounded,
      color: AppTheme.leadCold,
    ),
  };
}

class _BadgeConfig {
  final String label;
  final IconData icon;
  final Color color;
  const _BadgeConfig(
      {required this.label, required this.icon, required this.color});
}
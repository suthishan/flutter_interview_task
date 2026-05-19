import 'package:flutter/material.dart';
import 'package:japfa_pocket_feed/core/models/lead_model.dart';
import 'package:japfa_pocket_feed/core/theme/app_theme.dart';

class LeadClassificationBadge extends StatelessWidget {
  final LeadClassification classification;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const LeadClassificationBadge({
    super.key,
    required this.classification,
    required this.isSelected,
    required this.onTap,
    this.compact = false,
  });

  IconData _getIcon() {
    return switch (classification) {
      LeadClassification.hot => Icons.local_fire_department,
      LeadClassification.warm => Icons.trending_up,
      LeadClassification.cold => Icons.ac_unit,
    };
  }

  String _getLabel() {
    return switch (classification) {
      LeadClassification.hot => 'HOT',
      LeadClassification.warm => 'WARM',
      LeadClassification.cold => 'COLD',
    };
  }

  String _getDescription() {
    return switch (classification) {
      LeadClassification.hot => 'Immediate opportunity-ready to buy',
      LeadClassification.warm => 'Interested but needs follow-up',
      LeadClassification.cold => 'Early stage - repository only',
    };
  }

  Color _getColor() {
    return switch (classification) {
      LeadClassification.hot => AppTheme.leadHotColor,
      LeadClassification.warm => AppTheme.leadWarmColor,
      LeadClassification.cold => AppTheme.leadColdColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(compact ? 6 : 12),
          border: Border.all(
            color: isSelected ? color : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIcon(),
                  color: isSelected ? Colors.white : color,
                  size: compact ? 16 : 20,
                ),
                const SizedBox(width: 4),
                Text(
                  _getLabel(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 6),
              Text(
                _getDescription(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? Colors.white70
                      : theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

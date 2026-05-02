import 'package:flutter/material.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';

/// HOT / WARM / COLD selector.
/// Each option is a full card with background color, icon, label and
/// a short description — NOT a plain radio button list (spec requirement).
class LeadClassificationSelector extends StatelessWidget {
  final LeadClassification? selected;
  final ValueChanged<LeadClassification> onChanged;

  const LeadClassificationSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: LeadClassification.values.map((c) {
        final cfg = _configFor(c);
        final isSelected = selected == c;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: c != LeadClassification.cold ? 8 : 0,
            ),
            child: _ClassificationCard(
              config: cfg,
              isSelected: isSelected,
              onTap: () => onChanged(c),
            ),
          ),
        );
      }).toList(),
    );
  }

  static _ClassConfig _configFor(LeadClassification c) => switch (c) {
    LeadClassification.hot => _ClassConfig(
      classification: c,
      label: 'HOT',
      description: 'Immediate opportunity',
      icon: Icons.local_fire_department_rounded,
      color: AppTheme.leadHot,
      bgSelected: const Color(0xFFFFEBEE),
      bgUnselected: const Color(0xFFFFF8F8),
    ),
    LeadClassification.warm => _ClassConfig(
      classification: c,
      label: 'WARM',
      description: 'Needs follow-up',
      icon: Icons.trending_up_rounded,
      color: AppTheme.leadWarm,
      bgSelected: const Color(0xFFFFF3E0),
      bgUnselected: const Color(0xFFFFFBF5),
    ),
    LeadClassification.cold => _ClassConfig(
      classification: c,
      label: 'COLD',
      description: 'Early stage',
      icon: Icons.ac_unit_rounded,
      color: AppTheme.leadCold,
      bgSelected: const Color(0xFFE3F2FD),
      bgUnselected: const Color(0xFFF5FAFE),
    ),
  };
}

class _ClassificationCard extends StatelessWidget {
  final _ClassConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClassificationCard({
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? config.bgSelected : config.bgUnselected,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? config.color
                : config.color.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: config.color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
              : [],
        ),
        child: Column(
          children: [
            // Icon circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: config.color.withValues(
                    alpha: isSelected ? 0.18 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                config.icon,
                color: config.color,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            // Label
            Text(
              config.label,
              style: TextStyle(
                color: config.color,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 3),
            // Description
            Text(
              config.description,
              style: TextStyle(
                color: config.color.withValues(alpha: 0.75),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            // Selected checkmark
            if (isSelected) ...[
              const SizedBox(height: 6),
              Icon(Icons.check_circle_rounded, color: config.color, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClassConfig {
  final LeadClassification classification;
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgSelected;
  final Color bgUnselected;

  const _ClassConfig({
    required this.classification,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgSelected,
    required this.bgUnselected,
  });
}
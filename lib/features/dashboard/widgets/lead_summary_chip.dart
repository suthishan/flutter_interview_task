import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dashboard_providers.dart';

/// Three summary chips — HOT / WARM / COLD — showing the total count
/// for each classification (across ALL leads, not filtered).
///
/// Tapping a chip toggles it as a classification filter.
/// Spec: "Lead count summary row - 3 chips: Hot (count), Warm (count),
/// Cold (count) - tapping filters the list"
class LeadSummaryChips extends ConsumerWidget {
  const LeadSummaryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(leadCountsProvider);
    final filters = ref.watch(dashboardFiltersProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: LeadClassification.values.map((c) {
          final count = counts[c] ?? 0;
          final isActive = filters.classifications.contains(c);
          final cfg = _configFor(c);

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: c != LeadClassification.cold ? 10 : 0,
              ),
              child: _SummaryChip(
                label: cfg.label,
                count: count,
                color: cfg.color,
                icon: cfg.icon,
                isActive: isActive,
                onTap: () => notifier.toggleClassification(c),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static _ChipConfig _configFor(LeadClassification c) => switch (c) {
    LeadClassification.hot => _ChipConfig(
      label: 'HOT',
      icon: Icons.local_fire_department_rounded,
      color: AppTheme.leadHot,
    ),
    LeadClassification.warm => _ChipConfig(
      label: 'WARM',
      icon: Icons.trending_up_rounded,
      color: AppTheme.leadWarm,
    ),
    LeadClassification.cold => _ChipConfig(
      label: 'COLD',
      icon: Icons.ac_unit_rounded,
      color: AppTheme.leadCold,
    ),
  };
}

class _ChipConfig {
  final String label;
  final IconData icon;
  final Color color;
  const _ChipConfig(
      {required this.label, required this.icon, required this.color});
}

// ── Individual summary chip ───────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? color : color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? color : color.withValues(alpha: 0.3),
            width: isActive ? 0 : 1,
          ),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + label row
            Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isActive ? Colors.white : color,
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.9)
                        : color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Count — animated when it changes
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Text(
                '$count',
                key: ValueKey(count),
                style: TextStyle(
                  color: isActive ? Colors.white : color,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
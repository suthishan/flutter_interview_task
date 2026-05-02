import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dashboard_providers.dart';

/// Horizontal scrollable filter chip bar.
///
/// Spec: "FilterChip row for: All / Hot / Warm / Cold /
/// This Week / This Month — multiple filters can be active simultaneously"
///
/// Classification filters are OR-combined (Hot + Warm shows both).
/// Date filters are AND-combined with classification result.
/// 'All' clears everything.
class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(dashboardFiltersProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: Row(
          children: [
            // ── All ──────────────────────────────────────────────────────────
            _FilterChipItem(
              label: 'All',
              icon: Icons.layers_outlined,
              isActive: filters.isAllActive,
              activeColor: AppTheme.primary,
              onTap: notifier.clearFilters,
            ),

            const SizedBox(width: 8),

            // ── Classification filters ────────────────────────────────────────
            _FilterChipItem(
              label: 'Hot',
              icon: Icons.local_fire_department_rounded,
              isActive: filters.hasClassification(LeadClassification.hot),
              activeColor: AppTheme.leadHot,
              onTap: () => notifier.toggleClassification(LeadClassification.hot),
            ),

            const SizedBox(width: 8),

            _FilterChipItem(
              label: 'Warm',
              icon: Icons.trending_up_rounded,
              isActive: filters.hasClassification(LeadClassification.warm),
              activeColor: AppTheme.leadWarm,
              onTap: () =>
                  notifier.toggleClassification(LeadClassification.warm),
            ),

            const SizedBox(width: 8),

            _FilterChipItem(
              label: 'Cold',
              icon: Icons.ac_unit_rounded,
              isActive: filters.hasClassification(LeadClassification.cold),
              activeColor: AppTheme.leadCold,
              onTap: () =>
                  notifier.toggleClassification(LeadClassification.cold),
            ),

            const SizedBox(width: 8),

            // ── Divider ───────────────────────────────────────────────────────
            Container(
              height: 20,
              width: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),

            const SizedBox(width: 4),

            // ── Date filters ──────────────────────────────────────────────────
            _FilterChipItem(
              label: 'This Week',
              icon: Icons.date_range_outlined,
              isActive: filters.dateFilter == DateFilter.thisWeek,
              activeColor: AppTheme.secondary,
              onTap: notifier.toggleThisWeek,
            ),

            const SizedBox(width: 8),

            _FilterChipItem(
              label: 'This Month',
              icon: Icons.calendar_month_outlined,
              isActive: filters.dateFilter == DateFilter.thisMonth,
              activeColor: AppTheme.secondary,
              onTap: notifier.toggleThisMonth,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Individual filter chip ────────────────────────────────────────────────────

class _FilterChipItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? activeColor : activeColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? activeColor : activeColor.withValues(alpha: 0.3),
            width: isActive ? 0 : 1,
          ),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: activeColor.withValues(alpha: 0.28),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isActive ? Colors.white : activeColor,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : activeColor.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/visit_provider.dart';

/// Horizontal scrollable row of summary chips for each [VisitStatus].
///
/// Each chip shows the count for the selected date and tapping it
/// filters the list (sets [activeStatusFilterProvider]).
/// Count text animates when it changes.
class SummaryChips extends ConsumerWidget {
  const SummaryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(visitSummaryProvider);
    final activeFilter = ref.watch(activeStatusFilterProvider);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // "All" chip
            _SummaryChip(
              label: 'All',
              count: summary.values.fold(0, (a, b) => a + b),
              color: AppTheme.primary,
              isActive: activeFilter == null,
              onTap: () =>
              ref.read(activeStatusFilterProvider.notifier).state = null,
            ),
            const SizedBox(width: 8),
            ...VisitStatus.values.map((status) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _SummaryChip(
                  label: _labelFor(status),
                  count: summary[status] ?? 0,
                  color: AppTheme.statusColor(status),
                  isActive: activeFilter == status,
                  onTap: () {
                    final notifier =
                    ref.read(activeStatusFilterProvider.notifier);
                    // Toggle: tap active filter again → reset to All
                    notifier.state =
                    activeFilter == status ? null : status;
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _labelFor(VisitStatus s) => switch (s) {
    VisitStatus.pending => 'Pending',
    VisitStatus.inProgress => 'In Progress',
    VisitStatus.completed => 'Completed',
    VisitStatus.cancelled => 'Cancelled',
  };
}



// ── Private chip widget ───────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          // Active: filled; inactive: tinted bg
          color: isActive ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? color : color.withValues(alpha: 0.35),
            width: isActive ? 0 : 1,
          ),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Count badge
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Text(
                '$count',
                key: ValueKey(count),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isActive ? Colors.white : color,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.9)
                    : color.withValues(alpha: 0.85),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
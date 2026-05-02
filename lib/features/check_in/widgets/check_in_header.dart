import 'package:flutter/material.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../visit_plan/widgets/segment_badge.dart';

/// Screen header showing customer name, route, planned time, and badges.
///
/// FIX: original had hardcoded strings "Ramesh Farm", "Route A", "10:30 AM".
/// Now accepts [VisitModel] passed from the previous screen via GoRouter extra,
/// so real data flows through automatically.
class CheckInHeader extends StatelessWidget {
  final VisitModel visit;

  const CheckInHeader({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer name
          Text(
            visit.customerName,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Route + time row
          Row(
            children: [
              _MetaItem(
                icon: Icons.route_outlined,
                label: visit.routeName,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              _MetaItem(
                icon: Icons.schedule_outlined,
                label: AppDateUtils.formatTime(visit.scheduledTime),
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),

          const SizedBox(height:AppConstants.height10),

          // Segment badge + Status chip
          Row(
            children: [
              SegmentBadge(segment: visit.segment),
              const SizedBox(width: 8),
              StatusChip(status: visit.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
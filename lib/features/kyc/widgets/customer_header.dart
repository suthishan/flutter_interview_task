import 'package:flutter/material.dart';

import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../visit_plan/widgets/segment_badge.dart';

class CustomerHeader extends StatelessWidget {
  const CustomerHeader({super.key});

  // Mock customer data (would come via GoRouter `extra` in a real flow)
  static const String _customerName = 'Ramesh Poultry Farm';
  static const String _leadNo       = 'LEAD-2024-00142';
  static const FeedSegment _segment = FeedSegment.poultry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.defaultRadius,
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer name + segment badge
          Row(
            children: [
              Expanded(
                child: Text(
                  _customerName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SegmentBadge(segment: _segment),
            ],
          ),
          const SizedBox(height: 6),
          // Lead number
          Row(
            children: [
              Icon(Icons.tag, size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(
                _leadNo,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Customer type
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Customer Type: Individual',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
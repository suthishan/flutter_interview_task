import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:japfa_task/core/theme/app_theme.dart';
import 'package:japfa_task/router/app_router.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/constant/app_constant.dart';
import '../../../shared/widgets/status_chip.dart';
import '../widgets/segment_badge.dart';

class VisitDetailScreen extends StatelessWidget {

  final VisitModel? visit;
  final String visitId;

  const VisitDetailScreen({
    super.key,
    required this.visit,
    required this.visitId,
  });

  @override
  Widget build(BuildContext context) {
    final v = visit ?? GoRouterState.of(context).extra as VisitModel;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = AppTheme.statusColor(v.status);

    return Scaffold(
      // ── AppBar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        title: const Text('Visit Detail'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StatusChip(status: v.status),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero header block ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.08),
                border: Border(
                  bottom: BorderSide(
                    color: statusColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer name
                  Text(
                    v.customerName,
                    style: textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 8),

                  // Route row
                  Row(
                    children: [
                      Icon(
                        Icons.route_outlined,
                        size: 15,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          v.routeName,
                          style: textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Time row
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 15,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppDateUtils.formatTime(v.scheduledTime),
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        AppDateUtils.formatDate(v.scheduledTime),
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Segment badge
                  SegmentBadge(segment: v.segment),
                ],
              ),
            ),

            // ── Info section ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppConstants.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visit Information', style: textTheme.titleMedium),
                  const SizedBox(height: 12),

                  // Info card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                        AppConstants.cardRadius,
                      ),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.person_outline,
                          label: 'Customer',
                          value: v.customerName,
                        ),
                        const Divider(height: 20),
                        _InfoRow(
                          icon: Icons.route_outlined,
                          label: 'Route',
                          value: v.routeName,
                        ),
                        const Divider(height: 20),
                        _InfoRow(
                          icon: Icons.schedule_outlined,
                          label: 'Scheduled',
                          value: AppDateUtils.formatTime(v.scheduledTime),
                        ),
                        const Divider(height: 20),
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Date',
                          value: AppDateUtils.formatDate(v.scheduledTime),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── CTA button ─────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: v.status == VisitStatus.cancelled
                          ? null // disabled for cancelled visits
                          : () => context.pushNamed(
                        AppRoutes.checkIn,
                        pathParameters: {'visitId': v.id},
                        extra: v,
                      ),
                      icon: const Icon(Icons.location_on_outlined),
                      label: Text(
                        v.status == VisitStatus.cancelled
                            ? 'Visit Cancelled'
                            : 'Start Check-In',
                      ),
                    ),
                  ),

                   const SizedBox(height: AppConstants.height10),

                  // Back button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back to Visit Plan'),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Extracted info row widget ─────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          // ✅ theme token
          color: colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              // ✅ theme token — was hardcoded Colors.grey
              color: colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
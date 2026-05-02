import 'package:flutter/material.dart';

import '../../../core/models/dashboard_lead_model.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/widgets/lead_classification_badge.dart';
import '../../visit_plan/widgets/segment_badge.dart';

/// Lead card for the Manager Dashboard list.
///
/// Shows: customer name, area, segment badge, LeadClassificationBadge
/// (reused from shared/widgets/), sales officer name, created date,
/// and an unread remark indicator dot.
///
/// Spec: "Hot leads appear at top of list regardless of sort order"
/// → guaranteed by the provider; card renders in list order.
///
/// All colors from AppTheme — no hardcoded hex.
class DashboardLeadCard extends StatelessWidget {
  final DashboardLeadModel lead;
  final VoidCallback onTap;
  final int index;

  const DashboardLeadCard({
    super.key,
    required this.lead,
    required this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final classColor = _classificationColor(lead.classification);

    // Staggered entrance animation matching VisitCard style
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 280 + index * 50),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: child,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: classColor.withValues(alpha: 0.06),
          highlightColor: classColor.withValues(alpha: 0.03),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left classification accent bar ────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 4,
                  color: classColor,
                ),

                // ── Card content ──────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Customer name + classification badge + unread dot
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                lead.customerName,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Reused shared widget (spec requirement)
                            LeadClassificationBadge(
                              classification: lead.classification,
                            ),
                            if (lead.hasUnreadRemarks) ...[
                              const SizedBox(width: 6),
                              _UnreadDot(),
                            ],
                          ],
                        ),

                        const SizedBox(height: 7),

                        // Row 2: Area + Segment badge
                        Row(
                          children: [
                            _MetaItem(
                              icon: Icons.location_on_outlined,
                              label: lead.area,
                              color:
                              colorScheme.onSurface.withValues(alpha: 0.5),
                              textStyle: textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            SegmentBadge(segment: lead.segment),
                          ],
                        ),

                        const SizedBox(height: 5),

                        // Row 3: Officer name + created date
                        Row(
                          children: [
                            _MetaItem(
                              icon: Icons.person_outline,
                              label: lead.salesOfficerName,
                              color:
                              colorScheme.onSurface.withValues(alpha: 0.5),
                              textStyle: textTheme.bodySmall,
                            ),
                            const Spacer(),
                            _MetaItem(
                              icon: Icons.schedule_outlined,
                              label: AppDateUtils.relativeDate(lead.createdAt),
                              color:
                              colorScheme.onSurface.withValues(alpha: 0.45),
                              textStyle: textTheme.bodySmall,
                            ),
                          ],
                        ),

                        // Row 4: Remarks count (if any)
                        if (lead.remarksTimeline.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          _RemarksCountBadge(
                            count: lead.remarksTimeline.length,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // ── Trailing chevron ──────────────────────────────────────
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.chevron_right,
                      size: 18,
                      color:
                      colorScheme.onSurface.withValues(alpha: 0.28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _classificationColor(LeadClassification c) => switch (c) {
    LeadClassification.hot => AppTheme.leadHot,
    LeadClassification.warm => AppTheme.leadWarm,
    LeadClassification.cold => AppTheme.leadCold,
  };
}

// ── Unread indicator dot ──────────────────────────────────────────────────────

class _UnreadDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      margin: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withValues(alpha: 0.5),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

// ── Remarks count badge ───────────────────────────────────────────────────────

class _RemarksCountBadge extends StatelessWidget {
  final int count;
  const _RemarksCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.chat_bubble_outline_rounded,
          size: 11,
          color: colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 4),
        Text(
          '$count ${count == 1 ? 'remark' : 'remarks'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.45),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ── Shared meta row ───────────────────────────────────────────────────────────

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final TextStyle? textStyle;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            label,
            style: (textStyle ?? Theme.of(context).textTheme.bodySmall)
                ?.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
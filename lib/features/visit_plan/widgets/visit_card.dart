import 'package:flutter/material.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/status_chip.dart';
import 'segment_badge.dart';

/// A rich visit card with:
/// - Colored left accent bar (maps to visit status)
/// - Hero-wrapped customer name for smooth navigation transition
/// - Icon-labelled route and time rows
/// - Segment badge bottom-right
/// - Ink ripple on tap (Card + clipBehavior)
///
/// All colors from AppTheme — no hardcoded values.
class VisitCard extends StatelessWidget {
  final VisitModel visit;
  final VoidCallback onTap;

  /// Optional: pass the list index to stagger entrance animations.
  final int index;

  const VisitCard({
    super.key,
    required this.visit,
    required this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = AppTheme.statusColor(visit.status);
    final subtitleColor = colorScheme.onSurface.withValues(alpha: 0.5);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 60),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: 5,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: accentColor.withValues(alpha: 0.08),
          highlightColor: accentColor.withValues(alpha: 0.04),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left status accent bar ────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 4,
                  color: accentColor,
                ),

                // ── Main content ──────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Customer name + Status chip
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Hero(
                                tag: 'customer_${visit.id}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    visit.customerName,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            StatusChip(status: visit.status),
                          ],
                        ),

                        const SizedBox(height: 7),

                        // Row 2: Route
                        _IconRow(
                          icon: Icons.route_outlined,
                          label: visit.routeName,
                          color: subtitleColor,
                          textStyle: textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 4),

                        // Row 3: Time + Segment badge
                        Row(
                          children: [
                            _IconRow(
                              icon: Icons.schedule_outlined,
                              label: AppDateUtils.formatTime(visit.scheduledTime),
                              color: subtitleColor,
                              textStyle: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            SegmentBadge(segment: visit.segment),
                          ],
                        ),
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
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
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
}

// ── Tiny helper — keeps build() free of repeated icon+text patterns ───────────
class _IconRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final TextStyle? textStyle;

  const _IconRow({
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
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: textStyle?.copyWith(color: color) ??
                TextStyle(color: color, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
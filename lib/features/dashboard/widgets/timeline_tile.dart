import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/models/remark_model.dart';

/// Custom timeline tile for the Manager Lead Dashboard remark history.
///
/// Spec: "Remarks timeline - chronological list of remarks, each with:
/// author, timestamp, remark text — use a custom TimelineTile widget"
///
/// Visual layout:
///   [Avatar] ── Vertical line
///                [Name badge] [Role pill] [Timestamp]
///                [Remark text]
///
/// Manager remarks use [AppTheme.primary]; Sales Officer remarks use
/// [AppTheme.secondary] — distinct at a glance.
class TimelineTile extends StatelessWidget {
  final RemarkModel remark;

  /// When true, the bottom connector line is hidden (last item in list).
  final bool isLast;

  const TimelineTile({
    super.key,
    required this.remark,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isManager = remark.authorRole == 'Manager';
    final accentColor = isManager ? AppTheme.primary : AppTheme.secondary;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: avatar + vertical line ───────────────────────────────────
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Avatar circle
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.45),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _initials(remark.authorName),
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                // Connector line — hidden for the last tile
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            accentColor.withValues(alpha: 0.4),
                            accentColor.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 16),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ── Right: content card ────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author row: name + role pill + timestamp
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                remark.authorName,
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Role pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                  accentColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  remark.authorRole,
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Timestamp
                        Text(
                          _formatTimestamp(remark.timestamp),
                          style: textTheme.bodySmall?.copyWith(
                            color:
                            colorScheme.onSurface.withValues(alpha: 0.45),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Remark text
                    Text(
                      remark.text,
                      style: textTheme.bodyMedium?.copyWith(
                        color:
                        colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday ${AppDateUtils.formatTime(dt)}';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return AppDateUtils.formatDateTime(dt);
  }
}
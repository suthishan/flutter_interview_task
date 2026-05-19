import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:japfa_pocket_feed/core/models/remark_model.dart';
import 'package:japfa_pocket_feed/core/theme/app_theme.dart';

class TimelineTile extends StatelessWidget {
  final RemarkModel remark;
  final bool isFirst;
  final bool isLast;

  const TimelineTile({
    super.key,
    required this.remark,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isManager = remark.authorRole == 'Manager';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst) const SizedBox(height: 20),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isManager
                    ? AppTheme.leadHotColor
                    : theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 2),
              ),
            ),
            Expanded(
              child: Container(
                width: 2,
                color: theme.dividerColor,
                margin: const EdgeInsets.only(bottom: 20),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isFirst ? 0 : 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isManager
                  ? AppTheme.leadHotColor.withOpacity(0.1)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: isManager
                  ? Border.all(color: AppTheme.leadHotColor)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(remark.authorName, style: theme.textTheme.labelLarge),
                    Text(
                      DateFormat('HH:mm, MMM d').format(remark.timestamp),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(remark.text, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

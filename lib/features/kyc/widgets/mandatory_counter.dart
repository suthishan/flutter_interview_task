import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class MandatoryCounter extends StatelessWidget {
  final int uploaded; // 0–3
  const MandatoryCounter({super.key, required this.uploaded});

  @override
  Widget build(BuildContext context) {
    final theme    = Theme.of(context);
    final progress = uploaded / 3.0;
    final isDone   = uploaded == 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mandatory documents',
                style: theme.textTheme.labelLarge,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  '$uploaded of 3 uploaded',
                  key: ValueKey(uploaded),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isDone ? AppTheme.success : AppTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDone ? AppTheme.success : AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
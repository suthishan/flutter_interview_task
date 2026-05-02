import 'package:flutter/material.dart';

/// A consistently styled section title used across all forms and screens.
///
/// Renders [title] in [titleLarge] with an optional [trailing] widget
/// (e.g. a "See all" TextButton or an action IconButton) aligned to the end.
///
/// Usage:
/// ```dart
/// SectionHeader(title: 'Customer Details')
/// SectionHeader(title: 'Documents', trailing: TextButton(...))
/// ```
class SectionHeader extends StatelessWidget {
  final String title;

  /// Optional widget anchored to the trailing edge of the header row.
  /// Typically a [TextButton] or [IconButton].
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left accent bar + title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
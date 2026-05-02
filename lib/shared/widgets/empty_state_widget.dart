import 'package:flutter/material.dart';

/// A reusable empty-state display with an icon, title, optional subtitle,
/// and an optional CTA [ElevatedButton].
///
/// Usage:
/// ```dart
/// // No visits for the selected date
/// EmptyStateWidget(
///   icon: Icons.event_busy_outlined,
///   title: 'No visits planned',
///   subtitle: 'Tap below to plan a visit for this date.',
///   buttonText: 'Plan a Visit',
///   onPressed: () => context.push('/visit/add'),
/// )
///
/// // No leads yet — no CTA needed
/// EmptyStateWidget(
///   icon: Icons.person_search_outlined,
///   title: 'No leads found',
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  /// Label for the CTA button. Requires [onPressed] to be non-null.
  final String? buttonText;
  final VoidCallback? onPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onPressed,
  }) : assert(
  buttonText == null || onPressed != null,
  'onPressed must be provided when buttonText is set.',
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon inside a soft circular container
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                // Use onSurfaceVariant so it adapts to light/dark theme
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.add, size: 18),
                label: Text(buttonText!),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
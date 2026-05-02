import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/check_in_providers.dart';

/// Evaluator-only GPS state simulator.
///
/// Spec: "implement a mock position toggle. Add a Switch or SegmentedButton
/// at the bottom of the screen that lets the evaluator toggle between:
/// Within Range / Out of Range / GPS Unavailable"
///
/// Wrapped in a clearly labelled "Dev Tools" card so it is obvious this
/// is a test-only control and not a production UI element.
class StateToggle extends ConsumerWidget {
  const StateToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(checkInStateProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dev-mode label
            Row(
              children: [
                Icon(
                  Icons.developer_mode_rounded,
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  'Evaluator GPS Simulator',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),

            const SizedBox(height:AppConstants.height10),

            // Full-width segmented button
            SegmentedButton<CheckInState>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: CheckInState.withinRange,
                  label: const Text('Within\nRange', textAlign: TextAlign.center),
                  icon: Icon(
                    Icons.my_location_rounded,
                    color: current == CheckInState.withinRange
                        ? AppTheme.success
                        : null,
                    size: 14,
                  ),
                ),
                ButtonSegment(
                  value: CheckInState.outOfRange,
                  label: const Text('Out of\nRange', textAlign: TextAlign.center),
                  icon: Icon(
                    Icons.location_off_outlined,
                    color: current == CheckInState.outOfRange
                        ? AppTheme.error
                        : null,
                    size: 14,
                  ),
                ),
                ButtonSegment(
                  value: CheckInState.gpsUnavailable,
                  label: const Text('GPS\nOff', textAlign: TextAlign.center),
                  icon: Icon(
                    Icons.gps_off_rounded,
                    color: current == CheckInState.gpsUnavailable
                        ? AppTheme.warning
                        : null,
                    size: 14,
                  ),
                ),
              ],
              selected: {current},
              onSelectionChanged: (value) {
                ref.read(checkInStateProvider.notifier).state = value.first;
              },
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
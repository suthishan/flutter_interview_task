import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:japfa_task/router/app_router.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/check_in_providers.dart';
import '../widgets/cancellation_dialog.dart';
import '../widgets/check_in_button.dart';
import '../widgets/check_in_header.dart';
import '../widgets/distance_card.dart';
import '../widgets/gps_error_view.dart';
import '../widgets/map_placeholder.dart';
import '../widgets/out_of_range_banner.dart';
import '../widgets/state_toggle.dart';

class CheckInScreen extends ConsumerWidget {
  final VisitModel? visit;
  final String visitId;

  const CheckInScreen({super.key, this.visit, required this.visitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = visit ?? GoRouterState.of(context).extra as VisitModel;
    final checkInState = ref.watch(checkInStateProvider);
    final distance = ref.watch(distanceProvider);
    final canCheckIn = ref.watch(canCheckInProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => showCancellationDialog(context),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.onPrimary.withValues(alpha: 0.85),
              ),
              icon: const Icon(Icons.cancel_outlined, size: 16),
              label: const Text(
                'Cancel Visit',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),

      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,


      body: Column(
        children: [
          // ── Main content area (switches between normal and GPS error) ──────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: checkInState == CheckInState.gpsUnavailable
              // ── GPS error: full-area widget (NOT a Scaffold) ───────────
                  ? const GpsErrorView(key: ValueKey('gps_error'))
              // ── Normal / out-of-range view ────────────────────────────
                  : _CheckInBody(
                key: const ValueKey('check_in_body'),
                visit: v,
                checkInState: checkInState,
                distance: distance,
                canCheckIn: canCheckIn,
              ),
            ),
          ),

          const StateToggle(),
        ],
      ),
    );
  }
}

// ── Normal check-in body (extracted to keep build method clean) ───────────────
class _CheckInBody extends StatelessWidget {
  final VisitModel visit;
  final CheckInState checkInState;
  final String distance;
  final bool canCheckIn;

  const _CheckInBody({
    super.key,
    required this.visit,
    required this.checkInState,
    required this.distance,
    required this.canCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Customer info header
          CheckInHeader(visit: visit),

          // Map area (~50% of content per spec)
          MapPlaceholder(checkInState: checkInState),

          const SizedBox(height: 12),

          // Distance indicator card
          DistanceCard(
            distance: distance,
            checkInState: checkInState,
          ),

          // Out-of-range banner (animated in/out)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: checkInState == CheckInState.outOfRange
                ? const OutOfRangeBanner(key: ValueKey('banner'))
                : const SizedBox.shrink(key: ValueKey('no_banner')),
          ),

          // Primary check-in button
          CheckInButton(
            isEnabled: canCheckIn,
            distance: distance,
            onPressed: () => context.pushNamed(
              AppRoutes.leadForm,
              // pathParameters: {'visitId': visit.id},
              // extra: visit,
            ),
          ),

          const SizedBox(height: 12),

          // Cancel Visit — secondary outlined button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () => showCancellationDialog(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: BorderSide(
                  color: AppTheme.error.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: const Text(
                'Cancel Visit',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
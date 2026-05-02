import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../providers/visit_provider.dart';
import '../widgets/date_selector.dart';
import '../widgets/notification_badge.dart';
import '../widgets/summary_chip.dart';
import '../widgets/visit_card.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../router/app_router.dart';

class VisitPlanScreen extends ConsumerStatefulWidget {
  const VisitPlanScreen({super.key});

  @override
  ConsumerState<VisitPlanScreen> createState() => _VisitPlanScreenState();
}

class _VisitPlanScreenState extends ConsumerState<VisitPlanScreen> {
  // Drives the shimmer → content transition.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allVisits = ref.watch(visitListProvider);
    final activeFilter = ref.watch(activeStatusFilterProvider);
    final pendingCount = ref.watch(totalPendingCountProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final visits = activeFilter == null
        ? allVisits
        : allVisits.where((v) => v.status == activeFilter).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary,
                AppTheme.primary.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'CRM Pocket Feed',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              AppDateUtils.formatDate(DateTime.now()),
              style: TextStyle(
                color: AppTheme.onPrimary.withValues(alpha: 0.75),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          NotificationBadge(count: pendingCount),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: Column(
        children: [
          // Date strip and summary chips are always visible — they give
          // the user something to interact with even during the shimmer.
          const DateSelector(),
          const SummaryChips(),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),


          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: _buildBody(context, visits, activeFilter),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoutes.addVisit),
        backgroundColor: AppTheme.secondary,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Visit',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      List visits,
      VisitStatus? activeFilter,
      ) {
    // ── State 1: Loading ───────────────────────────────────────────────
    if (_isLoading) {
      return const ShimmerVisitList(
        key: ValueKey('shimmer'),
        count: 6,
      );
    }

    // ── State 2: Loaded, empty ─────────────────────────────────────────
    if (visits.isEmpty) {
      return EmptyStateWidget(
        key: const ValueKey('empty'),
        icon: Icons.event_busy_outlined,
        title: activeFilter != null
            ? 'No ${AppTheme.statusLabel(activeFilter)} visits'
            : 'No visits planned',
        subtitle: activeFilter != null
            ? 'Try a different filter or tap "All".'
            : 'Plan your first visit for this day.',
        buttonText: activeFilter == null ? 'Plan a Visit' : null,
        onPressed: activeFilter == null
            ? () => context.pushNamed(AppRoutes.addVisit)
            : null,
      );
    }

    // ── State 3: Loaded, has data ──────────────────────────────────────
    return ListView.builder(
      key: const ValueKey('list'),
      padding: const EdgeInsets.only(top: 10, bottom: 100),
      itemCount: visits.length,
      itemBuilder: (context, index) {
        final visit = visits[index];
        return VisitCard(
          visit: visit,
          index: index,
          onTap: () => context.pushNamed(
            AppRoutes.visitDetail,
            pathParameters: {'id': visit.id},
            extra: visit,
          ),
        );
      },
    );
  }


}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/dashboard_lead_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../router/app_router.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_lead_card.dart';
import '../widgets/filter_bar.dart';
import '../widgets/lead_summary_chip.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredLeads = ref.watch(filteredLeadsProvider);
    final filters = ref.watch(dashboardFiltersProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primary, Color(0xFF1E4D87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lead Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: AppTheme.onPrimary,
              ),
            ),
            Text(
              'Manager View',
              style: TextStyle(
                color: Color(0xAAFFFFFF),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          // Active filter indicator
          if (!filters.isAllActive)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.secondary.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_list_rounded,
                          size: 13, color: AppTheme.onPrimary),
                      const SizedBox(width: 4),
                      Text(
                        '${filteredLeads.length} result${filteredLeads.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: AppTheme.onPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── Scrollable header + filter section ──────────────────────────
          const DashboardHeader(),
          const LeadSummaryChips(),
          const FilterBar(),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),

          // ── Animated lead list ───────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 380),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              // Key change on filter hash → AnimatedSwitcher plays transition
              child: filteredLeads.isEmpty
                  ? EmptyStateWidget(
                key: const ValueKey('empty'),
                icon: Icons.search_off_outlined,
                title: 'No leads match your filters',
                subtitle:
                'Try adjusting your filter selection or tap "All" to reset.',
                buttonText: filters.isAllActive ? null : 'Clear Filters',
                onPressed: filters.isAllActive
                    ? null
                    : () => ref
                    .read(dashboardProvider.notifier)
                    .clearFilters(),
              )
                  : _LeadList(
                key: ValueKey(filters),
                leads: filteredLeads,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Lead list — extracted to be the AnimatedSwitcher child ───────────────────

class _LeadList extends StatelessWidget {
  final List<DashboardLeadModel> leads;

  const _LeadList({super.key, required this.leads});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 40),
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];

        return DashboardLeadCard(
          lead: lead,
          index: index,
          onTap: () => context.pushNamed(
            AppRoutes.dashboardLeadDetail,
            pathParameters: {'id': lead.id},
            extra: lead,
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:japfa_pocket_feed/shared/widgets/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:japfa_pocket_feed/core/models/visit_model.dart';
import 'package:japfa_pocket_feed/features/visit_plan/providers/visit_plan_provider.dart';
import 'package:japfa_pocket_feed/shared/widgets/status_chip.dart';
import 'package:japfa_pocket_feed/shared/widgets/empty_state_widget.dart';

class VisitPlanScreen extends StatelessWidget {
  const VisitPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        margin: Responsive.horizontalPadding(context, false),
        child: Consumer<VisitPlanProvider>(
          builder: (context, provider, _) => CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, provider),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildSummaryRow(context, provider),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              _buildVisitSliver(context, provider),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  SliverAppBar _buildSliverAppBar(
    BuildContext context,
    VisitPlanProvider provider,
  ) {
    final today = DateFormat('MMMM d, yyyy').format(DateTime.now());
    return SliverAppBar(
      expandedHeight: 190,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A3A5C), Color(0xFF254E7A)],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Japfa Pocket Feed',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            today,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12.5,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      goToDashboard(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildDateStrip(context, provider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateStrip(BuildContext context, VisitPlanProvider provider) {
    final dates = List.generate(
      7,
      (i) => DateTime.now().add(Duration(days: i)),
    );
    return SizedBox(
      height: 68,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected =
              date.year == provider.selectedDate.year &&
              date.month == provider.selectedDate.month &&
              date.day == provider.selectedDate.day;
          final dayName = DateFormat('EEE').format(date);
          final dayNum = DateFormat('d').format(date);

          return GestureDetector(
            onTap: () => provider.selectDate(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 52,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: isSelected
                          ? const Color(0xFF1A3A5C)
                          : Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? const Color(0xFF1A3A5C)
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, VisitPlanProvider provider) {
    final counts = provider.statusCounts;
    final total = counts.values.fold(0, (a, b) => a + b);

    final statusMeta = {
      VisitStatus.pending: (
        label: 'Pending',
        color: const Color(0xFF78909C),
        bg: const Color(0xFFF0F4F7),
        icon: Icons.schedule_rounded,
      ),
      VisitStatus.inProgress: (
        label: 'In Progress',
        color: const Color(0xFFE65C00),
        bg: const Color(0xFFFFF4EC),
        icon: Icons.directions_run_rounded,
      ),
      VisitStatus.completed: (
        label: 'Completed',
        color: const Color(0xFF2E7D32),
        bg: const Color(0xFFEFF7EF),
        icon: Icons.check_circle_rounded,
      ),
      VisitStatus.cancelled: (
        label: 'Cancelled',
        color: const Color(0xFFC62828),
        bg: const Color(0xFFFFF0F0),
        icon: Icons.cancel_rounded,
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Overview",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF455A64),
                    letterSpacing: 0.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A3A5C).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$total Total Visits',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A3A5C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: counts.entries.map((e) {
              final meta = statusMeta[e.key]!;
              final isHighlighted = e.value > 0;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isHighlighted ? meta.bg : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isHighlighted
                          ? meta.color.withOpacity(0.25)
                          : const Color(0xFFE8EDF2),
                      width: 1.2,
                    ),
                    boxShadow: isHighlighted
                        ? [
                            BoxShadow(
                              color: meta.color.withOpacity(0.10),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: meta.color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(meta.icon, color: meta.color, size: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${e.value}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isHighlighted
                              ? meta.color
                              : const Color(0xFFB0BEC5),
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        meta.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: isHighlighted
                              ? meta.color.withOpacity(0.75)
                              : const Color(0xFFB0BEC5),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitSliver(BuildContext context, VisitPlanProvider provider) {
    final visits = provider.filteredVisits;
    if (visits.isEmpty) {
      return SliverFillRemaining(
        child: EmptyStateWidget(
          title: 'No visits planned for this day',
          actionLabel: 'Plan a Visit',
          onAction: () => context.push('/add-visit'),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${visits.length} Visit${visits.length != 1 ? 's' : ''} Scheduled',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF455A64),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const Icon(
                        Icons.swap_vert_rounded,
                        size: 18,
                        color: Color(0xFF90A4AE),
                      ),
                    ],
                  ),
                ),
                _visitCard(context, visits[index], index),
              ],
            );
          }
          return _visitCard(context, visits[index], index);
        }, childCount: visits.length),
      ),
    );
  }

  Widget _visitCard(BuildContext context, VisitModel visit, int index) {
    final timeStr = DateFormat('HH:mm').format(visit.scheduledTime);
    final segColor = _getSegmentColor(visit.segment);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (visit.status == VisitStatus.pending) {
              context.push('/check-in', extra: visit.id);
            } else {
              context.push('/visit-detail', extra: visit.id);
            }
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: segColor.withOpacity(0.07),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    _SegmentBadge(segment: visit.segment, color: segColor),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A3A5C).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: Color(0xFF1A3A5C),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeStr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A3A5C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: segColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.storefront_rounded,
                        color: segColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            visit.customerName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A2B3C),
                              letterSpacing: 0.1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.alt_route_rounded,
                                size: 13,
                                color: Color(0xFF90A4AE),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                visit.routeName,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF78909C),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusChip(status: visit.status),
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: Color(0xFFB0BEC5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.push('/lead-form'),
      backgroundColor: const Color(0xFF1A3A5C),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add, color: Colors.white, size: 26),
    );
  }

  Color _getSegmentColor(FeedSegment segment) {
    return switch (segment) {
      FeedSegment.poultry => const Color(0xFFE65100),
      FeedSegment.aqua => const Color(0xFF0277BD),
      FeedSegment.cattle => const Color(0xFF2E7D32),
      FeedSegment.pig => const Color(0xFF6A1B9A),
    };
  }
}

class goToDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.menu, color: Colors.white, size: 22),
            onPressed: () {
              context.push('/dashboard');
            },
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFFFF5252),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _SegmentBadge extends StatelessWidget {
  final FeedSegment segment;
  final Color color;
  const _SegmentBadge({required this.segment, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        segment.name,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

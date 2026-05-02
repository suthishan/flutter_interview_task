import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/mock/dashboard_mock_data.dart';
import '../../../core/models/dashboard_lead_model.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/remark_model.dart';

@immutable
class DashboardFilters {

  final Set<LeadClassification> classifications;
  final DateFilter dateFilter;

  const DashboardFilters({
    this.classifications = const {},
    this.dateFilter = DateFilter.none,
  });

  bool get isAllActive =>
      classifications.isEmpty && dateFilter == DateFilter.none;

  bool hasClassification(LeadClassification c) => classifications.contains(c);

  DashboardFilters copyWith({
    Set<LeadClassification>? classifications,
    DateFilter? dateFilter,
  }) {
    return DashboardFilters(
      classifications: classifications ?? this.classifications,
      dateFilter: dateFilter ?? this.dateFilter,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is DashboardFilters &&
              setEquals(other.classifications, classifications) &&
              other.dateFilter == dateFilter);

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(classifications),
    dateFilter,
  );
}

// ─── Dashboard State ──────────────────────────────────────────────────────────

@immutable
class DashboardState {
  /// Source-of-truth lead list (includes mutated remarks).
  final List<DashboardLeadModel> allLeads;
  final DashboardFilters filters;

  const DashboardState({
    required this.allLeads,
    this.filters = const DashboardFilters(),
  });

  List<DashboardLeadModel> get filteredLeads {
    var leads = [...allLeads];

    if (filters.classifications.isNotEmpty) {
      leads = leads
          .where((l) => filters.classifications.contains(l.classification))
          .toList();
    }

    // Apply date filter (AND with classification result)
    switch (filters.dateFilter) {
      case DateFilter.thisWeek:
        final cutoff = DateTime.now().subtract(const Duration(days: 7));
        leads = leads.where((l) => l.createdAt.isAfter(cutoff)).toList();
      case DateFilter.thisMonth:
        final now = DateTime.now();
        leads = leads
            .where((l) =>
        l.createdAt.year == now.year &&
            l.createdAt.month == now.month)
            .toList();
      case DateFilter.none:
        break;
    }

    // Priority queue: HOT → WARM → COLD; newest first within each group
    final hot = leads
        .where((l) => l.classification == LeadClassification.hot)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final warm = leads
        .where((l) => l.classification == LeadClassification.warm)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final cold = leads
        .where((l) => l.classification == LeadClassification.cold)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return [...hot, ...warm, ...cold];
  }

  // ── Derived: per-classification counts (all leads, ignoring filters) ──────
  Map<LeadClassification, int> get classificationCounts {
    return {
      for (final c in LeadClassification.values)
        c: allLeads.where((l) => l.classification == c).length,
    };
  }

  DashboardState copyWith({
    List<DashboardLeadModel>? allLeads,
    DashboardFilters? filters,
  }) {
    return DashboardState(
      allLeads: allLeads ?? this.allLeads,
      filters: filters ?? this.filters,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier()
      : super(DashboardState(allLeads: DashboardMockData.leads));

  // ── Filter actions ─────────────────────────────────────────────────────────

  /// Toggle a classification filter.
  /// If toggling makes the set empty (all deselected), stays at "show all".
  void toggleClassification(LeadClassification c) {
    final current = Set<LeadClassification>.from(state.filters.classifications);
    if (current.contains(c)) {
      current.remove(c);
    } else {
      current.add(c);
    }
    state = state.copyWith(
      filters: state.filters.copyWith(classifications: current),
    );
  }

  /// Toggle 'This Week' date filter (clears 'This Month' if active).
  void toggleThisWeek() {
    final next = state.filters.dateFilter == DateFilter.thisWeek
        ? DateFilter.none
        : DateFilter.thisWeek;
    state = state.copyWith(
      filters: state.filters.copyWith(dateFilter: next),
    );
  }

  /// Toggle 'This Month' date filter (clears 'This Week' if active).
  void toggleThisMonth() {
    final next = state.filters.dateFilter == DateFilter.thisMonth
        ? DateFilter.none
        : DateFilter.thisMonth;
    state = state.copyWith(
      filters: state.filters.copyWith(dateFilter: next),
    );
  }

  /// Clear all active filters — resets to "All".
  void clearFilters() {
    state = state.copyWith(filters: const DashboardFilters());
  }

  // ── Lead remark actions ────────────────────────────────────────────────────

  /// Appends [remark] to the target lead's timeline and clears the
  /// unread indicator (manager just added a remark → considered read).
  ///
  /// Spec: "Adding a remark updates the timeline immediately (local state)"
  void addRemark(String leadId, RemarkModel remark) {
    final updated = state.allLeads.map((l) {
      if (l.id != leadId) return l;
      return l.copyWith(
        remarksTimeline: [...l.remarksTimeline, remark],
        hasUnreadRemarks: false,
      );
    }).toList();
    state = state.copyWith(allLeads: updated);
  }

  /// Returns the current (possibly mutated) version of a lead by ID.
  DashboardLeadModel? getLead(String id) =>
      state.allLeads.cast<DashboardLeadModel?>().firstWhere(
            (l) => l?.id == id,
        orElse: () => null,
      );
}

// ─── Providers ────────────────────────────────────────────────────────────────

/// Root dashboard provider. Do NOT autodispose — manager may navigate
/// away and back; we want filter state preserved within the session.
final dashboardProvider =
StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(),
);

/// Filtered + priority-sorted leads — derived, always in sync.
final filteredLeadsProvider = Provider<List<DashboardLeadModel>>((ref) {
  return ref.watch(dashboardProvider).filteredLeads;
});

/// Per-classification counts (for the summary row chips).
final leadCountsProvider = Provider<Map<LeadClassification, int>>((ref) {
  return ref.watch(dashboardProvider).classificationCounts;
});

/// Active filters — used by [FilterBar] to highlight selected chips.
final dashboardFiltersProvider = Provider<DashboardFilters>((ref) {
  return ref.watch(dashboardProvider).filters;
});
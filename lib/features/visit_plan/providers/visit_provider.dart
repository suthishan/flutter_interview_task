import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/mock/visit_mock_data.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/utils/date_utils.dart';

// ─── Selected date (drives the whole screen) ─────────────────────────────────
final selectedDateProvider = StateProvider<DateTime>(
      (ref) => DateTime.now(),
);

// ─── Full visit list (single source of truth from mock) ──────────────────────
// Keeping mock data access in one place — if the source changes to an API
// later, only this provider needs updating.
final allVisitsProvider = Provider<List<VisitModel>>(
      (ref) => VisitMockData.visits,
);

final activeStatusFilterProvider = StateProvider<VisitStatus?>((ref) => null);
// ─── Filtered + sorted list for the selected date ────────────────────────────
final visitListProvider = Provider<List<VisitModel>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final allVisits = ref.watch(allVisitsProvider);

  return allVisits
      .where((v) => AppDateUtils.isSameDay(v.scheduledTime, selectedDate))
      .toList()
    ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
});

// ─── Summary counts for the selected date ────────────────────────────────────
// Always initialises every status to 0 so chips render even with no data.
final visitSummaryProvider = Provider<Map<VisitStatus, int>>((ref) {
  final visits = ref.watch(visitListProvider);

  final summary = {
    for (final s in VisitStatus.values) s: 0,
  };

  for (final visit in visits) {
    summary[visit.status] = (summary[visit.status] ?? 0) + 1;
  }

  return summary;
});

// ─── Total pending across ALL dates (AppBar badge) ───────────────────────────
final totalPendingCountProvider = Provider<int>((ref) {
  return ref
      .watch(allVisitsProvider)
      .where((v) => v.status == VisitStatus.pending)
      .length;
});

// ─── Dates that have at least one visit (for dot indicators on date strip) ───
final datesWithVisitsProvider = Provider<Set<String>>((ref) {
  return ref
      .watch(allVisitsProvider)
      .map((v) => AppDateUtils.dateKey(v.scheduledTime))
      .toSet();
});
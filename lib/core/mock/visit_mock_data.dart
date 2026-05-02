import '../models/enums.dart';
import '../models/visit_model.dart';

class VisitMockData {
  static final DateTime _today = DateTime.now();
  static final DateTime _yesterday = DateTime.now().subtract(const Duration(days: 1));
  // tomorrow is intentionally skipped → empty state
  static final DateTime _dayAfter = DateTime.now().add(const Duration(days: 2));

  static final List<VisitModel> visits = [
    // ── TODAY (5 visits) ───────────────────────────────────────────────
    VisitModel(
      id: 'v001',
      customerName: 'Ramesh Poultry Farm',
      routeName: 'Route A – North Zone',
      scheduledTime: _today.copyWith(hour: 9, minute: 0),
      segment: FeedSegment.poultry,
      status: VisitStatus.completed,
    ),
    VisitModel(
      id: 'v002',
      customerName: 'Blue Ocean Aqua',
      routeName: 'Route B – Coastal',
      scheduledTime: _today.copyWith(hour: 11, minute: 30),
      segment: FeedSegment.aqua,
      status: VisitStatus.inProgress,
    ),
    VisitModel(
      id: 'v003',
      customerName: 'Green Valley Cattle',
      routeName: 'Route C – South Zone',
      scheduledTime: _today.copyWith(hour: 13, minute: 0),
      segment: FeedSegment.cattle,
      status: VisitStatus.pending,
    ),
    VisitModel(
      id: 'v004',
      customerName: 'Sunrise Pig Farm',
      routeName: 'Route D – West Zone',
      scheduledTime: _today.copyWith(hour: 15, minute: 0),
      segment: FeedSegment.pig,
      status: VisitStatus.cancelled,
    ),
    VisitModel(
      id: 'v005',
      customerName: 'Kumar Poultry House',
      routeName: 'Route A – North Zone',
      scheduledTime: _today.copyWith(hour: 16, minute: 30),
      segment: FeedSegment.poultry,
      status: VisitStatus.pending,
    ),

    // ── YESTERDAY (2 visits) ───────────────────────────────────────────
    VisitModel(
      id: 'v006',
      customerName: 'Patel Aqua Industries',
      routeName: 'Route B – Coastal',
      scheduledTime: _yesterday.copyWith(hour: 10, minute: 0),
      segment: FeedSegment.aqua,
      status: VisitStatus.completed,
    ),
    VisitModel(
      id: 'v007',
      customerName: 'Sharma Cattle Co.',
      routeName: 'Route C – South Zone',
      scheduledTime: _yesterday.copyWith(hour: 14, minute: 0),
      segment: FeedSegment.cattle,
      status: VisitStatus.completed,
    ),

    // ── DAY AFTER TOMORROW (2 visits) ─────────────────────────────────
    VisitModel(
      id: 'v008',
      customerName: 'Singh Pig Farms',
      routeName: 'Route D – West Zone',
      scheduledTime: _dayAfter.copyWith(hour: 9, minute: 30),
      segment: FeedSegment.pig,
      status: VisitStatus.pending,
    ),
    VisitModel(
      id: 'v009',
      customerName: 'Reddy Poultry Complex',
      routeName: 'Route A – North Zone',
      scheduledTime: _dayAfter.copyWith(hour: 12, minute: 0),
      segment: FeedSegment.poultry,
      status: VisitStatus.pending,
    ),

  ];
}
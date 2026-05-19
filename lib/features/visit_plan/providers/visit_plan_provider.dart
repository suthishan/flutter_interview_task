import 'package:flutter/foundation.dart';
import 'package:japfa_pocket_feed/core/mocks/mock_visits.dart';
import 'package:japfa_pocket_feed/core/models/visit_model.dart';

class VisitPlanProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  final List<VisitModel> _allVisits = MockVisits.getVisits();

  DateTime get selectedDate => _selectedDate;
  List<VisitModel> get filteredVisits => _allVisits
      .where(
        (v) =>
            v.scheduledTime.year == _selectedDate.year &&
            v.scheduledTime.month == _selectedDate.month &&
            v.scheduledTime.day == _selectedDate.day,
      )
      .toList();

  Map<VisitStatus, int> get statusCounts {
    Map<VisitStatus, int> counts = {
      VisitStatus.pending: 0,
      VisitStatus.inProgress: 0,
      VisitStatus.completed: 0,
      VisitStatus.cancelled: 0,
    };
    for (var visit in filteredVisits) {
      counts[visit.status] = (counts[visit.status] ?? 0) + 1;
    }
    return counts;
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}

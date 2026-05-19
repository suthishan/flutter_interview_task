import 'package:flutter/foundation.dart';
import 'package:japfa_pocket_feed/core/mocks/%20mock_leads.dart';
import 'package:japfa_pocket_feed/core/models/lead_model.dart';
import 'package:japfa_pocket_feed/core/models/remark_model.dart';

class DashboardProvider extends ChangeNotifier {
  final List<LeadModel> _allLeads = MockLeads.getLeads();
  final Set<String> _activeFilters = {'All'};

  List<LeadModel> get allLeads => _allLeads;
  Set<String> get activeFilters => _activeFilters;

  int get hotCount =>
      _allLeads.where((l) => l.classification == LeadClassification.hot).length;
  int get warmCount => _allLeads
      .where((l) => l.classification == LeadClassification.warm)
      .length;
  int get coldCount => _allLeads
      .where((l) => l.classification == LeadClassification.cold)
      .length;

  List<LeadModel> get filteredLeads {
    var leads = List<LeadModel>.from(_allLeads);

    if (!_activeFilters.contains('All')) {
      leads = leads.where((l) {
        if (_activeFilters.contains('Hot') &&
            l.classification == LeadClassification.hot)
          return true;
        if (_activeFilters.contains('Warm') &&
            l.classification == LeadClassification.warm)
          return true;
        if (_activeFilters.contains('Cold') &&
            l.classification == LeadClassification.cold)
          return true;
        return false;
      }).toList();
    }

    leads.sort((a, b) {
      bool aHot = a.classification == LeadClassification.hot;
      bool bHot = b.classification == LeadClassification.hot;
      if (aHot && !bHot) return -1;
      if (!aHot && bHot) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return leads;
  }

  void toggleFilter(String filter) {
    if (filter == 'All') {
      _activeFilters.clear();
      _activeFilters.add('All');
    } else {
      _activeFilters.remove('All');
      if (_activeFilters.contains(filter)) {
        _activeFilters.remove(filter);
      } else {
        _activeFilters.add(filter);
      }
      if (_activeFilters.isEmpty) {
        _activeFilters.add('All');
      }
    }
    notifyListeners();
  }

  void addRemark(String leadId, String remarkText) {
    final leadIndex = _allLeads.indexWhere((l) => l.id == leadId);
    if (leadIndex != -1) {
      final lead = _allLeads[leadIndex];
      lead.remarks!.add(
        RemarkModel(
          id: 'R_${DateTime.now().millisecondsSinceEpoch}',
          authorName: 'Manager',
          authorRole: 'Manager',
          timestamp: DateTime.now(),
          text: remarkText,
        ),
      );
      notifyListeners();
    }
  }
}

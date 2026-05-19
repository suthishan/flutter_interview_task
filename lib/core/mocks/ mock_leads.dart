import 'package:japfa_pocket_feed/core/models/lead_model.dart';
import 'package:japfa_pocket_feed/core/models/remark_model.dart';

class MockLeads {
  static List<LeadModel> getLeads() {
    return [
      _createLead(
        id: 'L1',
        name: 'A1 Poultry Farm',
        area: 'Sector 4',
        segment: FeedSegment.poultry,
        type: CustomerType.farmer,
        classification: LeadClassification.hot,
        officer: 'Amit S.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        hasRemarks: true,
      ),
      _createLead(
        id: 'L2',
        name: 'Aqua Tech Solutions',
        area: 'Coastal Belt',
        segment: FeedSegment.aqua,
        type: CustomerType.dealer,
        classification: LeadClassification.warm,
        officer: 'Priya K.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        hasRemarks: false,
      ),
      _createLead(
        id: 'L3',
        name: 'Green Cattle',
        area: 'Dairy Zone',
        segment: FeedSegment.cattle,
        type: CustomerType.integrator,
        classification: LeadClassification.hot,
        officer: 'Amit S.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        hasRemarks: true,
      ),
      _createLead(
        id: 'L4',
        name: 'Modern Pig Farm',
        area: 'Pig Colony',
        segment: FeedSegment.pig,
        type: CustomerType.farmer,
        classification: LeadClassification.cold,
        officer: 'Ravi P.',
        date: DateTime.now().subtract(const Duration(days: 10)),
        hasRemarks: false,
      ),
      _createLead(
        id: 'L5',
        name: 'Shree Poultry',
        area: 'Sector 9',
        segment: FeedSegment.poultry,
        type: CustomerType.farmer,
        classification: LeadClassification.warm,
        officer: 'Priya K.',
        date: DateTime.now().subtract(const Duration(days: 5)),
        hasRemarks: false,
      ),
    ];
  }

  static LeadModel _createLead({
    required String id,
    required String name,
    required String area,
    required FeedSegment segment,
    required CustomerType type,
    required LeadClassification classification,
    required String officer,
    required DateTime date,
    bool hasRemarks = false,
  }) {
    final remarks = hasRemarks
        ? [
            RemarkModel(
              id: 'R1',
              authorName: 'Amit S.',
              authorRole: 'Sales Officer',
              timestamp: date.add(const Duration(hours: 2)),
              text: 'Customer interested in premium feed for next cycle.',
            ),
            RemarkModel(
              id: 'R2',
              authorName: 'System',
              authorRole: 'Manager',
              timestamp: date.add(const Duration(hours: 5)),
              text: 'Approved. Send brochure.',
            ),
          ]
        : <RemarkModel>[];

    return LeadModel(
      id: id,
      createdAt: date,
      area: area,
      segment: segment,
      customerType: type,
      classification: classification,
      segmentFields: {},
      remarks: remarks,
      name: name,
      officer: officer,
    );
  }
}

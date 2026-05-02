import '../models/dashboard_lead_model.dart';
import '../models/enums.dart';
import '../models/remark_model.dart';


/// Mock leads for the Manager Lead Dashboard (Task 5).
///
/// Provides 10 leads covering:
///   - All 3 classifications (HOT / WARM / COLD)
///   - All 4 segments (Poultry / Aqua / Cattle / Pig)
///   - 3 Sales Officers
///   - Leads created this week, this month, and older
///   - Remarks on several leads (for timeline testing)
///   - Unread remark indicators on a subset
class DashboardMockData {
  DashboardMockData._();

  static final DateTime _now = DateTime.now();

  static DateTime _daysAgo(int d) => _now.subtract(Duration(days: d));

  // ── Shared remark authors ─────────────────────────────────────────────────

  static const String _mgr = 'Rajesh Kumar';
  static const String _so1 = 'Amit Patel';
  static const String _so2 = 'Priya Sharma';
  static const String _so3 = 'Vikram Singh';

  static final List<DashboardLeadModel> leads = [
    // ── HOT leads (always appear first in the list) ────────────────────────

    DashboardLeadModel(
      id: 'dl001',
      createdAt: _daysAgo(1),
      customerName: 'Ramesh Poultry Farm',
      area: 'Anand, Gujarat',
      segment: FeedSegment.poultry,
      customerType: CustomerType.farmer,
      classification: LeadClassification.hot,
      salesOfficerName: _so1,
      segmentFields: {
        'flockSize': '15000',
        'birdAge': '3',
        'currentFeedBrand': 'Local Brand',
      },
      formRemarks: 'Customer is actively looking to switch brands.',
      hasUnreadRemarks: true,
      remarksTimeline: [
        RemarkModel(
          id: 'r001a',
          authorName: _so1,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(1).copyWith(hour: 9, minute: 15),
          text:
          'Visited the farm. Owner is keen on switching. Currently using local brand at ₹28/kg. We can offer ₹26/kg for same quality.',
        ),
        RemarkModel(
          id: 'r001b',
          authorName: _mgr,
          authorRole: 'Manager',
          timestamp: _daysAgo(1).copyWith(hour: 11, minute: 0),
          text:
          'Good prospect. Offer the Q3 discount scheme. Schedule a demo feed trial next week.',
        ),
        RemarkModel(
          id: 'r001c',
          authorName: _so1,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(0).copyWith(hour: 8, minute: 30),
          text:
          'Demo trial confirmed for Monday. Owner wants to start with 500 kg trial batch.',
        ),
      ],
    ),

    DashboardLeadModel(
      id: 'dl002',
      createdAt: _daysAgo(2),
      customerName: 'Blue Horizon Aqua',
      area: 'Bharuch, Gujarat',
      segment: FeedSegment.aqua,
      customerType: CustomerType.integrator,
      classification: LeadClassification.hot,
      salesOfficerName: _so2,
      segmentFields: {
        'species': 'Shrimp',
        'pondArea': '45',
        'stockingDensity': '80',
      },
      formRemarks: 'Large integrator with 45 acres. High-value account.',
      hasUnreadRemarks: false,
      remarksTimeline: [
        RemarkModel(
          id: 'r002a',
          authorName: _so2,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(2).copyWith(hour: 10, minute: 0),
          text:
          'Met with procurement head. They manage 45 acres of shrimp ponds. Current vendor has supply delays.',
        ),
        RemarkModel(
          id: 'r002b',
          authorName: _mgr,
          authorRole: 'Manager',
          timestamp: _daysAgo(2).copyWith(hour: 14, minute: 0),
          text:
          'Priority account. Loop in the regional head. Prepare a formal proposal by Friday.',
        ),
      ],
    ),

    DashboardLeadModel(
      id: 'dl003',
      createdAt: _daysAgo(3),
      customerName: 'Sunrise Cattle Farms',
      area: 'Mehsana, Gujarat',
      segment: FeedSegment.cattle,
      customerType: CustomerType.dealer,
      classification: LeadClassification.hot,
      salesOfficerName: _so3,
      segmentFields: {
        'herdSize': '320',
        'cattleType': 'Dairy',
        'milkYield': '22',
      },
      hasUnreadRemarks: true,
      remarksTimeline: [
        RemarkModel(
          id: 'r003a',
          authorName: _so3,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(3).copyWith(hour: 11, minute: 30),
          text: 'Large dairy dealer. 320 head. Interested in mineral mix range.',
        ),
        RemarkModel(
          id: 'r003b',
          authorName: _so3,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(1).copyWith(hour: 16, minute: 0),
          text:
          'Follow-up done. Owner wants pricing for bulk 10-tonne orders.',
        ),
      ],
    ),

    // ── WARM leads ────────────────────────────────────────────────────────

    DashboardLeadModel(
      id: 'dl004',
      createdAt: _daysAgo(5),
      customerName: 'Green Pasture Pig Farm',
      area: 'Surat, Gujarat',
      segment: FeedSegment.pig,
      customerType: CustomerType.farmer,
      classification: LeadClassification.warm,
      salesOfficerName: _so1,
      segmentFields: {
        'herdSize': '450',
        'stage': 'Finisher',
      },
      formRemarks: 'Showed interest in starter and finisher range.',
      hasUnreadRemarks: false,
      remarksTimeline: [
        RemarkModel(
          id: 'r004a',
          authorName: _so1,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(5).copyWith(hour: 14, minute: 0),
          text:
          'Farm has 450 pigs in finisher stage. Currently using a competitor. Not fully committed yet.',
        ),
        RemarkModel(
          id: 'r004b',
          authorName: _mgr,
          authorRole: 'Manager',
          timestamp: _daysAgo(4).copyWith(hour: 9, minute: 0),
          text: 'Send the pig nutrition brochure and schedule a vet visit.',
        ),
      ],
    ),

    DashboardLeadModel(
      id: 'dl005',
      createdAt: _daysAgo(7),
      customerName: 'Delta Aqua Solutions',
      area: 'Valsad, Gujarat',
      segment: FeedSegment.aqua,
      customerType: CustomerType.distributor,
      classification: LeadClassification.warm,
      salesOfficerName: _so2,
      segmentFields: {
        'species': 'Fish',
        'pondArea': '18',
        'stockingDensity': '60',
      },
      hasUnreadRemarks: true,
      remarksTimeline: [
        RemarkModel(
          id: 'r005a',
          authorName: _so2,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(7).copyWith(hour: 10, minute: 45),
          text: 'Fish culture distributor. Covers 12 panchayats. Potential for bulk tie-up.',
        ),
        RemarkModel(
          id: 'r005b',
          authorName: _so2,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(1).copyWith(hour: 17, minute: 30),
          text: 'Revisited. Needs credit terms of 30 days. Pending credit team approval.',
        ),
      ],
    ),

    DashboardLeadModel(
      id: 'dl006',
      createdAt: _daysAgo(10),
      customerName: 'Kumar Poultry Integrators',
      area: 'Nadiad, Gujarat',
      segment: FeedSegment.poultry,
      customerType: CustomerType.integrator,
      classification: LeadClassification.warm,
      salesOfficerName: _so3,
      segmentFields: {
        'flockSize': '8000',
        'birdAge': '5',
        'currentFeedBrand': 'Suguna',
      },
      hasUnreadRemarks: false,
      remarksTimeline: [
        RemarkModel(
          id: 'r006a',
          authorName: _so3,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(10).copyWith(hour: 9, minute: 0),
          text: 'Integrator with 6 contract farms. Currently with Suguna. Open to comparing.',
        ),
        RemarkModel(
            id: 'r006b',
            authorName: _mgr,
            authorRole: 'Manager',
            timestamp: _daysAgo(9).copyWith(hour: 11, minute: 0),
            text: "Competitive account. Don't reduce price further. Offer quality certification instead.",
        ),
      ],
    ),

    // ── COLD leads ────────────────────────────────────────────────────────

    DashboardLeadModel(
      id: 'dl007',
      createdAt: _daysAgo(15),
      customerName: 'Patel Cattle Ranch',
      area: 'Palanpur, Gujarat',
      segment: FeedSegment.cattle,
      customerType: CustomerType.farmer,
      classification: LeadClassification.cold,
      salesOfficerName: _so1,
      segmentFields: {
        'herdSize': '40',
        'cattleType': 'Beef',
        'milkYield': '0',
      },
      hasUnreadRemarks: false,
      remarksTimeline: [
        RemarkModel(
          id: 'r007a',
          authorName: _so1,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(15).copyWith(hour: 12, minute: 0),
          text: 'Small beef farm. 40 head. Not currently using formulated feed. Very early stage.',
        ),
      ],
    ),

    DashboardLeadModel(
      id: 'dl008',
      createdAt: _daysAgo(20),
      customerName: 'Singh Pig Enterprise',
      area: 'Rajkot, Gujarat',
      segment: FeedSegment.pig,
      customerType: CustomerType.farmer,
      classification: LeadClassification.cold,
      salesOfficerName: _so2,
      segmentFields: {
        'herdSize': '90',
        'stage': 'Grower',
      },
      hasUnreadRemarks: false,
      remarksTimeline: [
        RemarkModel(
          id: 'r008a',
          authorName: _so2,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(20).copyWith(hour: 14, minute: 30),
          text: 'New farmer, recently started. 90 grower pigs. No brand preference yet. Repository lead.',
        ),
      ],
    ),

    DashboardLeadModel(
      id: 'dl009',
      createdAt: _daysAgo(25),
      customerName: 'Reddy Fish Farm',
      area: 'Navsari, Gujarat',
      segment: FeedSegment.aqua,
      customerType: CustomerType.farmer,
      classification: LeadClassification.cold,
      salesOfficerName: _so3,
      segmentFields: {
        'species': 'Fish',
        'pondArea': '5',
        'stockingDensity': '40',
      },
      hasUnreadRemarks: false,
      remarksTimeline: [],
    ),

    DashboardLeadModel(
      id: 'dl010',
      createdAt: _daysAgo(28),
      customerName: 'Mehta Poultry House',
      area: 'Junagadh, Gujarat',
      segment: FeedSegment.poultry,
      customerType: CustomerType.farmer,
      classification: LeadClassification.cold,
      salesOfficerName: _so1,
      segmentFields: {
        'flockSize': '2000',
        'birdAge': '2',
        'currentFeedBrand': 'Local Mix',
      },
      hasUnreadRemarks: false,
      remarksTimeline: [
        RemarkModel(
          id: 'r010a',
          authorName: _so1,
          authorRole: 'Sales Officer',
          timestamp: _daysAgo(28).copyWith(hour: 10, minute: 0),
          text: 'Small farmer. 2000 birds. Uses homemade feed mix. Awareness stage only.',
        ),
        RemarkModel(
          id: 'r010b',
          authorName: _mgr,
          authorRole: 'Manager',
          timestamp: _daysAgo(27).copyWith(hour: 9, minute: 0),
          text: 'Add to newsletter list. Re-visit in Q2.',
        ),
      ],
    ),
  ];
}
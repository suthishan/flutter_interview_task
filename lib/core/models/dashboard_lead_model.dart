import 'package:flutter/foundation.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/remark_model.dart';

@immutable
class DashboardLeadModel {
  final String id;
  final DateTime createdAt;
  final String customerName;
  final String area;
  final String gpsCoordinates;
  final FeedSegment segment;
  final CustomerType customerType;
  final LeadClassification classification;
  final Map<String, String> segmentFields;

  /// Optional free-text remark captured during lead creation (Task 3).
  final String? formRemarks;

  /// Name of the Sales Officer who created this lead.
  final String salesOfficerName;

  /// Chronological list of manager/officer remarks — oldest first.
  final List<RemarkModel> remarksTimeline;

  /// True when the manager has not yet viewed the most recent remark
  /// from a Sales Officer (shown as an indicator dot on the card).
  final bool hasUnreadRemarks;

  const DashboardLeadModel({
    required this.id,
    required this.createdAt,
    required this.customerName,
    required this.area,
    this.gpsCoordinates = '22.3072° N, 73.1812° E',
    required this.segment,
    required this.customerType,
    required this.classification,
    this.segmentFields = const {},
    this.formRemarks,
    required this.salesOfficerName,
    this.remarksTimeline = const [],
    this.hasUnreadRemarks = false,
  });

  DashboardLeadModel copyWith({
    List<RemarkModel>? remarksTimeline,
    bool? hasUnreadRemarks,
    LeadClassification? classification,
    String? formRemarks,
  }) {
    return DashboardLeadModel(
      id: id,
      createdAt: createdAt,
      customerName: customerName,
      area: area,
      gpsCoordinates: gpsCoordinates,
      segment: segment,
      customerType: customerType,
      classification: classification ?? this.classification,
      segmentFields: segmentFields,
      formRemarks: formRemarks ?? this.formRemarks,
      salesOfficerName: salesOfficerName,
      remarksTimeline: remarksTimeline ?? this.remarksTimeline,
      hasUnreadRemarks: hasUnreadRemarks ?? this.hasUnreadRemarks,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is DashboardLeadModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
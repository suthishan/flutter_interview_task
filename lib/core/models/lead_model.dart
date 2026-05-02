// ─── Enums (exact spec values) ───────────────────────────────────────────────



import 'enums.dart';



// Spec: Farmer / Integrator / Dealer / Distributor


// ─── Lead Model ───────────────────────────────────────────────────────────────

class LeadModel {
  final String id;
  final DateTime createdAt;
  final String gpsCoordinates;
  final String area;
  final FeedSegment? segment;
  final CustomerType? customerType;
  final LeadClassification? classification;
  final Map<String, String> segmentFields;
  final String? remarks;

  LeadModel({
    String? id,
    DateTime? createdAt,
    this.gpsCoordinates = '22.3072° N, 73.1812° E',
    this.area = '',
    this.segment,
    this.customerType,
    this.classification,
    Map<String, String>? segmentFields,
    this.remarks,
  })  : id = id ?? 'L-${DateTime.now().millisecondsSinceEpoch}',
        createdAt = createdAt ?? DateTime.now(),
        segmentFields = segmentFields ?? {};

  LeadModel copyWith({
    String? area,
    FeedSegment? segment,
    bool clearSegment = false,
    CustomerType? customerType,
    LeadClassification? classification,
    Map<String, String>? segmentFields,
    String? remarks,
    bool clearRemarks = false,
  }) {
    return LeadModel(
      id: id,
      createdAt: createdAt,
      gpsCoordinates: gpsCoordinates,
      area: area ?? this.area,
      segment: clearSegment ? null : segment ?? this.segment,
      customerType: customerType ?? this.customerType,
      classification: classification ?? this.classification,
      segmentFields: segmentFields ?? this.segmentFields,
      remarks: clearRemarks ? null : remarks ?? this.remarks,
    );
  }
}
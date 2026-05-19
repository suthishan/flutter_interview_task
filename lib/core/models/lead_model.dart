import 'package:japfa_pocket_feed/core/models/remark_model.dart';

enum FeedSegment { poultry, aqua, cattle, pig }

enum LeadClassification { hot, warm, cold }

enum CustomerType { farmer, integrator, dealer, distributor }

class LeadModel {
  final String id;
  final String? name;
  final String? officer;

  final DateTime createdAt;
  final String area;
  final FeedSegment segment;
  final CustomerType customerType;
  final LeadClassification classification;
  final Map<String, dynamic> segmentFields;
  final List<RemarkModel>? remarks;

  LeadModel({
    required this.id,
    this.name,
    this.officer,
    required this.createdAt,
    required this.area,
    required this.segment,
    required this.customerType,
    required this.classification,
    required this.segmentFields,
    this.remarks,
  });
}

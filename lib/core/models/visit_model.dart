import 'enums.dart';




class VisitModel {
  final String id;
  final String customerName;
  final String routeName;
  final DateTime scheduledTime;
  final FeedSegment segment;
  final VisitStatus status;

  const VisitModel({
    required this.id,
    required this.customerName,
    required this.routeName,
    required this.scheduledTime,
    required this.segment,
    required this.status,
  });

  VisitModel copyWith({
    String? id,
    String? customerName,
    String? routeName,
    DateTime? scheduledTime,
    FeedSegment? segment,
    VisitStatus? status,
  }) {
    return VisitModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      routeName: routeName ?? this.routeName,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      segment: segment ?? this.segment,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is VisitModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
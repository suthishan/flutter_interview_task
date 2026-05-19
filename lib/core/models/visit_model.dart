enum VisitStatus { pending, inProgress, completed, cancelled }

enum FeedSegment { poultry, aqua, cattle, pig }

class VisitModel {
  final String id;
  final String customerName;
  final String routeName;
  final DateTime scheduledTime;
  final FeedSegment segment;
  final VisitStatus status;

  VisitModel({
    required this.id,
    required this.customerName,
    required this.routeName,
    required this.scheduledTime,
    required this.segment,
    required this.status,
  });
}

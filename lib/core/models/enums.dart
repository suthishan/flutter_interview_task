enum FeedSegment { poultry, aqua, cattle, pig }
enum CheckInState {
  withinRange,    // 45 m — check-in button ACTIVE
  outOfRange,     // 320 m — button DISABLED, out-of-range banner shown
  gpsUnavailable, // N/A — full-screen GPS error state
}
enum UploadState { empty, loading, uploaded, error }
enum LeadClassification { hot, warm, cold }
enum CustomerType { farmer, integrator, dealer, distributor }
enum VisitStatus { pending, inProgress, completed, cancelled }
enum CancelReason {
  customerUnavailable('Customer not available'),
  visitPostponed('Visit postponed by customer'),
  other('Other');

  final String label;
  const CancelReason(this.label);
}

enum DateFilter { none, thisWeek, thisMonth }
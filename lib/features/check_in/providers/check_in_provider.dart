import 'package:flutter/foundation.dart';
import 'package:japfa_pocket_feed/core/models/check_in_model.dart';

class CheckInProvider extends ChangeNotifier {
  CheckInState _state = CheckInState.withinRange;
  double _mockDistance = 45;
  final String _customerName = 'A1 Poultry Farm';
  final String _routeName = 'Route A';
  final DateTime _plannedTime = DateTime(2026, 5, 18, 9, 0);
  final CheckInLocation _location = CheckInLocation(
    latitude: 28.6139,
    longitude: 77.2090,
  );

  CheckInState get state => _state;
  double get distance => _mockDistance;
  String get customerName => _customerName;
  String get routeName => _routeName;
  DateTime get plannedTime => _plannedTime;
  CheckInLocation get location => _location;
  bool get canCheckIn => _state == CheckInState.withinRange;

  void toggleMockState(CheckInState newState) {
    _state = newState;
    _mockDistance = switch (newState) {
      CheckInState.withinRange => 45,
      CheckInState.outOfRange => 320,
      CheckInState.gpsUnavailable => 0,
    };
    notifyListeners();
  }

  void cancelVisit(String reason) {
    debugPrint('Visit cancelled: $reason');
  }
}

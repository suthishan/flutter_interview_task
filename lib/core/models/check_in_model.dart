

/// App-wide check-in constants — single source of truth.
/// Change geofence radius here and every widget updates automatically.
class CheckInConstants {
  CheckInConstants._();

  /// Geofence radius in metres (per spec: 100 m).
  static const int geofenceRadiusMetres = 100;

  /// Mock customer coordinates (Ahmedabad, Gujarat).
  static const double customerLat = 23.0225;
  static const double customerLng = 72.5714;
}
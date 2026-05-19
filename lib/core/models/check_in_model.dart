enum CheckInState { withinRange, outOfRange, gpsUnavailable }

class CheckInLocation {
  final double latitude;
  final double longitude;
  final double geofenceRadius;

  CheckInLocation({
    required this.latitude,
    required this.longitude,
    this.geofenceRadius = 100,
  });
}

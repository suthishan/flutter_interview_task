import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/check_in_model.dart';
import '../../../core/models/enums.dart';

// ─── Mock GPS state toggle ────────────────────────────────────────────────────
// Drives the entire check-in screen. Evaluator switches between states
// using the StateToggle widget at the bottom of the screen.
final checkInStateProvider = StateProvider<CheckInState>(
      (ref) => CheckInState.withinRange,
);

// ─── Distance display text (derived from mock state) ─────────────────────────
// Returns the correct mocked distance string for each toggle state.
// The spec explicitly requires: 45m / 320m / N/A.
final distanceProvider = Provider<String>((ref) {
  return switch (ref.watch(checkInStateProvider)) {
    CheckInState.withinRange => '45 m',
    CheckInState.outOfRange => '320 m',
    CheckInState.gpsUnavailable => 'N/A',
  };
});

// ─── Distance in metres (numeric, for UI logic) ───────────────────────────────
// The geofence radius is 100 m per spec. Used to decide button enable state
// and distance indicator colour.
final distanceMetresProvider = Provider<int?>((ref) {
  return switch (ref.watch(checkInStateProvider)) {
    CheckInState.withinRange => 45,
    CheckInState.outOfRange => 320,
    CheckInState.gpsUnavailable => null, // null = GPS unavailable
  };
});

// ─── Check-in button enabled (within geofence) ────────────────────────────────
final canCheckInProvider = Provider<bool>((ref) {
  final metres = ref.watch(distanceMetresProvider);
  if (metres == null) return false;
  return metres <= CheckInConstants.geofenceRadiusMetres;
});

// ─── Cancellation reason (for Cancel Visit dialog) ───────────────────────────
// null = no reason selected yet
final cancelReasonProvider = StateProvider<CancelReason?>((ref) => null);

// ─── "Other" free-text reason ─────────────────────────────────────────────────
final cancelOtherTextProvider = StateProvider<String>((ref) => '');
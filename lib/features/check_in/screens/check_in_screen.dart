import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:japfa_pocket_feed/shared/widgets/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:japfa_pocket_feed/core/models/check_in_model.dart';
import 'package:japfa_pocket_feed/features/check_in/providers/check_in_provider.dart';
import 'package:japfa_pocket_feed/features/check_in/widgets/confirmation_dialog.dart';
import 'package:japfa_pocket_feed/shared/widgets/map_placeholder.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInScreen extends StatelessWidget {
  final String? visitId;

  const CheckInScreen({super.key, this.visitId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check In')),
      body: Container(
        margin: Responsive.horizontalPadding(context, false),
        child: Consumer<CheckInProvider>(
          builder: (context, provider, _) {
            if (provider.state == CheckInState.gpsUnavailable) {
              return _buildGpsUnavailable(context, provider);
            }
            return Column(
              children: [
                _buildHeader(context, provider),
                _buildMapArea(context, provider),
                _buildDistanceCard(context, provider),
                const Spacer(),
                _buildActionButtons(context, provider),
                _buildMockToggle(context, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CheckInProvider provider) {
    final timeStr = DateFormat(
      'EEE, MMM d • HH:mm',
    ).format(provider.plannedTime);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider.customerName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            '${provider.routeName} • $timeStr',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMapArea(BuildContext context, CheckInProvider provider) {
    return MapPlaceholder(
      location: provider.location,
      distance: provider.distance,
      isWithinRange: provider.canCheckIn,
    );
  }

  Widget _buildDistanceCard(BuildContext context, CheckInProvider provider) {
    final theme = Theme.of(context);
    final inRange = provider.canCheckIn;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: inRange ? theme.colorScheme.primary : theme.colorScheme.error,
        ),
      ),
      child: Row(
        children: [
          Icon(
            inRange ? Icons.check_circle : Icons.warning_amber_rounded,
            color: inRange
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inRange ? 'Within check-in zone' : 'Outside check-in zone',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  inRange
                      ? 'You can check in now'
                      : 'Move closer to the customer location',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${provider.distance}m',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: inRange
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, CheckInProvider provider) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.canCheckIn
                  ? () => _showCheckInSuccess(context)
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: provider.canCheckIn
                    ? theme.colorScheme.primary
                    : Colors.grey,
              ),
              child: Text(
                provider.canCheckIn
                    ? 'Check In Now'
                    : '${provider.distance}m away',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showCancelDialog(context, provider),
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Cancel Visit'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockToggle(BuildContext context, CheckInProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Text(
            'Mock GPS State (for demo)',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<CheckInState>(
            segments: const [
              ButtonSegment(
                value: CheckInState.withinRange,
                label: Text('Within'),
              ),
              ButtonSegment(value: CheckInState.outOfRange, label: Text('Out')),
              ButtonSegment(
                value: CheckInState.gpsUnavailable,
                label: Text('GPS Off'),
              ),
            ],
            selected: {provider.state},
            onSelectionChanged: (Set<CheckInState> selected) {
              provider.toggleMockState(selected.first);
            },
            showSelectedIcon: false,
          ),
        ],
      ),
    );
  }

  Widget _buildGpsUnavailable(BuildContext context, CheckInProvider provider) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gps_off_rounded,
              size: 80,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text('GPS Unavailable', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              'Enable location services to check in at customer sites.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () =>
                  provider.toggleMockState(CheckInState.withinRange),
              icon: const Icon(Icons.settings),
              label: const Text('Enable GPS'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, CheckInProvider provider) {
    showDialog(
      context: context,
      builder: (_) => Container(
        margin: Responsive.horizontalPadding(context, false),
        child: ConfirmationDialog(
          onConfirm: (reason) {
            provider.cancelVisit(reason);
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Visit cancelled: $reason')));
            // context.push('/');
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showCheckInSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Checked in successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

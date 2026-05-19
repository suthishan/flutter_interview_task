import 'package:flutter/material.dart';
import 'package:japfa_pocket_feed/core/models/check_in_model.dart';

class MapPlaceholder extends StatelessWidget {
  final CheckInLocation location;
  final double distance;
  final bool isWithinRange;

  const MapPlaceholder({
    super.key,
    required this.location,
    required this.distance,
    required this.isWithinRange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: isWithinRange ? 160 : 100,
            height: isWithinRange ? 120 : 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isWithinRange
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
                width: 2,
              ),
              color:
                  (isWithinRange
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error)
                      .withOpacity(0.1),
            ),
          ),
          const Icon(Icons.location_on, color: Colors.red, size: 32),
          Positioned(
            right: 40,
            bottom: 40,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: const Icon(
                Icons.person_pin_circle,
                color: Colors.blue,
                size: 24,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            child: Text(
              '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

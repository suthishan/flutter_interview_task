import 'package:flutter/material.dart';

import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';

/// Segment badge — distinct color + icon per [FeedSegment].
///
/// All colors come from dedicated [AppTheme] segment tokens.
/// No hardcoded hex values anywhere in this widget.
///
/// Used in: [VisitCard], [VisitDetailScreen], KYC screen header.
class SegmentBadge extends StatelessWidget {
  final FeedSegment segment;

  /// When true, renders a slightly larger badge with more padding.
  /// Useful on detail screens where space is not a constraint.
  final bool large;

  const SegmentBadge({
    super.key,
    required this.segment,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _configFor(segment);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 14 : 10,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: config.color.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: large ? 14 : 12,
            color: config.color,
          ),
          const SizedBox(width: 5),
          Text(
            config.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: config.color,
              fontSize: large ? 12 : 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  static _SegmentConfig _configFor(FeedSegment segment) => switch (segment) {
    FeedSegment.poultry => _SegmentConfig(
      label: 'Poultry',
      color: AppTheme.segmentPoultry,
      bgColor: AppTheme.segmentPoultryBg,
      icon: Icons.egg_outlined,
    ),
    FeedSegment.aqua => _SegmentConfig(
      label: 'Aqua',
      color: AppTheme.segmentAqua,
      bgColor: AppTheme.segmentAquaBg,
      icon: Icons.water_outlined,
    ),
    FeedSegment.cattle => _SegmentConfig(
      label: 'Cattle',
      color: AppTheme.segmentCattle,
      bgColor: AppTheme.segmentCattleBg,
      icon: Icons.agriculture_outlined,
    ),
    FeedSegment.pig => _SegmentConfig(
      label: 'Pig',
      color: AppTheme.segmentPig,
      bgColor: AppTheme.segmentPigBg,
      icon: Icons.pets_outlined,
    ),
  };
}

class _SegmentConfig {
  final String label;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _SegmentConfig({
    required this.label,
    required this.color,
    required this.bgColor,
    required this.icon,
  });
}
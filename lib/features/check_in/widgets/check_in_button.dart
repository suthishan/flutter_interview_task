import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Primary check-in action button.
///
/// FIX: original was a plain [ElevatedButton] with no width constraint,
/// incorrect disabled label, and no theme styling.
///
/// Spec requirements:
/// - ACTIVE: ElevatedButton, primary color — when within geofence radius
/// - DISABLED (greyed out): label shows "X metres away"
/// - Button must be un-tappable (not just visually greyed) — [onPressed: null]
///
/// Added: pulse animation ring when active to draw the officer's eye.
class CheckInButton extends StatefulWidget {
  final bool isEnabled;
  final String distance;
  final VoidCallback? onPressed;

  const CheckInButton({
    super.key,
    required this.isEnabled,
    required this.distance,
    this.onPressed,
  });

  @override
  State<CheckInButton> createState() => _CheckInButtonState();
}

class _CheckInButtonState extends State<CheckInButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.isEnabled) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CheckInButton old) {
    super.didUpdateWidget(old);
    if (widget.isEnabled && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isEnabled) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: widget.isEnabled ? _pulseAnimation.value : 1.0,
          child: child,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: widget.isEnabled
              ? FilledButton.icon(
            onPressed: widget.onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
              shadowColor: AppTheme.primary.withValues(alpha: 0.4),
            ),
            icon: const Icon(Icons.location_on_rounded, size: 20),
            label: const Text(
              'Check In',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          )
              : FilledButton.tonal(
            // onPressed: null makes it truly un-tappable (not just grey)
            onPressed: null,
              style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${widget.distance} away — move closer',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
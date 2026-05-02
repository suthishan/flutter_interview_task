import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';

/// Dashboard header card showing mocked manager name, team size, and date.
///
/// Spec: "Dashboard header: Manager name (mocked), team size, date"
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  // Mock manager data — in production would come from auth/profile provider
  static const String _managerName = 'Rajesh Kumar';
  static const int _teamSize = 3;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary,
            AppTheme.primary.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Avatar ───────────────────────────────────────────────────────
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.onPrimary.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.onPrimary.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                _initials(_managerName),
                style: const TextStyle(
                  color: AppTheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // ── Name + role ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _managerName,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppTheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Sales Manager',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppTheme.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 6),
                // Team size + date row
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetaBadge(
                      icon: Icons.group_outlined,
                      label: '$_teamSize Officers',
                    ),
                    _MetaBadge(
                      icon: Icons.calendar_today_outlined,
                      label: AppDateUtils.formatDate(DateTime.now()),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Manager role badge ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.secondary.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_outlined,
                  size: 12,
                  color: AppTheme.onPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Manager',
                  style: TextStyle(
                    color: AppTheme.onPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

// ── Small icon+label badge used inside the header ────────────────────────────

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppTheme.onPrimary.withValues(alpha: 0.7)),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.onPrimary.withValues(alpha: 0.75),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'ref_row.dart';

class ReferenceCard extends StatelessWidget {
  const ReferenceCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          RefRow(
            icon: Icons.person_outline,
            label: 'Customer',
            value: 'Ramesh Poultry Farm',
          ),
          const Divider(height: 16),
          RefRow(
            icon: Icons.tag,
            label: 'Lead No.',
            value: 'LEAD-2024-00142',
          ),
          const Divider(height: 16),
          RefRow(
            icon: Icons.upload_outlined,
            label: 'Documents',
            value: '3 of 3 mandatory uploaded',
            valueColor: AppTheme.success,
          ),
          const Divider(height: 16),
          RefRow(
            icon: Icons.access_time_outlined,
            label: 'Submitted',
            value: _formattedNow(),
          ),
        ],
      ),
    );
  }

  String _formattedNow() {
    final now = DateTime.now();
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final hour = now.hour > 12 ? now.hour - 12 : now.hour == 0 ? 12 : now.hour;
    final amPm = now.hour >= 12 ? 'PM' : 'AM';
    final min = now.minute.toString().padLeft(2, '0');
    return '${now.day} ${months[now.month - 1]} ${now.year}, $hour:$min $amPm';
  }
}

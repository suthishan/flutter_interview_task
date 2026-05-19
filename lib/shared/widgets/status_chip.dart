import 'package:flutter/material.dart';
import 'package:japfa_pocket_feed/core/models/visit_model.dart';

class StatusChip extends StatelessWidget {
  final VisitStatus status;

  const StatusChip({super.key, required this.status});

  Color _getStatusColor(BuildContext context) {
    return switch (status) {
      VisitStatus.pending => Colors.grey,
      VisitStatus.inProgress => Theme.of(context).colorScheme.secondary,
      VisitStatus.completed => Theme.of(context).colorScheme.primary,
      VisitStatus.cancelled => Theme.of(context).colorScheme.error,
    };
  }

  String _getLabel() {
    return switch (status) {
      VisitStatus.pending => 'Pending',
      VisitStatus.inProgress => 'In Progress',
      VisitStatus.completed => 'Completed',
      VisitStatus.cancelled => 'Cancelled',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(context).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _getLabel(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: _getStatusColor(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

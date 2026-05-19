import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmationDialog extends StatefulWidget {
  final ValueChanged<String> onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  String selectedReason = 'Customer unavailable';
  final TextEditingController otherController = TextEditingController();

  @override
  void dispose() {
    otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cancel Visit', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('Select a reason:', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            ...['Customer unavailable', 'Reschedule requested', 'Other'].map((
              reason,
            ) {
              return RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: selectedReason,
                onChanged: (val) {
                  setState(() {
                    selectedReason = val!;
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            }).toList(),
            if (selectedReason == 'Other') ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: otherController,
                decoration: const InputDecoration(
                  hintText: 'Specify reason',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 2,
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Go Back'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final finalReason = selectedReason == 'Other'
                        ? otherController.text.isNotEmpty
                              ? otherController.text
                              : 'Other'
                        : selectedReason;
                    widget.onConfirm(finalReason);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirm Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

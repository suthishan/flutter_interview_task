import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/kyc_provider.dart';

class SubmitBar extends StatelessWidget {
  final KycState state;
  final KycNotifier notifier;

  const SubmitBar({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final canSubmit = state.canSubmit;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: ElevatedButton(
        onPressed: canSubmit ? notifier.submit : null,
        child: state.isSubmitting
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          canSubmit
              ? 'Submit for Verification'
              : 'Upload mandatory documents to continue',
        ),
      ),
    );
  }
}
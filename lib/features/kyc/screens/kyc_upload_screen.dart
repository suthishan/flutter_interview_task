import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:japfa_pocket_feed/core/theme/app_theme.dart';
import 'package:japfa_pocket_feed/shared/widgets/responsive_utils.dart';
import 'package:japfa_pocket_feed/shared/widgets/section_header.dart';
import 'package:provider/provider.dart';
import 'package:japfa_pocket_feed/core/models/kyc_model.dart';
import 'package:japfa_pocket_feed/features/kyc/providers/kyc_provider.dart';
import 'package:japfa_pocket_feed/shared/widgets/upload_tile.dart';

class KycUploadScreen extends StatelessWidget {
  const KycUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload KYC')),
      body: Container(
        margin: Responsive.horizontalPadding(context, false),
        child: Consumer<KycProvider>(
          builder: (context, provider, _) {
            if (provider.showSuccess) {
              return _buildSuccessState(context, provider);
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, provider),
                  const SizedBox(height: 20),
                  _buildMandatoryCounter(context, provider),
                  const SizedBox(height: 16),
                  ...provider.documents.map(
                    (doc) => UploadTile(
                      document: doc,
                      onTap: () => provider.pickFile(doc.type),
                      onCancel: () => provider.cancelUpload(doc.type),
                      onRetry: () => provider.retryUpload(doc.type),
                      onRemove: () => provider.removeFile(doc.type),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDocumentRules(context),
                  const SizedBox(height: 24),
                  _buildSubmitButton(context, provider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, KycProvider provider) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(provider.customerName, style: theme.textTheme.titleLarge),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.segmentPoultry.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  provider.segment,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.segmentPoultry,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Lead: ${provider.leadNo}', style: theme.textTheme.bodyMedium),
          Text(
            'Type: ${provider.customerType}',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMandatoryCounter(BuildContext context, KycProvider provider) {
    final theme = Theme.of(context);
    final progress = provider.mandatoryUploaded / provider.mandatoryTotal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionHeader(title: 'Mandatory Documents'),
            Text(
              '${provider.mandatoryUploaded} of ${provider.mandatoryTotal}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation(
            progress == 1.0 ? AppTheme.successColor : theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentRules(BuildContext context) {
    return Text(
      'Accepted formats: JPG, PNG, PDF. Max size: 5 MB per file.',
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
    );
  }

  Widget _buildSubmitButton(BuildContext context, KycProvider provider) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.canSubmit && !provider.isSubmitting
            ? provider.submitKyc
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: provider.canSubmit
              ? theme.colorScheme.primary
              : Colors.grey,
        ),
        child: provider.isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                provider.canSubmit
                    ? 'Submit for Verification'
                    : 'Upload mandatory documents to continue',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, KycProvider provider) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 80),
          Icon(Icons.cloud_upload, color: AppTheme.successColor, size: 64),
          const SizedBox(height: 16),
          Text('Submitted', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Awaiting SAP MDM Verification',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              provider.resetSuccess();
              context.push('/');
            },
            child: const Text('Back to Plan'),
          ),
        ],
      ),
    );
  }
}

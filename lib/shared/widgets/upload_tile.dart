import 'dart:io';
import 'package:flutter/material.dart';
import 'package:japfa_pocket_feed/core/models/kyc_model.dart';
import 'package:japfa_pocket_feed/core/theme/app_theme.dart';

class UploadTile extends StatelessWidget {
  final KycDocument document;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onRemove;

  const UploadTile({
    super.key,
    required this.document,
    required this.onTap,
    this.onCancel,
    this.onRetry,
    this.onRemove,
  });

  IconData _getIcon() {
    return switch (document.type) {
      DocumentType.aadhaar => Icons.badge,
      DocumentType.pan => Icons.credit_card,
      DocumentType.customerPhoto => Icons.camera_alt,
      DocumentType.gstCertificate => Icons.description,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMandatory = document.isMandatory;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(theme),
          width: _isBorderThick() ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: document.state == UploadState.empty ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getIconBgColor(theme),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIcon(),
                        color: _getIconColor(theme),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                document.label,
                                style: theme.textTheme.titleMedium,
                              ),
                              if (isMandatory) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '*',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ],
                              if (!isMandatory) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '(Optional)',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getHintText(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStateAction(theme),
                  ],
                ),
                if (document.state == UploadState.loading) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: null,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.primary,
                    ),
                  ),
                ],
                if (document.state == UploadState.error &&
                    document.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    document.errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBorderColor(ThemeData theme) {
    return switch (document.state) {
      UploadState.empty => theme.dividerColor,
      UploadState.loading => theme.colorScheme.primary,
      UploadState.uploaded => AppTheme.successColor,
      UploadState.error => theme.colorScheme.error,
    };
  }

  bool _isBorderThick() {
    return document.state == UploadState.uploaded ||
        document.state == UploadState.error;
  }

  Color _getIconBgColor(ThemeData theme) {
    return switch (document.state) {
      UploadState.empty => theme.colorScheme.primary.withOpacity(0.1),
      UploadState.loading => theme.colorScheme.primary.withOpacity(0.15),
      UploadState.uploaded => AppTheme.successColor.withOpacity(0.15),
      UploadState.error => theme.colorScheme.error.withOpacity(0.15),
    };
  }

  Color _getIconColor(ThemeData theme) {
    return switch (document.state) {
      UploadState.empty => theme.colorScheme.primary,
      UploadState.loading => theme.colorScheme.primary,
      UploadState.uploaded => AppTheme.successColor,
      UploadState.error => theme.colorScheme.error,
    };
  }

  String _getHintText() {
    return switch (document.state) {
      UploadState.empty =>
        'Tap to upload • ${document.extensionHint} • Max ${document.maxSizeMb}MB',
      UploadState.loading => 'Uploading ${document.fileName ?? ''}...',
      UploadState.uploaded => '${document.fileName} • ${document.fileSize}',
      UploadState.error => 'Upload failed • Tap retry',
    };
  }

  Widget _buildStateAction(ThemeData theme) {
    return switch (document.state) {
      UploadState.empty => Icon(
        Icons.upload_file,
        color: theme.colorScheme.primary,
      ),
      UploadState.loading => SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary,
        ),
      ),
      UploadState.uploaded => IconButton(
        icon: const Icon(Icons.close, size: 18),
        color: Colors.grey,
        onPressed: onRemove,
      ),
      UploadState.error => IconButton(
        icon: const Icon(Icons.refresh, size: 18),
        color: theme.colorScheme.error,
        onPressed: onRetry,
      ),
    };
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:japfa_pocket_feed/core/models/kyc_model.dart';

class KycProvider extends ChangeNotifier {
  final List<KycDocument> _documents = [
    KycDocument(
      type: DocumentType.aadhaar,
      label: 'Aadhaar Card',
      isMandatory: true,
    ),
    KycDocument(type: DocumentType.pan, label: 'PAN Card', isMandatory: true),
    KycDocument(
      type: DocumentType.customerPhoto,
      label: 'Customer Photo',
      isMandatory: true,
    ),
    KycDocument(
      type: DocumentType.gstCertificate,
      label: 'GST Certificate',
      isMandatory: false,
    ),
  ];

  final String customerName = 'Rajesh Poultry Farm';
  final String leadNo = 'LEAD-2026-00184';
  final String segment = 'Poultry';
  final String customerType = 'Individual';

  List<KycDocument> get documents => _documents;
  int get mandatoryUploaded => _documents
      .where((d) => d.isMandatory && d.state == UploadState.uploaded)
      .length;
  int get mandatoryTotal => _documents.where((d) => d.isMandatory).length;
  bool get canSubmit => mandatoryUploaded == mandatoryTotal;
  bool _isSubmitting = false;
  bool _showSuccess = false;

  bool get isSubmitting => _isSubmitting;
  bool get showSuccess => _showSuccess;

  KycDocument? _findByType(DocumentType type) {
    return _documents.firstWhere(
      (d) => d.type == type,
      orElse: () => throw Exception('Doc not found'),
    );
  }

  Future<void> pickFile(DocumentType type) async {
    final doc = _findByType(type);
    doc!.state = UploadState.loading;
    notifyListeners();

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: doc.acceptedFormats,
      );

      if (result == null || result.files.isEmpty) {
        doc.state = UploadState.empty;
        notifyListeners();
        return;
      }

      final file = result.files.first;
      final fileSizeMb = (file.size / (1024 * 1024)).toStringAsFixed(1);

      if (file.size > doc.maxSizeMb * 1024 * 1024) {
        doc.state = UploadState.error;
        doc.errorMessage = 'File too large. Max ${doc.maxSizeMb}MB';
        notifyListeners();
        return;
      }

      doc.state = UploadState.uploaded;
      doc.fileName = file.name;
      doc.fileSize = '${fileSizeMb}MB';
      doc.errorMessage = null;
    } catch (e) {
      doc.state = UploadState.error;
      doc.errorMessage = 'Invalid format or error';
    }
    notifyListeners();
  }

  void cancelUpload(DocumentType type) {
    final doc = _findByType(type);
    doc!.state = UploadState.empty;
    doc!.fileName = null;
    doc!.fileSize = null;
    notifyListeners();
  }

  void retryUpload(DocumentType type) {
    pickFile(type);
  }

  void removeFile(DocumentType type) {
    final doc = _findByType(type);
    doc!.state = UploadState.empty;
    doc!.fileName = null;
    doc!.fileSize = null;
    doc!.errorMessage = null;
    notifyListeners();
  }

  Future<void> submitKyc() async {
    if (!canSubmit) return;
    _isSubmitting = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isSubmitting = false;
    _showSuccess = true;
    notifyListeners();
  }

  void resetSuccess() {
    _showSuccess = false;
    notifyListeners();
  }
}

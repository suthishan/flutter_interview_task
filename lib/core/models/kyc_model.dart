enum UploadState { empty, loading, uploaded, error }

enum DocumentType { aadhaar, pan, customerPhoto, gstCertificate }

class KycDocument {
  final DocumentType type;
  final String label;
  final bool isMandatory;
  final List<String> acceptedFormats;
  final int maxSizeMb;

  UploadState state;
  String? fileName;
  String? fileSize;
  String? errorMessage;

  KycDocument({
    required this.type,
    required this.label,
    required this.isMandatory,
    this.acceptedFormats = const ['jpg', 'jpeg', 'png', 'pdf'],
    this.maxSizeMb = 5,
    this.state = UploadState.empty,
    this.fileName,
    this.fileSize,
    this.errorMessage,
  });

  String get extensionHint => acceptedFormats.join(', ').toUpperCase();
}

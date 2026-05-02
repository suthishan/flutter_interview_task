import 'package:flutter/foundation.dart';

import 'enums.dart';

// ─── KYC Model ────────────────────────────────────────────────────────────────

@immutable
class KycModel {
  final UploadState aadhaarState;
  final String? aadhaarFile;
  final String? aadhaarError;

  final UploadState panState;
  final String? panFile;
  final String? panError;

  final UploadState photoState;
  final String? photoFile;
  final String? photoError;

  final UploadState gstState; // optional
  final String? gstFile;
  final String? gstError;

  const KycModel({
    this.aadhaarState = UploadState.empty,
    this.aadhaarFile,
    this.aadhaarError,
    this.panState = UploadState.empty,
    this.panFile,
    this.panError,
    this.photoState = UploadState.empty,
    this.photoFile,
    this.photoError,
    this.gstState = UploadState.empty,
    this.gstFile,
    this.gstError,
  });

  /// Count of mandatory docs (Aadhaar, PAN, Photo) that are uploaded.
  int get mandatoryUploadedCount => [
    aadhaarState == UploadState.uploaded,
    panState == UploadState.uploaded,
    photoState == UploadState.uploaded,
  ].where((v) => v).length;

  bool get allMandatoryUploaded => mandatoryUploadedCount == 3;

  KycModel copyWith({
    UploadState? aadhaarState,
    String? aadhaarFile,
    bool clearAadhaarFile = false,
    String? aadhaarError,
    UploadState? panState,
    String? panFile,
    bool clearPanFile = false,
    String? panError,
    UploadState? photoState,
    String? photoFile,
    bool clearPhotoFile = false,
    String? photoError,
    UploadState? gstState,
    String? gstFile,
    bool clearGstFile = false,
    String? gstError,
  }) {
    return KycModel(
      aadhaarState: aadhaarState ?? this.aadhaarState,
      aadhaarFile: clearAadhaarFile ? null : aadhaarFile ?? this.aadhaarFile,
      aadhaarError: aadhaarError,
      panState: panState ?? this.panState,
      panFile: clearPanFile ? null : panFile ?? this.panFile,
      panError: panError,
      photoState: photoState ?? this.photoState,
      photoFile: clearPhotoFile ? null : photoFile ?? this.photoFile,
      photoError: photoError,
      gstState: gstState ?? this.gstState,
      gstFile: clearGstFile ? null : gstFile ?? this.gstFile,
      gstError: gstError,
    );
  }
}
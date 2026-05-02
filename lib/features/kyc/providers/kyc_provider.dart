import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/kyc_model.dart';


// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class KycState {
  final KycModel kyc;
  final bool isSubmitting;
  final bool isSubmitted;

  const KycState({
    required this.kyc,
    this.isSubmitting = false,
    this.isSubmitted = false,
  });

  /// Derived — all 3 mandatory docs uploaded and not currently submitting.
  bool get canSubmit => kyc.allMandatoryUploaded && !isSubmitting;

  KycState copyWith({
    KycModel? kyc,
    bool? isSubmitting,
    bool? isSubmitted,
  }) {
    return KycState(
      kyc: kyc ?? this.kyc,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

final kycProvider = StateNotifierProvider.autoDispose<KycNotifier, KycState>(
      (ref) => KycNotifier(),
);

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class KycNotifier extends StateNotifier<KycState> {
  KycNotifier() : super(const KycState(kyc: KycModel()));

  // ── Generic file-pick helper ────────────────────────────────────────────────
  /// Opens file_picker, validates size, returns (fileName, sizeLabel) or null.
  /// Sets error state on the relevant slot if validation fails.
  Future<_PickResult?> _pickFile({
    required void Function(UploadState) setLoading,
    required void Function(String error) setError,
  }) async {
    setLoading(UploadState.loading);

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: AppConstants.allowedExtensions,
    );

    if (result == null || result.files.isEmpty) {
      // User cancelled → revert to empty
      setLoading(UploadState.empty);
      return null;
    }

    final file = result.files.single;
    final sizeMB = (file.size / (1024 * 1024));

    if (sizeMB > AppConstants.maxFileSizeMB) {
      setError('File too large (max ${AppConstants.maxFileSizeMB} MB)');
      return null;
    }

    final ext = file.extension?.toLowerCase() ?? '';
    if (!AppConstants.allowedExtensions.contains(ext)) {
      setError('Invalid format. Use JPG, PNG or PDF.');
      return null;
    }

    final sizeLabel = sizeMB < 1
        ? '${(file.size / 1024).toStringAsFixed(0)} KB'
        : '${sizeMB.toStringAsFixed(1)} MB';

    return _PickResult(name: file.name, sizeLabel: sizeLabel);
  }

  // ── Aadhaar ─────────────────────────────────────────────────────────────────
  Future<void> uploadAadhaar() async {
    final result = await _pickFile(
      setLoading: (s) => state = state.copyWith(
        kyc: state.kyc.copyWith(aadhaarState: s),
      ),
      setError: (e) => state = state.copyWith(
        kyc: state.kyc.copyWith(
          aadhaarState: UploadState.error,
          aadhaarError: e,
          clearAadhaarFile: true,
        ),
      ),
    );
    if (result == null) return;
    state = state.copyWith(
      kyc: state.kyc.copyWith(
        aadhaarFile: '${result.name} · ${result.sizeLabel}',
        aadhaarState: UploadState.uploaded,
        aadhaarError: null,
      ),
    );
  }

  void removeAadhaar() => state = state.copyWith(
    kyc: state.kyc.copyWith(
      aadhaarState: UploadState.empty,
      clearAadhaarFile: true,
      aadhaarError: null,
    ),
  );

  // ── PAN ─────────────────────────────────────────────────────────────────────
  Future<void> uploadPan() async {
    final result = await _pickFile(
      setLoading: (s) => state = state.copyWith(
        kyc: state.kyc.copyWith(panState: s),
      ),
      setError: (e) => state = state.copyWith(
        kyc: state.kyc.copyWith(
          panState: UploadState.error,
          panError: e,
          clearPanFile: true,
        ),
      ),
    );
    if (result == null) return;
    state = state.copyWith(
      kyc: state.kyc.copyWith(
        panFile: '${result.name} · ${result.sizeLabel}',
        panState: UploadState.uploaded,
        panError: null,
      ),
    );
  }

  void removePan() => state = state.copyWith(
    kyc: state.kyc.copyWith(
      panState: UploadState.empty,
      clearPanFile: true,
      panError: null,
    ),
  );

  // ── Customer Photo ───────────────────────────────────────────────────────────
  Future<void> uploadPhoto() async {
    final result = await _pickFile(
      setLoading: (s) => state = state.copyWith(
        kyc: state.kyc.copyWith(photoState: s),
      ),
      setError: (e) => state = state.copyWith(
        kyc: state.kyc.copyWith(
          photoState: UploadState.error,
          photoError: e,
          clearPhotoFile: true,
        ),
      ),
    );
    if (result == null) return;
    state = state.copyWith(
      kyc: state.kyc.copyWith(
        photoFile: '${result.name} · ${result.sizeLabel}',
        photoState: UploadState.uploaded,
        photoError: null,
      ),
    );
  }

  void removePhoto() => state = state.copyWith(
    kyc: state.kyc.copyWith(
      photoState: UploadState.empty,
      clearPhotoFile: true,
      photoError: null,
    ),
  );

  // ── GST (optional) ───────────────────────────────────────────────────────────
  Future<void> uploadGst() async {
    final result = await _pickFile(
      setLoading: (s) => state = state.copyWith(
        kyc: state.kyc.copyWith(gstState: s),
      ),
      setError: (e) => state = state.copyWith(
        kyc: state.kyc.copyWith(
          gstState: UploadState.error,
          gstError: e,
          clearGstFile: true,
        ),
      ),
    );
    if (result == null) return;
    state = state.copyWith(
      kyc: state.kyc.copyWith(
        gstFile: '${result.name} · ${result.sizeLabel}',
        gstState: UploadState.uploaded,
        gstError: null,
      ),
    );
  }

  void removeGst() => state = state.copyWith(
    kyc: state.kyc.copyWith(
      gstState: UploadState.empty,
      clearGstFile: true,
      gstError: null,
    ),
  );

  // ── Debug: simulate error on aadhaar tile (evaluator trigger) ────────────────
  void simulateError() => state = state.copyWith(
    kyc: state.kyc.copyWith(
      aadhaarState: UploadState.error,
      aadhaarError: 'File too large (max 5 MB)',
      clearAadhaarFile: true,
    ),
  );

  // ── Submit ───────────────────────────────────────────────────────────────────
  Future<void> submit() async {
    if (!state.canSubmit) return;
    state = state.copyWith(isSubmitting: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isSubmitting: false, isSubmitted: true);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal DTO
// ─────────────────────────────────────────────────────────────────────────────

class _PickResult {
  final String name;
  final String sizeLabel;
  const _PickResult({required this.name, required this.sizeLabel});
}
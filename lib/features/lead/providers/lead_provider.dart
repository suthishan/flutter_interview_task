import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/lead_model.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class LeadFormState {
  final LeadModel lead;
  final bool isSubmitting;
  final bool isSubmitted;

  const LeadFormState({
    required this.lead,
    this.isSubmitting = false,
    this.isSubmitted = false,
  });

  // Form is valid when all mandatory fields are filled
  bool get isValid {
    if (lead.area.trim().isEmpty) return false;
    if (lead.segment == null) return false;
    if (lead.customerType == null) return false;
    if (lead.classification == null) return false;
    if (!_segmentFieldsValid(lead.segment!, lead.segmentFields)) return false;
    return true;
  }

  LeadFormState copyWith({
    LeadModel? lead,
    bool? isSubmitting,
    bool? isSubmitted,
  }) {
    return LeadFormState(
      lead: lead ?? this.lead,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

// Validate that the mandatory segment-specific fields are filled
bool _segmentFieldsValid(
    FeedSegment segment, Map<String, String> fields) {
  final keys = _mandatoryKeysFor(segment);
  for (final key in keys) {
    if ((fields[key] ?? '').trim().isEmpty) return false;
  }
  return true;
}

List<String> _mandatoryKeysFor(FeedSegment segment) {
  return switch (segment) {
    FeedSegment.poultry => ['flockSize', 'birdAge', 'currentFeedBrand'],
    FeedSegment.aqua => ['species', 'pondArea', 'stockingDensity'],
    FeedSegment.cattle => ['herdSize', 'cattleType', 'milkYield'],
    FeedSegment.pig => ['herdSize', 'stage'],
  };
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class LeadFormNotifier extends StateNotifier<LeadFormState> {
  LeadFormNotifier() : super(LeadFormState(lead: LeadModel()));

  void updateArea(String value) {
    state = state.copyWith(lead: state.lead.copyWith(area: value));
  }

  void updateSegment(FeedSegment segment) {
    // Clear segment fields when segment changes — different fields per type
    state = state.copyWith(
      lead: state.lead.copyWith(
        segment: segment,
        segmentFields: {},
      ),
    );
  }

  void updateCustomerType(CustomerType type) {
    state = state.copyWith(lead: state.lead.copyWith(customerType: type));
  }

  void updateClassification(LeadClassification classification) {
    state = state.copyWith(
        lead: state.lead.copyWith(classification: classification));
  }

  void updateSegmentField(String key, String value) {
    final updated = Map<String, String>.from(state.lead.segmentFields);
    updated[key] = value;
    state = state.copyWith(lead: state.lead.copyWith(segmentFields: updated));
  }

  void updateRemarks(String value) {
    state = state.copyWith(lead: state.lead.copyWith(remarks: value));
  }

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true);
    // Mock 2-second API delay per spec
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isSubmitting: false, isSubmitted: true);
  }

  void reset() {
    state = LeadFormState(lead: LeadModel());
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final leadFormProvider =
StateNotifierProvider.autoDispose<LeadFormNotifier, LeadFormState>(
      (ref) => LeadFormNotifier(),
);

// Remarks character count — derived, no extra state
final remarksLengthProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(leadFormProvider).lead.remarks?.length ?? 0;
});
import 'package:flutter/foundation.dart';
import 'package:japfa_pocket_feed/core/models/lead_model.dart';

class LeadProvider extends ChangeNotifier {
  FeedSegment? _selectedSegment;
  CustomerType? _selectedCustomerType;
  LeadClassification? _selectedClassification;
  String _areaValue = '';
  String _remarksValue = '';
  Map<String, String> _segmentFields = {};
  bool _isSubmitting = false;
  bool _showSuccess = false;
  Map<String, String> _errors = {};

  FeedSegment? get selectedSegment => _selectedSegment;
  CustomerType? get selectedCustomerType => _selectedCustomerType;
  LeadClassification? get selectedClassification => _selectedClassification;
  String get areaValue => _areaValue;
  String get remarksValue => _remarksValue;
  Map<String, String> get segmentFields => _segmentFields;
  Map<String, String> get errors => _errors;
  bool get isSubmitting => _isSubmitting;
  bool get showSuccess => _showSuccess;
  bool get isValidForm =>
      _errors.isEmpty &&
      _selectedSegment != null &&
      _selectedCustomerType != null &&
      _selectedClassification != null;

  void setSegment(FeedSegment segment) {
    _selectedSegment = segment;
    _segmentFields.clear();
    _errors.remove('segment');
    notifyListeners();
  }

  void setCustomerType(CustomerType type) {
    _selectedCustomerType = type;
    _errors.remove('customerType');
    notifyListeners();
  }

  void setClassification(LeadClassification classification) {
    _selectedClassification = classification;
    _errors.remove('classification');
    notifyListeners();
  }

  void setAreaValue(String value) {
    _areaValue = value;
    _errors.remove('area');
    notifyListeners();
  }

  void setRemarksValue(String value) {
    if (value.length <= 300) {
      _remarksValue = value;
      _errors.remove('remarks');
      notifyListeners();
    }
  }

  void setSegmentField(String key, String value) {
    _segmentFields[key] = value;
    _errors.remove('segment_${key}');
    notifyListeners();
  }

  bool validateForm() {
    _errors.clear();
    if (_areaValue.trim().isEmpty) _errors['area'] = 'Area is required';
    if (_selectedSegment == null) _errors['segment'] = 'Select a segment';
    if (_selectedCustomerType == null)
      _errors['customerType'] = 'Select customer type';
    if (_selectedClassification == null)
      _errors['classification'] = 'Select lead classification';

    if (_selectedSegment != null) {
      switch (_selectedSegment!) {
        case FeedSegment.poultry:
          if ((_segmentFields['flockSize'] ?? '').isEmpty)
            _errors['segment_flockSize'] = 'Flock size required';
          if ((_segmentFields['birdAge'] ?? '').isEmpty)
            _errors['segment_birdAge'] = 'Bird age required';
          break;
        case FeedSegment.aqua:
          if ((_segmentFields['species'] ?? '') == 'none')
            _errors['segment_species'] = 'Select species';
          if ((_segmentFields['pondArea'] ?? '').isEmpty)
            _errors['segment_pondArea'] = 'Pond area required';
          break;
        case FeedSegment.cattle:
          if ((_segmentFields['herdSize'] ?? '').isEmpty)
            _errors['segment_herdSize'] = 'Herd size required';
          if ((_segmentFields['cattleType'] ?? '') == 'none')
            _errors['segment_cattleType'] = 'Select cattle type';
          break;
        case FeedSegment.pig:
          if ((_segmentFields['herdSize'] ?? '').isEmpty)
            _errors['segment_herdSize'] = 'Herd size required';
          if ((_segmentFields['stage'] ?? '') == 'none')
            _errors['segment_stage'] = 'Select stage';
          break;
      }
    }

    notifyListeners();
    return _errors.isEmpty;
  }

  Future<void> submitForm() async {
    if (!validateForm()) return;
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

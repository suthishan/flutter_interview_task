import 'package:flutter/material.dart';
import '../../../core/models/enums.dart';

/// Renders the correct set of input fields for the selected [FeedSegment].
/// Wrapped in [AnimatedSwitcher] so fields animate in/out on segment change.
///
/// Spec fields per segment:
///   Poultry → Flock Size, Bird Age (weeks), Current Feed Brand
///   Aqua    → Species (Shrimp/Fish dropdown), Pond Area (acres), Stocking Density
///   Cattle  → Herd Size, Cattle Type (Dairy/Beef dropdown), Milk Yield (litres/day)
///   Pig     → Herd Size, Stage (Grower/Finisher/Breeder dropdown)
class SegmentFieldsWidget extends StatelessWidget {
  final FeedSegment segment;
  final Map<String, String> values;
  final void Function(String key, String value) onChanged;
  final bool showErrors;

  const SegmentFieldsWidget({
    super.key,
    required this.segment,
    required this.values,
    required this.onChanged,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: child,
        ),
      ),
      child: _buildFields(context),
    );
  }

  Widget _buildFields(BuildContext context) {
    return switch (segment) {
      FeedSegment.poultry => _PoultryFields(
        key: const ValueKey('poultry'),
        values: values,
        onChanged: onChanged,
        showErrors: showErrors,
      ),
      FeedSegment.aqua => _AquaFields(
        key: const ValueKey('aqua'),
        values: values,
        onChanged: onChanged,
        showErrors: showErrors,
      ),
      FeedSegment.cattle => _CattleFields(
        key: const ValueKey('cattle'),
        values: values,
        onChanged: onChanged,
        showErrors: showErrors,
      ),
      FeedSegment.pig => _PigFields(
        key: const ValueKey('pig'),
        values: values,
        onChanged: onChanged,
        showErrors: showErrors,
      ),
    };
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

Widget _field({
  required String label,
  required String fieldKey,
  required Map<String, String> values,
  required void Function(String, String) onChanged,
  required bool showErrors,
  TextInputType keyboardType = TextInputType.text,
  String? hint,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      initialValue: values[fieldKey],
      keyboardType: keyboardType,
      onChanged: (v) => onChanged(fieldKey, v),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: showErrors && (values[fieldKey] ?? '').trim().isEmpty
            ? '$label is required'
            : null,
      ),
    ),
  );
}

Widget _dropdown({
  required String label,
  required String fieldKey,
  required List<String> items,
  required Map<String, String> values,
  required void Function(String, String) onChanged,
  required bool showErrors,
}) {
  final current = values[fieldKey];
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      initialValue: items.contains(current) ? current : null,
      decoration: InputDecoration(
        labelText: label,
        errorText: showErrors && (values[fieldKey] ?? '').trim().isEmpty
            ? '$label is required'
            : null,
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(fieldKey, v);
      },
    ),
  );
}

// ── Poultry fields ────────────────────────────────────────────────────────────

class _PoultryFields extends StatelessWidget {
  final Map<String, String> values;
  final void Function(String, String) onChanged;
  final bool showErrors;

  const _PoultryFields({
    super.key,
    required this.values,
    required this.onChanged,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(
          label: 'Flock Size',
          fieldKey: 'flockSize',
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
          keyboardType: TextInputType.number,
          hint: 'e.g. 5000',
        ),
        _field(
          label: 'Bird Age (weeks)',
          fieldKey: 'birdAge',
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
          keyboardType: TextInputType.number,
          hint: 'e.g. 3',
        ),
        _field(
          label: 'Current Feed Brand',
          fieldKey: 'currentFeedBrand',
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
          hint: 'e.g. Local Brand',
        ),
      ],
    );
  }
}

// ── Aqua fields ───────────────────────────────────────────────────────────────

class _AquaFields extends StatelessWidget {
  final Map<String, String> values;
  final void Function(String, String) onChanged;
  final bool showErrors;

  const _AquaFields({
    super.key,
    required this.values,
    required this.onChanged,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdown(
          label: 'Species',
          fieldKey: 'species',
          items: const ['Shrimp', 'Fish'],
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
        ),
        _field(
          label: 'Pond Area (acres)',
          fieldKey: 'pondArea',
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hint: 'e.g. 12.5',
        ),
        _field(
          label: 'Stocking Density',
          fieldKey: 'stockingDensity',
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
          keyboardType: TextInputType.number,
          hint: 'units per sq metre',
        ),
      ],
    );
  }
}

// ── Cattle fields ─────────────────────────────────────────────────────────────

class _CattleFields extends StatelessWidget {
  final Map<String, String> values;
  final void Function(String, String) onChanged;
  final bool showErrors;

  const _CattleFields({
    super.key,
    required this.values,
    required this.onChanged,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(
          label: 'Herd Size',
          fieldKey: 'herdSize',
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
          keyboardType: TextInputType.number,
          hint: 'e.g. 45',
        ),
        _dropdown(
          label: 'Cattle Type',
          fieldKey: 'cattleType',
          items: const ['Dairy', 'Beef'],
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
        ),
        _field(
          label: 'Milk Yield (litres/day)',
          fieldKey: 'milkYield',
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hint: 'e.g. 18',
        ),
      ],
    );
  }
}

// ── Pig fields ────────────────────────────────────────────────────────────────

class _PigFields extends StatelessWidget {
  final Map<String, String> values;
  final void Function(String, String) onChanged;
  final bool showErrors;

  const _PigFields({
    super.key,
    required this.values,
    required this.onChanged,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(
          label: 'Herd Size',
          fieldKey: 'herdSize',
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
          keyboardType: TextInputType.number,
          hint: 'e.g. 200',
        ),
        _dropdown(
          label: 'Stage',
          fieldKey: 'stage',
          items: const ['Grower', 'Finisher', 'Breeder'],
          values: values,
          onChanged: onChanged,
          showErrors: showErrors,
        ),
      ],
    );
  }
}
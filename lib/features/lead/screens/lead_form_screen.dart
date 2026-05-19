import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:japfa_pocket_feed/core/theme/app_theme.dart';
import 'package:japfa_pocket_feed/shared/widgets/responsive_utils.dart';
import 'package:japfa_pocket_feed/shared/widgets/section_header.dart';
import 'package:provider/provider.dart';
import 'package:japfa_pocket_feed/core/models/lead_model.dart';
import 'package:japfa_pocket_feed/features/lead/providers/lead_provider.dart';
import 'package:japfa_pocket_feed/shared/widgets/lead_classification_badge.dart';

class LeadFormScreen extends StatelessWidget {
  const LeadFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Lead')),
      body: Container(
        margin: Responsive.horizontalPadding(context, false),
        child: Consumer<LeadProvider>(
          builder: (context, provider, _) {
            if (provider.showSuccess) {
              return _buildSuccessDialog(context, provider);
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReadOnlyHeader(context),
                  const SizedBox(height: 20),
                  _buildAreaField(context, provider),
                  const SizedBox(height: 16),
                  _buildSegmentSelector(context, provider),
                  const SizedBox(height: 16),
                  _buildDynamicFields(context, provider),
                  const SizedBox(height: 16),
                  _buildCustomerTypeDropdown(context, provider),
                  const SizedBox(height: 20),
                  _buildClassificationSection(context, provider),
                  const SizedBox(height: 20),
                  _buildRemarksField(context, provider),
                  const SizedBox(height: 24),
                  _buildSubmitButton(context, provider),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReadOnlyHeader(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Created: $now', style: theme.textTheme.bodyMedium),
          Text(
            'GPS: 28.6139, 77.2090',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaField(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    final hasError = provider.errors.containsKey('area');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Area'),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: provider.areaValue,
          decoration: InputDecoration(
            hintText: 'Enter area name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            errorText: hasError ? provider.errors['area'] : null,
          ),
          onChanged: provider.setAreaValue,
        ),
      ],
    );
  }

  Widget _buildSegmentSelector(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    final hasError = provider.errors.containsKey('segment');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Feed Segment', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<FeedSegment>(
          segments: FeedSegment.values.map((s) {
            return ButtonSegment(value: s, label: Text(s.name.capitalize()));
          }).toList(),
          selected: provider.selectedSegment != null
              ? {provider.selectedSegment!}
              : {},
          onSelectionChanged: (Set<FeedSegment> selected) {
            provider.setSegment(selected.first);
          },
          showSelectedIcon: false,
          emptySelectionAllowed: true,
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            provider.errors['segment']!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDynamicFields(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    final segment = provider.selectedSegment;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: segment == null
          ? Container(key: const ValueKey('empty'))
          : switch (segment) {
              FeedSegment.poultry => _buildPoultryFields(context, provider),
              FeedSegment.aqua => _buildAquaFields(context, provider),
              FeedSegment.cattle => _buildCattleFields(context, provider),
              FeedSegment.pig => _buildPigFields(context, provider),
            },
    );
  }

  Widget _buildPoultryFields(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('poultry'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildTextRow(context, 'Flock Size', 'flockSize', provider),
          const SizedBox(height: 10),
          _buildTextRow(context, 'Bird Age (weeks)', 'birdAge', provider),
          const SizedBox(height: 10),
          _buildTextRow(
            context,
            'Current Feed Brand',
            'currentFeedBrand',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildAquaFields(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('aqua'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildDropdownRow(context, 'Species', 'species', [
            'none',
            'Shrimp',
            'Fish',
          ], provider),
          const SizedBox(height: 10),
          _buildTextRow(context, 'Pond Area (acres)', 'pondArea', provider),
          const SizedBox(height: 10),
          _buildTextRow(
            context,
            'Stocking Density',
            'stockingDensity',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildCattleFields(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('cattle'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildTextRow(context, 'Herd Size', 'herdSize', provider),
          const SizedBox(height: 10),
          _buildDropdownRow(context, 'Cattle Type', 'cattleType', [
            'none',
            'Dairy',
            'Beef',
          ], provider),
          const SizedBox(height: 10),
          _buildTextRow(
            context,
            'Milk Yield (litres/day)',
            'milkYield',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildPigFields(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('pig'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildTextRow(context, 'Herd Size', 'herdSize', provider),
          const SizedBox(height: 10),
          _buildDropdownRow(context, 'Stage', 'stage', [
            'none',
            'Grower',
            'Finisher',
            'Breeder',
          ], provider),
        ],
      ),
    );
  }

  Widget _buildTextRow(
    BuildContext context,
    String label,
    String key,
    LeadProvider provider,
  ) {
    final theme = Theme.of(context);
    final hasError = provider.errors.containsKey('segment_$key');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: provider.segmentFields[key],
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            errorText: hasError ? provider.errors['segment_$key'] : null,
          ),
          onChanged: (val) => provider.setSegmentField(key, val),
        ),
      ],
    );
  }

  Widget _buildDropdownRow(
    BuildContext context,
    String label,
    String key,
    List<String> options,
    LeadProvider provider,
  ) {
    final theme = Theme.of(context);
    final hasError = provider.errors.containsKey('segment_$key');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: provider.segmentFields[key]?.isNotEmpty == true
              ? provider.segmentFields[key]
              : 'none',
          items: options
              .map(
                (opt) => DropdownMenuItem(
                  value: opt,
                  child: Text(opt == 'none' ? 'Select' : opt),
                ),
              )
              .toList(),
          onChanged: (val) => provider.setSegmentField(key, val ?? 'none'),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            errorText: hasError ? provider.errors['segment_$key'] : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerTypeDropdown(
    BuildContext context,
    LeadProvider provider,
  ) {
    final hasError = provider.errors.containsKey('customerType');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Customer Type'),

        const SizedBox(height: 6),
        DropdownButtonFormField<CustomerType>(
          value: provider.selectedCustomerType,
          items: CustomerType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.name.capitalize()),
            );
          }).toList(),
          onChanged: (val) => provider.setCustomerType(val!),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            errorText: hasError ? provider.errors['customerType'] : null,
          ),
        ),
      ],
    );
  }

  Widget _buildClassificationSection(
    BuildContext context,
    LeadProvider provider,
  ) {
    final theme = Theme.of(context);
    final hasError = provider.errors.containsKey('classification');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Lead Classification'),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.1,
          children: LeadClassification.values.map((cls) {
            return LeadClassificationBadge(
              classification: cls,
              isSelected: provider.selectedClassification == cls,
              onTap: () => provider.setClassification(cls),
            );
          }).toList(),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            provider.errors['classification']!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRemarksField(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    final counter = '${provider.remarksValue.length}/300';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionHeader(title: 'Remarks'),
            Text(
              counter,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: provider.remarksValue,
          maxLines: 4,
          maxLength: 300,
          decoration: InputDecoration(
            hintText: 'Add notes...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            counterText: '',
          ),
          onChanged: provider.setRemarksValue,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.isValidForm && !provider.isSubmitting
            ? provider.submitForm
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: provider.isValidForm
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
                'Submit Lead',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildSuccessDialog(BuildContext context, LeadProvider provider) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: AppTheme.successColor, size: 64),
          const SizedBox(height: 16),
          Text('Lead Submitted', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Awaiting verification',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              provider.resetSuccess();
              context.go('/kyc-upload');
            },
            child: const Text('Back to Plan'),
          ),
        ],
      ),
    );
  }
}

extension StringCapitalize on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

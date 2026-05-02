import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../providers/lead_provider.dart';
import '../widgets/lead_classification_selector.dart';
import '../../../shared/widgets/lead_classification_badge.dart';
import '../../../shared/widgets/section_header.dart';
import '../widgets/segment_field_widget.dart';

class LeadFormScreen extends ConsumerStatefulWidget {
  const LeadFormScreen({super.key});

  @override
  ConsumerState<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends ConsumerState<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  final _remarksController = TextEditingController();

  // Tracks whether the user has attempted submit (shows inline errors)
  bool _submitAttempted = false;

  @override
  void dispose() {
    _areaController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(leadFormProvider);
    final notifier = ref.read(leadFormProvider.notifier);
    final lead = formState.lead;
    final remarksLen = ref.watch(remarksLengthProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Lead'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
      ),
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            // ── 1. Auto-filled read-only fields ────────────────────────────
            const SectionHeader(title: 'Visit Information'),
            const SizedBox(height: AppConstants.height10),

            Row(
              children: [
                Expanded(
                  child: _ReadOnlyField(
                    label: 'Date & Time',
                    value: AppDateUtils.formatDateTime(lead.createdAt),
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ReadOnlyField(
                    label: 'GPS Coordinates',
                    value: lead.gpsCoordinates,
                    icon: Icons.location_on_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── 2. Area field ───────────────────────────────────────────────
            const SectionHeader(title: 'Lead Details'),
            const SizedBox(height: AppConstants.height10),

            TextFormField(
              controller: _areaController,
              onChanged: notifier.updateArea,
              decoration: const InputDecoration(
                labelText: 'Area *',
                hintText: 'e.g. Anand, Gujarat',
                prefixIcon: Icon(Icons.map_outlined),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Area is required' : null,
            ),

            const SizedBox(height: 20),

            // ── 3. Segment selector ─────────────────────────────────────────
            const SectionHeader(title: 'Feed Segment *'),
            const SizedBox(height: AppConstants.height10),

            _SegmentSelector(
              selected: lead.segment,
              showError: _submitAttempted && lead.segment == null,
              onChanged: (seg) {
                notifier.updateSegment(seg);
              },
            ),

            const SizedBox(height: 20),

            // ── 4. Dynamic segment fields (animated in/out) ─────────────────
            if (lead.segment != null) ...[
              SectionHeader(title: '${_segmentLabel(lead.segment!)} Details *'),
              const SizedBox(height: AppConstants.height10),
              SegmentFieldsWidget(
                segment: lead.segment!,
                values: lead.segmentFields,
                onChanged: notifier.updateSegmentField,
                showErrors: _submitAttempted,
              ),
              const SizedBox(height: 8),
            ],

            // ── 5. Customer Type dropdown ───────────────────────────────────
            const SectionHeader(title: 'Customer Type *'),
            const SizedBox(height: AppConstants.height10),

            DropdownButtonFormField<CustomerType>(
              initialValue: lead.customerType,
              decoration: InputDecoration(
                labelText: 'Customer Type',
                errorText: _submitAttempted && lead.customerType == null
                    ? 'Please select a customer type'
                    : null,
              ),
              items: const [
                DropdownMenuItem(
                  value: CustomerType.farmer,
                  child: Text('Farmer'),
                ),
                DropdownMenuItem(
                  value: CustomerType.integrator,
                  child: Text('Integrator'),
                ),
                DropdownMenuItem(
                  value: CustomerType.dealer,
                  child: Text('Dealer'),
                ),
                DropdownMenuItem(
                  value: CustomerType.distributor,
                  child: Text('Distributor'),
                ),
              ],
              onChanged: (v) {
                if (v != null) notifier.updateCustomerType(v);
              },
              validator: (_) => _submitAttempted && lead.customerType == null
                  ? 'Required'
                  : null,
            ),

            const SizedBox(height: 20),

            // ── 6. Lead Classification — the MOST IMPORTANT UI element ──────
            Row(
              children: [
                const SectionHeader(title: 'Lead Classification *'),
                const SizedBox(width: 8),
                if (lead.classification != null)
                  LeadClassificationBadge(classification: lead.classification!),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to select the opportunity level',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            LeadClassificationSelector(
              selected: lead.classification,
              onChanged: notifier.updateClassification,
            ),

            if (_submitAttempted && lead.classification == null) ...[
              const SizedBox(height: 6),
              Text(
                'Please select a lead classification',
                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
              ),
            ],

            const SizedBox(height: 20),

            // ── 7. Remarks (optional, 300 char limit with live counter) ──────
            const SectionHeader(title: 'Remarks'),
            const SizedBox(height: AppConstants.height10),

            TextFormField(
              controller: _remarksController,
              maxLines: 4,
              maxLength: 300,
              onChanged: notifier.updateRemarks,
              decoration: InputDecoration(
                labelText: 'Remarks (optional)',
                hintText: 'Add any notes about this lead…',
                alignLabelWithHint: true,
                // Live counter replaces the default maxLength counter
                counterText: '$remarksLen / 300',
                counterStyle: textTheme.bodySmall?.copyWith(
                  color: remarksLen > 280
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── 8. Submit button ────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                // Truly un-tappable when invalid or submitting
                onPressed: formState.isValid && !formState.isSubmitting
                    ? _onSubmit
                    : () {
                  // On tap when invalid → show all inline errors
                  setState(() => _submitAttempted = true);
                  _formKey.currentState?.validate();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: formState.isValid
                      ? AppTheme.primary
                      : colorScheme.surfaceContainerHighest,
                  foregroundColor: formState.isValid
                      ? AppTheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: formState.isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        formState.isValid
                            ? 'Submit Lead'
                            : 'Complete all required fields',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    setState(() => _submitAttempted = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref.read(leadFormProvider.notifier).submit();

    if (!mounted) return;
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(
        onContinueToKyc: () {
          Navigator.of(context).pop();
          context.pushNamed('kyc');
        },
        onLater: () {
          Navigator.of(context).pop();
          context.pop(); // back to check-in / visit plan
        },
      ),
    );
  }

  String _segmentLabel(FeedSegment s) => switch (s) {
    FeedSegment.poultry => 'Poultry',
    FeedSegment.aqua => 'Aqua',
    FeedSegment.cattle => 'Cattle',
    FeedSegment.pig => 'Pig',
  };
}

// ── Read-only auto-filled field ───────────────────────────────────────────────

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Segment selector (4-button toggle) ───────────────────────────────────────

class _SegmentSelector extends StatelessWidget {
  final FeedSegment? selected;
  final bool showError;
  final ValueChanged<FeedSegment> onChanged;

  const _SegmentSelector({
    required this.selected,
    required this.showError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: FeedSegment.values.map((seg) {
            final isSelected = selected == seg;
            final cfg = _segConfig(seg);
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: seg != FeedSegment.pig ? 8 : 0),
                child: GestureDetector(
                  onTap: () => onChanged(seg),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cfg.color.withValues(alpha: 0.12)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? cfg.color
                            : colorScheme.outlineVariant,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(cfg.icon, size: 20, color: cfg.color),
                        const SizedBox(height: 4),
                        Text(
                          cfg.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? cfg.color
                                : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (showError) ...[
          const SizedBox(height: 6),
          Text(
            'Please select a segment',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
          ),
        ],
      ],
    );
  }

  static _SegConfig _segConfig(FeedSegment s) => switch (s) {
    FeedSegment.poultry => _SegConfig(
      'Poultry',
      Icons.egg_outlined,
      AppTheme.segmentPoultry,
    ),
    FeedSegment.aqua => _SegConfig(
      'Aqua',
      Icons.water_outlined,
      AppTheme.segmentAqua,
    ),
    FeedSegment.cattle => _SegConfig(
      'Cattle',
      Icons.agriculture_outlined,
      AppTheme.segmentCattle,
    ),
    FeedSegment.pig => _SegConfig(
      'Pig',
      Icons.pets_outlined,
      AppTheme.segmentPig,
    ),
  };
}

class _SegConfig {
  final String label;
  final IconData icon;
  final Color color;

  const _SegConfig(this.label, this.icon, this.color);
}

// ── Custom Success Dialog ─────────────────────────────────────────────────────

class _SuccessDialog extends StatelessWidget {
  final VoidCallback onContinueToKyc;
  final VoidCallback onLater;

  const _SuccessDialog({required this.onContinueToKyc, required this.onLater});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 40,
                color: AppTheme.success,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Lead Created!',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The lead has been saved successfully.\nWould you like to proceed to KYC verification?',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onLater,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                      side: BorderSide(color: colorScheme.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Later'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onContinueToKyc,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Go to KYC',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

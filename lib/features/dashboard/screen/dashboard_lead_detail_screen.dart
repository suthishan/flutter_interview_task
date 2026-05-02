import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/dashboard_lead_model.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/remark_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/widgets/lead_classification_badge.dart';
import '../../../shared/widgets/section_header.dart';
import '../../visit_plan/widgets/segment_badge.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/timeline_tile.dart';

/// Lead detail screen for the Manager Dashboard.
///
/// Spec requirements:
/// - Full lead information display (all fields from the lead model)
/// - Remarks timeline — chronological, oldest at top, newest at bottom
/// - Add Remark section — TextFormField + counter + Submit button
/// - Adding a remark updates the timeline immediately (local state)
/// - 'Sales Officer Notified' SnackBar on remark submit
class DashboardLeadDetailScreen extends ConsumerStatefulWidget {
  final String leadId;

  /// Pre-fetched lead object passed via GoRouter `extra`.
  final DashboardLeadModel? lead;

  const DashboardLeadDetailScreen({
    super.key,
    required this.leadId,
    this.lead,
  });

  @override
  ConsumerState<DashboardLeadDetailScreen> createState() =>
      _DashboardLeadDetailScreenState();
}

class _DashboardLeadDetailScreenState
    extends ConsumerState<DashboardLeadDetailScreen> {
  final _remarkController = TextEditingController();
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _remarkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always read from provider so live updates (added remarks) are reflected
    final lead = ref.watch(dashboardProvider).allLeads.cast<DashboardLeadModel?>().firstWhere(
          (l) => l?.id == widget.leadId,
      orElse: () => widget.lead,
    ) ??
        widget.lead;

    if (lead == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lead Detail')),
        body: const Center(child: Text('Lead not found')),
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Lead Detail'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LeadClassificationBadge(
              classification: lead.classification,
              compact: false,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ── Hero header ─────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _LeadHeroHeader(lead: lead)),

          // ── Lead info section ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: SectionHeader(title: 'Lead Information'),
            ),
          ),

          SliverToBoxAdapter(
            child: _LeadInfoCard(lead: lead),
          ),

          // ── Segment-specific fields ──────────────────────────────────────────
          if (lead.segmentFields.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: SectionHeader(
                  title: '${AppTheme.segmentLabel(lead.segment)} Details',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SegmentFieldsCard(fields: lead.segmentFields),
            ),
          ],

          // ── Form remarks ─────────────────────────────────────────────────────
          if (lead.formRemarks != null && lead.formRemarks!.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: SectionHeader(title: 'Field Remarks'),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Text(
                    lead.formRemarks!,
                    style: textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ),
              ),
            ),
          ],

          // ── Remarks timeline ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: SectionHeader(
                title: 'Remarks Timeline',
                trailing: Text(
                  '${lead.remarksTimeline.length} total',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: lead.remarksTimeline.isEmpty
                ? _EmptyRemarks()
                : _RemarksTimeline(remarks: lead.remarksTimeline),
          ),

          // ── Add Remark section ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: SectionHeader(title: 'Add Remark'),
            ),
          ),

          SliverToBoxAdapter(
            child: _AddRemarkSection(
              leadId: lead.id,
              controller: _remarkController,
              formKey: _formKey,
              onSubmitted: () => _scrollToBottom(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }
}

// ── Hero header ───────────────────────────────────────────────────────────────

class _LeadHeroHeader extends StatelessWidget {
  final DashboardLeadModel lead;
  const _LeadHeroHeader({required this.lead});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final classColor = _classColor(lead.classification);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: classColor.withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(color: classColor.withValues(alpha: 0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lead.customerName,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Text(lead.area, style: textTheme.bodyMedium),
              const SizedBox(width: 16),
              Icon(Icons.person_outline,
                  size: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Text(lead.salesOfficerName, style: textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SegmentBadge(segment: lead.segment),
              const SizedBox(width: 8),
              LeadClassificationBadge(
                classification: lead.classification,
                compact: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _classColor(LeadClassification c) => switch (c) {
    LeadClassification.hot => AppTheme.leadHot,
    LeadClassification.warm => AppTheme.leadWarm,
    LeadClassification.cold => AppTheme.leadCold,
  };
}

// ── Lead info card ────────────────────────────────────────────────────────────

class _LeadInfoCard extends StatelessWidget {
  final DashboardLeadModel lead;
  const _LeadInfoCard({required this.lead});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Created',
              value: AppDateUtils.formatDateTime(lead.createdAt),
            ),
            const Divider(height: 1),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'GPS',
              value: lead.gpsCoordinates,
            ),
            const Divider(height: 1),
            _InfoRow(
              icon: Icons.person_outline,
              label: 'Customer Type',
              value: _customerTypeLabel(lead.customerType),
            ),
            const Divider(height: 1),
            _InfoRow(
              icon: Icons.person_pin_outlined,
              label: 'Sales Officer',
              value: lead.salesOfficerName,
            ),
            const Divider(height: 1),
            _InfoRow(
              icon: Icons.verified_outlined,
              label: 'Lead ID',
              value: lead.id.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }

  String _customerTypeLabel(CustomerType t) => switch (t) {
    CustomerType.farmer => 'Farmer',
    CustomerType.integrator => 'Integrator',
    CustomerType.dealer => 'Dealer',
    CustomerType.distributor => 'Distributor',
  };
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.primary.withValues(alpha: 0.7)),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Segment fields card ───────────────────────────────────────────────────────

class _SegmentFieldsCard extends StatelessWidget {
  final Map<String, String> fields;
  const _SegmentFieldsCard({required this.fields});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: fields.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final entry = fields.entries.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      _formatKey(entry.key),
                      style: textTheme.bodyMedium?.copyWith(
                        color:
                        colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      entry.value,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Converts camelCase key to "Title Case Label".
  String _formatKey(String key) {
    final spaced = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
          (m) => ' ${m.group(0)}',
    );
    return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
  }
}

// ── Remarks timeline ──────────────────────────────────────────────────────────

class _RemarksTimeline extends StatelessWidget {
  final List<RemarkModel> remarks;
  const _RemarksTimeline({required this.remarks});

  @override
  Widget build(BuildContext context) {
    // Oldest first (spec: "chronological list of remarks")
    final sorted = [...remarks]..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: sorted.asMap().entries.map((e) {
          return TimelineTile(
            remark: e.value,
            isLast: e.key == sorted.length - 1,
          );
        }).toList(),
      ),
    );
  }
}

// ── Empty remarks state ───────────────────────────────────────────────────────

class _EmptyRemarks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              size: 28,
            ),
            const SizedBox(width: 14),
            Text(
              'No remarks yet.\nBe the first to add one below.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.45),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add Remark section ────────────────────────────────────────────────────────

class _AddRemarkSection extends ConsumerStatefulWidget {
  final String leadId;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmitted;

  const _AddRemarkSection({
    required this.leadId,
    required this.controller,
    required this.formKey,
    required this.onSubmitted,
  });

  @override
  ConsumerState<_AddRemarkSection> createState() => _AddRemarkSectionState();
}

class _AddRemarkSectionState extends ConsumerState<_AddRemarkSection> {
  bool _isSubmitting = false;
  int _charCount = 0;
  static const int _maxChars = 300;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Author row (mocked) ──────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'RK',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rajesh Kumar',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Manager',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Text field ──────────────────────────────────────────────
              TextFormField(
                controller: widget.controller,
                maxLines: 3,
                maxLength: _maxChars,
                onChanged: (v) => setState(() => _charCount = v.length),
                decoration: InputDecoration(
                  hintText: 'Type your remark here…',
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppTheme.primary, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    const BorderSide(color: AppTheme.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppTheme.error, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor:
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Remark cannot be empty'
                    : null,
              ),

              const SizedBox(height: 6),

              // ── Character counter + submit ──────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Live character counter
                  Text(
                    '$_charCount / $_maxChars',
                    style: textTheme.bodySmall?.copyWith(
                      color: _charCount > 280
                          ? AppTheme.error
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Submit button
                  SizedBox(
                    height: 40,
                    child: FilledButton.icon(
                      onPressed: _isSubmitting ? null : _submitRemark,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      icon: _isSubmitting
                          ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.send_rounded, size: 16),
                      label: Text(
                        _isSubmitting ? 'Sending…' : 'Submit Remark',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRemark() async {
    if (!(widget.formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    // Mock 1-second delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Add remark to provider (updates timeline immediately — local state)
    ref.read(dashboardProvider.notifier).addRemark(
      widget.leadId,
      RemarkModel(
        id: 'r_${DateTime.now().millisecondsSinceEpoch}',
        authorName: 'Rajesh Kumar',
        authorRole: 'Manager',
        timestamp: DateTime.now(),
        text: widget.controller.text.trim(),
      ),
    );

    widget.controller.clear();
    setState(() {
      _charCount = 0;
      _isSubmitting = false;
    });

    // Scroll to show new remark
    widget.onSubmitted();

    // Spec: 'Sales Officer Notified' SnackBar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Sales Officer Notified'),
            ],
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
import 'package:flutter/material.dart';
import 'package:japfa_pocket_feed/shared/widgets/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:japfa_pocket_feed/core/models/lead_model.dart';
import 'package:japfa_pocket_feed/features/dashboard/providers/dashboard_provider.dart';
import 'package:japfa_pocket_feed/shared/widgets/timeline_tile.dart';
import 'package:japfa_pocket_feed/shared/widgets/lead_classification_badge.dart';

class LeadDetailScreen extends StatelessWidget {
  final String leadId;
  const LeadDetailScreen({super.key, required this.leadId});

  LeadModel? _findLead(BuildContext context) {
    final allLeads = context.read<DashboardProvider>().allLeads;
    return allLeads.firstWhere(
      (l) => l.id == leadId,
      orElse: () => throw Exception('Lead not found'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lead = _findLead(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F6),
      appBar: _buildAppBar(context, lead!),
      body: Container(
        margin: Responsive.horizontalPadding(context, false),
        child: Consumer<DashboardProvider>(
          builder: (context, provider, _) {
            final currentLead = provider.allLeads.firstWhere(
              (l) => l.id == leadId,
            );
            return Column(
              children: [
                _buildHeader(context, currentLead),
                Expanded(child: _buildTimeline(context, currentLead)),
                _buildAddRemark(context, currentLead),
              ],
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, LeadModel lead) {
    return AppBar(
      backgroundColor: const Color(0xFF1A3560),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
      title: Text(
        lead.name ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LeadModel lead) {
    final initials = _initials(lead.name ?? '');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEAECF0)),
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFDE2E2),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC0392B),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lead.name ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C2336),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Area',
                    value: lead.area,
                  ),
                  const SizedBox(height: 5),
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Officer',
                    value: lead.officer!,
                  ),
                  const SizedBox(height: 5),
                  _InfoRow(
                    icon: Icons.category_outlined,
                    label: 'Type',
                    value: lead.customerType.name.toUpperCase(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 90,
              child: LeadClassificationBadge(
                classification: lead.classification,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, LeadModel lead) {
    final sortedRemarks = List.from(lead.remarks!);
    sortedRemarks.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (sortedRemarks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEAECF0)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 120),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 32,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 10),
              const Text(
                'No remarks yet',
                style: TextStyle(fontSize: 14, color: Color(0xFFB0B7C3)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Add the first remark below to\nstart the conversation trail.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFC5CAD6),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      itemCount: sortedRemarks.length,
      itemBuilder: (context, index) {
        return TimelineTile(
          remark: sortedRemarks[index],
          isFirst: index == 0,
          isLast: index == sortedRemarks.length - 1,
        );
      },
    );
  }

  Widget _buildAddRemark(BuildContext context, LeadModel lead) {
    final controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAECF0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E6F0), width: 1.5),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Add remark...',
                  hintStyle: TextStyle(color: Color(0xFFB0B7C3), fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  isDense: true,
                ),
                maxLines: 2,
                minLines: 1,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1C2336)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context.read<DashboardProvider>().addRemark(
                    lead.id,
                    controller.text.trim(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Remark added. Sales Officer notified.'),
                    ),
                  );
                  controller.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3560),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9AA0B4)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: Color(0xFF9AA0B4)),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Color(0xFF5A6270)),
        ),
      ],
    );
  }
}

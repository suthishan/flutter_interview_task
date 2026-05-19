import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:japfa_pocket_feed/features/dashboard/lead_detail_screen.dart';
import 'package:japfa_pocket_feed/shared/widgets/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:japfa_pocket_feed/features/dashboard/providers/dashboard_provider.dart';
import 'package:japfa_pocket_feed/shared/widgets/lead_classification_badge.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F6),
      appBar: _buildAppBar(context),
      body: Container(
        margin: Responsive.horizontalPadding(context, false),
        child: Consumer<DashboardProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                _buildSummaryChips(context, provider),
                _buildFilterRow(context, provider),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildLeadList(context, provider),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final today = DateFormat('MMM d, yyyy').format(DateTime.now());
    return AppBar(
      backgroundColor: const Color(0xFF1A3560),
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manager Dashboard',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          Row(
            children: [
              Text(
                'Team Size: 12',
                style: const TextStyle(fontSize: 13, color: Color(0x99FFFFFF)),
              ),
              const SizedBox(width: 6),
              const _DotSeparator(),
              const SizedBox(width: 6),
              Text(
                today,
                style: const TextStyle(fontSize: 13, color: Color(0x99FFFFFF)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChips(BuildContext context, DashboardProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          _SummaryChip(
            label: 'HOT',
            count: provider.hotCount,
            color: const Color(0xFFC0392B),
            borderColor: const Color(0xFFFDE2E2),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 10),
          _SummaryChip(
            label: 'WARM',
            count: provider.warmCount,
            color: const Color(0xFFD4680F),
            borderColor: const Color(0xFFFDECD8),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 10),
          _SummaryChip(
            label: 'COLD',
            count: provider.coldCount,
            color: const Color(0xFF1A5DA8),
            borderColor: const Color(0xFFDDE8F8),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context, DashboardProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: ['All', 'Hot', 'Warm', 'Cold'].map((f) {
          final isSelected = provider.activeFilters.contains(f);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => provider.toggleFilter(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A3560) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1A3560)
                        : const Color(0xFFD8DCE6),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF5A6270),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLeadList(BuildContext context, DashboardProvider provider) {
    final leads = provider.filteredLeads;
    if (leads.isEmpty) {
      return Center(
        child: Text(
          'No leads match your filters',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF8A90A0)),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];
        return _LeadCard(lead: lead);
      },
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color borderColor;
  final Color backgroundColor;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
    required this.borderColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  final dynamic lead;
  const _LeadCard({required this.lead});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  Color _avatarBg(String classification) {
    switch (classification.toLowerCase()) {
      case 'hot':
        return const Color(0xFFFDE2E2);
      case 'warm':
        return const Color(0xFFFDECD8);
      default:
        return const Color(0xFFDDE8F8);
    }
  }

  Color _avatarFg(String classification) {
    switch (classification.toLowerCase()) {
      case 'hot':
        return const Color(0xFFC0392B);
      case 'warm':
        return const Color(0xFFD4680F);
      default:
        return const Color(0xFF1A5DA8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d').format(lead.createdAt);
    final classification = lead.classification.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/lead-detail', extra: lead.id),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEAECF0), width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _avatarBg(classification),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initials(lead.name ?? ''),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _avatarFg(classification),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lead.name ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C2336),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (lead.remarks.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFC0392B),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            lead.area,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A90A0),
                            ),
                          ),
                          const _MetaDot(),
                          Text(
                            lead.officer,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A90A0),
                            ),
                          ),
                          const _MetaDot(),
                          Text(
                            dateStr,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A90A0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                LeadClassificationBadge(
                  classification: lead.classification,
                  isSelected: false,
                  onTap: () {},
                  compact: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DotSeparator extends StatelessWidget {
  const _DotSeparator();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0x66FFFFFF),
      ),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFC5C9D4),
      ),
    );
  }
}

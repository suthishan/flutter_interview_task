import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../providers/visit_provider.dart';

/// Horizontal date strip showing 7 days (D-3 … today … D+3).
///
/// Improvements over the original:
/// - [ScrollController] created in [State] so it is disposed — no leak.
/// - Dot indicator shows when a date has visits (reads [datesWithVisitsProvider]).
/// - Today is marked with a distinct secondary-color dot.
/// - Uses [AutoScrollController]-equivalent via [WidgetsBinding.addPostFrameCallback]
///   to centre the selected item without a hardcoded pixel offset.
class DateSelector extends ConsumerStatefulWidget {
  const DateSelector({super.key});

  @override
  ConsumerState<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends ConsumerState<DateSelector> {
  late final ScrollController _scrollController;

  // 7 days: index 0 = D-3, index 3 = today, index 6 = D+3
  static const int _totalDays = 7;
  static const int _todayIndex = 3;
  static const double _itemWidth = 64;
  static const double _itemSpacing = 8;

  static List<DateTime> _generateDates() {
    final today = DateTime.now();
    final base = DateTime(today.year, today.month, today.day);
    return List.generate(
      _totalDays,
          (i) => base.add(Duration(days: i - _todayIndex)),
    );
  }

  @override
  void initState() {
    super.initState();
    // Centre "today" on first render without a hardcoded pixel offset.
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerToday());
  }

  void _centerToday() {
    if (!_scrollController.hasClients) return;
    final viewportWidth = _scrollController.position.viewportDimension;
    final targetOffset =
        _todayIndex * (_itemWidth + _itemSpacing) - (viewportWidth / 2) + (_itemWidth / 2);
    _scrollController.animateTo(
      targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // FIX: was missing in original
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final datesWithVisits = ref.watch(datesWithVisitsProvider);
    final dates = _generateDates();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
      child: SizedBox(
        height: 82,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            final isSelected = AppDateUtils.isSameDay(date, selectedDate);
            final isToday = AppDateUtils.isToday(date);
            final hasVisits =
            datesWithVisits.contains(AppDateUtils.dateKey(date));

            return _DateItem(
              date: date,
              isSelected: isSelected,
              isToday: isToday,
              hasVisits: hasVisits,
              onTap: () {
                ref.read(selectedDateProvider.notifier).state = date;
              },
            );
          },
        ),
      ),
    );
  }
}

// ── Private item widget keeps build() clean ───────────────────────────────────

class _DateItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool hasVisits;
  final VoidCallback onTap;

  const _DateItem({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.hasVisits,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onPrimary = AppTheme.onPrimary;
    final secondary = AppTheme.secondary;

    final selectedBg = AppTheme.onPrimary;
    final unselectedBg = Colors.transparent;

    final labelColor =
    isSelected ? AppTheme.primary : onPrimary.withValues(alpha: 0.6);
    final numberColor = isSelected ? AppTheme.primary : onPrimary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: 64,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : onPrimary.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Month
            Text(
              AppDateUtils.shortMonth(date),
              style: TextStyle(
                color: labelColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 3),
            // Day number
            Text(
              AppDateUtils.dayNumber(date),
              style: TextStyle(
                color: numberColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            // Weekday
            Text(
              AppDateUtils.shortWeekday(date),
              style: TextStyle(
                color: labelColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 5),
            // Dot row: today-dot (secondary) + visit-dot (white)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isToday)
                  _Dot(
                    color: isSelected ? secondary : secondary,
                    size: 5,
                  ),
                if (isToday && hasVisits) const SizedBox(width: 3),
                if (hasVisits && !isToday)
                  _Dot(
                    color: isSelected
                        ? AppTheme.primary.withValues(alpha: 0.4)
                        : onPrimary.withValues(alpha: 0.5),
                    size: 4,
                  ),
                // Spacer so column height stays constant when no dots
                if (!isToday && !hasVisits) const SizedBox(height: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;

  const _Dot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
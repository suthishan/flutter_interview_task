import 'package:intl/intl.dart';

/// Centralised date/time utility class for CRM Pocket Feed.
///
/// All formatting goes through [DateFormat] (intl package) — no inline
/// date arithmetic or string manipulation scattered across widgets.
///
/// This class is a pure-static utility; instantiation is blocked via
/// the private constructor.
class AppDateUtils {
  AppDateUtils._();

  // ─── FULL FORMATS ─────────────────────────────────────────────────────────

  /// e.g. "Mon, 28 Apr 2025"
  static String formatDate(DateTime date) =>
      DateFormat('EEE, dd MMM yyyy').format(date);

  /// e.g. "09:30 AM"
  static String formatTime(DateTime date) =>
      DateFormat('hh:mm a').format(date);

  /// e.g. "28 Apr 2025, 09:30 AM"
  static String formatDateTime(DateTime date) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(date);

  /// e.g. "Monday, 28 April 2025" — used in form read-only header (Task 3)
  static String formatDateLong(DateTime date) =>
      DateFormat('EEEE, dd MMMM yyyy').format(date);

  // ─── DATE STRIP HELPERS (Task 1) ──────────────────────────────────────────

  /// Short weekday for date strip, e.g. "Mon"
  static String shortWeekday(DateTime date) =>
      DateFormat('EEE').format(date);

  /// Day number for date strip, e.g. "28"
  static String dayNumber(DateTime date) =>
      DateFormat('dd').format(date);

  /// Short month for date strip, e.g. "Apr"
  static String shortMonth(DateTime date) =>
      DateFormat('MMM').format(date);

  // ─── COMPARISON ───────────────────────────────────────────────────────────

  /// True when both dates fall on the same calendar day.
  ///
  /// This is the KEY helper for Task 1 visit filtering — do NOT compare
  /// with == on DateTime objects (that includes time components).
  ///
  /// FIX: original had broken markdown URLs [a.day](http://a.day) and
  /// [b.day](http://b.day) — corrected to plain `a.day == b.day`.
  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// True when [date] falls on today's calendar day.
  ///
  /// FIX: original had [DateTime.now](http://DateTime.now)() — corrected
  /// to DateTime.now().
  static bool isToday(DateTime date) => isSameDay(date, DateTime.now());

  /// True when [date] is in the past (strictly before today's midnight).
  static bool isPast(DateTime date) {
    final today = _todayMidnight();
    return DateTime(date.year, date.month, date.day).isBefore(today);
  }

  /// True when [date] is in the future (strictly after today's midnight).
  static bool isFuture(DateTime date) {
    final today = _todayMidnight();
    return DateTime(date.year, date.month, date.day).isAfter(today);
  }

  // ─── DATE KEY (needed by datesWithVisitsProvider — Task 1) ────────────────

  /// Returns a canonical string key for a date, e.g. "2025-04-28".
  ///
  /// Used by [datesWithVisitsProvider] to build a [Set<String>] of dates
  /// that have at least one visit, so the date strip can show dot indicators
  /// without comparing [DateTime] objects directly.
  ///
  /// Using ISO-8601 format ensures lexicographic sort == chronological sort.
  static String dateKey(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  // ─── DATE STRIP GENERATOR (Task 1) ────────────────────────────────────────

  /// Returns a list of dates centered around [anchor] (default: today).
  ///
  /// With defaults, produces 7 days: D-3 … today … D+3.
  /// The [DateSelector] widget calls this with daysBefore: 3, count: 7
  /// so today is always at index 3.
  ///
  /// Stripping the time component via [DateTime(y, m, d)] ensures no
  /// off-by-one bugs from DST or system clock drift.
  static List<DateTime> generateDateStrip({
    DateTime? anchor,
    int daysBefore = 3,
    int count = 7,
  }) {
    final base = anchor ?? DateTime.now();
    final baseDay = DateTime(base.year, base.month, base.day);
    return List.generate(
      count,
          (i) => baseDay.add(Duration(days: i - daysBefore)),
    );
  }

  // ─── RELATIVE LABEL (optional UX polish) ──────────────────────────────────

  /// Returns a human-readable relative label for nearby dates.
  ///
  /// - "Today"
  /// - "Yesterday"
  /// - "Tomorrow"
  /// - Otherwise: the result of [formatDate]
  ///
  /// Useful in screen titles and empty-state messages.
  static String relativeDate(DateTime date) {
    if (isToday(date)) return 'Today';

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (isSameDay(date, yesterday)) return 'Yesterday';

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (isSameDay(date, tomorrow)) return 'Tomorrow';

    return formatDate(date);
  }

  // ─── GPS FORMAT (Task 2 & 3) ──────────────────────────────────────────────

  /// Formats mock GPS coordinates for display.
  ///
  /// e.g. formatGps(20.5937, 78.9629) → "20.593700, 78.962900"
  static String formatGps(double lat, double lng) =>
      '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';

  /// Returns a maps-style label with cardinal directions.
  ///
  /// e.g. "20.5937° N, 78.9629° E" — used in Lead Creation Form (Task 3)
  /// read-only GPS field.
  static String formatGpsLabelled(double lat, double lng) {
    final latDir = lat >= 0 ? 'N' : 'S';
    final lngDir = lng >= 0 ? 'E' : 'W';
    return '${lat.abs().toStringAsFixed(4)}° $latDir, '
        '${lng.abs().toStringAsFixed(4)}° $lngDir';
  }

  // ─── INTERNAL ─────────────────────────────────────────────────────────────

  static DateTime _todayMidnight() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
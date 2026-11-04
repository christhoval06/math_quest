import 'package:hive/hive.dart';

/// Keeps only the latest local calendar day's count, separately for each child.
/// Legacy weekday totals cannot be assigned to a date or child reliably.
class DailyPracticeProgress {
  final Box settings;
  const DailyPracticeProgress(this.settings);

  String _dateKey(DateTime date) => '${date.year}-${date.month}-${date.day}';

  int solvedOn(String profileId, DateTime date) {
    final stored = settings.get('daily_solved_$profileId');
    if (stored is! Map || stored['date'] != _dateKey(date)) return 0;
    final count = stored['count'];
    return count is int && count > 0 ? count : 0;
  }

  Future<void> record(String profileId, DateTime date, int solvedCount) async {
    if (solvedCount <= 0) return;
    final count = solvedOn(profileId, date) + solvedCount;
    await settings.put('daily_solved_$profileId', {
      'date': _dateKey(date),
      'count': count,
    });
  }
}

import 'dart:math'; // Required for max()

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class WeeklyPracticeChartCard extends StatelessWidget {
  final Map<String, int> weeklyData;
  final Color primaryColor;
  final int dailyGoal;

  const WeeklyPracticeChartCard({
    super.key,
    required this.weeklyData,
    required this.primaryColor,
    this.dailyGoal = 20,
  });

  double _getSolvedForDay(int index) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayKey = days[index];

    final value =
        weeklyData[index.toString()] ??
        weeklyData[dayKey] ??
        weeklyData[dayKey.toLowerCase()] ??
        0;

    return value.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Calculate the highest value in the current week's data
    double maxDataValue = 0;
    for (int i = 0; i < 7; i++) {
      final val = _getSolvedForDay(i);
      if (val > maxDataValue) {
        maxDataValue = val;
      }
    }

    // 2. Determine dynamic maxY:
    // It should be at least the dailyGoal (plus a bit of headroom),
    // or higher if the user solved more than the goal.
    final double targetTop = max(maxDataValue.toDouble(), dailyGoal.toDouble());
    final double calculatedMaxY =
        targetTop * 1.15; // Adds 15% headroom at the top

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.weeklyPractice,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.dailyProblemGoal(dailyGoal),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  maxDataValue == 0
                      ? AppLocalizations.of(context)!.noWeeklyData
                      : maxDataValue >= dailyGoal
                      ? AppLocalizations.of(context)!.weeklyGoalMet
                      : AppLocalizations.of(context)!.weeklyKeepGoing,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 130,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                // Use dynamic maxY with a fallback minimum (e.g., 25) so empty charts still look good
                maxY: calculatedMaxY < 25 ? 25 : calculatedMaxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        final index = val.toInt();
                        if (index < 0 || index >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .weekdayShort('d$index'),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (dayIdx) {
                  final solvedToday = _getSolvedForDay(dayIdx);
                  return BarChartGroupData(
                    x: dayIdx,
                    barRods: [
                      BarChartRodData(
                        toY: solvedToday,
                        color: solvedToday >= dailyGoal
                            ? primaryColor
                            : primaryColor.withOpacity(0.35),
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

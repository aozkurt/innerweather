import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/day_data.dart';
import '../../utils/constants.dart';


class WeekdaysBarchart extends StatelessWidget {
  WeekdaysBarchart({super.key, required this.dayData});

  final DayData dayData;

  final weekdayOrder = Constants.allWeekdays;

  @override
  Widget build(BuildContext context) {
    final weekdayMoods = dayData.averageMoodByWeekday;

    return BarChart(
      BarChartData(
        maxY: 100,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= weekdayOrder.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  weekdayOrder[index].substring(0, 1),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value % 20 == 0 && value >= 0 && value <= 100) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.black),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBorderRadius: BorderRadius.circular(8),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipColor: (group) => Colors.black.withOpacity(0.8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final weekday = weekdayOrder[group.x.toInt()];
              final mood = rod.toY.toStringAsFixed(1);
              return BarTooltipItem(
                "$weekday\nMood: $mood",
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
        barGroups: List.generate(weekdayOrder.length, (i) {
          final weekday = weekdayOrder[i];
          final mood = weekdayMoods[weekday] ?? 50.0;
          final roundedMood = double.parse(mood.toStringAsFixed(1));
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: roundedMood,
                color: Colors.black,
                width: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }
}
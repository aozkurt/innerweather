import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/day_data.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatted_date_helper.dart';


class AllDaysInner extends StatelessWidget {
  final double heightFactor;

  const AllDaysInner({super.key, this.heightFactor = 0.2});

  @override
  Widget build(BuildContext context) {
    final dayData = Provider.of<DayData>(context);

    final allDays =
        dayData.getDaysForSeason('Spring') +
            dayData.getDaysForSeason('Summer') +
            dayData.getDaysForSeason('Fall') +
            dayData.getDaysForSeason('Winter');

    final validDays = allDays.where((d) {
      try {
        FormattedDateHelper.parseFormattedDate(d.date);
        return true;
      } catch (_) {
        return false;
      }
    }).toList();

    validDays.sort((a, b) {
      final aDate = FormattedDateHelper.parseFormattedDate(a.date);
      final bDate = FormattedDateHelper.parseFormattedDate(b.date);
      return aDate.compareTo(bDate);
    });

    final now = Constants.now;
    final last30Days = validDays.where((d) {
      final date = FormattedDateHelper.parseFormattedDate(d.date);
      return date.isAfter(now.subtract(const Duration(days: 30)));
    }).toList();

    final moodValues = last30Days
        .map((d) => d.mood?.toDouble() ?? Constants.defaultMood)
        .toList();

    final smoothed = moodValues.cast<double>();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: smoothed.isNotEmpty ? smoothed.length.toDouble() - 1 : 0,
        minY: 0,
        maxY: 100,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),

        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              smoothed.length,
                  (i) => FlSpot(i.toDouble(), smoothed[i]),
            ),
            isCurved: true,
            barWidth: 1,
            color: Colors.black,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: false,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBorderRadius: BorderRadius.circular(8),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipColor: (spots) => Colors.black.withOpacity(0.8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = FormattedDateHelper.parseFormattedDate(
                  last30Days[spot.spotIndex].date,
                );
                return LineTooltipItem(
                  "${date.day}/${date.month}\nMood: ${spot.y.toInt()}",
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList();
            },
          ),

          getTouchedSpotIndicator: (barData, indicators) {
            return indicators.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: Colors.transparent,
                  strokeWidth: 0,
                ), // hides the line
                FlDotData(show: true), // keeps the dot
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
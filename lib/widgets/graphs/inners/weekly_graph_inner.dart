import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/day_data.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatted_date_helper.dart';

class LastWeekInner extends StatelessWidget {
  final double heightFactor;

  const LastWeekInner({super.key, this.heightFactor = 0.2});

  String _getShortWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayData = Provider.of<DayData>(context);
    final today = Constants.now;
    final last7Dates = List.generate(
      7,
          (i) => today.subtract(Duration(days: 6 - i)),
    );

    final allDays = dayData.getDaysForSeason(dayData.getSeasonFromDate(today))
      ..sort(
            (a, b) => FormattedDateHelper.parseFormattedDate(
          a.date,
        ).compareTo(FormattedDateHelper.parseFormattedDate(b.date)),
      );

    final moodByDate = {
      for (var day in allDays) day.date: day.mood ?? Constants.defaultMood,
    };

    final screenHeight = Constants.getHeight(context);
    final screenWidth = Constants.getWidth(context);

    final spots = List.generate(last7Dates.length, (index) {
      final date = last7Dates[index];
      final formatted = FormattedDateHelper.formatDate(date);
      return FlSpot(
        index.toDouble(),
        (moodByDate[formatted] ?? Constants.defaultMood).toDouble(),
      );
    });

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.01,
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 6,
                    ),
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index < 0 || index >= last7Dates.length) {
                    return const SizedBox.shrink();
                  }
                  final date = last7Dates[index];
                  final weekdayLabel = _getShortWeekdayName(date.weekday);
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      weekdayLabel,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                interval: 1,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 1,
              dotData: FlDotData(show: false),
              color: Colors.black,
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
                  final date = last7Dates[spot.spotIndex];
                  return LineTooltipItem(
                    "${_getShortWeekdayName(date.weekday)}\nMood: ${spot.y.toInt()}",
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
                  FlLine(color: Colors.transparent, strokeWidth: 0),
                  FlDotData(show: true),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
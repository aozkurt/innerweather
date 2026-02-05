import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/day_data.dart';
import '../../style/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/formatted_date_helper.dart';

class SeasonalMoodGraph extends StatelessWidget {
  final String season;

  const SeasonalMoodGraph({required this.season, super.key});

  @override
  Widget build(BuildContext context) {
    final dayData = Provider.of<DayData>(context);
    final days = dayData.getDaysForSeason(season);

    final averagedMoods = <double>[];
    final averagedDays = <String>[];

    for (int i = 0; i < days.length; i += 2) {
      final day1 = days[i];
      final mood1 = (day1.mood ?? Constants.defaultMood).toDouble();

      double avgMood;
      if (i + 1 < days.length) {
        final day2 = days[i + 1];
        final mood2 = (day2.mood ?? Constants.defaultMood).toDouble();
        avgMood = (mood1 + mood2) / 2.0;

        final date1 = FormattedDateHelper.parseFormattedDate(day1.date);
        final date2 = FormattedDateHelper.parseFormattedDate(day2.date);
        averagedDays.add(
          "${date1.day}/${date1.month}–${date2.day}/${date2.month}",
        );
      } else {
        avgMood = mood1;
        final date1 = FormattedDateHelper.parseFormattedDate(day1.date);
        averagedDays.add("${date1.day}/${date1.month}");
      }

      averagedMoods.add(avgMood);
    }

    final spots = List.generate(
      averagedMoods.length,
          (i) => FlSpot(i.toDouble(), averagedMoods[i]),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 100,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20,
                  reservedSize: 30,
                  getTitlesWidget: (value, _) => Text(
                    value.toInt().toString(),
                    style: AppTextStyles.seasonalGraphLeftTextStyle,
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.black,
                barWidth: 1,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],

            lineTouchData: LineTouchData(
              enabled: true,
              getTouchedSpotIndicator: (barData, spotIndexes) =>
                  spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(color: Colors.transparent, strokeWidth: 0),
                      FlDotData(show: true),
                    );
                  }).toList(),
              touchTooltipData: LineTouchTooltipData(
                tooltipBorderRadius: BorderRadius.circular(8),
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                getTooltipColor: (spots) => Colors.black.withOpacity(0.8),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final label = averagedDays[spot.spotIndex];
                    final mood = averagedMoods[spot.spotIndex].toStringAsFixed(
                      1,
                    );
                    return LineTooltipItem(
                      "$label\nMood: $mood",
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
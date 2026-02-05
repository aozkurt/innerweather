import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/day_data.dart';
import '../../style/app_text_styles.dart';
import '../wrapper_card.dart';



Widget buildWeatherStats(DayData dayData, double screenWidth) {
  final avgMoods = dayData.averageMoodByWeather;
  final frequencies = dayData.weatherFrequency;
  final weatherTypes = avgMoods.keys.toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ...weatherTypes.map((weather) {
        final mood = avgMoods[weather]!;
        final freq = frequencies[weather];
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WrapperCard(
              width: screenWidth * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$weather ", // added frequency in parentheses
                        textAlign: TextAlign.center,
                        style: AppTextStyles.weekdaysTextStyle,
                      ),
                      SizedBox(width: 5),
                      Text("$freq day(s)", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Avg Mood: ${mood.toStringAsFixed(1)}",
                    style: AppTextStyles.weekdaysMoodTextStyle,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    ],
  );
}
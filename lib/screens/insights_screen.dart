import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/day_data.dart';
import '../style/app_colors.dart';
import '../style/app_text_styles.dart';
import '../utils/constants.dart';
import '../widgets/day_card.dart';
import '../widgets/graphs/build_weather_stats.dart';
import '../widgets/graphs/weekdays_barchart.dart';
import '../widgets/wrapper_card.dart';
import 'day_editor_screen.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = Constants.getWidth(context);
    final dayData = Provider.of<DayData>(context);

    final bestDay = dayData.oneOfBestDays;
    final worstDay = dayData.oneOfWorstDays;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Average Mood by Weekdays",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.graphTitleStyle,
                  ),
                ),
                WrapperCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ), // Prevent full width
                    child: SizedBox(
                      height: 200,
                      child: WeekdaysBarchart(dayData: dayData),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Average Mood by Weather",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.graphTitleStyle,
                  ),
                ),
                buildWeatherStats(dayData, screenWidth),
                const SizedBox(height: 20),

                if (bestDay != null) ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Best Day",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.graphTitleStyle,
                    ),
                  ),
                  DayCard(
                    date: bestDay.date,
                    mood: bestDay.mood ?? 50,
                    weather: bestDay.weather,
                    isEditable: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DayEditorScreen(day: bestDay),
                        ),
                      );
                    },
                    day: bestDay,
                  ),
                  const SizedBox(height: 12),
                ],

                if (worstDay != null) ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Worst Day",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.graphTitleStyle,
                    ),
                  ),
                  DayCard(
                    date: worstDay.date,
                    mood: worstDay.mood ?? 50,
                    weather: worstDay.weather,
                    isEditable: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DayEditorScreen(day: worstDay),
                        ),
                      );
                    },
                    day: worstDay,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
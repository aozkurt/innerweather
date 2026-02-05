import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/day.dart';
import '../models/day_data.dart';
import '../style/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatted_date_helper.dart';
import '../widgets/day_card.dart';
import '../widgets/season_card.dart';
import 'day_editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dayData = Provider.of<DayData>(context);
    final now = Constants.now;
    final today = FormattedDateHelper.formatDate(now);
    final currentSeason = dayData.getSeasonFromDate(now);

    final screenWidth = Constants.getWidth(context);
    final screenHeight = Constants.getHeight(context);

    final todayDay = dayData
        .getDaysForSeason(currentSeason)
        .firstWhere(
          (d) => d.date == today,
      orElse: () => Day(
        mood: Constants.defaultMood,
        weather: Constants.defaultWeather,
      ),
    );

    if (dayData.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SafeArea(
      child: Container(
        color: AppColors.background,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DayCard(
                  date: today,
                  mood: todayDay.mood ?? Constants.defaultMood,
                  weather: todayDay.weather,
                  isEditable: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DayEditorScreen(day: todayDay),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                    );
                  },
                  day: todayDay,
                ),
                SizedBox(height: screenHeight * 0.01),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SeasonCard(
                      season: Constants.seasonSpring,
                      riveAnim: "assets/animations/spring.riv",
                      bgColor: AppColors.springColor,
                    ),
                    SeasonCard(
                      season: Constants.seasonSummer,
                      riveAnim: "assets/animations/summer.riv",
                      bgColor: AppColors.summerColor,
                    ),
                    SeasonCard(
                      season: Constants.seasonFall,
                      riveAnim: "assets/animations/fall.riv",
                      bgColor: AppColors.fallColor,
                    ),
                    SeasonCard(
                      season: Constants.seasonWinter,
                      riveAnim: "assets/animations/winter.riv",
                      bgColor: AppColors.winterColor,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
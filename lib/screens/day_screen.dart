import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;

import '../models/day.dart';
import '../style/app_colors.dart';
import '../style/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/weather_config.dart';
import '../widgets/custom_text_field.dart';

class DayScreen extends StatelessWidget {
  final Day day;

  const DayScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final screenWidth = Constants.getWidth(context);
    final screenHeight = Constants.getHeight(context);

    final config = weatherConfigs[day.weather] ??
        WeatherConfig(
          gradientColors: [Colors.grey.shade900, Colors.black],
          animation: 'assets/animations/weathers/cloudy.riv',
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,
          centerTitle: true,
          title: Text(day.date, style: AppTextStyles.editDateStyle),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: config.gradientColors,
            stops: const [0.0, 0.4, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Mood: ',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          '${day.mood}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Weather: ',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          day.weather,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Note:',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextField(
                  screenHeight: screenHeight,
                  child: SingleChildScrollView(
                    child: Text(
                      day.note ?? Constants.defaultNote,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.3,
                  child: RiveAnimation.asset(
                    config.animation,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
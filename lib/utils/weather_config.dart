import 'package:flutter/material.dart';

import '../style/app_colors.dart';

class WeatherConfig {
  final List<Color> gradientColors;
  final String animation;

  const WeatherConfig({required this.gradientColors, required this.animation});
}

final Map<String, WeatherConfig> weatherConfigs = {
  'Sunny': WeatherConfig(
    gradientColors: [
      AppColors.background,
      Color(0xFF282D57),
      Color(0xFF596F98),
      Color(0xFFDABA79),
    ],
    animation: 'assets/animations/sunny.riv',
  ),
  'Snowy': WeatherConfig(
    gradientColors: [
      AppColors.background,
      Color(0xFF282D57),
      Color(0xFF4D5291),
      Color(0xFFAFBFE4),

    ],
    animation: 'assets/animations/snowy.riv',
  ),
  'Rainy': WeatherConfig(
    gradientColors: [
      AppColors.background,
      Color(0xFF15151B),
      Color(0xFF282D57),
      Color(0xFFAFBFE4),
    ],
    animation: 'assets/animations/rainy.riv',
  ),
  'Stormy': WeatherConfig(
    gradientColors: [
      AppColors.background,
      Color(0xFF15151B),
      Color(0xFF282D57),
      Color(0xFFAFBFE4),
    ],
    animation: 'assets/animations/stormy.riv',
  ),
  'Cloudy': WeatherConfig(
    gradientColors: [
      AppColors.background,
      Color(0xFF15151B),
      Color(0xFF282D57),
      Color(0xFFAFBFE4),
    ],
    animation: 'assets/animations/cloudy.riv',
  ),
};
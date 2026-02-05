import 'package:flutter/material.dart';

class IconUtils {
  // Mood Icons
  static IconData getMoodIcon(int mood) {
    if (mood >= 80) return Icons.sentiment_very_satisfied;
    if (mood >= 60) return Icons.sentiment_satisfied;
    if (mood >= 40) return Icons.sentiment_neutral;
    if (mood >= 20) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  static Color getMoodColor(int mood) {
    if (mood >= 80) return Color(0xFF3AB54A);
    if (mood >= 60) return Color(0xFF91CA5F);
    if (mood >= 40) return Color(0xFFFAB140);
    if (mood >= 20) return Color(0xFFF25A29);
    return Color(0xFFE12025);
  }

  // Weather Icons
  static const Map<String, IconData> weatherIcons = {
    'Sunny': Icons.wb_sunny,
    'Cloudy': Icons.wb_cloudy,
    'Rainy': Icons.umbrella_outlined,
    'Snowy': Icons.ac_unit,
    'Stormy': Icons.thunderstorm,
  };
}
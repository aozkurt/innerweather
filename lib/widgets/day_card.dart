import 'package:flutter/material.dart';

import '../models/day.dart';
import '../screens/day_screen.dart';
import '../style/app_text_styles.dart';
import '../utils/icon_utils.dart';

class DayCard extends StatelessWidget {
  final String date;
  final String weather;
  final int mood;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final bool isAutoCreated;
  final bool isEditable;
  final Day day;

  const DayCard({
    super.key,
    required this.date,
    required this.weather,
    required this.mood,
    required this.onTap,
    required this.day,
    this.isAutoCreated = false,
    this.isEditable = false,
    this.height = 60,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final moodIcon = IconUtils.getMoodIcon(mood);
    final weatherIcon = IconUtils.weatherIcons[weather];
    final moodColor = IconUtils.getMoodColor(mood);

    return GestureDetector(
      onTap: () {
        if (isEditable) {
          onTap();
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DayScreen(day: day),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        }
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: AppTextStyles.dayCardBoxDecoration,
        height: height,
        width: width,
        child: Row(
          children: [
            // Date Text
            Expanded(
              flex: 5,
              child: Text(
                date,
                style: AppTextStyles.dateTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isEditable) const Icon(Icons.update, size: 16),
                  const SizedBox(width: 5),
                  Icon(moodIcon, size: 22, color: moodColor),
                  const SizedBox(width: 5),
                  if (weatherIcon != null) Icon(weatherIcon, size: 22),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
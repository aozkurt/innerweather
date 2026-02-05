import 'package:flutter/material.dart';

import '../style/app_colors.dart';
import '../utils/icon_utils.dart';

class WeatherSelector extends StatelessWidget {
  final String selectedWeather;
  final Function(String) onSelected;

  const WeatherSelector({
    required this.selectedWeather,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final weatherList = IconUtils.weatherIcons.entries.toList();

    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: List.generate(weatherList.length, (index) {
          final entry = weatherList[index];
          final isSelected = selectedWeather == entry.key;

          return GestureDetector(
            onTap: () => onSelected(entry.key),
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.lightTone.withOpacity(0.3)
                    : Colors.white.withOpacity(0.08),
                border: Border.all(
                  color: isSelected ? AppColors.lightTone : Colors.white24,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                entry.value,
                size: 32,
                color: isSelected ? AppColors.lightTone : Colors.white,
              ),
            ),
          );
        }),
      ),
    );
  }
}
import 'package:provider/provider.dart';

import '../models/day.dart';
import 'package:flutter/material.dart';

import '../models/day_data.dart';
import '../style/app_colors.dart';
import '../style/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/formatted_date_helper.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/weather_selector.dart';

class DayEditorScreen extends StatefulWidget {
  final Day? day;

  const DayEditorScreen({super.key, this.day});

  @override
  State<DayEditorScreen> createState() => _DayEditorScreenState();
}

class _DayEditorScreenState extends State<DayEditorScreen> {
  late int mood;
  late String selectedWeather;
  late TextEditingController _noteController;
  late String date;

  @override
  void initState() {
    super.initState();

    if (widget.day != null) {
      mood = widget.day!.mood ?? Constants.defaultMood;
      selectedWeather = widget.day!.weather == Constants.defaultWeather
          ? Constants.sunnyWeather
          : widget.day!.weather;
      _noteController = TextEditingController(
        text: widget.day!.note ?? Constants.defaultNote,
      );
      date = widget.day!.date;
    } else {
      mood = Constants.defaultMood;
      selectedWeather = Constants.sunnyWeather;
      _noteController = TextEditingController();
      date = FormattedDateHelper.formatDate(DateTime.now());
    }
  }

  void saveDay() async {
    final dayData = Provider.of<DayData>(context, listen: false);
    final season = dayData.getSeasonFromDate(DateTime.now());

    final newDay = Day.withDate(
      date: date,
      mood: mood,
      weather: selectedWeather,
      note: _noteController.text.isEmpty
          ? Constants.defaultNote
          : _noteController.text,
      isAutoCreated: false,
    );

    await dayData.updateDay(newDay);

    final exists = dayData
        .getDaysForSeason(season)
        .any((existing) => existing.date == date);

    if (!exists) {
      await dayData.addDayToSeason(season, newDay);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              // Date
              Text(
                date,
                textAlign: TextAlign.center,
                style: AppTextStyles.graphTitleStyle,
              ),

              SizedBox(height: screenHeight * 0.04),

              // Mood
              Text(
                "Mood: $mood",
                textAlign: TextAlign.center,
                style: AppTextStyles.editMoodStyle,
              ),
              Slider(
                activeColor: AppColors.lightTone,
                inactiveColor: Colors.grey.shade700,
                thumbColor: AppColors.lightTone,
                value: mood.toDouble(),
                min: 0,
                max: 100,
                label: "$mood",
                onChanged: (value) {
                  setState(() {
                    mood = value.round();
                  });
                },
              ),

              SizedBox(height: screenHeight * 0.05),

              // Weather
              const Text(
                "Weather",
                style: AppTextStyles.selectedWeatherStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              WeatherSelector(
                selectedWeather: selectedWeather,
                onSelected: (value) => setState(() => selectedWeather = value),
              ),

              SizedBox(height: screenHeight * 0.05),

              // Notes
              CustomTextField(
                screenHeight: screenHeight,
                child: TextField(
                  controller: _noteController,
                  cursorColor: Colors.white,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Write your thoughts...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Save button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightTone,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: saveDay,
                child: Text(
                  widget.day != null ? "Save Changes" : "Save Day",
                  style: AppTextStyles.editButtonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
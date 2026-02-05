import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../utils/formatted_date_helper.dart';
import '../utils/icon_utils.dart';
import 'day.dart';

class DayData extends ChangeNotifier {
  final Map<String, List<Day>> _seasonalDays = {
    Constants.seasonSpring: [],
    Constants.seasonSummer: [],
    Constants.seasonFall: [],
    Constants.seasonWinter: [],
  };

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DayData() {
    loadData();
  }

  // Getters for seasonal days
  List<Day> getDaysForSeason(String season) => _seasonalDays[season]!;

  // a function to find out the season from a date
  String getSeasonFromDate(DateTime date) {
    final month = date.month;
    if ([12, 1, 2].contains(month)) return Constants.seasonWinter;
    if ([3, 4, 5].contains(month)) return Constants.seasonSpring;
    if ([6, 7, 8].contains(month)) return Constants.seasonSummer;
    return Constants.seasonFall;
  }

  // a function to add a day to a season, only used once in add_day_screen.dart,
  // an async function, it saves data to the storage
  Future<void> addDayToSeason(String season, Day day) async {
    // Exists a boolean, which checks if the day already exists in the season
    // .any is a function that checks if there is at least one instance of the given object in the list
    // for every 'existing' days in the seasons days list, searches for the given day in the list
    // if there is no days that shares the same date as the given day, exists will be false
    final exists = _seasonalDays[season]!.any(
          (existing) => existing.date == day.date,
    );
    //if exists false so no same day exists, add the day to the season list with its add method
    if (!exists) {
      _seasonalDays[season]!.add(day);
      await _saveData();
      notifyListeners();
    }
  }

  //checks if the day is in the correct season, in case seasonal days list is wrong
  List<Day> getAllDaysInSeasonByDate(String season) {
    return _seasonalDays.values
        .expand((list) => list)
        .where((d) =>
    getSeasonFromDate(FormattedDateHelper.parseFormattedDate(d.date)) ==
        season)
        .toList();
  }

  // gets shared preferences instance,
  // all of the key, values into the seasonal days assigned into the key, value variables
  // creating a new map with MapEntry, keys being keys (string) values being a list of days
  // getting all the days inside of the list and assigning them to e variable
  // then turns them into json maps then puts them into a list.
  // we have a Map<String, List<Map<String, dynamic>>>> instead of the Map<String, List<Day>>.
  // so the season days map turned into a map that all of the days are json objects
  // with json encode, we are turning the map into a json string
  //then storing it into a database with shared preferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _seasonalDays.map(
            (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
    );

    await prefs.setString('seasonal_days', encoded);
  }

  Future<void> fillMissingDaysWithDefaults(String season) async {
    final allRelevantDays = getAllDaysInSeasonByDate(season);
    if (allRelevantDays.isEmpty) return;

    DateTime earliestDate = allRelevantDays
        .map((d) => FormattedDateHelper.parseFormattedDate(d.date))
        .reduce((a, b) => a.isBefore(b) ? a : b);

    DateTime now = Constants.now;
    DateTime today = DateTime(now.year, now.month, now.day);

    final existingDates = _seasonalDays.values
        .expand((list) => list)
        .map((d) => d.date)
        .toSet();

    for (DateTime date = earliestDate;
    date.isBefore(today);
    date = date.add(const Duration(days: 1))) {

      final formattedDate = FormattedDateHelper.formatDate(date);

      if (!existingDates.contains(formattedDate)) {
        final seasonForDate = getSeasonFromDate(date);
        final newDay = Day.withDate(
          date: formattedDate,
          mood: Constants.defaultMood,
          weather: Constants.defaultWeather,
          note: Constants.defaultNote,
          isAutoCreated: true,
        );

        _seasonalDays[seasonForDate]!.add(newDay);
      }
    }

    await _saveData();
    notifyListeners();
  }

  Future<void> updateDay(Day updatedDay) async {
    for (var entry in _seasonalDays.entries) {
      final index = entry.value.indexWhere((d) => d.date == updatedDay.date);
      if (index != -1) {
        entry.value[index] = updatedDay;
        await _saveData();
        notifyListeners();
        return;
      }
    }
  }

  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('seasonal_days');

      if (data != null) {
        final Map<String, dynamic> decoded = jsonDecode(data);
        decoded.forEach((season, daysList) {
          final days = List<Map<String, dynamic>>.from(
            daysList,
          ).map((json) => Day.fromJson(json)).toList();
          _seasonalDays[season] = days;
        });
      }
    } catch (e) {
      debugPrint('Failed to load data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> exportAsJson() async {
    final encoded = jsonEncode(
      _seasonalDays.map(
            (key, value) => MapEntry(
          key,
          value.map((e) => e.toJson()).toList(),
        ),
      ),
    );
    return encoded;
  }

  Future<void> importFromJson(String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

      final Map<String, List<Day>> restored = {
        Constants.seasonSpring: [],
        Constants.seasonSummer: [],
        Constants.seasonFall: [],
        Constants.seasonWinter: [],
      };

      for (final entry in restored.keys) {
        if (!decoded.containsKey(entry)) {
          throw Exception('Missing season key: $entry');
        }

        final daysList = List<Map<String, dynamic>>.from(decoded[entry]);
        restored[entry] =
            daysList.map((json) => Day.fromJson(json)).toList();
      }

      _seasonalDays
        ..clear()
        ..addAll(restored);

      await _saveData();
      notifyListeners();
    } catch (e) {
      debugPrint('Import failed: $e');
      rethrow;
    }
  }

  int countUserAddedDays() {
    return _seasonalDays.values
        .expand((list) => list)       // flatten all seasons into one list
        .where((day) => !day.isAutoCreated) // filter user-added
        .length;                      // count them
  }

  Day? _cachedBestDay;
  Day? _cachedWorstDay;
  String? _lastBestDayGeneratedDate;

  Day? get oneOfBestDays {
    final todayStr = FormattedDateHelper.formatDate(DateTime.now());

    if (_cachedBestDay != null && _lastBestDayGeneratedDate == todayStr) {
      return _cachedBestDay;
    }

    final allDays = _seasonalDays.values.expand((days) => days).toList();
    final validDays = allDays.where((d) => d.mood != null).toList();
    if (validDays.isEmpty) return null;

    final maxMood = validDays.map((d) => d.mood!).reduce(max);
    final bestDays = validDays.where((d) => d.mood == maxMood).toList();

    _cachedBestDay = bestDays[Random().nextInt(bestDays.length)];
    _lastBestDayGeneratedDate = todayStr;

    return _cachedBestDay;
  }

  Day? get oneOfWorstDays {
    final todayStr = FormattedDateHelper.formatDate(DateTime.now());

    if (_cachedWorstDay != null && _lastBestDayGeneratedDate == todayStr) {
      return _cachedWorstDay;
    }

    final allDays = _seasonalDays.values.expand((days) => days).toList();
    final validDays = allDays.where((d) => d.mood != null).toList();
    if (validDays.isEmpty) return null;

    final minMood = validDays.map((d) => d.mood!).reduce(min);
    final worstDays = validDays.where((d) => d.mood == minMood).toList();

    _cachedWorstDay = worstDays[Random().nextInt(worstDays.length)];
    _lastBestDayGeneratedDate = todayStr;

    return _cachedWorstDay;
  }

  Map<String, double> get averageMoodByWeekday {
    final allDays = _seasonalDays.values.expand((days) => days).toList();
    final moodSums = <String, int>{};
    final moodCounts = <String, int>{};

    for (final day in allDays) {
      if (day.mood == null) continue;
      final dateTime = FormattedDateHelper.parseFormattedDate(day.date);
      final weekday = DateFormat('EEEE').format(dateTime);
      moodSums[weekday] = (moodSums[weekday] ?? 0) + day.mood!;
      moodCounts[weekday] = (moodCounts[weekday] ?? 0) + 1;
    }

    final allWeekdays = Constants.allWeekdays;

    final averages = <String, double>{};
    for (final weekday in allWeekdays) {
      if (moodSums.containsKey(weekday)) {
        averages[weekday] = moodSums[weekday]! / moodCounts[weekday]!;
      } else {
        averages[weekday] = 50.0;
      }
    }

    return averages;
  }

  Map<String, double> get averageMoodByWeather {
    final weatherTypes = IconUtils.weatherIcons.keys.toList();

    final allDays = _seasonalDays.values.expand((d) => d).toList();
    final moodSums = <String, int>{};
    final moodCounts = <String, int>{};

    for (final day in allDays) {
      if (day.mood == null || day.weather == Constants.defaultWeather) continue;
      final weather = day.weather;
      moodSums[weather] = (moodSums[weather] ?? 0) + day.mood!;
      moodCounts[weather] = (moodCounts[weather] ?? 0) + 1;
    }

    final averages = <String, double>{};
    for (final weather in weatherTypes) {
      if (moodSums.containsKey(weather)) {
        averages[weather] = moodSums[weather]! / moodCounts[weather]!;
      } else {
        averages[weather] = 50.0;
      }
    }

    return averages;
  }

  Map<String, int> get weatherFrequency {
    final weatherTypes = IconUtils.weatherIcons.keys.toList();

    final allDays = _seasonalDays.values.expand((d) => d).toList();
    final frequency = <String, int>{};

    for (final day in allDays) {
      final weather = day.weather;
      if (weather == Constants.defaultWeather) continue;
      frequency[weather] = (frequency[weather] ?? 0) + 1;
    }

    for (final weather in weatherTypes) {
      frequency.putIfAbsent(weather, () => 0);
    }

    return frequency;
  }


}
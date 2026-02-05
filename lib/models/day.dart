import '../utils/constants.dart';
import '../utils/formatted_date_helper.dart';

class Day {
  late final String date;
  final String weather;
  final String? note;
  final int? mood;
  final bool isAutoCreated;

  //Default Constructor to create a day that has the current date
  Day({
    this.mood = Constants.defaultMood,
    this.weather = Constants.defaultWeather,
    this.note = Constants.defaultNote,
    this.isAutoCreated = false,
  }) {
    //Constructor body {}
    date = FormattedDateHelper.formatDate(DateTime.now());
  }

  // A named constructor to create a day with a specific date, used for auto-created days that has dates other than today,
  // editing days that has dates other than today
  // and getting days from the json files that has dates other than today
  Day.withDate({
    required this.date,
    this.mood = Constants.defaultMood,
    this.weather = Constants.defaultWeather,
    this.note = Constants.defaultNote,
    this.isAutoCreated = false,
  });

  //Map<String, dynamic> is dart's version of a JSON object
  //using factory here because we want to use the Day.withDate named constructor instead of default.
  factory Day.fromJson(Map<String, dynamic> json) {
    return Day.withDate(
      date: json['date'],
      mood: json['mood'],
      weather: json['weather'],
      note: json['note'],
      isAutoCreated: json['isAutoCreated'] ?? false,
    );
  }

  //Function for turning a Day object into a JSON object so we can save the data
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'weather': weather,
      'note': note,
      'mood': mood,
      'isAutoCreated': isAutoCreated,
    };
  }
}

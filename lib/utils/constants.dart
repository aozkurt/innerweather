import 'package:flutter/material.dart';

class Constants{

  // mood
  static const defaultMood = 50;

  // weathers
  static const defaultWeather = 'Natural';
  static const sunnyWeather = 'Sunny';
  static const cloudyWeather = 'Cloudy';
  static const rainyWeather = 'Rainy';
  static const snowyWeather = 'Snowy';
  static const stormyWeather = 'Stormy';

  // note
  static const defaultNote = '';

  // seasons
  static const seasonSpring = 'Spring';
  static const seasonSummer = 'Summer';
  static const seasonFall = 'Fall';
  static const seasonWinter = 'Winter';

  static final allWeekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  static final now = DateTime.now();

  static double getHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static double getWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
}
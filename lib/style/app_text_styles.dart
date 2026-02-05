import 'package:flutter/material.dart';

class AppTextStyles {
  //Season Screen
  static const seasonScreenStyle = TextStyle(fontSize: 16, color: Colors.white);
  static const seasonNameStyle = TextStyle(color: Colors.white);

  //Edit Day Screen
  static const editDateStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const editMoodStyle = TextStyle(color: Colors.white);
  static const selectedWeatherStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const textFieldInputDecoration = InputDecoration(
    labelText: "Note",
    labelStyle: TextStyle(color: Colors.white),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
  static const editButtonTextStyle = TextStyle(color: Colors.black);

  //Graph Screen
  static const weekdaysTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const weekdaysTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.black87,
  );

  static const weekdaysMoodTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  //Graph Screen 2

  static const graphTitleStyle = TextStyle(color: Colors.white, fontSize: 16);

  //Day Card

  static const dateTextStyle = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.bold,
  );

  static BoxDecoration dayCardBoxDecoration = BoxDecoration(
    color: Colors.grey.shade300,
    borderRadius: BorderRadius.circular(30.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 0,
      ),
    ],
  );

  //Season Card

  static const seasonCardTextStyle = TextStyle(fontSize: 18);

  //Seasonal Graph

  static const seasonalGraphLeftTextStyle = TextStyle(
    fontSize: 10,
    color: Colors.black,
  );
}
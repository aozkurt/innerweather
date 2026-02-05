import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../screens/season_screen.dart';
import '../style/app_text_styles.dart';
import '../utils/constants.dart';

class SeasonCard extends StatelessWidget {
  final String season;
  final double? width;
  final double? height;
  final String riveAnim;
  final Color bgColor;

  const SeasonCard({
    super.key,
    required this.season,
    this.width,
    this.height,
    required this.riveAnim,
    required this.bgColor,
  });
  @override
  Widget build(BuildContext context) {
    final screenHeight = Constants.getHeight(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (context, animation, secondaryAnimation) =>
                SeasonScreen(season: season),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: AppTextStyles.dayCardBoxDecoration,
        width: width ?? double.infinity,
        height: height ?? screenHeight * 0.15,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Stack(
            children: [
              Container(color: bgColor),
              Opacity(
                opacity: 0.7,
                child: RiveAnimation.asset(
                  riveAnim,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              Center(
                child: Text(
                  season,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
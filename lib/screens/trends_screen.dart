import 'package:flutter/material.dart';

import '../style/app_colors.dart';
import '../style/app_text_styles.dart';
import '../utils/constants.dart';
import '../widgets/ai_insight_button.dart';
import '../widgets/graphs/monthly_graph.dart';
import '../widgets/graphs/seasonal_graph.dart';
import '../widgets/graphs/weekly_graph.dart';
import '../widgets/info_row.dart';
import '../widgets/wrapper_card.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  String? expandedSeason;

  void toggleExpanded(String season) {
    setState(() {
      if (expandedSeason == season) {
        expandedSeason = null;
      } else {
        expandedSeason = season;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = Constants.getWidth(context);

    Widget buildSeasonCard(String season, Color color) {
      final isSelected = expandedSeason == season;
      return AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: isSelected ? double.infinity : null,
        child: WrapperCard(
          color: color,
          child: Stack(
            children: [
              SeasonalMoodGraph(season: season),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    isSelected ? Icons.zoom_in_map : Icons.zoom_out_map,
                    size: 15,
                  ),
                  onPressed: () => toggleExpanded(season),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: 10,
          ),
          child: Column(
            children: [
              Text("Weekly Graph", style: AppTextStyles.graphTitleStyle),
              SizedBox(height: 10),
              LastWeekMoodGraph(),
              SizedBox(height: 10),
              Text("", style: AppTextStyles.graphTitleStyle),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AiInsightButton(),
                  IconButton(
                    onPressed: () => _showAiInfo(context),
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text("Seasonal Graphs", style: AppTextStyles.graphTitleStyle),
              SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOutCubic,
                      ),
                      child: child,
                    ),
                  );
                },
                child: expandedSeason != null
                    ? buildSeasonCard(
                  expandedSeason!,
                  getColorForSeason(expandedSeason!),
                )
                    : GridView.count(
                  key: const ValueKey("grid"),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildSeasonCard('Spring', AppColors.springColor),
                    buildSeasonCard('Summer', AppColors.summerColor),
                    buildSeasonCard('Fall', AppColors.fallColor),
                    buildSeasonCard('Winter', AppColors.winterColor),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text("Monthly Graph", style: AppTextStyles.graphTitleStyle),
              SizedBox(height: 10),
              AllDaysGraph(),
            ],
          ),
        ),
      ),
    );
  }

  Color getColorForSeason(String season) {
    switch (season) {
      case 'Spring':
        return AppColors.springColor;
      case 'Summer':
        return AppColors.summerColor;
      case 'Fall':
        return AppColors.fallColor;
      case 'Winter':
        return AppColors.winterColor;
      default:
        return Colors.grey;
    }
  }

  void _showAiInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Mood Insight',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              InfoRow(
                icon: Icon(Icons.info, color: AppColors.background),
                title: 'About',
                text:
                'AI Insights analyze your mood data to offer reflective observations. '
                    'They are not medical advice and may not always be accurate. '
                    'A short ad may be shown before accessing AI Insights to support the app.',
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
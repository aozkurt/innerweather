import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/day_data.dart';
import '../style/app_colors.dart';
import '../style/app_text_styles.dart';
import '../widgets/days_list.dart';

class SeasonScreen extends StatefulWidget {
  final String season;

  const SeasonScreen({super.key, required this.season});

  @override
  State<SeasonScreen> createState() => _SeasonScreenState();
}

class _SeasonScreenState extends State<SeasonScreen> {
  bool _didFill = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didFill) {
      final dayData = Provider.of<DayData>(context, listen: false);
      final hasAnyRealDay = dayData
          .getAllDaysInSeasonByDate(widget.season)
          .any((d) => !d.isAutoCreated);

      if (hasAnyRealDay) {
        _didFill = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!dayData.isLoading && mounted) {
            Future.delayed(const Duration(milliseconds: 200), () {
              dayData.fillMissingDaysWithDefaults(widget.season);
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayData = Provider.of<DayData>(context);

    if (dayData.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final dayCount = dayData.getDaysForSeason(widget.season).length;
    final currentSeason = dayData.getSeasonFromDate(DateTime.now());
    final isCurrentSeason = currentSeason == widget.season;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            '${widget.season} Days',
            style: AppTextStyles.seasonNameStyle,
          ),
          backgroundColor: AppColors.background,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: 10),
          child: dayCount == 0
              ? Center(
            child: Text(
              isCurrentSeason
                  ? "This season is waiting for your first entry."
                  : "You haven't recorded anything for this season yet.",
              textAlign: TextAlign.center,
              style: AppTextStyles.seasonScreenStyle,
            ),
          )
              : DaysList(season: widget.season),
        ),
      ),
    );
  }
}
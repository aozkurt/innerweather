import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/day_data.dart';
import '../screens/day_editor_screen.dart';
import '../style/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatted_date_helper.dart';
import 'day_card.dart';

class DaysList extends StatefulWidget {
  final String season;

  const DaysList({super.key, required this.season});

  @override
  State<DaysList> createState() => _DaysListState();
}

class _DaysListState extends State<DaysList> {
  final ScrollController _scrollController = ScrollController();
  final int _batchSize = 20;
  int _loadedItemCount = 0;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoadingMore) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() async {
    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _loadedItemCount += _batchSize;
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DayData>(
      builder: (context, dayData, _) {
        final allDays = dayData.getDaysForSeason(widget.season);
        final visibleDays = allDays.take(_loadedItemCount + _batchSize).toList();

        return ListView.builder(
          controller: _scrollController,
          itemCount: visibleDays.length + (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == visibleDays.length) {
              final Color loaderColor;
              switch (widget.season.toLowerCase()) {
                case 'spring':
                  loaderColor = AppColors.springColor;
                  break;
                case 'summer':
                  loaderColor = AppColors.summerColor;
                  break;
                case 'autumn':
                  loaderColor = AppColors.fallColor;
                  break;
                case 'winter':
                  loaderColor = AppColors.winterColor;
                  break;
                default:
                  loaderColor = Colors.grey;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Center(
                  child: CircularProgressIndicator(
                    color: loaderColor,
                    strokeWidth: 3,
                  ),
                ),
              );
            }

            final day = visibleDays[index];
            return DayCard(
              date: day.date,
              weather: day.weather,
              mood: day.mood ?? Constants.defaultMood,
              isAutoCreated: day.isAutoCreated,
              isEditable: FormattedDateHelper.isToday(day.date) || day.isAutoCreated,
              onTap: () {
                if (FormattedDateHelper.isToday(day.date) || day.isAutoCreated) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                      pageBuilder: (context, animation, secondaryAnimation) => DayEditorScreen(day: day),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
                }
              },
              day: day,
            );
          },
        );
      },
    );
  }
}
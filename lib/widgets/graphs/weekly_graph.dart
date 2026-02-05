import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../wrapper_card.dart';
import 'inners/weekly_graph_inner.dart';

class LastWeekMoodGraph extends StatefulWidget {
  final double collapsedHeightFactor;
  final double expandedHeightFactor;

  const LastWeekMoodGraph({
    super.key,
    this.collapsedHeightFactor = 0.25,
    this.expandedHeightFactor = 0.5,
  });

  @override
  State<LastWeekMoodGraph> createState() => _LastWeekMoodGraphState();
}

class _LastWeekMoodGraphState extends State<LastWeekMoodGraph> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = Constants.getHeight(context);

    return WrapperCard(
      height: isExpanded
          ? screenHeight * (widget.expandedHeightFactor + 0.02)
          : screenHeight * (widget.collapsedHeightFactor + 0.01),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.zoom_in_map : Icons.zoom_out_map,
                  size: 15,
                ),
                onPressed: () => setState(() => isExpanded = !isExpanded),
              ),
            ],
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isExpanded
                  ? RotatedBox(quarterTurns: 1, child: LastWeekInner())
                  : LastWeekInner(),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:innerweather/screens/settings_panel.dart';
import 'package:innerweather/screens/trends_screen.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:provider/provider.dart';
import '../ads/ad_manager.dart';
import '../models/day_data.dart';
import '../style/app_colors.dart';
import '../style/app_text_styles.dart';
import '../widgets/glowing_dot.dart';
import 'home_screen.dart';
import 'insights_screen.dart';

class ScreenNavigation extends StatefulWidget {
  const ScreenNavigation({super.key});

  @override
  State<ScreenNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<ScreenNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    InsightsScreen(),
    TrendsScreen(),
  ];

  Future<void> _initMediaStore() async {
    await MediaStore.ensureInitialized();

    MediaStore.appFolder = 'Innerweather';
  }

  @override
  void initState() {
    super.initState();
    _initMediaStore();
    InterstitialAdManager.load();
  }

  @override
  Widget build(BuildContext context) {

    final dayData = Provider.of<DayData>(context);
    final addedDays = dayData.countUserAddedDays();

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.grey.shade900,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 15),
                  GlowingDot(),
                  SizedBox(width: 10),
                  Text(
                    '$addedDays ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Days Added',
                    style: AppTextStyles.graphTitleStyle,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: GestureDetector(
                  child: Icon(Icons.settings, color: Colors.white),
                  onTap: () => showSettingsPanel(context),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.lightTone,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.grey.shade900,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Trends',
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style/app_colors.dart';
import '../utils/notification_helper.dart';

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({super.key});

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  bool notificationsEnabled = false;

  static const _prefsKey = 'notifications_enabled';

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_prefsKey) ?? false;

    setState(() => notificationsEnabled = enabled);

    // If notifications were enabled, ensure they are scheduled
    if (enabled) {
      final helper = NotificationHelper();
      await helper.init();
      await helper.scheduleDailyAround9PM();
    }
  }

  Future<void> _onToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);

    setState(() => notificationsEnabled = value);

    final helper = NotificationHelper();

    if (value) {
      // User enabled notifications
      await helper.init();
      await helper.requestPermissions();
      await helper.scheduleDailyAround9PM();
    } else {
      // User disabled notifications
      await helper.cancelAll();
    }
  }


  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        "Daily Notifications",
        style: TextStyle(color: AppColors.background),
      ),
      value: notificationsEnabled,
      onChanged: _onToggle,
      secondary: const Icon(Icons.notifications, color: AppColors.background),
      activeColor: AppColors.background,
      inactiveTrackColor: AppColors.lightTone,
    );
  }
}
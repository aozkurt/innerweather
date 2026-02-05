import 'package:intl/intl.dart';

class FormattedDateHelper {
  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  static DateTime parseFormattedDate(String dateStr) {
    try {
      return DateFormat('EEEE, MMMM d, yyyy').parse(dateStr);
    } catch (_) {
      return DateTime.now();
    }
  }

  static bool isToday(String formattedDate) {
    final date = parseFormattedDate(formattedDate);
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
import 'package:intl/intl.dart';

class DateFormatter {
  static String getMonthName(DateTime dateTime) {
    return DateFormat.MMMM().format(dateTime);
  }

  static String getTodayDate(DateTime dateTime) {
    return DateFormat.d().format(dateTime);
  }

  static String getFormattedTime(DateTime dateTime) {
    return DateFormat("hh:mm a").format(dateTime);
  }

  static String getFormattedDateTime(DateTime dateTime) {
    return DateFormat("dd-MM-yyyy hh:mm a").format(dateTime);
  }
}

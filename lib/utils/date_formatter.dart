import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatter {
  static String toShortDateText(context, DateTime date) {
    initializeDateFormatting('id', null);
    return DateFormat('dd ').format(date) +
        DateFormat.MMM('id').format(date) +
        DateFormat(' yyyy').format(date);
  }

  static String toLongDateText(context, DateTime date) {
    initializeDateFormatting('id', null);
    return DateFormat('dd ').format(date) +
        DateFormat.MMMM('id').format(date) +
        DateFormat(' yyyy').format(date);
  }

  static String removeSecondFromTime(String time) {
    var dateF = DateFormat('yyyy-MM-dd ').format(DateTime.now());
    return DateFormat('HH:mm').format(DateTime.parse(dateF + time));
  }

  static String format12HourPeriod(context, String time, String locale) {
    var dateF = DateFormat('yyyy-MM-dd ').format(DateTime.now());
    var rawDate = DateTime.parse(dateF + time);
    if (locale == 'id') {
      initializeDateFormatting('id', null);
      if (rawDate.hour >= 0 && rawDate.hour < 11)
        return DateFormat('hh:mm ').format(rawDate) + ' Pagi';
      else if (rawDate.hour >= 11 && rawDate.hour < 15)
        return DateFormat('hh:mm ').format(rawDate) + ' Siang';
      else if (rawDate.hour >= 15 && rawDate.hour < 19)
        return DateFormat('hh:mm ').format(rawDate) + ' Sore';
      else
        return DateFormat('hh:mm ').format(rawDate) + ' Malam';
    } else {
      return DateFormat('hh:mm a').format(rawDate);
    }
  }

  static DateTime strTimeToTime(String time) {
    var dateF = DateFormat('yyyy-MM-dd ').format(DateTime.now());
    return DateTime.parse(dateF + time);
  }
}

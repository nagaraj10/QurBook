import 'package:intl/intl.dart';

class FHBUtils {
  String convertMonthFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    String formattedDate = DateFormat('MMM').format(todayDate);

    return formattedDate.toUpperCase();
  }

  String convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    String formattedDate = DateFormat('dd').format(todayDate);

    return formattedDate;
  }
}

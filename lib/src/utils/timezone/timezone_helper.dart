import 'package:flutter_timezone/flutter_timezone.dart';

class TimeZoneHelper {
  static Future<String> get getCurrentTimezone async => await FlutterTimezone.getLocalTimezone();
}
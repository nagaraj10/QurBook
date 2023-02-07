import 'package:get/get.dart';
import 'package:myfhb/src/utils/language/app_localizations.dart';

extension StringExtensions on String {
  String t() => AppLocalizations.of(Get.context).translate(this) ?? '';
}

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;

class Utils {
  static const Map<String, String> supportedLanguages = {
    'english': 'en',
    'french': 'fr',
    'german': 'de',
    'spanish': 'es',
    'bengali': 'bn',
    'gujarati': 'gu',
    'hindi': 'hi',
    'kannada': 'kn',
    'malayalam': 'ml',
    'tamil': 'ta',
    'telugu': 'te',
  };

  static const Map<String, String> langaugeCodes = {
    'en': 'en-IN',
    'ta': 'ta-IN',
    'te': 'te-IN',
    'hi': 'hi-IN',
    'undef': 'undef',
    'bn': 'bn-IN',
    'gu': 'gu-IN',
    'kn': 'kn-IN',
    'ml': 'ml-IN',
    'es': 'es-ES',
    'fr': 'fr-FR',
    'de': 'de-DE'
  };

  static String getCurrentLanCode() {
    if (PreferenceUtil.getStringValue(constants.SHEELA_LANG) != null &&
        PreferenceUtil.getStringValue(constants.SHEELA_LANG) != '') {
      return PreferenceUtil.getStringValue(constants.SHEELA_LANG);
    } else {
      return 'undef';
    }
  }
}

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;

class Utils {
  static String getCurrentLanCode() {
    if (PreferenceUtil.getStringValue(constants.SHEELA_LANG) != null &&
        PreferenceUtil.getStringValue(constants.SHEELA_LANG) != '') {
      return PreferenceUtil.getStringValue(constants.SHEELA_LANG);
    } else {
      return 'undef';
    }
  }
}

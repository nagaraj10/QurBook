import 'dart:convert';
import './timezone_helper.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/fhb_constants.dart' as constants;
import '../../../constants/fhb_query.dart' as query;
import '../../resources/network/ApiBaseHelper.dart';

class TimezoneServices {
  Future<bool> checkUpdateTimezone({bool isUpdateTimezone = true}) async {
    try {
      final lastTimeZone = await PreferenceUtil.getLastTimeZone();
      final currentTimezone = await TimeZoneHelper.getCurrentTimezone;

      if (currentTimezone != lastTimeZone) {
        if (isUpdateTimezone) {
          updateTimezone(currentTimezone);
        }
        return true;
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  updateTimezone(String currentTimezone) async {
    try {
      final userid = PreferenceUtil.getStringValue(constants.KEY_USERID)!;

      final _apiBaseHelper = ApiBaseHelper();
      final body = {
        'id': userid,
        'timezone': currentTimezone,
      };
      final jsonData = json.encode(body);
      final req = await _apiBaseHelper.updateUserTimeZone(
        query.qr_user + userid + query.qr_section + query.qr_generalInfo,
        jsonData,
      );
      if (req != null) {
        await PreferenceUtil.saveLastTimeZone(currentTimezone);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }
}

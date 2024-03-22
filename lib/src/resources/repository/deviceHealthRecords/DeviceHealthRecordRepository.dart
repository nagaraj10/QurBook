
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

import 'package:myfhb/constants/fhb_query.dart' as query;

class DeviceHealthRecord {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<dynamic> postDeviceData(String jsonString) async {
    /*String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var response = await _helper.saveDeviceData(
        query.qr_deviceInfo +
        query.qr_slash +
        query.qr_user +
        query.qr_slash +
        userID +
        query.qr_slash + query.qr_deviceInfo,
        jsonString) ;
*/
    var response =
        await _helper.saveDeviceData(query.qr_DeviceInfo, jsonString);
    return response;
  }

  Future<dynamic> getLastsynctime(String qr_param) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
    //print('static user id ${Constants.asgurduserID}');

    var response = await _helper.getDeviceInfo(query.qr_DeviceInfo +
        query.qr_slash +
        query.qr_User +
        query.qr_slash +
        userID +
        query.qr_slash +
        query.qr_LastSync +
        qr_param);
    return response;
  }

  Future<dynamic> getlastMeasureSync({String? userId}) async {
    var userID;
    if (userId != null) {
      userID = userId;
    } else {
      userID = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
    }

    var response = await _helper.getDeviceInfo(query.qr_DeviceInfo +
        query.qr_slash +
        query.qr_User +
        query.qr_slash +
        userID +
        query.qr_slash +
        query.qr_LastMeasureSync);

    return response;
  }

  Future<dynamic> queryBydeviceInterval(String jsonString,{String filter='',String? userId}) async {

    var userID;
    if (userId != null) {
      userID = userId;
    } else {
      userID = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
    }

    var response = await _helper.getByRecordDataType(
        query.qr_DeviceInfo +
            query.qr_slash +
            query.qr_User +
            query.qr_slash +
            userID +
            query.qr_slash +
            query.qr_DeviceInterval+
            (filter!=''?query.qr_calendarType+filter:''),
        jsonString);
    return response;
  }
}

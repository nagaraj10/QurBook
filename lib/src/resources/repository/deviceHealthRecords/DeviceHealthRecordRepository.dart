import 'dart:convert' as convert;
import 'dart:io';

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/record_detail/model/MetaDataMovedResponse.dart';
import 'package:myfhb/record_detail/model/UpdateMediaResponse.dart';
import 'package:myfhb/src/model/Health/DigitRecogResponse.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/PostImageResponse.dart';
import 'package:myfhb/src/model/Health/SavedMetaDataResponse.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';

import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class DeviceHealthRecord {
  ApiBaseHelper _helper = ApiBaseHelper();

/*
  Future<dynamic> queryByRecordDatatype(String jsonString) async {
    print(jsonString);
    String userID = "117bdb52-4f2b-4a3e-8ae6-f0278ba1535b";

    var response = await _helper.getByRecordDataType(
        query.qr_devicehealthrecord +
            userID +
            query.qr_slash +
            query.qr_getByRecordDataType,
        jsonString);
    return response;
  }*/

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
        await _helper.saveDeviceData(query.qr_deviceInfo, jsonString);
    return response;
  }

  Future<dynamic> getLastsynctime(String qr_param) async {
    //String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    String userID = "49cdc4be-afd9-419e-b3f9-1bd35207c74f";

  var response = await _helper.getLastsynctime(query.qr_deviceInfo +
        query.qr_slash +
        query.qr_user +
        query.qr_slash +
        userID +
        query.qr_slash +
        query.qr_lastSync+qr_param);
    return response;
  }
}

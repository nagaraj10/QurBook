import 'dart:typed_data';

import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

//import 'dart:convert' as convert;

class HealthReportListForUserRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserHealthResponseList> getHealthReportList() async {
    final response = await _helper.getHealthRecordList(
        "mediameta/" + Constants.USER_ID + "/getmediameta/");
    return UserHealthResponseList.fromJson(response);
  }

  Future<dynamic> getDoctorProfile(String doctorsId) async {
    final response = await _helper
        .getDoctorProfilePic("doctors/" + doctorsId + "/getprofilepic");
    return response;
  }


  Future<dynamic> getDocumentImage(String metaMasterID) async {
    final response = await _helper
        .getDocumentImage("mediameta/"+Constants.USER_ID +"/getRawMedia/"+metaMasterID);
    return response;
  }
}

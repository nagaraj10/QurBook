import 'dart:convert';

import 'package:intl/intl.dart';

import '../../common/PreferenceUtil.dart';
import '../../constants/HeaderRequest.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_query.dart' as variable;
import '../models/regiment_response_model.dart';
import '../models/save_response_model.dart';
import '../models/field_response_model.dart';
import '../models/profile_response_model.dart';
import '../../common/CommonUtil.dart';
import 'package:myfhb/src/resources/network/api_services.dart';

class RegimentService {
  static Future<RegimentResponseModel> getRegimentData(
      {String dateSelected, int isSymptoms = 0}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var currentLanguage = '';
      var lan = CommonUtil.getCurrentLanCode();
      if (lan != 'undef') {
        var langCode = lan.split('-').first;
        currentLanguage = langCode;
      } else {
        currentLanguage = 'en';
      }
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            "method": "get",
            "data":
                "Action=GetUserActivities&lang=$currentLanguage&date=$dateSelected&issymptom=$isSymptoms${variable.qr_patientEqaul}$userId",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return RegimentResponseModel.fromJson(json.decode(response.body));
      } else {
        return RegimentResponseModel(
          regimentsList: [],
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<SaveResponseModel> saveFormData(
      {String eid, String events}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'post',
            'data':
                "Action=SaveFormForEvent&eid=$eid${events ?? ''}${variable.qr_patientEqaul}$userId",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return SaveResponseModel.fromJson(json.decode(response.body));
      } else {
        return SaveResponseModel(
          result: SaveResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<SaveResponseModel> deleteMedia({String eid}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'post',
            'data':
                "Action=ResetOtherData&eid=$eid&dataname=PHOTO${variable.qr_patientEqaul}$userId",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return SaveResponseModel.fromJson(json.decode(response.body));
      } else {
        return SaveResponseModel(
          result: SaveResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<SaveResponseModel> updatePhoto({String eid, String url}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'post',
            'data':
                "Action=SetOtherData&eid=$eid&dataname=PHOTO&name=&url=$url",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return SaveResponseModel.fromJson(json.decode(response.body));
      } else {
        return SaveResponseModel(
          result: SaveResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<FieldsResponseModel> getFormData({String eid}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'get',
            'data':
                "Action=GetFormForEvent&eid=$eid${variable.qr_patientEqaul}$userId",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return FieldsResponseModel.fromJson(json.decode(response.body));
      } else {
        return FieldsResponseModel(
          result: ResultDataModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<ProfileResponseModel> getProfile() async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'get',
            'data': "&Action=GetProfile${variable.qr_patientEqaul}$userId",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return ProfileResponseModel.fromJson(json.decode(response.body));
      } else {
        return ProfileResponseModel(
          result: ProfileResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<SaveResponseModel> saveProfile({String schedules}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'post',
            'data':
                "Action=SetProfile$schedules&IsDefault=0${variable.qr_patientEqaul}$userId",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return SaveResponseModel.fromJson(json.decode(response.body));
      } else {
        return SaveResponseModel(
          result: SaveResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<SaveResponseModel> undoSaveFormData({String eid}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'post',
            'data': "Action=UnDO&eid=$eid${variable.qr_patientEqaul}$userId",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return SaveResponseModel.fromJson(json.decode(response.body));
      } else {
        return SaveResponseModel(
          result: SaveResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<SaveResponseModel> enableDisableActivity({
    String eidUser,
    DateTime startTime,
    bool isDisable = true,
  }) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var hh = DateFormat('HH').format(startTime);
      var mm = DateFormat('mm').format(startTime);
      var date = '${CommonUtil.dateConversionToApiFormat(startTime)}';
      var hide = isDisable ? '1' : '0';
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'post',
            'data':
                "Action=ShowHideEvent&teid_user=$eidUser&hh=$hh&mm=$mm&hide=$hide${variable.qr_patientEqaul}$userId",
            // 'data':
            //     'Action=${isDisable ? 'DisableUserActivity' : 'EnableUserActivity'}&teid=$eidUser${variable.qr_patientEqaul}$userId',
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return SaveResponseModel.fromJson(json.decode(response.body));
      } else {
        return SaveResponseModel(
          result: SaveResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }
}

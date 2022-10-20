import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/models/ExternalLinksResponseModel.dart';
import 'package:myfhb/regiment/models/GetEventIdModel.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:provider/provider.dart';

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
      {String dateSelected,
      int isSymptoms = 0,
      bool isForMasterData = false,
      String searchText = ''}) async {
    var response;
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
      if (isForMasterData) {
        response = await ApiServices.post(
          urlForRegiment,
          headers: headerRequest,
          body: json.encode(
            {
              "method": "get",
              "data":
                  "Action=GetUserActivities&lang=$currentLanguage&date=$dateSelected&issymptom=$isSymptoms&all=1&page=0&pagesize=50&search=$searchText${variable.qr_patientEqaul}$userId",
            },
          ),
        );
      } else {
        response = await ApiServices.post(
          urlForRegiment,
          headers: headerRequest,
          body: json.encode(
            {
              "method": "get",
              "data":
                  "Action=GetUserActivities&lang=$currentLanguage&date=$dateSelected&issymptom=$isSymptoms${variable.qr_patientEqaul}$userId",
            },
          ),
          timeOutSeconds: 60,
        );
      }

      if (response != null && response.statusCode == 200) {
        print(response.body);
        return RegimentResponseModel.fromJson(json.decode(response.body));
      } else {
        return RegimentResponseModel(
          regimentsList: [],
        );
      }
    } catch (e) {
      print(e.toString());

      return RegimentResponseModel(
        regimentsList: [],
      );
    }
  }

  static Future<ExternalLinksResponseModel> getExternalLinks() async {
    var response;
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
        response = await ApiServices.post(
          urlForRegiment,
          headers: headerRequest,
        );

      if (response != null && response.statusCode == 200) {
        print(response.body);
        return ExternalLinksResponseModel.fromJson(json.decode(response.body));
      } else {
        return ExternalLinksResponseModel(
        );
      }
    } catch (e) {
      print(e.toString());
      return ExternalLinksResponseModel( );
    }
  }

  static Future<SaveResponseModel> saveFormData(
      {String eid,
      String events,
      bool isFollowEvent,
      String followEventContext,
      DateTime selectedDate,
      TimeOfDay selectedTime}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    var localTime;
    try {
      if (Provider.of<RegimentViewModel>(Get.context, listen: false)
              .regimentFilter ==
          RegimentFilter.AsNeeded) {
        localTime = CommonUtil.dateFormatterWithdatetimeseconds(
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
              selectedTime.hour, selectedTime.minute),
          isIndianTime: true,
        );
      } else {
        localTime = CommonUtil.dateFormatterWithdatetimeseconds(
          DateTime.now(),
          isIndianTime: true,
        );
      }

      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var followEventParams = '';
      if (isFollowEvent ?? false) {
        followEventParams =
            '&followevent=1&context=${followEventContext ?? ''}';
      }
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'post',
            'data':
                "Action=SaveFormForEvent&eid=$eid&ack_local=$localTime${(isFollowEvent ?? false) ? Provider.of<RegimentViewModel>(Get.context, listen: false).cachedEvents?.reduce((value, element) => value + element) : events ?? ''}${variable.qr_patientEqaul}$userId$followEventParams&source=QURBOOK",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        getProviderFromTriggerInputs(response.body);
        return SaveResponseModel.fromJson(json.decode(response.body));
      } else {
        return SaveResponseModel(
          result: SaveResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      return SaveResponseModel(
        result: SaveResultModel(),
        isSuccess: false,
      );
      throw Exception('$e was thrown');
    }
  }

   static getProviderFromTriggerInputs(String response){
    var data;
    var data1;
    var data2;
    final decoded = jsonDecode(response) as Map;
    if (decoded != null) {
      data = decoded['result'] as Map;
    }
    if (data != null) {
      data1 = data['actions'] as Map;
    }
    if (data1 != null) {
      data2 = data1['input'] as Map;
    }
    if (data2 != null) {
      for (final name in data2.keys) {
        final value = data2[name];
        if (name.contains('pf_')) {
          var provider =
          Provider.of<RegimentViewModel>(Get.context, listen: false);
          provider.cachedEvents
              ?.removeWhere((element) => element?.contains(name));
          provider.cachedEvents.add('&$name=$value'.toString());
        }
      }
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

  static Future<SaveResponseModel> undoSaveFormData({
    String eid,
    String activityDate,
  }) async {
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
                "Action=UnDO&eid=$eid${variable.qr_patientEqaul}$userId&date=$activityDate",
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

  static Future<GetEventIdModel> getEventId(
      {dynamic uid, dynamic aid, dynamic formId, dynamic formName}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForGetEventId = Constants.BASE_URL + variable.getEventId;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var response = await ApiServices.post(
        urlForGetEventId,
        headers: headerRequest,
        body: json.encode(
          {
            'uid': uid,
            'aid': aid,
            'formId': formId,
            'formName': formName,
            'userId': userId
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return GetEventIdModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }
}

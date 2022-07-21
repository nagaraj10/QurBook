import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/calllogmodel.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/callpushmodel.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/carecoordinatordata.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/keysofmodel.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/src/resources/network/AppException.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/ui/loader_class.dart';

class QurHomeApiProvider {
  DateTime selectedRegimenDate = DateTime.now();

  Future<dynamic> getRegimenList(String date) async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    try {
      RegimentResponseModel regimentsData;

      regimentsData = await RegimentService.getRegimentData(
        dateSelected: CommonUtil.dateConversionToApiFormat(
          selectedRegimenDate,
          isIndianTime: true,
        ),
        isSymptoms: 0,
      );
      return regimentsData;

      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.get(
        '${CommonUtil.BASE_URL_FROM_RES}kiosk/$userId?date=$date',
        headers: header,
      );
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return null;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> unPairHub(String hubId) async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    var data = {"userHubId": hubId};
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.post(
        '${CommonUtil.BASE_URL_QURHUB}user-hub/unpair-hub',
        headers: header,
        body: json.encode(data),
      );
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return null;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e) {
      return null;
    }
  }

  getCareCoordinatorId() async {
    var regController = Get.find<QurhomeRegimenController>();
    http.Response responseJson;
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID_MAIN);
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.get(
        '${Constants.BASE_URL}$qr_getCareCoordinatorId$userId',
        headers: header,
      );
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        regController.careCoordinatorIdEmptyMsg.value =
            CommonUtil().validString(json.decode(responseJson.body));
        return null;
      }
    } on SocketException {
      regController.careCoordinatorIdEmptyMsg.value =
          CommonUtil().validString(strNoInternet);
      throw FetchDataException(strNoInternet);
    } catch (e) {
      regController.careCoordinatorIdEmptyMsg.value =
          CommonUtil().validString(e.toString());
      return null;
    }
  }

  Future<bool> callMessagingAPI(
      {String token, CallPushNSModel callModel}) async {
    bool isCallSent = false;
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = await ApiServices.post(
        Constants.BASE_URL + qr_messaging,
        headers: header,
        body: jsonEncode(callModel.toJson()),
      );

      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        if (response[c_res_isSuccess] == true) {
          isCallSent = true;
        }
      } else {
        CallMessagingErrorResponse err =
            CallMessagingErrorResponse.fromJson(json.decode(res.body));
        if (err.isSuccess == false && err.diagnostics?.message != null) {
          FlutterToast().getToast(
              'Could not initiate call. Please try again later', Colors.red);
        } else {
          FlutterToast().getToast(
              ((err?.message ?? '')).isNotEmpty
                  ? err?.message
                  : 'Could not initiate call. Please try again later',
              Colors.red);
        }
        isCallSent = false;
      }
    } on Exception catch (e) {
      isCallSent = false;
    }
    return isCallSent;
  }

  /*Future<bool> callMissedCallNsAlertAPI({dynamic request}) async {
    bool isCallSent = false;
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = await ApiServices.post(
        Constants.BASE_URL + qr_triggerMissedCallNotification,
        headers: header,
        body: convert.jsonEncode(request),
      );

      if (res.statusCode == 200) {
        var response = convert.json.decode(res.body);
        return response['isSuccess'];
      } else {
        var response = convert.json.decode(res.body);
        return response['isSuccess'];
      }
    } on Exception catch (e) {
      isCallSent = false;
    }
    return isCallSent;
  }*/

  Future<dynamic> callLogData({CallLogModel request}) async {
    try {
      var regController = Get.find<QurhomeRegimenController>();
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = await ApiServices.post(
        Constants.BASE_URL + qr_callLog,
        headers: header,
        body: convert.jsonEncode(request.toJson()),
      );
      if (res.statusCode == 200) {
        CallLogResponseModel _response =
            CallLogResponseModel.fromJson(convert.json.decode(res.body));
        regController.resultId.value =
            CommonUtil().validString(_response.result);

        regController.callStartTime.value =
            CommonUtil().validString(request.startedTime);

        return _response.isSuccess;
      } else {
        CallLogErrorResponseModel error =
            CallLogErrorResponseModel.fromJson(convert.json.decode(res.body));
        return error.isSuccess;
      }
    } catch (e) {}
  }

  Future<dynamic> callLogEndData({CallEndModel request}) async {
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = await ApiServices.put(
        Constants.BASE_URL + qr_callLog,
        headers: header,
        body: convert.jsonEncode(request.toJson()),
      );
      if (res.statusCode == 200) {
        CallLogResponseModel _response =
            CallLogResponseModel.fromJson(convert.json.decode(res.body));

        return _response.isSuccess;
      } else {
        CallLogErrorResponseModel error =
            CallLogErrorResponseModel.fromJson(convert.json.decode(res.body));
        return error.isSuccess;
      }
    } catch (e) {}
  }

  Future<dynamic> callMissedCallNsAlertAPI({CallLogModel request}) async {
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = await ApiServices.post(
        Constants.BASE_URL + qr_triggerMissedCallNotification,
        headers: header,
        body: convert.jsonEncode(request.toJson()),
      );
      if (res.statusCode == 200) {
        CallLogResponseModel _response =
            CallLogResponseModel.fromJson(convert.json.decode(res.body));

        return _response.isSuccess;
      } else {
        CallLogErrorResponseModel error =
            CallLogErrorResponseModel.fromJson(convert.json.decode(res.body));
        return error.isSuccess;
      }
    } catch (e) {}
  }

  Future<dynamic> startRecordSOSCall() async {
    try {
      var regController = Get.find<QurhomeRegimenController>();
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      var data = {
        qr_meetingId: CommonUtil().validString(regController.meetingId.value),
        qr_UID: CommonUtil().validString(regController.UID.value)
      };
      http.Response res = await ApiServices.post(
        Constants.BASE_URL + qr_startRecordCallLog,
        headers: header,
        body: json.encode(data),
      );
      if (res.statusCode == 200) {
        CallRecordModel _response =
            CallRecordModel.fromJson(convert.json.decode(res.body));

        regController.resourceId.value =
            CommonUtil().validString(_response.result.resourceId);

        regController.sid.value =
            CommonUtil().validString(_response.result.sid);

        return _response.isSuccess;
      } else {
        CallLogErrorResponseModel error =
            CallLogErrorResponseModel.fromJson(convert.json.decode(res.body));
        return error.isSuccess;
      }
    } catch (e) {}
  }

  Future<dynamic> stopRecordSOSCall() async {
    try {
      var regController = Get.find<QurhomeRegimenController>();
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      var data = {
        qr_meetingId: CommonUtil().validString(regController.meetingId.value),
        qr_UID: CommonUtil().validString(regController.UID.value),
        qr_resourceId: CommonUtil().validString(regController.resourceId.value),
        qr_sid: CommonUtil().validString(regController.sid.value),
        qr_callLogId: CommonUtil().validString(regController.resultId.value),
      };
      http.Response res = await ApiServices.post(
        Constants.BASE_URL + qr_stopRecordCallLog,
        headers: header,
        body: json.encode(data),
      );
      if (res.statusCode == 200) {
        CallLogResponseModel _response =
            CallLogResponseModel.fromJson(convert.json.decode(res.body));
        return _response.isSuccess;
      } else {
        CallLogErrorResponseModel error =
            CallLogErrorResponseModel.fromJson(convert.json.decode(res.body));
        return error.isSuccess;
      }
    } catch (e) {}
  }

  getSOSAgentNumber() async {
    var regController = Get.find<QurhomeRegimenController>();
    http.Response responseJson;
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      var data = {
        qr_location: regController.locationModel,
      };
      responseJson = await ApiServices.post(
        '${Constants.BASE_URL}$qr_getSOSAgentNumber',
        headers: header,
        body: json.encode(data),
      );
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        regController.SOSAgentNumberEmptyMsg.value =
            CommonUtil().validString(json.decode(responseJson.body));
        return null;
      }
    } on SocketException {
      regController.SOSAgentNumberEmptyMsg.value =
          CommonUtil().validString(strNoInternet);
      throw FetchDataException(strNoInternet);
    } catch (e) {
      regController.SOSAgentNumberEmptyMsg.value =
          CommonUtil().validString(e.toString());
      return null;
    }
  }
}

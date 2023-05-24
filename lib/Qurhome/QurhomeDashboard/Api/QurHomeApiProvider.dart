import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/CareGiverPatientList.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/calllogmodel.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/callpushmodel.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/carecoordinatordata.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/SuccessModel.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_data.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_list_model.dart';
import 'package:myfhb/authentication/service/authservice.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/keysofmodel.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/resources/network/AppException.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/video_call/model/UpdatedInfo.dart';
import '../../../constants/variable_constant.dart' as variable;

class QurHomeApiProvider {
  //DateTime selectedRegimenDate = DateTime.now();
  final ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<dynamic> getRegimenList(String date, {String? patientId}) async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    try {
      RegimentResponseModel regimentsData;
      String selectedDate = '';
      if (date != null) {
        selectedDate = date;
      } else {
        selectedDate = CommonUtil.dateConversionToApiFormat(
          date != null ? DateTime.now() : DateTime.parse(date),
          isIndianTime: true,
        );
      }
      regimentsData = await RegimentService.getRegimentData(
          dateSelected: CommonUtil.dateConversionToApiFormat(
            (date.length == 0) ? DateTime.now() : DateTime.parse(date),
            isIndianTime: true,
          ),
          isSymptoms: 0,
          patientId: patientId);
      return regimentsData;

      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = (await ApiServices.get(
        '${CommonUtil.BASE_URL_FROM_RES}kiosk/$userId?date=$date',
        headers: header,
      ))!;
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

  Future<dynamic> getRegimenListCalendar(DateTime startDate, DateTime endDate,
      {String? patientId}) async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    try {
      RegimentResponseModel regimentsData;

      regimentsData = await RegimentService.getRegimentDataCalendar(
          startDate: CommonUtil.dateConversionToApiFormat(
            startDate,
            isIndianTime: true,
          ),
          endDate: CommonUtil.dateConversionToApiFormat(
            endDate,
            isIndianTime: true,
          ),
          isSymptoms: 0,
          patientId: patientId);
      return regimentsData;

      // var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      // responseJson = await ApiServices.get(
      //   '${CommonUtil.BASE_URL_FROM_RES}kiosk/$userId?date=$date',
      //   headers: header,
      // );
      // if (responseJson.statusCode == 200) {
      //   return responseJson;
      // } else {
      //   return null;
      // }
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
      responseJson = (await ApiServices.post(
        '${CommonUtil.BASE_URL_QURHUB}user-hub/unpair-hub',
        headers: header,
        body: json.encode(data),
      ))!;
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
      responseJson = (await ApiServices.get(
        '${Constants.BASE_URL}$qr_getCareCoordinatorId$userId',
        headers: header,
      ))!;
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
      {String? token, required CallPushNSModel callModel}) async {
    bool isCallSent = false;
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = (await ApiServices.post(
        Constants.BASE_URL + qr_messaging,
        headers: header,
        body: jsonEncode(callModel.toJson()),
      ))!;

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
              (err.message ?? '').isNotEmpty
                  ? err.message!
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

  Future<dynamic> callLogData({required CallLogModel request}) async {
    try {
      var regController = Get.find<QurhomeRegimenController>();
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = (await ApiServices.post(
        Constants.BASE_URL + qr_callLog,
        headers: header,
        body: convert.jsonEncode(request.toJson()),
      ))!;
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

  Future<dynamic> callLogEndData({required CallEndModel request}) async {
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = (await ApiServices.put(
        Constants.BASE_URL + qr_callLog,
        headers: header,
        body: convert.jsonEncode(request.toJson()),
      ))!;
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

  Future<dynamic> callMissedCallNsAlertAPI(
      {CallLogModel? request, dynamic isFromSheelaRequest}) async {
    try {
      var regController = Get.find<QurhomeRegimenController>();
      var jsonString = "";
      String strURL = "";
      if (regController.isFromSOS.value) {
        strURL = qr_triggerSOSMissedCallNotification;
        jsonString = convert.jsonEncode(request!.toJson());
      } else {
        strURL = qr_triggerMissedCallNotification;
        jsonString = convert.jsonEncode(isFromSheelaRequest);
      }
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = (await ApiServices.post(
        Constants.BASE_URL + strURL,
        headers: header,
        body: jsonString,
      ))!;
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

  Future<dynamic> updateCallStatus(String? appointmentId) async {
    try {
      final AuthService authService = AuthService();
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      var jsonData = {};
      jsonData['id'] = appointmentId;
      jsonData['statusCode'] = 'PATDNA';
      final response = (await ApiServices.put(
          Constants.BASE_URL + qr_callAppointmentUpdate + "statusUpdate",
          headers: header,
          body: convert.jsonEncode(jsonData)))!;
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return body;
      } else {
        return authService.createErrorJsonString(response);
      }
    } catch (e) {
      //print(e);
    }
  }

  Future<dynamic> insertCallNonAppointment(String jsonBody) async {
    var response = await apiBaseHelper.insertCallNonAppointment(jsonBody);

    return response;
  }

  Future<dynamic> putNonAppointmentCall(Map<String, dynamic> body) async {
    var responseJson;
    try {
      final AuthService authService = AuthService();
      var header = await HeaderRequest().getRequestHeadersTimeSlot();

      final response = (await ApiServices.put(
          Constants.BASE_URL + qr_nonAppointmentUrl,
          headers: header,
          body: convert.jsonEncode(body)))!;
      if (response.statusCode == 200) {
        responseJson = jsonDecode(response.body);

        return responseJson;
      } else {
        responseJson = authService.createErrorJsonString(response);
        return responseJson;
      }
    } catch (e) {
      //print(e);
    }
    return responseJson;
  }

  /*Future<dynamic> recordCallLogForSheelaCommand(
      {UpdatedInfo request, String url}) async {
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      http.Response res = await ApiServices.put(
        Constants.BASE_URL + qr_callAppointmentUpdate + url,
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
  }*/

  Future<dynamic> startRecordSOSCall() async {
    try {
      var regController = Get.find<QurhomeRegimenController>();
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      var data = {
        qr_meetingId: CommonUtil().validString(regController.meetingId.value),
        qr_UID: CommonUtil().validString(regController.UID.value)
      };
      http.Response res = (await ApiServices.post(
        Constants.BASE_URL + qr_startRecordCallLog,
        headers: header,
        body: json.encode(data),
      ))!;
      if (res.statusCode == 200) {
        CallRecordModel _response =
            CallRecordModel.fromJson(convert.json.decode(res.body));

        regController.resourceId.value =
            CommonUtil().validString(_response.result!.resourceId);

        regController.sid.value =
            CommonUtil().validString(_response.result!.sid);

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
      http.Response res = (await ApiServices.post(
        Constants.BASE_URL + qr_stopRecordCallLog,
        headers: header,
        body: json.encode(data),
      ))!;
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
      responseJson = (await ApiServices.post(
        '${Constants.BASE_URL}$qr_getSOSAgentNumber',
        headers: header,
        body: json.encode(data),
      ))!;
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

  static Future<dynamic> snoozeEvent(String jsonBody) async {
    var responseJson;
    try {
      HeaderRequest headerRequest = HeaderRequest();

      var response = (await ApiServices.put(
          Constants.BASE_URL + qurPlanNode + updateSnoozeEvent,
          headers: await headerRequest.getRequestHeader(),
          body: jsonBody))!;

      if (response.statusCode == 200) {
        CallLogResponseModel _response =
            CallLogResponseModel.fromJson(convert.json.decode(response.body));

        return _response.isSuccess;
      } else {
        CallLogErrorResponseModel error = CallLogErrorResponseModel.fromJson(
            convert.json.decode(response.body));
        return error.isSuccess;
      }
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<PatientAlertListModel> getPatientAlertList(String patientId) async {
    var regController = Get.find<QurhomeDashboardController>();

    http.Response responseJson;

    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = (await ApiServices.get(
        '${Constants.BASE_URL}$patient_alert$patientId$page_no',
        headers: header,
      ))!;
      if (responseJson.statusCode == 200) {
        return PatientAlertListModel.fromJson(json.decode(responseJson.body));
      } else {
        regController.careCoordinatorIdEmptyMsg.value =
            CommonUtil().validString(json.decode(responseJson.body));
        return PatientAlertListModel();
      }
    } on SocketException {
      regController.careCoordinatorIdEmptyMsg.value =
          CommonUtil().validString(strNoInternet);
      throw FetchDataException(strNoInternet);
    } catch (e) {
      regController.careCoordinatorIdEmptyMsg.value =
          CommonUtil().validString(e.toString());
      return PatientAlertListModel();
    }
  }

  Future<bool> careGiverOKAction(
      CareGiverPatientListResult? careGiverPatientListResult) async {
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      String name = (careGiverPatientListResult?.firstName ?? ' ') +
          (careGiverPatientListResult?.lastName ?? '');
      var data = {
        qr_caregivername: name,
        qr_caregiverid: careGiverPatientListResult?.childId ?? ''
      };
      http.Response res = (await ApiServices.post(
        Constants.BASE_URL + qr_caregiver_ok,
        headers: header,
        body: json.encode(data),
      ))!;
      if (res.statusCode == 200) {
        var _response = SuccessModel.fromJson(convert.json.decode(res.body));
        return _response.isSuccess ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> careGiverEscalateAction(PatientAlertData? patientAlertData,
      CareGiverPatientListResult? careGiverPatientListResult) async {
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();
      var userId = PreferenceUtil.getStringValue(KEY_USERID);
      var myProf = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

      var postMediaData = Map<String, dynamic>();
      String fullPatientName = (careGiverPatientListResult?.firstName ?? ' ') +
          (careGiverPatientListResult?.lastName ?? '');
      String fullName = (myProf?.result?.firstName ?? ' ') +
          (myProf?.result?.lastName ?? ' ');

      postMediaData['caregiverName'] = fullName;
      postMediaData['id'] = userId;
      postMediaData['patientName'] = fullPatientName;
      postMediaData['patientId'] = careGiverPatientListResult?.childId;
      postMediaData['additionalInfo'] =
          patientAlertData?.additionalInfo?.toJson();
      postMediaData['activityName'] =
          patientAlertData?.additionalInfo?.activityname;
      postMediaData['alertCategory'] =
          patientAlertData?.additionalInfo?.category;

      final params = json.encode(postMediaData);
      print(params);

      http.Response res = (await ApiServices.post(
        Constants.BASE_URL + qr_caregiver_escalate,
        headers: header,
        body: json.encode(patientAlertData?.toJson()),
      ))!;
      if (res.statusCode == 200) {
        var _response = SuccessModel.fromJson(convert.json.decode(res.body));
        return _response.isSuccess ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

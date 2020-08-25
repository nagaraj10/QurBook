import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/model/ImageDocumentResponse.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/resources/network/AppException.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';
import 'package:myfhb/telehealth/features/appointments/model/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/resheduleModel.dart';
import 'package:myfhb/telehealth/features/followUp/model/followUpResponse.dart';

import 'AppException.dart';

class ApiBaseHelper {
  final String _baseUrl = Constants.BASE_URL;

  String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

  HeaderRequest headerRequest = new HeaderRequest();

  Future<dynamic> signIn(String url, String jsonData) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData,
          headers: await headerRequest.getRequesHeaderWithoutToken());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> verifyOTP(String url, String otpVerifyData) async {
    var responseJson;

    try {
      final response = await http.post(_baseUrl + url,
          body: otpVerifyData,
          headers: await headerRequest.getRequesHeaderWithoutToken());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> verifyAddFamilyOTP(String url, String otpVerifyData) async {
    var responseJson;
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    try {
      final response = await http.post(_baseUrl + url,
          body: otpVerifyData,
          headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> deleteHealthRecord(
      String url, String healthRecordData) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: healthRecordData,
          headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> bookmarkRecord(String url, String bookmarkData) async {
    var responseJson;

    try {
      final response = await http.post(_baseUrl + url,
          body: bookmarkData,
          headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateProvidersOld(String url) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: '',
          headers: await headerRequest.getRequestHeadersForProvider());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateProviders(String url, String query) async {
    Dio dio = new Dio();
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;

    dio.options.headers[variable.straccept] = variable.strAcceptVal;
    dio.options.headers[variable.strContentType] = variable.strcntVal;
    dio.options.headers[variable.strAuthorization] = authToken;

    Map<String, dynamic> mapForSignUp = new Map();
    mapForSignUp[parameters.strSections] = query;
    FormData formData = new FormData.fromMap(mapForSignUp);

    var response = await dio.post(_baseUrl + url, data: formData);

    //responseJson = _returnResponse(response.data);

    print(response.data);
    return response.data;
  }

  Future<dynamic> updateTeleHealthProviders(String url, String query) async {
    Dio dio = new Dio();
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;

    dio.options.headers[variable.straccept] = variable.strAcceptVal;
    dio.options.headers[variable.strContentType] = variable.strcntVal;
    dio.options.headers[variable.strAuthorization] = authToken;

    Map<String, dynamic> mapForSignUp = new Map();
    mapForSignUp[parameters.strSections] = query;
    FormData formData = new FormData.fromMap(mapForSignUp);

    var response = await dio.post(_baseUrl + url, data: formData);

    //responseJson = _returnResponse(response.data);

    return response.data;
  }

  Future<dynamic> addProviders(String url, String jsonData) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData, headers: await headerRequest.getRequestHeader());
      responseJson = _returnResponse(response);
      print(responseJson.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getMedicalPreferencesList(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  /**
   * The below method helps to get categroy list from server using the get method,
   * it contains one parameter which describ ethe URL  type
   * Created by Parvathi M on 7th Jan 2020
   */

  Future<dynamic> getCategoryList(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url.trim(),
          headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  /**
   * The below method helps to get health record list from server for a particular userID using the get method,
   * it contains one parameter which describ ethe URL  type
   * Created by Parvathi M on 7th Jan 2020
   */

  Future<dynamic> getHealthRecordList(String url, {bool condition}) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      if (condition) {
        String baseURL = "https://dev.healthbook.vsolgmi.com/hb/api/v3/";
        final response = await http.get(baseURL + url,
            headers: await headerRequest.getAuth());
        responseJson = _returnResponse(response);
      } else {
        final response = await http.get(_baseUrl + url,
            headers: await headerRequest.getRequestHeadersAuthAccept());
        responseJson = _returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getMediaTypes(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDoctorProfilePic(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeaderWithStar());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getHospitalListFromSearch(String url, String param) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDocumentImage(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDoctorsListFromSearch(String url, String param) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url + param,
          headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getFamilyMembersList(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(authToken);
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getProfileInfo(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson;
        if (response.headers[variable.strcontenttype] ==
                variable.file_img_jpg ||
            response.headers[variable.strcontenttype] ==
                variable.file_img_png ||
            response.headers[variable.strcontenttype] ==
                variable.file_img_all ||
            response.headers[variable.strcontenttype] ==
                variable.file_audio_mp) {
          responseJson = response.bodyBytes;
        } else {
          responseJson = convert.jsonDecode(response.body.toString());
        }
        print(response.body.toString());

        return responseJson;

      case 201:
        var responseJson = convert.jsonDecode(response.body.toString());

        return responseJson;

      case 400:
        var responseJson = convert.jsonDecode(response.body.toString());

        return responseJson;
      case 401:
        var responseJson = convert.jsonDecode(response.body.toString());

        if (responseJson[parameters.strMessage] ==
            Constants.STR_OTPMISMATCHED) {
          return responseJson;
        } else {
          //SnackbarToLogout();
        }
        break;

      case 403:
        var responseJson = convert.jsonDecode(response.body.toString());

        if (responseJson[parameters.strMessage] ==
            Constants.STR_OTPMISMATCHEDFOREMAIL) {
          return responseJson;
        } else {
          // SnackbarToLogout();
        }
        break;

      case 500:
      default:
        throw FetchDataException(
            variable.strErrComm + '${response.statusCode}');
    }
  }

  Future<dynamic> saveMediaData(String url, String jsonBody) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    var response;
    try {
      response = await http.post(_baseUrl + url,
          body: jsonBody, headers: await headerRequest.getRequestHeader());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> saveImageToServerClone(String url, File file, String filePath,
      String metaID, String jsonBody) async {
    var response;
    try {
      String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      Dio dio = new Dio();

      dio.options.headers[variable.straccept] = variable.strAcceptVal;
      dio.options.headers[variable.strcontenttype] = variable.strcntVal;
      dio.options.headers[variable.strauthorization] = authToken;
      String fileNoun = file.path.split('/').last;

      FormData formData = new FormData.fromMap({
        parameters.strmediaMetaId: metaID,
        parameters.strfile:
            await MultipartFile.fromFile(file.path, filename: fileNoun.trim())
      });
      response = await dio.post(_baseUrl + url, data: formData);

      return response.data;
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
  }

  Future<dynamic> signUpPage(
      String url, Map<String, dynamic> mapForSignUp) async {
    var responseJson;
    try {
      Dio dio = new Dio();

      dio.options.headers[variable.straccept] = variable.strAcceptVal;
      dio.options.headers[variable.strContentType] = variable.strcntVal;
      FormData formData = new FormData.fromMap(mapForSignUp);

      var response = await dio.post(_baseUrl + url, data: formData);

      responseJson = _returnResponse(response.data);

      return response.data;
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
  }

  Future<dynamic> addUserLinking(String url, String jsonData) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData, headers: await headerRequest.getRequestHeader());
      responseJson = _returnResponse(response);
      print(response.body.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> addUserDeLinking(String url, String jsonData) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData, headers: await headerRequest.getRequestHeader());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateFamilyUserProfile(String url, String query) async {
    Dio dio = new Dio();
    var responseJson;

    dio.options.headers[variable.strContentType] = variable.strcntVal;
    dio.options.headers[variable.strAuthorization] = authToken;
    dio.options.headers[variable.straccept] = variable.strAcceptVal;

    Map<String, dynamic> mapForSignUp = new Map();
    mapForSignUp[parameters.strSections] = query;
    FormData formData = new FormData.fromMap(mapForSignUp);

    var response = await dio.post(_baseUrl + url, data: formData);

    //responseJson = _returnResponse(response.data);

    return response.data;

    /*var responseJson;
    try {
      final response =
          await http.put(_baseUrl + url, body: '', headers: variable.requestHeadersAuthContent);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;*/
  }

  Future<dynamic> updateRelationShipUserInFamilyLinking(
      String url, String jsonData) async {
    var responseJson;
    try {
      final response = await http.put(_baseUrl + url,
          body: jsonData,
          headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getCustomRoles(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeaderWithStar());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveImageToServerClone1(
      String url, File file, String jsonBody) async {
    var response;
    try {
      String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      Dio dio = new Dio();

      dio.options.headers[variable.straccept] = variable.strAcceptVal;
      //dio.options.headers[variable.strContentType] = variable.strcntVal;
      dio.options.headers[variable.strauthorization] = authToken;
      String fileNoun = file.path.split('/').last;

      Map<String, dynamic> mapForSignUp = new Map();
      mapForSignUp[parameters.strSections] = url;
      mapForSignUp[parameters.strprofilePic] =
          await MultipartFile.fromFile(file.path, filename: fileNoun);

      FormData formData = new FormData.fromMap(mapForSignUp);
      response = await dio.post(_baseUrl + jsonBody, data: formData);

      return response.data;
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
  }

  Future<dynamic> moveMetaDataToOtherUser(String url, String jsonBody) async {
    var responseJson;
    var response;
    try {
      response = await http.post(_baseUrl + url,
          body: jsonBody, headers: await headerRequest.getRequestHeader());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> updateMediaData(String url, String jsonBody) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    var response;
    try {
      response = await http.put(_baseUrl + url,
          body: jsonBody, headers: await headerRequest.getRequestHeader());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<List<dynamic>> getDocumentImageListOld(
      String url, List<MediaMasterIds> metaMasterIdList) async {
    var imagesList = new List<dynamic>();
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    for (int i = 0; i < metaMasterIdList.length; i++) {
      var responseJson;
      try {
        final response = await http.get(_baseUrl + url + metaMasterIdList[i].id,
            headers: await headerRequest.getRequestHeadersAuthAccept());
        responseJson = _returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      imagesList.add(responseJson);
    }

    return imagesList;
  }

  Future<List<ImageDocumentResponse>> getDocumentImageList(
      String url, List<MediaMasterIds> metaMasterIdList) async {
    var imagesList = new List<ImageDocumentResponse>();
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    for (int i = 0; i < metaMasterIdList.length; i++) {
      var responseJson;
      try {
        final response = await http.get(_baseUrl + url + metaMasterIdList[i].id,
            headers: await headerRequest.getRequestHeadersAuthAccept());
        responseJson = _returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }

      imagesList.add(ImageDocumentResponse.fromJson(responseJson));
    }

    return imagesList;
  }

  Future<dynamic> signoutPage(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    var response;
    try {
      response = await http.put(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> getSearchMediaFromServer(String url, String param) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url + param,
          headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveImageAndGetDeviceInfo(String url, File file,
      String filePath, String metaID, String jsonBody) async {
    var response;
    try {
      String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      Dio dio = new Dio();

      dio.options.headers[variable.strContentType] = variable.strAcceptVal;
      dio.options.headers[variable.strAuthorization] = authToken;
      String fileNoun = file.path.split('/').last;

      FormData formData = new FormData.fromMap({
        parameters.strmediaMetaInfo: metaID,
        parameters.strfile:
            await MultipartFile.fromFile(file.path, filename: fileNoun)
      });
      response = await dio.post(_baseUrl + url, data: formData);

      return response.data;
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
  }

  Future<dynamic> verifyEmail(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> verifyOTPFromEmail(String url, String otpVerifyData) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;

    try {
      final response = await http.post(_baseUrl + url,
          body: otpVerifyData,
          headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDoctorsFromId(String url, String param) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url + param,
          headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getHospitalAndLabUsingId(String url, String param) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url + param,
          headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getTelehealthDoctorsList(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> bookMarkDoctor(String url, String jsonBody) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeader(), body: jsonBody);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getTimeSlotsList(String url, String jsonBody) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonBody);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  void SnackbarToLogout() {
    PreferenceUtil.clearAllData().then((value) {
      Get.offAll(SignInScreen());
      Get.snackbar(variable.strMessage, variable.strlogInDeviceOthr);
    });
  }

  Future<dynamic> bookAppointment(String url, String jsonBody) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonBody);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updatePayment(String url, String jsonBody) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonBody);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<AppointmentsModel> fetchAppointments() async {
    String userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
//    print('patient_id: '+userId);
    return await http
        .get(
      _baseUrl + qr_appointment_fetch + userId,
      headers: await headerRequest.getAuth(),
    )
        .then((http.Response response) {
      if (response.statusCode == 200) {

        var resReturnCode =
            AppointmentsModel.fromJson(jsonDecode(response.body));
        if (resReturnCode.status == 200) {
//          print(response.body);
          return AppointmentsModel.fromJson(jsonDecode(response.body));
        } else {
          throw Exception(variable.strFailed);
        }
      } else {
        throw Exception(variable.strFailed);
      }
    });
  }

  Future<CancelAppointmentModel> getCancelAppointment(
      List<String> doctorIds) async {
    var inputBody = {};
    inputBody[CANCEL_SOURCE] = PATIENT;
    inputBody[BOOKING_IDS] = doctorIds;

    var jsonString = convert.jsonEncode(inputBody);
    print(jsonString);
    final response =
        await getApiForCancelAppointment(qr_appointment_cancel, jsonString);
    return CancelAppointmentModel.fromJson(response);
  }

  Future<dynamic> getApiForCancelAppointment(
      String url, String jsonBody) async {
    var responseJson;
    try {
//      print(authtoken);
//      print(url);
//      print(jsonBody);
      final response = await http.put(_baseUrl + url,
          headers: await headerRequest.getRequestHeader(), body: jsonBody);
//      print(response.body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<Reshedule> resheduleAppointment(
      List<String> doctorIds, String slotNumber, String resheduleDate) async {
    var inputBody = {};
    inputBody[BOOKING_ID] = doctorIds;
    inputBody[RESHEDULED_DATE] = resheduleDate;
    inputBody[SLOTMUNBER] = slotNumber;
    inputBody[RESHEDULE_SOURCE] = PATIENT;

    var jsonString = convert.jsonEncode(inputBody);
    print(jsonString);
    final response = await getApiForresheduleAppointment(
        qr_appoinment_reshedule, jsonString);
    return Reshedule.fromJson(response);
  }

  Future<dynamic> getApiForresheduleAppointment(
      String url, String jsonBody) async {
    var responseJson;
    try {
//      print(authtoken);
//      print(url);
//      print(jsonBody);
      final response = await http.put(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonBody);
//      print(_baseUrl+url);
//      print(jsonBody);
      print(response.body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<FollowOnDate> followUpAppointment(
      String id, String date) async {
    var inputBody = {};
    inputBody[FOLLOWID] = id;
    inputBody[FOLLOWONDATE] = date;

    var jsonString = convert.jsonEncode(inputBody);
    print(jsonString);
    final response = await getApiForfollowUpAppointment(
        qr_follow_up_appointment, jsonString);
    return FollowOnDate.fromJson(response);
  }

  Future<dynamic> getApiForfollowUpAppointment(
      String url, String jsonBody) async {
    var responseJson;
    try {
//      print(authtoken);
//      print(url);
//      print(jsonBody);
      final response = await http.put(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonBody);
//      print(_baseUrl+url);
//      print(jsonBody);
      print(response.body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> postDeviceId(String url, String jsonBody) async {
    Map<String, String> requestHeadersAuthAccept = new Map();
    requestHeadersAuthAccept['accept'] = 'application/json';
    requestHeadersAuthAccept['Content-type'] = 'application/json';

    requestHeadersAuthAccept['Authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    print(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));
    var responseJson;
    try {
      final response = await http.post(CommonUtil.COGNITO_URL + url,
          headers: requestHeadersAuthAccept, body: jsonBody);
      print(response.body);
      responseJson = _returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }
}

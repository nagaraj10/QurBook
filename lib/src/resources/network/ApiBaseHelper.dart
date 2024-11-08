// ignore: file_names
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as gett;
import 'package:http/http.dart' as http;
import 'package:myfhb/add_new_plan/model/PlanCode.dart';
import 'package:myfhb/common/UnitConfiguration.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/ticket_support/controller/create_ticket_controller.dart';
import 'package:myfhb/ticket_support/model/ticket_list_model/images_model.dart';
import 'package:myfhb/widgets/cart_genric_response.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:myfhb/widgets/make_payment_response.dart';
import 'package:myfhb/widgets/update_payment_response.dart';
import '../../../add_family_user_info/models/address_type_list.dart';
import '../../../authentication/constants/constants.dart';
import '../../../authentication/view/login_screen.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/HeaderRequest.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_parameters.dart' as parameters;
import '../../../constants/fhb_query.dart';
import '../../../constants/variable_constant.dart' as variable;
import '../../../record_detail/model/ImageDocumentResponse.dart';
import '../../model/Health/MediaMasterIds.dart';
import '../../model/common_response.dart';
import '../../model/error_map.dart';
import 'AppException.dart';

import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';

class ApiBaseHelper {
  final String _baseUrl = Constants.BASE_URL;
  final String _baseUrlDeviceReading = CommonUtil.BASEURL_DEVICE_READINGS;

  // String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

  HeaderRequest headerRequest = HeaderRequest();
  ErrorMap errorMap = ErrorMap();

  Future<dynamic> signIn(String url, String jsonData) async {
    var responseJson;
    try {
      var response = (await ApiServices.post(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequesHeaderWithoutToken()));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> verifyOTP(String url, String otpVerifyData) async {
    var responseJson;

    try {
      var response = await ApiServices.post(_baseUrl + url, body: otpVerifyData, headers: await headerRequest.getRequesHeaderWithoutToken());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> verifyAddFamilyOTP(String url, String otpVerifyData) async {
    var responseJson;
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    try {
      var response = await ApiServices.post(_baseUrl + url, body: otpVerifyData, headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> deleteHealthRecord(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.delete(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> bookmarkRecord(String url, String bookmarkData) async {
    var responseJson;

    try {
      var response = await ApiServices.post(_baseUrl + url, body: bookmarkData, headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateProvidersOld(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, body: '', headers: await headerRequest.getRequestHeadersForProvider());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateProviders(String url, String query) async {
    final dio = Dio();
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;

    dio.options.headers[variable.straccept] = variable.strAcceptVal;
    dio.options.headers[variable.strContentType] = variable.strcntVal;
    dio.options.headers[variable.strAuthorization] = authToken;
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();
    final Map<String, dynamic> mapForSignUp = {};
    mapForSignUp[parameters.strSections] = query;
    final FormData formData = FormData.fromMap(mapForSignUp);

    final response = await dio.post(_baseUrl + url, data: formData);

    //responseJson = _returnResponse(response.data);

    print(response.data);
    return response.data;
  }

  Future<bool> callBackForPlanExpiry(
    String? userId,
    String? planId,
  ) async {
    try {
      final head = await headerRequest.getRequestHeadersAuthContent();
      final body = convert.jsonEncode(
        {
          "planId": planId,
          "userId": userId,
        },
      );
      final response = await http.post(
        Uri.parse(_baseUrl + 'fire-base/call-back'),
        headers: head,
        body: body,
      );
      final res = convert.jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        if (res["isSuccess"] == true) {
          print(res);
          return true;
        } else {
          print(res);
          return false;
        }
      } else {
        print(res);
        return false;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
      return false;
    }
  }

  Future<bool> callBackFromChat(
    String? careGiverId,
    String? patId,
  ) async {
    try {
      final head = await headerRequest.getRequestHeadersAuthContent();
      final body = convert.jsonEncode(
        {
          "careGiverId": careGiverId,
          "patientId": patId,
        },
      );
      final response = await http.post(
        Uri.parse(_baseUrl + 'user/callback/patient-caregiver-chat'),
        headers: head,
        body: body,
      );
      final res = convert.jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        if (res["isSuccess"] == true) {
          print(res);
          return true;
        } else {
          print(res);
          return false;
        }
      } else {
        print(res);
        return false;
      }
    } catch (e, stackTrace) {
      print(e.toString());
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }

  Future<dynamic> updateTeleHealthProviders(String url, String query) async {
    var dio = Dio();
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;

    dio.options.headers[variable.straccept] = variable.strAcceptVal;
    dio.options.headers[variable.strAuthorization] = authToken;
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();
    final mapForSignUp = Map<String, dynamic>();
    mapForSignUp[parameters.strSections] = query;
    final FormData formData = FormData.fromMap(mapForSignUp);

    final response = await dio.post(_baseUrl + url, data: formData);
    print(response.data);
    return true;
  }

  Future<dynamic> updateTeleHealthProvidersNew(String url, String jsonString, {bool? isPAR}) async {
    Dio dio = Dio();
    dio.options.headers[variable.straccept] = variable.strAcceptVal;
    dio.options.headers[variable.strAuthorization] = await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    final response = await dio.put(_baseUrl + url + "&associationRequest=${isPAR}", data: jsonString);
    print(response.data);

    return response.data;
  }

  Future<dynamic> getDoctorsListFromSearchNew(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    print(url);
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersForSearch());

      responseJson = _returnResponse(response, forDoctorSearch: true);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> addProviders(String url, String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeader());
      responseJson = _returnResponse(response);
      print(responseJson.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getHospitalListFromSearchNew(String url) async {
    //String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      print(_baseUrl + url);
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAcceptNew());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getMedicalPreferencesList(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAcceptNew());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> addProvidersForPlan(String url, String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeader());
      responseJson = _returnResponse(response);
      print(responseJson.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  /// The below method helps to get categroy list from server using the get method,
  /// it contains one parameter which describ ethe URL  type
  /// Created by Parvathi M on 7th Jan 2020

  Future<dynamic> getCategoryList(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url.trim(), headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getCategoryLists(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url.trim(), headers: await headerRequest.getAuths());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  /// The below method helps to get health record list from server for a particular userID using the get method,
  /// it contains one parameter which describ ethe URL  type
  /// Created by Parvathi M on 7th Jan 2020

  Future<dynamic> getHealthRecordList(String url, {required bool condition}) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      if (condition) {
        var baseURL = 'https://dev.healthbook.vsolgmi.com/hb/api/v3/';
        var response = await ApiServices.get(baseURL + url, headers: await headerRequest.getAuth());
        responseJson = _returnResponse(response);
      } else {
        var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
        responseJson = _returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getMediaTypes(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDoctorProfilePic(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeaderWithStar());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getHospitalListFromSearch(String url, String param) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDocumentImage(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDoctorsListFromSearch(String url, String param) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url + param, headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getFamilyMembersList(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(authToken);
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getFamilyMembersListNew(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(authToken);
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAcceptNew());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getNonAdheranceList(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(authToken);
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAcceptNew());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveOrEditNonAdherance(String url, dynamic data) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(authToken);
    var responseJson;
    final body = convert.jsonEncode(data);
    print(body);
    try {
      final response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersWithoutOffset(), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> fetchAlreadySelectedFamilyMembersList(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(authToken);
    var responseJson;
    try {
      final response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAcceptNew());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> submitVoiceCloneWithFamilyMembers(String url, dynamic data) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(authToken);
    var responseJson;
    final body = convert.jsonEncode(data);
    print(body);
    try {
      final response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersWithoutOffset(), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> remainderForApi(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(authToken);
    var responseJson;
    final body = convert.jsonEncode(["ACTREMSETTYPE"]);
    print(body);
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersWithoutOffset(), body: '["ACTREMSETTYPE"]');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getProfileInfo(String url) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateUserTimeZone(String url, String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.put(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> insertCallNonAppointment(String jsonBody) async {
    var responseJson;

    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlot();

      var response = await ApiServices.post(Constants.BASE_URL + qr_nonAppointmentUrl, headers: header, body: jsonBody);

      responseJson = _returnResponse(response);
    } catch (e, stackTrace) {
      //print(e);
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response? response, {bool? forDoctorSearch}) {
    print(response?.statusCode);
    print(response?.request?.url);
    switch (response?.statusCode) {
      case 200:
        var responseJson;
        if (response!.headers[variable.strcontenttype] == variable.file_img_jpg ||
            response.headers[variable.strcontenttype] == variable.file_img_png ||
            response.headers[variable.strcontenttype] == variable.file_img_all ||
            response.headers[variable.strcontenttype] == variable.file_audio_mp) {
          responseJson = response.bodyBytes;
        } else {
          responseJson = convert.jsonDecode(response.body.toString());
        }
        print(response.body.toString());

        return responseJson;

      case 201:
        final responseJson = convert.jsonDecode(response!.body.toString());
        exitFromApp();

        return responseJson;

      case 400:
        final responseJson = convert.jsonDecode(response!.body.toString());

        exitFromApp();

        return responseJson;
      case 401:
        final responseJson = convert.jsonDecode(response!.body.toString());
        if (responseJson[parameters.strMessage] != null && responseJson[parameters.strMessage] != '') {
          SnackbarToLogout(msg: responseJson[parameters.strMessage]);
        } else {
          exitFromApp();
        }

        // if (responseJson[parameters.strMessage] == Constants.STR_UN_AUTH_USER) {
        //   SnackbarToLogout();
        // } else {
        //   return responseJson;
        // }
        break;

      case 403:
        final responseJson = convert.jsonDecode(response!.body.toString());
        if (responseJson[parameters.strMessage] == Constants.STR_OTPMISMATCHEDFOREMAIL) {
          return responseJson;
        } else {
          exitFromApp();
        }
        break;
      case 404:
        if (forDoctorSearch!) {
          final responseJson = convert.jsonDecode(response!.body.toString());
          return responseJson;
        } else {
          exitFromApp();
        }
        break;
      case 500:
        print(response!.body.toString());

        try {
          if (forDoctorSearch != null) {
            final responseJson = convert.jsonDecode(response.body.toString());
            return responseJson;
          } else {
            final responseJson = convert.jsonDecode(response.body.toString());
            return responseJson;
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);

          final responseJson = convert.jsonDecode(response.body.toString());
          return responseJson;
        }
        break;
      default:
        throw FetchDataException(variable.strErrComm + '${response?.statusCode ?? "0"}');
    }
  }

  Future<dynamic> saveMediaData(String url, String jsonBody) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    var response;
    try {
      response = await ApiServices.post(_baseUrl + url, body: jsonBody, headers: await headerRequest.getRequestHeader());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> saveImageToServerClone(String url, File file, String filePath, String metaID, String jsonBody) async {
    var response;
    try {
      var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      var dio = Dio();

      dio.options.headers[variable.straccept] = variable.strAcceptVal;
      dio.options.headers[variable.strcontenttype] = variable.strcntVal;
      dio.options.headers[variable.strauthorization] = authToken;
      dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

      final fileNoun = file.path.split('/').last;

      final FormData formData = FormData.fromMap({parameters.strmediaMetaId: metaID, parameters.strfile: await MultipartFile.fromFile(file.path, filename: fileNoun.trim())});
      response = await dio.post(_baseUrl + url, data: formData);

      return response.data;
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
  }

  Future<dynamic> signUpPage(String url, Map<String, dynamic> mapForSignUp) async {
    var responseJson;
    try {
      final dio = Dio();

      dio.options.headers[variable.straccept] = variable.strAcceptVal;
      dio.options.headers[variable.strContentType] = variable.strcntVal;
      dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

      final FormData formData = FormData.fromMap(mapForSignUp);

      final response = await dio.post(_baseUrl + url, data: formData);

      responseJson = _returnResponse(response.data);

      return response.data;
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
  }

  Future<dynamic> addUserLinking(String url, String jsonData) async {
    print(_baseUrl + url);
    print(jsonData);
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeader());
      responseJson = _returnResponse(response);
      print(response!.body.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> addUserDeLinking(String url, String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeader());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateFamilyUserProfile(String url, String query) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var dio = Dio();
    var responseJson;

    //dio.options.headers[variable.strContentType] = variable.strcntVal;
    dio.options.headers[variable.strAuthorization] = authToken;
    dio.options.headers[variable.straccept] = variable.strAcceptVal;
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    print(url);
    print(query);

    final Map<String, dynamic> mapForSignUp = {};
    mapForSignUp[parameters.strSections] = query;
    final FormData formData = FormData.fromMap(mapForSignUp);

    final response = await dio.post(_baseUrl + url, data: formData);

    //responseJson = _returnResponse(response.data);

    return response.data;

    /*var responseJson;
    try {
      final response =
          await ApiServices.put(_baseUrl + url, body: '', headers: variable.requestHeadersAuthContent);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;*/
  }

  Future<dynamic> updateRelationShipUserInFamilyLinking(String url, String jsonData) async {
    var responseJson;
    print(url);
    print(jsonData);

    try {
      var response = await ApiServices.put(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getCustomRoles(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeaderWithStar());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<http.Response> getNotificationList(String path, {Map<String, String>? headers, int timeout = 20}) async {
    var responseJson;
    try {
      var response = await ApiServices.get(path, headers: headers, timeout: timeout);
      if (response!.statusCode != 200) {
        await _returnResponse(response);
      }
      responseJson = response;
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveImageToServerClone1(String url, File file, String jsonBody) async {
    var response;
    try {
      var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      var dio = Dio();

      //dio.options.headers[variable.straccept] = variable.strAcceptVal;
      dio.options.headers[variable.strContentType] = variable.strcntVal;
      dio.options.headers[variable.strauthorization] = authToken;
      dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

      final fileNoun = file.path.split('/').last;

      final Map<String, dynamic> mapForSignUp = {};
      mapForSignUp[parameters.strSections] = url;
      mapForSignUp[parameters.strprofilePic] = await MultipartFile.fromFile(file.path, filename: fileNoun);

      final FormData formData = FormData.fromMap(mapForSignUp);
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
      response = await ApiServices.post(_baseUrl + url, body: jsonBody, headers: await headerRequest.getRequestHeader());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> updateMediaData(String url, String jsonBody) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    var response;
    try {
      response = await ApiServices.put(_baseUrl + url, body: jsonBody, headers: await headerRequest.getRequestHeader());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<List<dynamic>> getDocumentImageListOld(String url, List<MediaMasterIds> metaMasterIdList) async {
    final imagesList = <dynamic>[];
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    for (var i = 0; i < metaMasterIdList.length; i++) {
      var responseJson;
      try {
        var response = await ApiServices.get(_baseUrl + url + metaMasterIdList[i].id!, headers: await headerRequest.getRequestHeadersAuthAccept());
        responseJson = _returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      imagesList.add(responseJson);
    }

    return imagesList;
  }

  Future<List<ImageDocumentResponse>> getDocumentImageList(String url, List<MediaMasterIds> metaMasterIdList) async {
    final imagesList = <ImageDocumentResponse>[];
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    for (var i = 0; i < metaMasterIdList.length; i++) {
      var responseJson;
      try {
        var response = await ApiServices.get(_baseUrl + url + metaMasterIdList[i].id!, headers: await headerRequest.getRequestHeadersAuthAccept());
        responseJson = _returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }

      imagesList.add(ImageDocumentResponse.fromJson(responseJson));
    }

    return imagesList;
  }

  Future<dynamic> signoutPage(String url) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    var response;
    try {
      response = await ApiServices.put(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> getSearchMediaFromServer(String url, String param) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url + param, headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveImageAndGetDeviceInfo(String url, List<String?> imagePaths, String payload, String jsonBody, String? userId) async {
    var response;
    try {
      final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      var dio = Dio();
      dio.options.headers['content-type'] = 'multipart/form-data';
      dio.options.headers['authorization'] = authToken;
      dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

      FormData formData;

      if (imagePaths != null && imagePaths.isNotEmpty) {
        formData = FormData.fromMap({
          'metadata': payload,
          'userId': userId,
        });

        for (final image in imagePaths) {
          final fileName = File(image!);
          final fileNoun = fileName.path.split('/').last;
          formData.files.addAll([
            MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
          ]);
        }

        response = await dio.post(_baseUrl + url, data: formData);

        return response.data;
      }
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
  }

  Future<dynamic> verifyEmail(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> verifyOTPFromEmail(String url, String otpVerifyData) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;

    try {
      var response = await ApiServices.post(_baseUrl + url, body: otpVerifyData, headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDoctorsFromId(String url, String param) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url + param, headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getHospitalAndLabUsingId(String url, String param) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url + param, headers: await headerRequest.getRequestHeadersAuthAccept());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getTelehealthDoctorsList(String url) async {
    var responseJson;
    try {
      print(_baseUrl + url);
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
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
      print(_baseUrl + url);
      print(jsonBody);
      var response = await ApiServices.put(_baseUrl + url, headers: await headerRequest.getRequestHeader(), body: jsonBody);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getTimeSlotsList(String url, String jsonBody) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonBody);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  void SnackbarToLogout(
      {String? msg = 'something went wrong, please try again later.'}) {
    // Initialize SheelaAIController using onInitSheelaAIController method from CommonUtil
    var sheelaAIController = CommonUtil().onInitSheelaAIController();
    // Check if internet connection is available
    if (sheelaAIController.isInternetConnection.value) {
      PreferenceUtil.clearAllData().then((value) {
        gett.Get.offAll(PatientSignInScreen());
        gett.Get.snackbar(parameters.strMessage, msg!);
      });
    }
  }

  Future<dynamic> bookAppointment(String url, String jsonBody) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonBody);
      print(_baseUrl + url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updatePayment(String url, String jsonBody) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonBody);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveDeviceData(String url, String jsonBody) async {
    final header = await headerRequest.getRequestHeader();
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrlDeviceReading + url, body: jsonBody, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getByRecordDataType(String url, String jsonBody) async {
    final header = await headerRequest.getRequestHeader();
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrlDeviceReading + url, body: jsonBody, headers: header);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDeviceInfo(String url) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    final header = await headerRequest.getRequestHeader();
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrlDeviceReading + url, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> postDeviceId(String url, String jsonBody, bool isActive) async {
    final Map<String, String> requestHeadersAuthAccept = {}; // FUcrash Map<String, String?>  to Map<String, String>
    requestHeadersAuthAccept['accept'] = 'application/json';
    requestHeadersAuthAccept['Content-type'] = 'application/json';

    requestHeadersAuthAccept['Authorization'] = await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!;
    requestHeadersAuthAccept[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    var responseJson;
    try {
      if (isActive) {
        var response = await ApiServices.post(_baseUrl + url, headers: requestHeadersAuthAccept, body: jsonBody);
        responseJson = _returnResponse(response);
      } else {
        var response = await ApiServices.post(_baseUrl + url, headers: requestHeadersAuthAccept, body: jsonBody);
        responseJson = _returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> escalateNonAdherance(String url, dynamic jsonString) async {
    var responseJson;
    final Map<String, String?> requestHeadersAuthContent = {};

    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] = await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    // requestHeadersAuthContent[Constants.KEY_OffSet] =
    //     CommonUtil().setTimeZone();
    print(jsonString);
    try {
      var response = await ApiServices.post(
        _baseUrl + url,
        body: convert.jsonEncode(jsonString),
        headers: await headerRequest.getRequestHeadersAuthContent(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> associateRecords(String url, String jsonString) async {
    var responseJson;
    final Map<String, String?> requestHeadersAuthContent = {};

    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] = await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersAuthContent[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    try {
      var response = await ApiServices.post(
        _baseUrl + url,
        body: jsonString,
        headers: await headerRequest.getRequestHeadersAuthContent(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getMetaIdURL(List<String?> recordIds, String? patientId) async {
    final inputBody = {};
    inputBody[strUserId] = patientId;
    inputBody[HEALTH_RECORDMETAIDS] = recordIds;
    //  final jsonString = json.encode(inputBody);
    var jsonString = convert.jsonEncode(inputBody);
    print(jsonString);
    var response = await getApiForGetMetaURL(jsonString);
    return response;
  }

  Future<dynamic> getApiForGetMetaURL(String jsonBody) async {
    var responseJson;
    String jsonBodyNew = jsonBody.replaceAll("'\n'", "");
    try {
      var response = await ApiServices.post(_baseUrl + qr_health_record + qr_filter, headers: await headerRequest.getRequestHeader(), body: jsonBodyNew);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  void printWrapped(String text) {
    var pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  getValueBasedOnSearch(String name, String apiname) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!;

    final response = await ApiServices.get(
      '$_baseUrl$apiname/search/$name',
      headers: {HttpHeaders.authorizationHeader: authToken, Constants.KEY_OffSet: CommonUtil().setTimeZone()},
    );
    if (response!.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body;
    } else {
      //throw Exception("Unable to perform request!");
      throw InnerException('No Data Found');
    }
  }

  getStateList(String apiname) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!;

    final response = await ApiServices.get(
      '$_baseUrl$apiname',
      headers: {HttpHeaders.authorizationHeader: authToken, Constants.KEY_OffSet: CommonUtil().setTimeZone()},
    );
    if (response!.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body;
    } else {
      //throw Exception("Unable to perform request!");
      throw InnerException('No Data Found');
    }
  }

  Future<dynamic> getMediaTypesList(String url) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getAuths());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  getHealthRecordLists(String jsonData, String url) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeadersAuthContents());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateSelfProfileNew(String url, String jsonBody) async {
    var responseJson;
    print(jsonBody);
    try {
      var response = await ApiServices.put(_baseUrl + url, body: jsonBody, headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<AddressTypeResult> fetchAddressType(String responseQuery) async {
    var response = await ApiServices.post(_baseUrl + responseQuery, headers: await headerRequest.getRequestHeadersAuthContent(), body: '["ADDTYP"]');

    print(response!.body);

    if (response.statusCode == 200) {
      return AddressTypeResult.fromJson(jsonDecode(response.body));
    } else {
      return AddressTypeResult.fromJson(errorMap.createErrorJsonString(response));
    }
  }

  Future<dynamic> createMediaData(String url, String payload, List<String?>? imagePaths, String? audioPath, String? id, {bool isVital = false}) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final dio = Dio();
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers['authorization'] = authToken;
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    FormData formData;

    if (imagePaths != null && imagePaths.isNotEmpty) {
      formData = FormData.fromMap({'metadata': payload, 'userId': id, 'isBookmarked': false, 'isVitalSave': isVital});

      for (final image in imagePaths) {
        final fileName = File(image!);
        final fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }

      if (audioPath != null && audioPath != '') {
        var fileName = File(audioPath);
        final fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }
    } else {
      formData = FormData.fromMap({'metadata': payload, 'userId': id, 'isBookmarked ': false, 'isVitalSave': isVital});

      if (audioPath != null && audioPath != '') {
        var fileName = File(audioPath);
        var fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }
    }
    var response;
    try {
      response = await dio.post(_baseUrl + url, data: formData);

      if (response.statusCode == 200) {
        print(response.data.toString());
        return response;
      } else {
        return response;
      }
    } on DioError catch (e, stackTrace) {
      print(e.toString());
      print(e);
      return response;
    }
  }

  Future<dynamic> createMediaDataClaim(String url, String payload, List<String?>? imagePaths, String? audioPath, String? id) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final dio = Dio();
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers['authorization'] = authToken;
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    FormData formData;

    if (imagePaths != null && imagePaths.isNotEmpty) {
      formData = FormData.fromMap({
        'metadata': payload,
        'userId': id,
        'isBookmarked': false,
        'isClaimRecord': true,
      });

      for (final image in imagePaths) {
        final fileName = File(image!);
        final fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }

      if (audioPath != null && audioPath != '') {
        var fileName = File(audioPath);
        final fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }
    } else {
      formData = FormData.fromMap({'metadata': payload, 'userId': id, 'isBookmarked ': false});

      if (audioPath != null && audioPath != '') {
        var fileName = File(audioPath);
        var fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }
    }
    var response;
    try {
      response = await dio.post(_baseUrl + url, data: formData);

      if (response.statusCode == 200) {
        print(response.data.toString());
        return response;
      } else {
        return response;
      }
    } on DioError catch (e, stackTrace) {
      print(e.toString());
      print(e);
      return response;
    }
  }

  Future<bool> uploadLogData(String logPath, String fileName) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    final value = await MultipartFile.fromFile(logPath, filename: fileName);
    final dio = Dio();
    dio.options.headers['authorization'] = authToken;
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    FormData formData = FormData.fromMap(
      {
        'folderName': 'logs',
        'source': strSource,
        'file': value,
      },
    );
    var response;
    try {
      response = await dio.post(
        _baseUrl + 'media-details/store-log',
        data: formData,
      );
      if (response.statusCode == 200) {
        print(response.data.toString());
        return true;
      } else {
        return false;
      }
    } on DioError catch (e, stackTrace) {
      print(e.toString());
      print(e);
      return false;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
      return false;
    }
  }

  Future<dynamic> updateHealthRecords(String url, String payload, List<String?>? imagePaths, String? audioPath, String? metaId) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var dio = Dio();
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers['authorization'] = authToken;
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    FormData formData;

    if (imagePaths != null && imagePaths.isNotEmpty) {
      formData = FormData.fromMap({
        'metadata': payload,
        'userId': userId,
        'isBookmarked': true,
        'id': metaId,
      });

      for (final image in imagePaths) {
        var fileName = File(image!);
        var fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }

      if (audioPath != null && audioPath != '') {
        final fileName = File(audioPath);
        final fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }
    } else {
      formData = FormData.fromMap({
        'metadata': payload,
        'userId': userId,
        'isBookmarked ': false,
        'id': metaId,
      });
      if (audioPath != null && audioPath != '') {
        final fileName = File(audioPath);
        final fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }
    }
    var response;
    try {
      response = await dio.put(_baseUrl + url, data: formData);

      if (response.statusCode == 200) {
        print(response.data.toString());
        return response;
      } else {
        return response;
      }
    } on DioError catch (e, stackTrace) {
      print(e.toString());
      print(e);
      return response;
    }
  }

  Future<dynamic> getHealthOrgApi(String url) async {
    var responseJson;
    try {
      print(_baseUrl + url);
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDoctorsFromHospital(String url) async {
    var responseJson;
    try {
      print(_baseUrl + url);
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getUserProfilePic(String url) async {
    CommonResponse responseJson;
    try {
      var response = (await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeader()))!;
      //responseJson = _returnResponse(response);
      responseJson = CommonResponse.fromJson(json.decode(response.body));
      print(responseJson.toJson());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> uploadUserProfilePicToServer(String url, File image) async {
    var authToken = await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    //String userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var filename = image.path.split('/').last;
    final fileType = filename.split('.')[1];
    final dio = Dio();
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers['authorization'] = authToken;
    dio.options.headers['accept'] = 'application/json';
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    final FormData formData = FormData.fromMap({
      'profilePicture': await MultipartFile.fromFile(image.path, filename: filename, contentType: MediaType('image', '$fileType')),
    });
    late var response;
    try {
      response = await dio.put(_baseUrl + url, data: formData);

      if (response.statusCode == 200) {
        print(response.data.toString());
        return response?.data;
      } else {
        return response?.data;
      }
    } on DioError catch (e, stackTrace) {
      print(e.toString());
      print(e);
      return response?.data;
    }
  }

  Future<bool?> uploadAttachment(String url, String ticketId, File image) async {
    var authToken = await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!;
    String? userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var filename = image.path.split('/').last;
    final fileType = filename.split('.')[1];

    var dio = Dio();
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers['authorization'] = 'Bearer ' + authToken;
    dio.options.headers['accept'] = 'application/json';
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    FormData formData = FormData.fromMap({
      'ticketId': ticketId,
      'patientUserId': userId,
    });

    var fileNoun = image.path.split('/').last;
    formData.files.add(
      MapEntry('attachment', await MultipartFile.fromFile(image.path, filename: fileNoun)),
    );

    var response;
    try {
      response = await dio.post(_baseUrl + url, data: formData);
      print('upload code: ' + response.statusCode.toString());
      if (response.statusCode == 200) {
        print('upload response: ' + response.data.toString());
        return response.data['isSuccess'];
      } else {
        return response.data['isSuccess'];
      }
    } on DioError catch (e, stackTrace) {
      print("dio attachment error");
      print(e.toString());
      print(e);
      return false;
    }
  }

  Future<dynamic> getDeviceSelection(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getAvailableDevices(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> unPairDexcomm(String url, Object jsonBody) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeader(), body: jsonBody);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> createDeviceSelection(String url, String jsonBody) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonBody);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateDeviceSelection(String url, String jsonBody) async {
    var responseJson;
    try {
      var response = await ApiServices.put(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonBody);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> associateUpdateRecords(String url, String jsonString) async {
    var responseJson;
    final requestHeadersAuthContent = Map<String, String?>();

    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersAuthContent[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    try {
      var response = await ApiServices.put(
        _baseUrl + url,
        body: jsonString,
        headers: await headerRequest.getRequestHeadersAuthContent(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getAppointmentDetail(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeaderWithStar());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> deleteDeviceRecords(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.delete(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getPlanList(String url, String jsonString) async {
    var responseJson;
    try {
      print('refer:  ' + url + jsonString);
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getReportList(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getHealthConditions(String url, String jsonString) async {
    var responseJson;
    try {
      final response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getPlanDetails(String url, String jsonString) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getQurPlanDashBoard(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        headers: await headerRequest.getRequestHeadersTimeSlot(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getAppScreenConfig(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        headers: await headerRequest.getRequestHeadersTimeSlot(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getMemberShipDetails(String url) async {
    var headers = headerRequest.getAuths();
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        headers: await headerRequest.getAuths(),
      );
      responseJson = _returnResponse(response);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveRegimentMedia(String url, String imagePaths, String? userId, String? providerId) async {
    var response;
    try {
      var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      final dio = Dio();
      dio.options.headers['content-type'] = 'multipart/form-data';
      dio.options.headers['authorization'] = authToken;
      dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

      FormData formData;

      if (imagePaths != null && imagePaths.isNotEmpty) {
        formData = FormData.fromMap({'folderName': 'event', 'userId': userId, 'userLinkId': userId, 'providerLinkId': providerId});

        var fileName = File(imagePaths);
        var fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry('file', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);

        response = await dio.post(_baseUrl + url, data: formData);

        return response.data;
      }
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
  }

  Future<dynamic> getLanguageList(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url.trim(), headers: await headerRequest.getAuths());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getSearchListApi(String url, String jsonString) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDoctorsByIdNew(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAcceptNew());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> addDoctorFromProvider(String url, String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.post(
        _baseUrl + url,
        body: jsonData,
        headers: await headerRequest.getRequestHeader(),
      );
      responseJson = _returnResponse(response);
      print(responseJson.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> doctorSpecializationList(
    String url,
  ) async {
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        // body: jsonData,
        headers: await headerRequest.getRequestHeader(),
      );
      responseJson = _returnResponse(response);
      print(responseJson.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> doctorFilterList(String url, String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.post(
        _baseUrl + url,
        body: jsonData,
        headers: await headerRequest.getRequestHeader(),
      );
      responseJson = _returnResponse(response);
      print(responseJson.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getLoginDetails() async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!;

    final response = (await ApiServices.get(
      _baseUrl + 'user/loggedin-details/',
      headers: {HttpHeaders.authorizationHeader: authToken, Constants.KEY_OffSet: CommonUtil().setTimeZone()},
    ))!;
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body;
    } else {
      //throw Exception("Unable to perform request!");
      throw InnerException('No Data Found');
    }
  }

  Future<dynamic> getAppVersion(String? endpoint) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!;
    final response = (await ApiServices.get(
      _baseUrl + 'app-update?appName=$endpoint',
      headers: {HttpHeaders.authorizationHeader: authToken, Constants.KEY_OffSet: CommonUtil().setTimeZone()},
    ));
    if (response?.statusCode == 200) {
      var body = jsonDecode(response?.body ?? '');
      return body ?? '';
    } else {
      return null;
    }
  }

  Future<dynamic> createSubscribe(String url, String jsonString) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> addToCartHelper(String url, String jsonString) async {
    var responseJson;
    try {
      final response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateLastVisited() async {
    try {
      final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      final dateTime = DateTime.now();
      var responseJson;

      if (userID != null && userID != '') {
        final Map<String, String> jsobBodyMap = {};
        jsobBodyMap['userId'] = userID;
        jsobBodyMap['lastVisitedDatetimeUtc'] = dateTime.toUtc().toString();
        jsobBodyMap['statusType'] = 'lastVisitedDate';
        try {
          var response = await ApiServices.put(_baseUrl + 'user/update-last-visited-details', body: json.encode(jsobBodyMap), headers: await headerRequest.getRequestHeadersAuthContent());

          responseJson = _returnResponse(response);
        } on SocketException {
          throw FetchDataException(variable.strNoInternet);
        }
        return responseJson;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<FetchingCartItemsModel?> fetchCartItems({String? cartUserId, String? notificationListId, bool isPaymentLinkViaPush = false, String? cartId = ""}) async {
    try {
      String? userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String? createBy = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      FetchingCartItemsModel responseJson;

      if (userID != null && userID != "" && ((createBy ?? '').isNotEmpty)) {
        Map<String, dynamic> jsobBodyMap = Map();
        jsobBodyMap['userId'] = ((cartUserId ?? '').isNotEmpty) ? cartUserId : userID;
        jsobBodyMap['createdBy'] = ((notificationListId ?? '').isNotEmpty) ? notificationListId : createBy;
        if (isPaymentLinkViaPush) {
          jsobBodyMap['paymentLinkViaPush'] = isPaymentLinkViaPush;
          jsobBodyMap['cartId'] = cartId ?? '';
        }
        try {
          final response = (await ApiServices.post(_baseUrl + "cart/getAllItems?isCount=false", body: json.encode(jsobBodyMap), headers: await headerRequest.getRequestHeadersAuthContent()))!;
          //responseJson = _returnResponse(response);
          responseJson = FetchingCartItemsModel.fromJson(json.decode(response.body.toString()));
        } on SocketException {
          throw FetchDataException(variable.strNoInternet);
        }
        return responseJson;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print("**********************" + e.toString());
    }
  }

  Future<FetchingCartItemsModel?> clearCartItems() async {
    try {
      String? userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String? createBy = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      FetchingCartItemsModel responseJson;

      if (userID != null && userID != "" && ((createBy ?? '').isNotEmpty)) {
        Map<String, String?> jsobBodyMap = Map();
        jsobBodyMap['userId'] = userID;
        jsobBodyMap['createdBy'] = createBy;
        try {
          final response = await ApiServices.post(_baseUrl + "cart/clear", body: json.encode(jsobBodyMap), headers: await headerRequest.getRequestHeadersAuthContent());
          //responseJson = _returnResponse(response);
          responseJson = FetchingCartItemsModel.fromJson(json.decode(response!.body.toString()));
        } on SocketException {
          throw FetchDataException(variable.strNoInternet);
        }
        return responseJson;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<CartGenricResponse?> removeCartItems(dynamic body) async {
    try {
      String? userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String? createBy = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      CartGenricResponse responseJson;

      if (userID != null && userID != "" && ((createBy ?? '').isNotEmpty)) {
        body['userId'] = userID;
        body['createdBy'] = createBy;
        try {
          final response = await ApiServices.post(_baseUrl + "cart/remove-product", body: json.encode(body), headers: await headerRequest.getRequestHeadersAuthContent());
          //responseJson = _returnResponse(response);
          responseJson = CartGenricResponse.fromJson(json.decode(response!.body.toString()));
        } on SocketException {
          throw FetchDataException(variable.strNoInternet);
        }
        return responseJson;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<MakePaymentResponse?> makePayment(dynamic body) async {
    try {
      String? userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String? createBy = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      MakePaymentResponse responseJson;

      try {
        final response = await ApiServices.post(_baseUrl + "payment/plan-subscription-create-payment", body: json.encode(body), headers: await headerRequest.getRequestHeadersAuthContent());
        //responseJson = _returnResponse(response);
        responseJson = MakePaymentResponse.fromJson(json.decode(response!.body.toString()));
      } on SocketException {
        throw FetchDataException(variable.strNoInternet);
      }
      return responseJson;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
    }
  }

  Future<dynamic> updateCartIcon(dynamic body) async {
    try {
      String? userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String? createBy = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      var responseJson;

      try {
        final response = await ApiServices.post(_baseUrl + "cart/update-product-details", body: json.encode(body), headers: await headerRequest.getRequestHeadersAuthContent());
        //responseJson = _returnResponse(response);
        responseJson = json.decode(response!.body.toString());
      } on SocketException {
        throw FetchDataException(variable.strNoInternet);
      }
      return responseJson;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<dynamic> addNewPlan(String jsonData) async {
    var responseJson;
    try {
      final response = await ApiServices.post(_baseUrl + "user/feedback", body: jsonData, headers: await headerRequest.getRequestHeadersTimeSlot());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<PlanCode> getPlanCode(String responseQuery) async {
    final response = await ApiServices.post(_baseUrl + responseQuery, headers: await headerRequest.getRequestHeadersAuthContent(), body: '["FEEDBKTYP"]');

    print(response!.body);

    if (response.statusCode == 200) {
      return PlanCode.fromJson(jsonDecode(response.body));
    } else {
      return PlanCode.fromJson(errorMap.createErrorJsonString(response));
    }
  }

  Future<UpdatePaymentResponse?> updatePaymentStatus(dynamic body) async {
    try {
      String? userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String? createBy = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      UpdatePaymentResponse responseJson;

      //if (userID != null && userID != "" && ((createBy ?? '').isNotEmpty)) {
      try {
        final response = await ApiServices.post(_baseUrl + "payment/plan-subscription-update-payment-status", body: json.encode(body), headers: await headerRequest.getRequestHeadersAuthContent());
        //responseJson = _returnResponse(response);
        responseJson = UpdatePaymentResponse.fromJson(json.decode(response!.body.toString()));
      } on SocketException {
        throw FetchDataException(variable.strNoInternet);
      }
      return responseJson;
      //}
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<dynamic> getProviderPlan(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    print(url);
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersForSearch());

      responseJson = _returnResponse(response, forDoctorSearch: true);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getUserPlanInfo(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        headers: await headerRequest.getRequestHeadersTimeSlot(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getTags(String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + 'reference-value/data-codes', body: '["TAGS"]', headers: await headerRequest.getRequestHeadersAuthContents());
      responseJson = _returnResponse(response);
      print(responseJson.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> addHospitalFromProvider(String url, String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeader());
      responseJson = _returnResponse(response);
      print(responseJson.toString());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  // API BASE HELPER CLASS

// True desk API List for no of tickets -- Yogeshwar

  Future<dynamic> getTicketList(url) async {
    var responseJson;
    var token = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print('My access token : $token');
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getAuth());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  // True desk API List for no of ticket types -- Yogeshwar
  Future<dynamic> getTicketTypesList(url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getAuth());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  // True desk Create Ticket -- Yogeshwar
  Future<dynamic> createTicket(url) async {
    var createTicketController = gett.Get.put(CreateTicketController());
    var responseJson;
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    try {
      var bodyData = {
        'subject': (Constants.tckTitle != '' && Constants.tckTitle != null) ? Constants.tckTitle : Constants.tckTitleOpt,
        'issue': (Constants.tckDesc != '' && Constants.tckDesc != null) ? Constants.tckDesc : 'desc',
        'type': Constants.ticketType, //ask
        'priority': Constants.tckPriority, //ask
        'preferredDate': Constants.tckPrefDate != 'pref_date' ? Constants.tckPrefDate : '',
        'patientUserId': userid,
        'additionalInfo': {
          ...createTicketController.dynamicTextFiledObj,
          'preferredLabId': Constants.tckPrefLabId.trim().isNotEmpty ? Constants.tckPrefLabId : "",
          "choose_doctor": Constants.tckSelectedDoctor != 'Doctor' ? Constants.tckSelectedDoctor : '',
          "choose_hospital": Constants.tckSelectedHospital != 'Hospital' ? Constants.tckSelectedHospital : '',
          "choose_category": Constants.tckSelectedCategory != 'Category' ? Constants.tckSelectedCategory : '',
          "package_name": Constants.tckPackageName != 'Package Name' ? Constants.tckPackageName : '',
          "doctor": {"id": Constants.tckSelectedDoctorId != 'DoctorId' ? Constants.tckSelectedDoctorId : '', "name": Constants.tckSelectedDoctor != 'Doctor' ? Constants.tckSelectedDoctor : ''},
          "hospital": {
            "id": Constants.tckSelectedHospitalId != 'HospitalId' ? Constants.tckSelectedHospitalId : '',
            "name": Constants.tckSelectedHospital != 'Hospital' ? Constants.tckSelectedHospital : ''
          },
        },
      };
      var response = await ApiServices.post(_baseUrl + url, body: json.encode(bodyData), headers: await headerRequest.getRequestHeadersTimeSlot());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  // True desk - Get user list of comments
  Future<dynamic> commentsForTicket(url) async {
    var responseJson;
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    try {
      var bodyData = {'comment': Constants.tckComment, '_id': Constants.tckID, 'patientUserId': userid};
      var response = await ApiServices.post(_baseUrl + url, body: json.encode(bodyData), headers: await headerRequest.getRequestHeadersTimeSlot());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> retryPayment(String url) async {
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getCredit(String url) async {
    print(await headerRequest.getAuths());
    var headers = headerRequest.getAuths();
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        headers: await headerRequest.getAuths(),
      );
      responseJson = _returnResponse(response);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getClaimList(String url) async {
    print(await headerRequest.getAuths());
    var headers = headerRequest.getAuths();
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        headers: await headerRequest.getAuths(),
      );
      responseJson = _returnResponse(response);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> createClaimRecord(String url, String jsonBody) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonBody);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getClaimListDetails(String url) async {
    print(await headerRequest.getAuths());
    var headers = headerRequest.getAuths();
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        headers: await headerRequest.getAuths(),
      );
      responseJson = _returnResponse(response);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getClaimExpiryResponseList(String url) async {
    print(await headerRequest.getAuths());
    var headers = headerRequest.getAuths();
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        headers: await headerRequest.getAuthsClaimList(),
      );
      responseJson = _returnResponse(response);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> uploadChatDocument(String url, String image, String userId, String peerId, String groupId) async {
    var authToken = await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    final dio = Dio();

    dio.options.headers['content-type'] = 'multipart/form-data';

    dio.options.headers['authorization'] = authToken;

    dio.options.headers['accept'] = 'application/json';

    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    FormData formData;

    var mapSub = Map<String, dynamic>();

    mapSub["id"] = groupId;

    mapSub["idTo"] = peerId;

    mapSub["idFrom"] = userId;

    var params = json.encode(mapSub);

    formData = FormData.fromMap({'data': params.toString()});

    final fileName = File(image);

    final fileNoun = fileName.path.split('/').last;

    formData.files.addAll([
      MapEntry('fileName', await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
    ]);

    late var response;

    try {
      response = await dio.post(_baseUrl + url, data: formData);

      if (response.statusCode == 200) {
        print(response.data.toString());

        return response?.data;
      } else {
        return response?.data;
      }
    } on DioError catch (e, stackTrace) {
      print(e.toString());

      print(e);

      return response?.data;
    } catch (f) {
      print(f.toString());
    }
  }

  Future<dynamic> getChatHistory(String url, String jsonString) async {
    var responseJson;

    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> initNewChat(String url, String jsonString) async {
    var responseJson;

    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> initRRTNotification({
    String? url,
    String? jsonString,
  }) async {
    var responseJson;

    try {
      var response = await ApiServices.put(_baseUrl + url!, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getUserIdFromDocId(String url) async {
    var responseJson;

    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> getSymptomList(String url) async {
    var responseJson;

    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> checkUserDelink(String url, String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.post(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeader());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> getAppointmentDetailUsingId(String url) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    final header = await headerRequest.getRequestHeader();
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> checkIfChildIsMember(String url) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic?> uploadAttachmentForTicket(String url, String? ticketId, List<ImagesModel> imagePaths) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final dio = Dio();
    dio.options.headers['accept'] = '*/*';

    dio.options.headers['authorization'] = authToken;

    List<FormData> formData = [];

    if (imagePaths != null && imagePaths.isNotEmpty) {
      for (ImagesModel image in imagePaths) {
        FormData newFormData;

        var fileName = File(image.file!);
        var fileNoun, filePathForUrl;
        if (!image.isFromFile) {
          filePathForUrl = fileName.path + image.fileType!;
        }
        fileNoun = image.isFromFile ? fileName.path.split('/').last : filePathForUrl;

        String mimeType = mime(image.isFromFile ? fileName.path : image.fileType)!;
        String mimee = mimeType.split('/')[0];
        String type = mimeType.split('/')[1];
        print("-----------------------");
        print(fileName);
        print("-----------------------");
        print(fileNoun);

        newFormData = FormData.fromMap({'userId': userId, 'attachment': await MultipartFile.fromFile(fileName.path, filename: fileNoun, contentType: MediaType(mimee, type)), 'ticketId': ticketId});

        formData.add(newFormData);
      }
    }
    var response;
    List responses = [];

    // formData.forEach((element) async {
    //   if (responses.length != formData.length) {
    //     try {
    //       response = await dio.post(url, data: element);

    //       if (response.statusCode == 200) {
    //         print(response.data.toString());
    //         responses.add(response);
    //       } else {
    //         responses.add(response);
    //       }
    //     } on DioError catch (e,stackTrace) {
    //       print(e.toString());
    //       print(e);
    //       responses.add(response);
    //     }
    //   }
    //   if (responses.length == formData.length ) {
    //     return responses;
    //   }
    // });

    for (var element in formData) {
      if (responses.length != formData.length) {
        try {
          response = await dio.post(url, data: element);

          if (response.statusCode == 200) {
            print(response.data.toString());
            responses.add(response);
          } else {
            responses.add(response);
          }
        } on DioError catch (e, stackTrace) {
          print(e.toString());
          print(e);
          responses.add(response);
        }
      }
    }
    return responses;
  }

  Future<UnitConfiguration> getUnitConfiguration(String url) async {
    var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    print(url);
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersForSearch());

      responseJson = _returnResponse(response, forDoctorSearch: true);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return UnitConfiguration.fromJson(responseJson);
  }

  Future<dynamic> postNotificationSheelaQueue(String url, String jsonString) async {
    var responseJson;

    try {
      var response = await ApiServices.post(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot(), body: jsonString);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> getSheelaBadgeCount(String url) async {
    var responseJson;

    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersTimeSlot());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

/*
  Future<dynamic> getMemberShipDetails(String url) async {
    MemberShipDetails responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeader());
      //responseJson = _returnResponse(response);
      responseJson = MemberShipDetails.fromJson(json.decode(response.body));
      print(responseJson.toJson());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }
*/

  Future<dynamic> getProviderList(type) async {
    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + CommonUtil.getProviderType(type), headers: await headerRequest.getAuth());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getCityList(String param) async {
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + param,
        headers: await headerRequest.getRequestHeadersTimeSlot(),
      );

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getSheelaConfig(String url) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      var response = await ApiServices.get(_baseUrl + url, headers: await headerRequest.getRequestHeadersAuthAccept());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getStatusOfVoiceCloning(String url) async {
    var headers = headerRequest.getAuths();
    var responseJson;
    try {
      var response = await ApiServices.get(
        _baseUrl + url,
        headers: await headerRequest.getAuths(),
      );
      responseJson = _returnResponse(response);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> revokeVoiceClone(String url, String jsonData) async {
    var responseJson;
    try {
      var response = await ApiServices.put(_baseUrl + url, body: jsonData, headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  // Define a function named labFilterList that takes a URL and JSON data as parameters
  Future<dynamic> labFilterList(String url, String jsonData) async {
    // Declare a variable to store the JSON response
    var responseJson;

    try {
      // Make an HTTP POST request using the ApiServices.post method
      var response = await ApiServices.post(
        _baseUrl + url,                    // Combine the base URL and the provided URL
        body: jsonData,                    // Pass the JSON data in the request body
        headers: await headerRequest.getRequestHeader(),  // Include headers from headerRequest
      );

      // Process the response using the _returnResponse method
      responseJson = _returnResponse(response);

    } on SocketException {
      // Handle the case when a SocketException occurs (no internet connection)
      throw FetchDataException(variable.strNoInternet);
    }

    // Return the processed JSON response or an exception if applicable
    return responseJson;
  }

}

void exitFromApp() async {
  // Initialize SheelaAIController using onInitSheelaAIController method from CommonUtil
  var sheelaAIController = CommonUtil().onInitSheelaAIController();
  // Check if internet connection is available
  if (sheelaAIController.isInternetConnection.value) {
    await PreferenceUtil.clearAllData().then((value) {
      gett.Get.offAll(PatientSignInScreen());
    });
  }
}

abstract class InnerException {
  factory InnerException([var message]) => _Exception(message);
}

/// Default implementation of [Exception] which carries a message. */
class _Exception implements InnerException {
  final dynamic message;

  _Exception([this.message]);

  @override
  String toString() {
    final String? message = this.message;
    if (message == null) return 'Exception';
    return '$message';
  }
}

// ignore: file_names
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/add_family_user_info/models/address_type_list.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonDialogBox.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/model/ImageDocumentResponse.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/common_response.dart';
import 'package:myfhb/src/model/error_map.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_success.dart';
import 'package:myfhb/src/resources/network/AppException.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/chat/model/GetRecordIdsFilter.dart';
import 'package:myfhb/widgets/cart_genric_response.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:myfhb/widgets/make_payment_response.dart';
import 'package:myfhb/widgets/update_payment_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppException.dart';
import 'package:http_parser/http_parser.dart';

import 'dart:async';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/src/resources/network/AppException.dart';

class ApiBaseHelper {
  final String _baseUrl = Constants.BASE_URL;
  final String _baseUrlDeviceReading = CommonUtil.BASEURL_DEVICE_READINGS;

  // String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

  HeaderRequest headerRequest = new HeaderRequest();
  ErrorMap errorMap = new ErrorMap();

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

  Future<dynamic> deleteHealthRecord(String url) async {
    var responseJson;
    try {
      final response = await http.delete(_baseUrl + url,
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
    dio.options.headers[variable.strAuthorization] = authToken;

    Map<String, dynamic> mapForSignUp = new Map();
    mapForSignUp[parameters.strSections] = query;
    FormData formData = new FormData.fromMap(mapForSignUp);

    var response = await dio.post(_baseUrl + url, data: formData);

    //responseJson = _returnResponse(response.data);

    return response.data;
  }

  Future<dynamic> updateTeleHealthProvidersNew(
      String url, String jsonString) async {
    Dio dio = new Dio();
    dio.options.headers[variable.straccept] = variable.strAcceptVal;
    dio.options.headers[variable.strAuthorization] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var response = await dio.put(_baseUrl + url, data: jsonString);
    print(response.data);

    return response.data;
  }

  Future<dynamic> getDoctorsListFromSearchNew(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    print(url);
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersForSearch());

      responseJson = _returnResponse(response, forDoctorSearch: true);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
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

  Future<dynamic> getHospitalListFromSearchNew(String url) async {
    //String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      print(_baseUrl + url);
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAcceptNew());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getMedicalPreferencesList(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAcceptNew());
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

  Future<dynamic> getCategoryLists(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url.trim(),
          headers: await headerRequest.getAuths());
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

  Future<dynamic> getFamilyMembersListNew(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(authToken);
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAcceptNew());
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

  dynamic _returnResponse(http.Response response, {bool forDoctorSearch}) {
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
        exitFromApp();

        return responseJson;

      case 400:
        var responseJson = convert.jsonDecode(response.body.toString());

        exitFromApp();

        return responseJson;
      case 401:
        var responseJson = convert.jsonDecode(response.body.toString());
        if (responseJson[parameters.strMessage] != null &&
            responseJson[parameters.strMessage] != '') {
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
        var responseJson = convert.jsonDecode(response.body.toString());
        if (responseJson[parameters.strMessage] ==
            Constants.STR_OTPMISMATCHEDFOREMAIL) {
          return responseJson;
        } else {
          exitFromApp();
        }
        break;
      case 404:
        exitFromApp();

        break;
      case 500:
        try {
          if (forDoctorSearch) {
            var responseJson = convert.jsonDecode(response.body.toString());
            return responseJson;
          } else {
            var responseJson = convert.jsonDecode(response.body.toString());
            return responseJson;
          }
        } catch (e) {
          var responseJson = convert.jsonDecode(response.body.toString());
          return responseJson;
        }
        break;
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
    print(_baseUrl + url);
    print(jsonData);
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
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Dio dio = new Dio();
    var responseJson;

    //dio.options.headers[variable.strContentType] = variable.strcntVal;
    dio.options.headers[variable.strAuthorization] = authToken;
    dio.options.headers[variable.straccept] = variable.strAcceptVal;
    print(url);
    print(query);

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
    print(url);
    print(jsonData);

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

      //dio.options.headers[variable.straccept] = variable.strAcceptVal;
      dio.options.headers[variable.strContentType] = variable.strcntVal;
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

  Future<dynamic> saveImageAndGetDeviceInfo(String url, List<String> imagePaths,
      String payload, String jsonBody, String userId) async {
    var response;
    try {
      String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      Dio dio = new Dio();
      dio.options.headers['content-type'] = 'multipart/form-data';
      dio.options.headers["authorization"] = authToken;
      FormData formData;

      if (imagePaths != null && imagePaths.length > 0) {
        formData = new FormData.fromMap({
          'metadata': payload,
          'userId': userId,
        });

        for (var image in imagePaths) {
          File fileName = new File(image);
          String fileNoun = fileName.path.split('/').last;
          formData.files.addAll([
            MapEntry(
                "fileName",
                await MultipartFile.fromFile(fileName.path,
                    filename: fileNoun)),
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
      print(_baseUrl + url);
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
      print(_baseUrl + url);
      print(jsonBody);
      final response = await http.put(_baseUrl + url,
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

  void SnackbarToLogout(
      {String msg = 'something went wrong, please try again later.'}) {
    PreferenceUtil.clearAllData().then((value) {
      Get.offAll(PatientSignInScreen());
      Get.snackbar(variable.strMessage, msg);
    });
  }

  Future<dynamic> bookAppointment(String url, String jsonBody) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonBody);
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
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonBody);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveDeviceData(String url, String jsonBody) async {
    var header = await headerRequest.getRequestHeader();
    var responseJson;
    try {
      final response = await http.post(_baseUrlDeviceReading + url,
          body: jsonBody, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getByRecordDataType(String url, String jsonBody) async {
    var header = await headerRequest.getRequestHeader();
    var responseJson;
    try {
      final response = await http.post(_baseUrlDeviceReading + url,
          body: jsonBody, headers: header);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDeviceInfo(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    var header = await headerRequest.getRequestHeader();
    var responseJson;
    try {
      final response =
          await http.get(_baseUrlDeviceReading + url, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> postDeviceId(
      String url, String jsonBody, bool isActive) async {
    Map<String, String> requestHeadersAuthAccept = new Map();
    requestHeadersAuthAccept['accept'] = 'application/json';
    requestHeadersAuthAccept['Content-type'] = 'application/json';

    requestHeadersAuthAccept['Authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      if (isActive) {
        final response = await http.post(_baseUrl + url,
            headers: requestHeadersAuthAccept, body: jsonBody);
        responseJson = _returnResponse(response);
      } else {
        final response = await http.post(_baseUrl + url,
            headers: requestHeadersAuthAccept, body: jsonBody);
        responseJson = _returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> associateRecords(String url, String jsonString) async {
    var responseJson;
    Map<String, String> requestHeadersAuthContent = new Map();

    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    try {
      final response = await http.post(
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

  Future<GetRecordIdsFilter> getMetaIdURL(
      List<String> recordIds, String patientId) async {
    var inputBody = {};
    inputBody[strUserId] = patientId;
    inputBody[HEALTH_RECORDIDS] = recordIds;
    var jsonString = convert.jsonEncode(inputBody);
    final response = await getApiForGetMetaURL(jsonString);
    return GetRecordIdsFilter.fromJson(response);
  }

  Future<dynamic> getApiForGetMetaURL(String jsonBody) async {
    var responseJson;
    try {
      final response = await http.post(
          _baseUrl + qr_health_record + qr_slash + qr_filter,
          headers: await headerRequest.getRequestHeader(),
          body: jsonBody);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  getValueBasedOnSearch(String name, String apiname) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var response = await http.get(
      '$_baseUrl$apiname/search/$name',
      headers: {HttpHeaders.authorizationHeader: authToken},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      //throw Exception("Unable to perform request!");
      throw InnerException('No Data Found');
    }
  }

  Future<dynamic> getMediaTypesList(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getAuths());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  getHealthRecordLists(String jsonData, String url) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData,
          headers: await headerRequest.getRequestHeadersAuthContents());
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
      final response = await http.put(_baseUrl + url,
          body: jsonBody,
          headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<AddressTypeResult> fetchAddressType(String responseQuery) async {
    final response = await http.post(_baseUrl + responseQuery,
        headers: await headerRequest.getRequestHeadersAuthContent(),
        body: '["ADDTYP"]');

    print(response.body);

    if (response.statusCode == 200) {
      return AddressTypeResult.fromJson(jsonDecode(response.body));
    } else {
      return AddressTypeResult.fromJson(
          errorMap.createErrorJsonString(response));
    }
  }

  Future<dynamic> createMediaData(String url, String payload,
      List<String> imagePaths, String audioPath, String id) async {
    String authToken =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    String userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID);

    Dio dio = new Dio();
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers["authorization"] = authToken;
    FormData formData;

    if (imagePaths != null && imagePaths.length > 0) {
      formData = new FormData.fromMap({
        'metadata': payload,
        'userId': id,
        'isBookmarked': false,
      });

      for (var image in imagePaths) {
        File fileName = new File(image);
        String fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry("fileName",
              await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }

      if (audioPath != null && audioPath != '') {
        File fileName = new File(audioPath);
        String fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry("fileName",
              await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }
    } else {
      formData = new FormData.fromMap(
          {'metadata': payload, 'userId': id, 'isBookmarked ': false});

      if (audioPath != null && audioPath != '') {
        File fileName = new File(audioPath);
        String fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry("fileName",
              await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
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
    } on DioError catch (e) {
      print(e.toString());
      print(e);
      return response;
    }
  }

  Future<dynamic> updateHealthRecords(String url, String payload,
      List<String> imagePaths, String audioPath, String metaId) async {
    String authToken =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    String userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID);

    Dio dio = new Dio();
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers["authorization"] = authToken;
    FormData formData;

    if (imagePaths != null && imagePaths.length > 0) {
      formData = new FormData.fromMap({
        'metadata': payload,
        'userId': userId,
        'isBookmarked': true,
        'id': metaId,
      });

      for (var image in imagePaths) {
        File fileName = new File(image);
        String fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry("fileName",
              await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }

      if (audioPath != null && audioPath != '') {
        File fileName = new File(audioPath);
        String fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry("fileName",
              await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);
      }
    } else {
      formData = new FormData.fromMap({
        'metadata': payload,
        'userId': userId,
        'isBookmarked ': false,
        'id': metaId,
      });
      if (audioPath != null && audioPath != '') {
        File fileName = new File(audioPath);
        String fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry("fileName",
              await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
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
    } on DioError catch (e) {
      print(e.toString());
      print(e);
      return response;
    }
  }

  Future<dynamic> getHealthOrgApi(String url) async {
    var responseJson;
    try {
      print(_baseUrl + url);
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());
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
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAccept());
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
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeader());
      //responseJson = _returnResponse(response);
      responseJson = CommonResponse.fromJson(json.decode(response.body));
      print(responseJson.toJson());
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> uploadUserProfilePicToServer(String url, File image) async {
    String authToken =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    //String userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
    String filename = image.path.split('/').last;
    String fileType = filename.split('.')[1];
    Dio dio = new Dio();
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers["authorization"] = authToken;
    dio.options.headers["accept"] = 'application/json';
    FormData formData = FormData.fromMap({
      "profilePicture": await MultipartFile.fromFile(image.path,
          filename: filename, contentType: MediaType('image', '${fileType}')),
    });
    var response;
    try {
      response = await dio.put(_baseUrl + url, data: formData);

      if (response.statusCode == 200) {
        print(response.data.toString());
        return response?.data;
      } else {
        return response?.data;
      }
    } on DioError catch (e) {
      print(e.toString());
      print(e);
      return response?.data;
    }
  }

  Future<dynamic> getDeviceSelection(String url) async {
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

  Future<dynamic> createDeviceSelection(String url, String jsonBody) async {
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

  Future<dynamic> updateDeviceSelection(String url, String jsonBody) async {
    var responseJson;
    try {
      final response = await http.put(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonBody);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> associateUpdateRecords(String url, String jsonString) async {
    var responseJson;
    Map<String, String> requestHeadersAuthContent = new Map();

    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    try {
      final response = await http.put(
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
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeaderWithStar());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> deleteDeviceRecords(String url) async {
    var responseJson;
    try {
      final response = await http.delete(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot());
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
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getPlanDetails(String url, String jsonString) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getQurPlanDashBoard(String url) async {
    var responseJson;
    try {
      final response = await http.get(
        _baseUrl + url,
        headers: await headerRequest.getRequestHeadersTimeSlot(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveRegimentMedia(
      String url, String imagePaths, String userId) async {
    var response;
    try {
      String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      Dio dio = new Dio();
      dio.options.headers['content-type'] = 'multipart/form-data';
      dio.options.headers["authorization"] = authToken;
      FormData formData;

      if (imagePaths != null && imagePaths.length > 0) {
        formData = new FormData.fromMap({
          'folderName': 'event',
          'userId': userId,
        });

        File fileName = new File(imagePaths);
        String fileNoun = fileName.path.split('/').last;
        formData.files.addAll([
          MapEntry("file",
              await MultipartFile.fromFile(fileName.path, filename: fileNoun)),
        ]);

        response = await dio.post(_baseUrl + url, data: formData);

        return response.data;
      }
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
  }

  Future<dynamic> getLanguageList(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url.trim(),
          headers: await headerRequest.getAuths());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getSearchListApi(String url, String jsonString) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getDoctorsByIdNew(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersAuthAcceptNew());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> addDoctorFromProvider(String url, String jsonData) async {
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

  Future<dynamic> getLoginDetails() async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var response = await http.get(
      _baseUrl + 'user/loggedin-details/',
      headers: {HttpHeaders.authorizationHeader: authToken},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      //throw Exception("Unable to perform request!");
      throw InnerException('No Data Found');
    }
  }

  Future<dynamic> createSubscribe(String url, String jsonString) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonString);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateLastVisited() async {
    try {
      String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      DateTime dateTime = DateTime.now();
      var responseJson;

      if (userID != null && userID != "") {
        Map<String, String> jsobBodyMap = new Map();
        jsobBodyMap['userId'] = userID;
        jsobBodyMap['lastVisitedDatetimeUtc'] = dateTime.toUtc().toString();
        jsobBodyMap['statusType'] = "lastVisitedDate";
        try {
          final response = await http.put(
              _baseUrl + "user/update-last-visited-details",
              body: json.encode(jsobBodyMap),
              headers: await headerRequest.getRequestHeadersAuthContent());
          print(response.body + " ***********************Last viviited bodyy");
          print(userID + " ***********************Last viviited bodyy");
          responseJson = _returnResponse(response);
        } on SocketException {
          throw FetchDataException(variable.strNoInternet);
        }
        return responseJson;
      }
    } catch (e) {}
  }

  Future<FetchingCartItemsModel> fetchCartItems() async {
    try {
      String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String createBy =
          await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      FetchingCartItemsModel responseJson;

      if (userID != null && userID != "" && ((createBy ?? '').isNotEmpty)) {
        Map<String, String> jsobBodyMap = new Map();
        jsobBodyMap['userId'] = userID;
        jsobBodyMap['createdBy'] = createBy;
        try {
          final response = await http.post(
              _baseUrl + "cart/getAllItems?isCount=false",
              body: json.encode(jsobBodyMap),
              headers: await headerRequest.getRequestHeadersAuthContent());
          //responseJson = _returnResponse(response);
          responseJson = FetchingCartItemsModel.fromJson(
              json.decode(response.body.toString()));
        } on SocketException {
          throw FetchDataException(variable.strNoInternet);
        }
        return responseJson;
      }
    } catch (e) {}
  }

  Future<FetchingCartItemsModel> clearCartItems() async {
    try {
      String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String createBy =
          await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      FetchingCartItemsModel responseJson;

      if (userID != null && userID != "" && ((createBy ?? '').isNotEmpty)) {
        Map<String, String> jsobBodyMap = new Map();
        jsobBodyMap['userId'] = userID;
        jsobBodyMap['createdBy'] = createBy;
        try {
          final response = await http.post(_baseUrl + "cart/clear",
              body: json.encode(jsobBodyMap),
              headers: await headerRequest.getRequestHeadersAuthContent());
          //responseJson = _returnResponse(response);
          responseJson = FetchingCartItemsModel.fromJson(
              json.decode(response.body.toString()));
        } on SocketException {
          throw FetchDataException(variable.strNoInternet);
        }
        return responseJson;
      }
    } catch (e) {}
  }

  Future<CartGenricResponse> removeCartItems(dynamic body) async {
    try {
      String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String createBy =
          await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      CartGenricResponse responseJson;

      if (userID != null && userID != "" && ((createBy ?? '').isNotEmpty)) {
        body['userId'] = userID;
        body['createdBy'] = createBy;
        try {
          final response = await http.post(_baseUrl + "cart/remove-product",
              body: json.encode(body),
              headers: await headerRequest.getRequestHeadersAuthContent());
          //responseJson = _returnResponse(response);
          responseJson = CartGenricResponse.fromJson(
              json.decode(response.body.toString()));
        } on SocketException {
          throw FetchDataException(variable.strNoInternet);
        }
        return responseJson;
      }
    } catch (e) {}
  }

  Future<MakePaymentResponse> makePayment(dynamic body) async {
    try {
      String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String createBy =
          await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      MakePaymentResponse responseJson;

      try {
        final response = await http.post(
            _baseUrl + "payment/plan-subscription-create-payment",
            body: json.encode(body),
            headers: await headerRequest.getRequestHeadersAuthContent());
        //responseJson = _returnResponse(response);
        responseJson =
            MakePaymentResponse.fromJson(json.decode(response.body.toString()));
      } on SocketException {
        throw FetchDataException(variable.strNoInternet);
      }
      return responseJson;
    } catch (e) {}
  }

  Future<UpdatePaymentResponse> updatePaymentStatus(dynamic body) async {
    try {
      String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
      String createBy =
          await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      DateTime dateTime = DateTime.now();
      UpdatePaymentResponse responseJson;

      if (userID != null && userID != "" && ((createBy ?? '').isNotEmpty)) {
        body['userId'] = userID;
        body['createdBy'] = createBy;
        try {
          final response = await http.post(
              _baseUrl + "payment/plan-subscription-update-payment-status",
              body: json.encode(body),
              headers: await headerRequest.getRequestHeadersAuthContent());
          //responseJson = _returnResponse(response);
          responseJson = UpdatePaymentResponse.fromJson(
              json.decode(response.body.toString()));
        } on SocketException {
          throw FetchDataException(variable.strNoInternet);
        }
        return responseJson;
      }
    } catch (e) {}
  }
}

void exitFromApp() async {
  PreferenceUtil.clearAllData().then((value) {
    Get.offAll(PatientSignInScreen());
  });
}

abstract class InnerException {
  factory InnerException([var message]) => _Exception(message);
}

/** Default implementation of [Exception] which carries a message. */
class _Exception implements InnerException {
  final dynamic message;

  _Exception([this.message]);

  String toString() {
    String message = this.message;
    if (message == null) return "Exception";
    return "$message";
  }
}

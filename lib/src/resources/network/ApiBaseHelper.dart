import 'dart:convert' as convert;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/record_detail/model/ImageDocumentResponse.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/HeaderRequest.dart';

import 'AppException.dart';

class ApiBaseHelper {
  final String _baseUrl = Constants.BASEURL_V2;
  final String _baseUrlV2 = Constants.BASEURL_V2;

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

  Future<dynamic> updateProviders(String url) async {
    var responseJson;
    try {
      final response = await http.put(_baseUrl + url,
          body: '',
          headers: await headerRequest.getRequestHeadersAuthContent());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
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
      final response = await http.get(_baseUrl + url,
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
          SnackbarToLogout();
        }
        break;

      case 403:
        var responseJson = convert.jsonDecode(response.body.toString());

        if (responseJson[parameters.strMessage] ==
            Constants.STR_OTPMISMATCHEDFOREMAIL) {
          return responseJson;
        } else {
          SnackbarToLogout();
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
            await MultipartFile.fromFile(file.path, filename: fileNoun)
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
      dio.options.headers[variable.strcontenttype] = variable.strcntVal;
      dio.options.headers[variable.strauthorization] = authToken;
      String fileNoun = file.path.split('/').last;

      FormData formData = new FormData.fromMap({
        parameters.strprofilePic:
            await MultipartFile.fromFile(file.path, filename: fileNoun)
      });
      response = await dio.put(_baseUrl + url, data: formData);

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
      final response = await http.get(_baseUrlV2 + url,
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
      final response = await http.post(_baseUrlV2 + url,
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
      final response = await http.post(_baseUrlV2 + url,
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
      final response = await http.post(_baseUrlV2 + url,
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
      final response = await http.post(_baseUrlV2 + url,
          headers: await headerRequest.getRequestHeadersTimeSlot(),
          body: jsonBody);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> saveDeviceData(String url, String jsonBody) async {
    //String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var header = await headerRequest.getRequestHeader();
    //header['Authorization'] =
    //    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJQcm92aWRlclBheWxvYWQiOnsiaWRfdG9rZW4iOiJleUpyYVdRaU9pSktVSFpHWVZrd2NtTkRZemsxYVUxdGJWUkJZMGRUZDFoV2FVTlhkVlpHTWxCQk5WTTJXWEZYZDFsclBTSXNJbUZzWnlJNklsSlRNalUySW4wLmV5SmhkRjlvWVhOb0lqb2ljSE0yUVRJdFgzVlpabXhhVEZWbFVrVjZVRFZ3ZHlJc0luTjFZaUk2SWpKbU1HTmhORE0yTFRoaE4yTXRORE5qT1MxaU5EUmpMVFV5TTJFM1pUVm1OVE5oWlNJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwMGNuVmxMQ0ppYVhKMGFHUmhkR1VpT2lJd09DMHdPQzB4T1Rrd0lpd2lhWE56SWpvaWFIUjBjSE02WEM5Y0wyTnZaMjVwZEc4dGFXUndMblZ6TFdWaGMzUXRNaTVoYldGNmIyNWhkM011WTI5dFhDOTFjeTFsWVhOMExUSmZabmQxVm05blYzZG9JaXdpY0dodmJtVmZiblZ0WW1WeVgzWmxjbWxtYVdWa0lqcG1ZV3h6WlN3aVkyOW5ibWwwYnpwMWMyVnlibUZ0WlNJNklqSm1NR05oTkRNMkxUaGhOMk10TkROak9TMWlORFJqTFRVeU0yRTNaVFZtTlROaFpTSXNJbWRwZG1WdVgyNWhiV1VpT2lKcVlXZGhiaUlzSW1GMVpDSTZJalpzYkdObWMybHZaVGd5TW5SdVoyNXVkbVJ1WkhSMk4zUnBJaXdpZEc5clpXNWZkWE5sSWpvaWFXUWlMQ0poZFhSb1gzUnBiV1VpT2pFMU9UVTNNRFU1TnpFc0luQm9iMjVsWDI1MWJXSmxjaUk2SWlzNU1Ua3hOell4TVRjNE1qSWlMQ0psZUhBaU9qRTFPVFUzTURrMU56RXNJbWxoZENJNk1UVTVOVGN3TlRrM01pd2labUZ0YVd4NVgyNWhiV1VpT2lKaVlXSjFJaXdpWlcxaGFXd2lPaUpoWkc5dWFXRnFZV2RoYmtCbmJXRnBiQzVqYjIwaWZRLkZ1WXBZZkc2OFNUSWNNcmpSX1NOVHZYbnhyU1RuTVNpV0J1ZGRDbkZUSHZQdzNoYlN1WHZlYVJwQUxKOXp0ak5DTjVjQ1F1MHllc3RMYl9GbjVTQU4zMWMyTzJvX1NMRmQwRk5VTWg0aXpReWMwS3IwTGtEZ2NvcHN2cWo3Rmk0Vk52WGJsVlZrcWU5d0pteE1HcmJvVmtBQWdQVXNwejNETWRacFNIY2FNZmVPUUNiUWpmVWlJVkI4UC1WQkJBQ2FlVV84aHI3TjFqWWoxWGduRVFqSUpiWWlpSEJBTkgtaWhxbGpWQl9SckFndTgtU2otR0Vma1NyUVprQXlFNTFqbWg2cUxGaWdMc3E1bHpCY3oycjNYVW9KTkhhMXJCTDd5bFo3R2dGSUhPbUdQNWdORk1ZZHZJNURVbnFkME1UX2wtTjE3b3M0WXc0MEZ0TGNHZHFSQSIsImFjY2Vzc190b2tlbiI6ImV5SnJhV1FpT2lKd01rSnJUM0p2ZFZReFZGaDJSSGRNU0V4U1pFRnZNRkExU21sTGNuQnFaRGhJVFVoWWQwTmNMM05OUlQwaUxDSmhiR2NpT2lKU1V6STFOaUo5LmV5SnpkV0lpT2lJeVpqQmpZVFF6TmkwNFlUZGpMVFF6WXprdFlqUTBZeTAxTWpOaE4yVTFaalV6WVdVaUxDSjBiMnRsYmw5MWMyVWlPaUpoWTJObGMzTWlMQ0p6WTI5d1pTSTZJbUYzY3k1amIyZHVhWFJ2TG5OcFoyNXBiaTUxYzJWeUxtRmtiV2x1SUhCb2IyNWxJRzl3Wlc1cFpDQndjbTltYVd4bElHVnRZV2xzSWl3aVlYVjBhRjkwYVcxbElqb3hOVGsxTnpBMU9UY3hMQ0pwYzNNaU9pSm9kSFJ3Y3pwY0wxd3ZZMjluYm1sMGJ5MXBaSEF1ZFhNdFpXRnpkQzB5TG1GdFlYcHZibUYzY3k1amIyMWNMM1Z6TFdWaGMzUXRNbDltZDNWV2IyZFhkMmdpTENKbGVIQWlPakUxT1RVM01EazFOekVzSW1saGRDSTZNVFU1TlRjd05UazNNaXdpZG1WeWMybHZiaUk2TWl3aWFuUnBJam9pTldJd05EazJabVV0WmpZellpMDBNVGswTFRnelpXSXRPREpoT0RVNU1XSTRPV1ZtSWl3aVkyeHBaVzUwWDJsa0lqb2lObXhzWTJaemFXOWxPREl5ZEc1bmJtNTJaRzVrZEhZM2RHa2lMQ0oxYzJWeWJtRnRaU0k2SWpKbU1HTmhORE0yTFRoaE4yTXRORE5qT1MxaU5EUmpMVFV5TTJFM1pUVm1OVE5oWlNKOS5xRjNJMVExTUo1LVhvOTVJLXd0Qi1EQTRuU3dKOFMwclh0R0taLWMyZ1pVNW5HTUdXTW5jRVJ1T2pSV0dBX29jckdIdXRwTFdiSWlZY0ROYmV0cmF1em1qem1vUGt6ZWdTdEZFNF9OVkxsUC1mMVp5c3hSWV80dGJfZ0xLNDVuc2N0ME5CUzc3SWptSWtBMHRuNkVNZ2g4QmFmLUM2b01vQ0MtUnNWN3ZxRzVEX2pTSUJ0VGhMUzhUakpXUFJjWnliY0E0OGJGaUVtWWp5ZjJ0R0lTRzh5Y19WUWxkV2xZX3Nsb1JsTHJKajVOaEExVzZHenZUQXNEN0tVakRxMEYyclgxalNRWWp4R2pyaE1vTmRqUUhlX25ELWstZUJRQ2U5aXRYdG43T0VPemdyQVpsU01vNHdFdUVXQjFfTGN3ZkFyNmpVb3l3bDRtR3BxSW5NcUw5WlEiLCJyZWZyZXNoX3Rva2VuIjoiZXlKamRIa2lPaUpLVjFRaUxDSmxibU1pT2lKQk1qVTJSME5OSWl3aVlXeG5Jam9pVWxOQkxVOUJSVkFpZlEuR0swU0Fmb2J2bllWbjBESGN2TlNBdEc3UU54N3Y1eUstTmNxSXhFRmFHanR6YTJwM0J0QTVuQkQwX2tvX3NsN1BiMF9iMmJEOEtEYWpZVllXajJhT3lVanM5YVlPV2MybUxSMUptX3VITk1FRGVFTUttanZmQW5iTjhyWldWZ2RaZWttSk9uakphTnZqSFVhTnF6RXhtRDN4dGJ2dWxYSi03Yk5nSDRENXk1cUV2eXFmUzh0ZUIyZWdVNVJIU3A3N3czSFVDY0haSVg2VUhxRmgxY2laTHVQWjdTYVItVXJhRDJhVlFZb1BGMjdsX0FrWkFLLWZXZjIzcWJydF9ZT2NhRTM4bTg1QWFOMzdHek5NWVhvSzFCYzZtYlNrNFB3RFhaR3dEbkktdW12SUVfRXIwVGZiU3pfT3liVTZqVHFJbzh3X1dXNWZ0aUpWWnJPU1QxMVBRLnI5RlBRVHJrMlVwb1VDUlIuX19yVDl3bEJaSzNGNFoyT01NXzRYUXdJcEY5M040aFlQaVpULVFYTVQtbDc4b1ZQWGRfZXhieUIxaF9wd1JfWHp2blMwU1FLN3ZPWWdCRlp6WUlFQi1lRkZvVGNpTU1oODNiZVRWOEQwZkNZMm40bDE1TF9ETWVmMnNIRU1vZ1g1Y3ZqV0NvOTJZRkxhVE84WktqOGJJZ190NW01WlVhQ3lRR1AwQkVZdm5XOUY2WWxWS3RSSTZOeUcwSGc3aHloQTNHbnZTc3Zkb1UwVWlpTUxyU3ZGbl8zNHA1a2oyS3p1TWh6b2ZZR3NJTEx0VzZJempFZTFCaW8yTF9Cb21iWjFGX0RGZjZqcnBobjMydVlMMzlCUkl4SUF0eTEtUDlZLTFnX1FiYktMLWFhOEZyY20yb05CZ2FFa2NDTnliN1R0RzJKT0s4eko1bElWcUtYRU00MG1PTDl0T0ZWSHZJZThYWXA4cVkycmVVbVN4WEMxUjlsWmJkSkRRT0wzWnIzR0JMcFAtakRJOEpROXh3Q2pqSVJndUJ4cGIwNWowZE5JREVITjBJN0V4Z1hBT1p5YlRMVTBORVFvd211YkZkSWUwWTQxeEhnbjA5MDM3MmxPMkZFMThfZVNnWVlBUFFaUUtLYkt3cjloOElWOGJCV3hZYWVWanlTRDktSmlWaHpEYlg1N1FZQzQxTWNodkV3RTY0eldfT0Z0Q0wzY2hGNEhkZWlOYVBlMWdFN2l1YnNCczhfeEJzXzNIMXYySnY1c0lhVVhBendsQVBoYmdGZVNlVGRndXBZRnpQRGF0bUZVZGVZRFlZQUg2eHZnTW44LVVlamxmQjNiaEV1YkgwY2dYR01fVmJ6TEJ4NW9NNG5zLWp3bHU4Q1B2X1ZDZDBOanlGeDBFQ3I5cWJrUUJvYzlDM1lkQU4wdDB1QzF4WjhSZGh1N3VranBybVowcVI3aXMwRjhlUDJudC1McE9Xb0JDbExPZHJvNUFZRGV5ZVJlZ0lNUkdLVTRTOTNOMGVZSWFZTkthdDhKU3RUWGY0amxDREVrMXh2cDlCQUgtOHk1amNVSmtKN01yQWt5NnVmY19qT2tBdGNrQlE2Yzl4X2ZXVzVxQV9uRDFkS1hXdkpJcUIwQWNkR0g1eWJfS0JMU29hdG1ETDZMT2p5aHpvRk9qX3hNaG5HSVptaTd2c3pkZ0R6MWRwVUZILW0zbFdoYWF4UUJUbjFpNnNEbHNWQnpaUXdBZmdaYXRfbWpyRGNBbDBMaXBianpEOXZLaC1GNmN3ZnZfdmdBYXgxTmtqZkNycEJucVZjdF9JcHhrTVQtSmFjektCWUt5OWtDR0tXSkxyOHNybUJscVVTZWtVMlhyQ0hUT05xQmZLeEpSX3NWWmtoUHBFaHhZWVZWNDhHZk9ack53MXl1aG51M01rZ05BNlRyc3pDOHNkT3Jzc0wxdkIySGJmV1gwZ3g2cUw1bkdPejl6aFRreGxUVVg0OXdhSEFzbEdJcXIyVmJNUTFTcjZZOHJ1aGhJMXViME90aF9yVlpTV09MZ0hUVlpHMGRLUnpkNVlla3BhSU5iMlVYYWpGbUhiZFpBVmxiSTJQTTRkUGFnaVdKX1piRjY0SzNFeUxDUXExdzhjajRQa1E5MXQ5eHEwYnhCbFBYajItaEx4bXMwdUVfV29JWlA2MUYxLXl2dk5VTXEtNWVsRnNfcS0zXzQ5bTNsdzhiWTZwazRRanZ6QzRVbzZpUWtzbXlzSUlfWmFneVM4Lmt1WExqTFI5XzhGNGpONTBDS0M0ZkEiLCJleHBpcmVzX2luIjozNjAwLCJ0b2tlbl90eXBlIjoiQmVhcmVyIn0sImNvdW50cnlDb2RlIjoiKzkxIiwiZXhwaXJ5RGF0ZSI6MTU5ODkwODA2MTAyOSwicm9sZUlkIjoiOGY0NWY0NDItNjg1YS00YjhiLTg2ZTctYjkzZTY5ZDgwOTZkIiwic2Vzc2lvbkRhdGUiOjE1OTU3MDU5NzQwMTMsInNlc3Npb25Sb2xlcyI6IjhmNDVmNDQyLTY4NWEtNGI4Yi04NmU3LWI5M2U2OWQ4MDk2ZCIsInNvdXJjZUluZm8iOnsic3ViU291cmNlSWQiOiIyNGUxNWJlMy05Njk1LTQ0ZjctODIyOS0zNGZmNGVmODEzOTYiLCJlbnRpdHlJZCI6IjkyYmRjN2IxLWQ1MDAtNDkwMS1iZmU4LThlMTlhMDlmZmFkNCIsInJvbGVJZCI6IjhmNDVmNDQyLTY4NWEtNGI4Yi04NmU3LWI5M2U2OWQ4MDk2ZCIsImlzRGV2aWNlIjpmYWxzZSwiZGV2aWNlSWQiOiIifSwic3ViamVjdCI6ImFkb25pYWphZ2FuQGdtYWlsLmNvbSIsInVzZXJJZCI6ImFjOWQxMTRkLThlMDEtNGMwOS04ZDc0LTg4Yjk5MGRlZDRjMyIsInBob25lTnVtYmVyIjoiOTE3NjExNzgyMiJ9LCJpYXQiOjE1OTU3MDU5NzV9.JrIzllRP3NCWPwQB6qX37XGs68BWF0BKjLiqfDylB_8";

    var responseJson;
    var response;
    try {
      response = await http.post(
          "https://dev.healthbook.vsolgmi.com/asgard" + url,
          body: jsonBody,
          headers: header);
      responseJson = _returnResponse(response);
      //print(responseJson);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<dynamic> getByRecordDataType(String url, String jsonBody) async {
    //String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var header = await headerRequest.getRequestHeader();
    //header['Authorization'] =
    //    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJQcm92aWRlclBheWxvYWQiOnsiaWRfdG9rZW4iOiJleUpyYVdRaU9pSktVSFpHWVZrd2NtTkRZemsxYVUxdGJWUkJZMGRUZDFoV2FVTlhkVlpHTWxCQk5WTTJXWEZYZDFsclBTSXNJbUZzWnlJNklsSlRNalUySW4wLmV5SmhkRjlvWVhOb0lqb2ljSE0yUVRJdFgzVlpabXhhVEZWbFVrVjZVRFZ3ZHlJc0luTjFZaUk2SWpKbU1HTmhORE0yTFRoaE4yTXRORE5qT1MxaU5EUmpMVFV5TTJFM1pUVm1OVE5oWlNJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwMGNuVmxMQ0ppYVhKMGFHUmhkR1VpT2lJd09DMHdPQzB4T1Rrd0lpd2lhWE56SWpvaWFIUjBjSE02WEM5Y0wyTnZaMjVwZEc4dGFXUndMblZ6TFdWaGMzUXRNaTVoYldGNmIyNWhkM011WTI5dFhDOTFjeTFsWVhOMExUSmZabmQxVm05blYzZG9JaXdpY0dodmJtVmZiblZ0WW1WeVgzWmxjbWxtYVdWa0lqcG1ZV3h6WlN3aVkyOW5ibWwwYnpwMWMyVnlibUZ0WlNJNklqSm1NR05oTkRNMkxUaGhOMk10TkROak9TMWlORFJqTFRVeU0yRTNaVFZtTlROaFpTSXNJbWRwZG1WdVgyNWhiV1VpT2lKcVlXZGhiaUlzSW1GMVpDSTZJalpzYkdObWMybHZaVGd5TW5SdVoyNXVkbVJ1WkhSMk4zUnBJaXdpZEc5clpXNWZkWE5sSWpvaWFXUWlMQ0poZFhSb1gzUnBiV1VpT2pFMU9UVTNNRFU1TnpFc0luQm9iMjVsWDI1MWJXSmxjaUk2SWlzNU1Ua3hOell4TVRjNE1qSWlMQ0psZUhBaU9qRTFPVFUzTURrMU56RXNJbWxoZENJNk1UVTVOVGN3TlRrM01pd2labUZ0YVd4NVgyNWhiV1VpT2lKaVlXSjFJaXdpWlcxaGFXd2lPaUpoWkc5dWFXRnFZV2RoYmtCbmJXRnBiQzVqYjIwaWZRLkZ1WXBZZkc2OFNUSWNNcmpSX1NOVHZYbnhyU1RuTVNpV0J1ZGRDbkZUSHZQdzNoYlN1WHZlYVJwQUxKOXp0ak5DTjVjQ1F1MHllc3RMYl9GbjVTQU4zMWMyTzJvX1NMRmQwRk5VTWg0aXpReWMwS3IwTGtEZ2NvcHN2cWo3Rmk0Vk52WGJsVlZrcWU5d0pteE1HcmJvVmtBQWdQVXNwejNETWRacFNIY2FNZmVPUUNiUWpmVWlJVkI4UC1WQkJBQ2FlVV84aHI3TjFqWWoxWGduRVFqSUpiWWlpSEJBTkgtaWhxbGpWQl9SckFndTgtU2otR0Vma1NyUVprQXlFNTFqbWg2cUxGaWdMc3E1bHpCY3oycjNYVW9KTkhhMXJCTDd5bFo3R2dGSUhPbUdQNWdORk1ZZHZJNURVbnFkME1UX2wtTjE3b3M0WXc0MEZ0TGNHZHFSQSIsImFjY2Vzc190b2tlbiI6ImV5SnJhV1FpT2lKd01rSnJUM0p2ZFZReFZGaDJSSGRNU0V4U1pFRnZNRkExU21sTGNuQnFaRGhJVFVoWWQwTmNMM05OUlQwaUxDSmhiR2NpT2lKU1V6STFOaUo5LmV5SnpkV0lpT2lJeVpqQmpZVFF6TmkwNFlUZGpMVFF6WXprdFlqUTBZeTAxTWpOaE4yVTFaalV6WVdVaUxDSjBiMnRsYmw5MWMyVWlPaUpoWTJObGMzTWlMQ0p6WTI5d1pTSTZJbUYzY3k1amIyZHVhWFJ2TG5OcFoyNXBiaTUxYzJWeUxtRmtiV2x1SUhCb2IyNWxJRzl3Wlc1cFpDQndjbTltYVd4bElHVnRZV2xzSWl3aVlYVjBhRjkwYVcxbElqb3hOVGsxTnpBMU9UY3hMQ0pwYzNNaU9pSm9kSFJ3Y3pwY0wxd3ZZMjluYm1sMGJ5MXBaSEF1ZFhNdFpXRnpkQzB5TG1GdFlYcHZibUYzY3k1amIyMWNMM1Z6TFdWaGMzUXRNbDltZDNWV2IyZFhkMmdpTENKbGVIQWlPakUxT1RVM01EazFOekVzSW1saGRDSTZNVFU1TlRjd05UazNNaXdpZG1WeWMybHZiaUk2TWl3aWFuUnBJam9pTldJd05EazJabVV0WmpZellpMDBNVGswTFRnelpXSXRPREpoT0RVNU1XSTRPV1ZtSWl3aVkyeHBaVzUwWDJsa0lqb2lObXhzWTJaemFXOWxPREl5ZEc1bmJtNTJaRzVrZEhZM2RHa2lMQ0oxYzJWeWJtRnRaU0k2SWpKbU1HTmhORE0yTFRoaE4yTXRORE5qT1MxaU5EUmpMVFV5TTJFM1pUVm1OVE5oWlNKOS5xRjNJMVExTUo1LVhvOTVJLXd0Qi1EQTRuU3dKOFMwclh0R0taLWMyZ1pVNW5HTUdXTW5jRVJ1T2pSV0dBX29jckdIdXRwTFdiSWlZY0ROYmV0cmF1em1qem1vUGt6ZWdTdEZFNF9OVkxsUC1mMVp5c3hSWV80dGJfZ0xLNDVuc2N0ME5CUzc3SWptSWtBMHRuNkVNZ2g4QmFmLUM2b01vQ0MtUnNWN3ZxRzVEX2pTSUJ0VGhMUzhUakpXUFJjWnliY0E0OGJGaUVtWWp5ZjJ0R0lTRzh5Y19WUWxkV2xZX3Nsb1JsTHJKajVOaEExVzZHenZUQXNEN0tVakRxMEYyclgxalNRWWp4R2pyaE1vTmRqUUhlX25ELWstZUJRQ2U5aXRYdG43T0VPemdyQVpsU01vNHdFdUVXQjFfTGN3ZkFyNmpVb3l3bDRtR3BxSW5NcUw5WlEiLCJyZWZyZXNoX3Rva2VuIjoiZXlKamRIa2lPaUpLVjFRaUxDSmxibU1pT2lKQk1qVTJSME5OSWl3aVlXeG5Jam9pVWxOQkxVOUJSVkFpZlEuR0swU0Fmb2J2bllWbjBESGN2TlNBdEc3UU54N3Y1eUstTmNxSXhFRmFHanR6YTJwM0J0QTVuQkQwX2tvX3NsN1BiMF9iMmJEOEtEYWpZVllXajJhT3lVanM5YVlPV2MybUxSMUptX3VITk1FRGVFTUttanZmQW5iTjhyWldWZ2RaZWttSk9uakphTnZqSFVhTnF6RXhtRDN4dGJ2dWxYSi03Yk5nSDRENXk1cUV2eXFmUzh0ZUIyZWdVNVJIU3A3N3czSFVDY0haSVg2VUhxRmgxY2laTHVQWjdTYVItVXJhRDJhVlFZb1BGMjdsX0FrWkFLLWZXZjIzcWJydF9ZT2NhRTM4bTg1QWFOMzdHek5NWVhvSzFCYzZtYlNrNFB3RFhaR3dEbkktdW12SUVfRXIwVGZiU3pfT3liVTZqVHFJbzh3X1dXNWZ0aUpWWnJPU1QxMVBRLnI5RlBRVHJrMlVwb1VDUlIuX19yVDl3bEJaSzNGNFoyT01NXzRYUXdJcEY5M040aFlQaVpULVFYTVQtbDc4b1ZQWGRfZXhieUIxaF9wd1JfWHp2blMwU1FLN3ZPWWdCRlp6WUlFQi1lRkZvVGNpTU1oODNiZVRWOEQwZkNZMm40bDE1TF9ETWVmMnNIRU1vZ1g1Y3ZqV0NvOTJZRkxhVE84WktqOGJJZ190NW01WlVhQ3lRR1AwQkVZdm5XOUY2WWxWS3RSSTZOeUcwSGc3aHloQTNHbnZTc3Zkb1UwVWlpTUxyU3ZGbl8zNHA1a2oyS3p1TWh6b2ZZR3NJTEx0VzZJempFZTFCaW8yTF9Cb21iWjFGX0RGZjZqcnBobjMydVlMMzlCUkl4SUF0eTEtUDlZLTFnX1FiYktMLWFhOEZyY20yb05CZ2FFa2NDTnliN1R0RzJKT0s4eko1bElWcUtYRU00MG1PTDl0T0ZWSHZJZThYWXA4cVkycmVVbVN4WEMxUjlsWmJkSkRRT0wzWnIzR0JMcFAtakRJOEpROXh3Q2pqSVJndUJ4cGIwNWowZE5JREVITjBJN0V4Z1hBT1p5YlRMVTBORVFvd211YkZkSWUwWTQxeEhnbjA5MDM3MmxPMkZFMThfZVNnWVlBUFFaUUtLYkt3cjloOElWOGJCV3hZYWVWanlTRDktSmlWaHpEYlg1N1FZQzQxTWNodkV3RTY0eldfT0Z0Q0wzY2hGNEhkZWlOYVBlMWdFN2l1YnNCczhfeEJzXzNIMXYySnY1c0lhVVhBendsQVBoYmdGZVNlVGRndXBZRnpQRGF0bUZVZGVZRFlZQUg2eHZnTW44LVVlamxmQjNiaEV1YkgwY2dYR01fVmJ6TEJ4NW9NNG5zLWp3bHU4Q1B2X1ZDZDBOanlGeDBFQ3I5cWJrUUJvYzlDM1lkQU4wdDB1QzF4WjhSZGh1N3VranBybVowcVI3aXMwRjhlUDJudC1McE9Xb0JDbExPZHJvNUFZRGV5ZVJlZ0lNUkdLVTRTOTNOMGVZSWFZTkthdDhKU3RUWGY0amxDREVrMXh2cDlCQUgtOHk1amNVSmtKN01yQWt5NnVmY19qT2tBdGNrQlE2Yzl4X2ZXVzVxQV9uRDFkS1hXdkpJcUIwQWNkR0g1eWJfS0JMU29hdG1ETDZMT2p5aHpvRk9qX3hNaG5HSVptaTd2c3pkZ0R6MWRwVUZILW0zbFdoYWF4UUJUbjFpNnNEbHNWQnpaUXdBZmdaYXRfbWpyRGNBbDBMaXBianpEOXZLaC1GNmN3ZnZfdmdBYXgxTmtqZkNycEJucVZjdF9JcHhrTVQtSmFjektCWUt5OWtDR0tXSkxyOHNybUJscVVTZWtVMlhyQ0hUT05xQmZLeEpSX3NWWmtoUHBFaHhZWVZWNDhHZk9ack53MXl1aG51M01rZ05BNlRyc3pDOHNkT3Jzc0wxdkIySGJmV1gwZ3g2cUw1bkdPejl6aFRreGxUVVg0OXdhSEFzbEdJcXIyVmJNUTFTcjZZOHJ1aGhJMXViME90aF9yVlpTV09MZ0hUVlpHMGRLUnpkNVlla3BhSU5iMlVYYWpGbUhiZFpBVmxiSTJQTTRkUGFnaVdKX1piRjY0SzNFeUxDUXExdzhjajRQa1E5MXQ5eHEwYnhCbFBYajItaEx4bXMwdUVfV29JWlA2MUYxLXl2dk5VTXEtNWVsRnNfcS0zXzQ5bTNsdzhiWTZwazRRanZ6QzRVbzZpUWtzbXlzSUlfWmFneVM4Lmt1WExqTFI5XzhGNGpONTBDS0M0ZkEiLCJleHBpcmVzX2luIjozNjAwLCJ0b2tlbl90eXBlIjoiQmVhcmVyIn0sImNvdW50cnlDb2RlIjoiKzkxIiwiZXhwaXJ5RGF0ZSI6MTU5ODkwODA2MTAyOSwicm9sZUlkIjoiOGY0NWY0NDItNjg1YS00YjhiLTg2ZTctYjkzZTY5ZDgwOTZkIiwic2Vzc2lvbkRhdGUiOjE1OTU3MDU5NzQwMTMsInNlc3Npb25Sb2xlcyI6IjhmNDVmNDQyLTY4NWEtNGI4Yi04NmU3LWI5M2U2OWQ4MDk2ZCIsInNvdXJjZUluZm8iOnsic3ViU291cmNlSWQiOiIyNGUxNWJlMy05Njk1LTQ0ZjctODIyOS0zNGZmNGVmODEzOTYiLCJlbnRpdHlJZCI6IjkyYmRjN2IxLWQ1MDAtNDkwMS1iZmU4LThlMTlhMDlmZmFkNCIsInJvbGVJZCI6IjhmNDVmNDQyLTY4NWEtNGI4Yi04NmU3LWI5M2U2OWQ4MDk2ZCIsImlzRGV2aWNlIjpmYWxzZSwiZGV2aWNlSWQiOiIifSwic3ViamVjdCI6ImFkb25pYWphZ2FuQGdtYWlsLmNvbSIsInVzZXJJZCI6ImFjOWQxMTRkLThlMDEtNGMwOS04ZDc0LTg4Yjk5MGRlZDRjMyIsInBob25lTnVtYmVyIjoiOTE3NjExNzgyMiJ9LCJpYXQiOjE1OTU3MDU5NzV9.JrIzllRP3NCWPwQB6qX37XGs68BWF0BKjLiqfDylB_8";

    var responseJson;
    var response;
    try {
      response = await http.post(
          "https://dev.healthbook.vsolgmi.com/asgard" + url,
          body: jsonBody,
          headers: header);

      responseJson = _returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getLastsynctime(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    var header = await headerRequest.getRequestHeader();
    //header['Authorization'] =
    //   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJQcm92aWRlclBheWxvYWQiOnsiaWRfdG9rZW4iOiJleUpyYVdRaU9pSktVSFpHWVZrd2NtTkRZemsxYVUxdGJWUkJZMGRUZDFoV2FVTlhkVlpHTWxCQk5WTTJXWEZYZDFsclBTSXNJbUZzWnlJNklsSlRNalUySW4wLmV5SmhkRjlvWVhOb0lqb2ljSE0yUVRJdFgzVlpabXhhVEZWbFVrVjZVRFZ3ZHlJc0luTjFZaUk2SWpKbU1HTmhORE0yTFRoaE4yTXRORE5qT1MxaU5EUmpMVFV5TTJFM1pUVm1OVE5oWlNJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwMGNuVmxMQ0ppYVhKMGFHUmhkR1VpT2lJd09DMHdPQzB4T1Rrd0lpd2lhWE56SWpvaWFIUjBjSE02WEM5Y0wyTnZaMjVwZEc4dGFXUndMblZ6TFdWaGMzUXRNaTVoYldGNmIyNWhkM011WTI5dFhDOTFjeTFsWVhOMExUSmZabmQxVm05blYzZG9JaXdpY0dodmJtVmZiblZ0WW1WeVgzWmxjbWxtYVdWa0lqcG1ZV3h6WlN3aVkyOW5ibWwwYnpwMWMyVnlibUZ0WlNJNklqSm1NR05oTkRNMkxUaGhOMk10TkROak9TMWlORFJqTFRVeU0yRTNaVFZtTlROaFpTSXNJbWRwZG1WdVgyNWhiV1VpT2lKcVlXZGhiaUlzSW1GMVpDSTZJalpzYkdObWMybHZaVGd5TW5SdVoyNXVkbVJ1WkhSMk4zUnBJaXdpZEc5clpXNWZkWE5sSWpvaWFXUWlMQ0poZFhSb1gzUnBiV1VpT2pFMU9UVTNNRFU1TnpFc0luQm9iMjVsWDI1MWJXSmxjaUk2SWlzNU1Ua3hOell4TVRjNE1qSWlMQ0psZUhBaU9qRTFPVFUzTURrMU56RXNJbWxoZENJNk1UVTVOVGN3TlRrM01pd2labUZ0YVd4NVgyNWhiV1VpT2lKaVlXSjFJaXdpWlcxaGFXd2lPaUpoWkc5dWFXRnFZV2RoYmtCbmJXRnBiQzVqYjIwaWZRLkZ1WXBZZkc2OFNUSWNNcmpSX1NOVHZYbnhyU1RuTVNpV0J1ZGRDbkZUSHZQdzNoYlN1WHZlYVJwQUxKOXp0ak5DTjVjQ1F1MHllc3RMYl9GbjVTQU4zMWMyTzJvX1NMRmQwRk5VTWg0aXpReWMwS3IwTGtEZ2NvcHN2cWo3Rmk0Vk52WGJsVlZrcWU5d0pteE1HcmJvVmtBQWdQVXNwejNETWRacFNIY2FNZmVPUUNiUWpmVWlJVkI4UC1WQkJBQ2FlVV84aHI3TjFqWWoxWGduRVFqSUpiWWlpSEJBTkgtaWhxbGpWQl9SckFndTgtU2otR0Vma1NyUVprQXlFNTFqbWg2cUxGaWdMc3E1bHpCY3oycjNYVW9KTkhhMXJCTDd5bFo3R2dGSUhPbUdQNWdORk1ZZHZJNURVbnFkME1UX2wtTjE3b3M0WXc0MEZ0TGNHZHFSQSIsImFjY2Vzc190b2tlbiI6ImV5SnJhV1FpT2lKd01rSnJUM0p2ZFZReFZGaDJSSGRNU0V4U1pFRnZNRkExU21sTGNuQnFaRGhJVFVoWWQwTmNMM05OUlQwaUxDSmhiR2NpT2lKU1V6STFOaUo5LmV5SnpkV0lpT2lJeVpqQmpZVFF6TmkwNFlUZGpMVFF6WXprdFlqUTBZeTAxTWpOaE4yVTFaalV6WVdVaUxDSjBiMnRsYmw5MWMyVWlPaUpoWTJObGMzTWlMQ0p6WTI5d1pTSTZJbUYzY3k1amIyZHVhWFJ2TG5OcFoyNXBiaTUxYzJWeUxtRmtiV2x1SUhCb2IyNWxJRzl3Wlc1cFpDQndjbTltYVd4bElHVnRZV2xzSWl3aVlYVjBhRjkwYVcxbElqb3hOVGsxTnpBMU9UY3hMQ0pwYzNNaU9pSm9kSFJ3Y3pwY0wxd3ZZMjluYm1sMGJ5MXBaSEF1ZFhNdFpXRnpkQzB5TG1GdFlYcHZibUYzY3k1amIyMWNMM1Z6TFdWaGMzUXRNbDltZDNWV2IyZFhkMmdpTENKbGVIQWlPakUxT1RVM01EazFOekVzSW1saGRDSTZNVFU1TlRjd05UazNNaXdpZG1WeWMybHZiaUk2TWl3aWFuUnBJam9pTldJd05EazJabVV0WmpZellpMDBNVGswTFRnelpXSXRPREpoT0RVNU1XSTRPV1ZtSWl3aVkyeHBaVzUwWDJsa0lqb2lObXhzWTJaemFXOWxPREl5ZEc1bmJtNTJaRzVrZEhZM2RHa2lMQ0oxYzJWeWJtRnRaU0k2SWpKbU1HTmhORE0yTFRoaE4yTXRORE5qT1MxaU5EUmpMVFV5TTJFM1pUVm1OVE5oWlNKOS5xRjNJMVExTUo1LVhvOTVJLXd0Qi1EQTRuU3dKOFMwclh0R0taLWMyZ1pVNW5HTUdXTW5jRVJ1T2pSV0dBX29jckdIdXRwTFdiSWlZY0ROYmV0cmF1em1qem1vUGt6ZWdTdEZFNF9OVkxsUC1mMVp5c3hSWV80dGJfZ0xLNDVuc2N0ME5CUzc3SWptSWtBMHRuNkVNZ2g4QmFmLUM2b01vQ0MtUnNWN3ZxRzVEX2pTSUJ0VGhMUzhUakpXUFJjWnliY0E0OGJGaUVtWWp5ZjJ0R0lTRzh5Y19WUWxkV2xZX3Nsb1JsTHJKajVOaEExVzZHenZUQXNEN0tVakRxMEYyclgxalNRWWp4R2pyaE1vTmRqUUhlX25ELWstZUJRQ2U5aXRYdG43T0VPemdyQVpsU01vNHdFdUVXQjFfTGN3ZkFyNmpVb3l3bDRtR3BxSW5NcUw5WlEiLCJyZWZyZXNoX3Rva2VuIjoiZXlKamRIa2lPaUpLVjFRaUxDSmxibU1pT2lKQk1qVTJSME5OSWl3aVlXeG5Jam9pVWxOQkxVOUJSVkFpZlEuR0swU0Fmb2J2bllWbjBESGN2TlNBdEc3UU54N3Y1eUstTmNxSXhFRmFHanR6YTJwM0J0QTVuQkQwX2tvX3NsN1BiMF9iMmJEOEtEYWpZVllXajJhT3lVanM5YVlPV2MybUxSMUptX3VITk1FRGVFTUttanZmQW5iTjhyWldWZ2RaZWttSk9uakphTnZqSFVhTnF6RXhtRDN4dGJ2dWxYSi03Yk5nSDRENXk1cUV2eXFmUzh0ZUIyZWdVNVJIU3A3N3czSFVDY0haSVg2VUhxRmgxY2laTHVQWjdTYVItVXJhRDJhVlFZb1BGMjdsX0FrWkFLLWZXZjIzcWJydF9ZT2NhRTM4bTg1QWFOMzdHek5NWVhvSzFCYzZtYlNrNFB3RFhaR3dEbkktdW12SUVfRXIwVGZiU3pfT3liVTZqVHFJbzh3X1dXNWZ0aUpWWnJPU1QxMVBRLnI5RlBRVHJrMlVwb1VDUlIuX19yVDl3bEJaSzNGNFoyT01NXzRYUXdJcEY5M040aFlQaVpULVFYTVQtbDc4b1ZQWGRfZXhieUIxaF9wd1JfWHp2blMwU1FLN3ZPWWdCRlp6WUlFQi1lRkZvVGNpTU1oODNiZVRWOEQwZkNZMm40bDE1TF9ETWVmMnNIRU1vZ1g1Y3ZqV0NvOTJZRkxhVE84WktqOGJJZ190NW01WlVhQ3lRR1AwQkVZdm5XOUY2WWxWS3RSSTZOeUcwSGc3aHloQTNHbnZTc3Zkb1UwVWlpTUxyU3ZGbl8zNHA1a2oyS3p1TWh6b2ZZR3NJTEx0VzZJempFZTFCaW8yTF9Cb21iWjFGX0RGZjZqcnBobjMydVlMMzlCUkl4SUF0eTEtUDlZLTFnX1FiYktMLWFhOEZyY20yb05CZ2FFa2NDTnliN1R0RzJKT0s4eko1bElWcUtYRU00MG1PTDl0T0ZWSHZJZThYWXA4cVkycmVVbVN4WEMxUjlsWmJkSkRRT0wzWnIzR0JMcFAtakRJOEpROXh3Q2pqSVJndUJ4cGIwNWowZE5JREVITjBJN0V4Z1hBT1p5YlRMVTBORVFvd211YkZkSWUwWTQxeEhnbjA5MDM3MmxPMkZFMThfZVNnWVlBUFFaUUtLYkt3cjloOElWOGJCV3hZYWVWanlTRDktSmlWaHpEYlg1N1FZQzQxTWNodkV3RTY0eldfT0Z0Q0wzY2hGNEhkZWlOYVBlMWdFN2l1YnNCczhfeEJzXzNIMXYySnY1c0lhVVhBendsQVBoYmdGZVNlVGRndXBZRnpQRGF0bUZVZGVZRFlZQUg2eHZnTW44LVVlamxmQjNiaEV1YkgwY2dYR01fVmJ6TEJ4NW9NNG5zLWp3bHU4Q1B2X1ZDZDBOanlGeDBFQ3I5cWJrUUJvYzlDM1lkQU4wdDB1QzF4WjhSZGh1N3VranBybVowcVI3aXMwRjhlUDJudC1McE9Xb0JDbExPZHJvNUFZRGV5ZVJlZ0lNUkdLVTRTOTNOMGVZSWFZTkthdDhKU3RUWGY0amxDREVrMXh2cDlCQUgtOHk1amNVSmtKN01yQWt5NnVmY19qT2tBdGNrQlE2Yzl4X2ZXVzVxQV9uRDFkS1hXdkpJcUIwQWNkR0g1eWJfS0JMU29hdG1ETDZMT2p5aHpvRk9qX3hNaG5HSVptaTd2c3pkZ0R6MWRwVUZILW0zbFdoYWF4UUJUbjFpNnNEbHNWQnpaUXdBZmdaYXRfbWpyRGNBbDBMaXBianpEOXZLaC1GNmN3ZnZfdmdBYXgxTmtqZkNycEJucVZjdF9JcHhrTVQtSmFjektCWUt5OWtDR0tXSkxyOHNybUJscVVTZWtVMlhyQ0hUT05xQmZLeEpSX3NWWmtoUHBFaHhZWVZWNDhHZk9ack53MXl1aG51M01rZ05BNlRyc3pDOHNkT3Jzc0wxdkIySGJmV1gwZ3g2cUw1bkdPejl6aFRreGxUVVg0OXdhSEFzbEdJcXIyVmJNUTFTcjZZOHJ1aGhJMXViME90aF9yVlpTV09MZ0hUVlpHMGRLUnpkNVlla3BhSU5iMlVYYWpGbUhiZFpBVmxiSTJQTTRkUGFnaVdKX1piRjY0SzNFeUxDUXExdzhjajRQa1E5MXQ5eHEwYnhCbFBYajItaEx4bXMwdUVfV29JWlA2MUYxLXl2dk5VTXEtNWVsRnNfcS0zXzQ5bTNsdzhiWTZwazRRanZ6QzRVbzZpUWtzbXlzSUlfWmFneVM4Lmt1WExqTFI5XzhGNGpONTBDS0M0ZkEiLCJleHBpcmVzX2luIjozNjAwLCJ0b2tlbl90eXBlIjoiQmVhcmVyIn0sImNvdW50cnlDb2RlIjoiKzkxIiwiZXhwaXJ5RGF0ZSI6MTU5ODkwODA2MTAyOSwicm9sZUlkIjoiOGY0NWY0NDItNjg1YS00YjhiLTg2ZTctYjkzZTY5ZDgwOTZkIiwic2Vzc2lvbkRhdGUiOjE1OTU3MDU5NzQwMTMsInNlc3Npb25Sb2xlcyI6IjhmNDVmNDQyLTY4NWEtNGI4Yi04NmU3LWI5M2U2OWQ4MDk2ZCIsInNvdXJjZUluZm8iOnsic3ViU291cmNlSWQiOiIyNGUxNWJlMy05Njk1LTQ0ZjctODIyOS0zNGZmNGVmODEzOTYiLCJlbnRpdHlJZCI6IjkyYmRjN2IxLWQ1MDAtNDkwMS1iZmU4LThlMTlhMDlmZmFkNCIsInJvbGVJZCI6IjhmNDVmNDQyLTY4NWEtNGI4Yi04NmU3LWI5M2U2OWQ4MDk2ZCIsImlzRGV2aWNlIjpmYWxzZSwiZGV2aWNlSWQiOiIifSwic3ViamVjdCI6ImFkb25pYWphZ2FuQGdtYWlsLmNvbSIsInVzZXJJZCI6ImFjOWQxMTRkLThlMDEtNGMwOS04ZDc0LTg4Yjk5MGRlZDRjMyIsInBob25lTnVtYmVyIjoiOTE3NjExNzgyMiJ9LCJpYXQiOjE1OTU3MDU5NzV9.JrIzllRP3NCWPwQB6qX37XGs68BWF0BKjLiqfDylB_8";
    var responseJson;
    var response;
    try {
      response = await http.get(
          "https://dev.healthbook.vsolgmi.com/asgard" + url,
          headers: header);

      responseJson = _returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }
}

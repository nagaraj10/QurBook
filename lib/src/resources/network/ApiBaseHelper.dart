import 'dart:convert' as convert;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

import 'AppException.dart';

class ApiBaseHelper {
  final String _baseUrl = Constants.BASEURL_V2;
  final String _baseUrlV2 = Constants.BASEURL_V2;

  String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

  Future<dynamic> signIn(String url, String jsonData) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData, headers: variable.requestHeadersWithoutToken);
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
          body: otpVerifyData, headers: variable.requestHeadersWithoutToken);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> verifyAddFamilyOTP(String url, String otpVerifyData) async {
    var responseJson;

    try {
      final response = await http.post(_baseUrl + url,
          body: otpVerifyData, headers: variable.requestHeadersAuthContent);
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
          body: healthRecordData, headers: variable.requestHeadersAuthContent);
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
          body: bookmarkData, headers: variable.requestHeadersAuthContent);
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
          body: '', headers: variable.requestHeadersAuthContent);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateTeleHealthProviders(String url, String query) async {
    Dio dio = new Dio();
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
          body: jsonData, headers: variable.requestHeaders);
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
          headers: variable.requestHeadersAuthAccept);
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
          headers: variable.requestHeadersAuthContent);
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
        final response = await http.get(baseURL + url, headers: variable.auth);
        responseJson = _returnResponse(response);
      } else {
        final response = await http.get(_baseUrl + url,
            headers: variable.requestHeadersAuthAccept);
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
          headers: variable.requestHeadersAuthAccept);
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
          headers: variable.requestHeadersAuthStar);
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
          headers: variable.requestHeadersAuthAccept);

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
          headers: variable.requestHeadersAuthAccept);
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
          headers: variable.requestHeadersAuthAccept);

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
          headers: variable.requestHeadersAuthAccept);
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
          headers: variable.requestHeadersAuthAccept);
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
          body: jsonBody, headers: variable.requestHeaders);

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
        parameters.strfile: await MultipartFile.fromFile(file.path, filename: fileNoun)
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
          body: jsonData, headers: variable.requestHeaders);
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
          body: jsonData, headers: variable.requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> updateFamilyUserProfile(String url,String query) async {
    Dio dio = new Dio();
    var responseJson;

    dio.options.headers[variable.strContentType] = variable.strcntVal;
    dio.options.headers[variable.strAuthorization] = authToken;

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
          body: jsonData, headers: variable.requestHeadersAuthContent);
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
      final response = await http.get(_baseUrl + url, headers: variable.requestHeadersAuthStar);
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
          body: jsonBody, headers: variable.requestHeaders);

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
          body: jsonBody, headers: variable.requestHeaders);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }

    return responseJson;
  }

  Future<List<dynamic>> getDocumentImageList(
      String url, List<MediaMasterIds> metaMasterIdList) async {
    var imagesList = new List<dynamic>();
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    for (int i = 0; i < metaMasterIdList.length; i++) {
     

      var responseJson;
      try {
        final response = await http.get(_baseUrl + url + metaMasterIdList[i].id,
            headers: variable.requestHeadersAuthAccept);
        responseJson = _returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      imagesList.add(responseJson);
    }

    return imagesList;
  }

  Future<dynamic> signoutPage(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

   

    var responseJson;
    var response;
    try {
      response = await http.put(_baseUrl + url, headers: variable.requestHeadersAuthAccept);

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
      final response =
          await http.get(_baseUrl + url + param, headers: variable.requestHeadersAuthAccept);

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
        parameters.strfile: await MultipartFile.fromFile(file.path, filename: fileNoun)
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
      final response = await http.post(_baseUrl + url, headers: variable.requestHeadersAuthAccept);

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
          body: otpVerifyData, headers: variable.requestHeadersAuthContent);
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
      final response =
          await http.get(_baseUrl + url + param, headers: variable.requestHeadersAuthAccept);

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
      final response =
          await http.get(_baseUrl + url + param, headers: variable.requestHeadersAuthAccept);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  Future<dynamic> getTelehealthDoctorsList(String url) async {
   
    var responseJson;
    try {
      final response =
          await http.get(_baseUrlV2 + url, headers: variable.requestHeadersAuthAccept);
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
          headers: variable.requestHeaders, body: jsonBody);
      
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
          headers: variable.requestHeadersTimeSlot, body: jsonBody);
      
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
          headers: variable.requestHeadersTimeSlot, body: jsonBody);
      print(variable.requestHeadersTimeSlot.toString());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

}

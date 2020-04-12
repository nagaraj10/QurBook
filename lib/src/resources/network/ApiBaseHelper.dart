import 'dart:convert' as convert;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';

import 'AppException.dart';

class ApiBaseHelper {
  final String _baseUrl = Constants.BASERURL;

  String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

  Future<dynamic> signIn(String url, String jsonData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> verifyOTP(String url, String otpVerifyData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
    };

    var responseJson;

    print('url' + url);
    print('otpVerifyData' + otpVerifyData);
    try {
      final response = await http.post(_baseUrl + url,
          body: otpVerifyData, headers: requestHeaders);
      responseJson = _returnResponse(response);
      print('responseJson' + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> verifyAddFamilyOTP(String url, String otpVerifyData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;

    print('url' + url);
    print('AddFamilyOtpVerifyData' + otpVerifyData);
    try {
      final response = await http.post(_baseUrl + url,
          body: otpVerifyData, headers: requestHeaders);
      responseJson = _returnResponse(response);
      print('responseJson' + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> deleteHealthRecord(
      String url, String healthRecordData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;

    print('url' + _baseUrl + url);
    print('healthRecordData' + healthRecordData);
    try {
      final response = await http.post(_baseUrl + url,
          body: healthRecordData, headers: requestHeaders);
      responseJson = _returnResponse(response);
      print('responseJson' + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> bookmarkRecord(String url, String bookmarkData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;

    print('url' + _baseUrl + url);
    print('bookmarkData' + bookmarkData);
    try {
      final response = await http.post(_baseUrl + url,
          body: bookmarkData, headers: requestHeaders);
      responseJson = _returnResponse(response);
      print('responseJson' + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> updateProviders(String url) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response =
          await http.put(_baseUrl + url, body: '', headers: requestHeaders);
      responseJson = _returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> addProviders(String url, String jsonData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getMedicalPreferencesList(String url) async {
    print('authToken : ${authToken}');

    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
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
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  /**
   * The below method helps to get health record list from server for a particular userID using the get method,
   * it contains one parameter which describ ethe URL  type 
   * Created by Parvathi M on 7th Jan 2020
   */

  Future<dynamic> getHealthRecordList(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getMediaTypes(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getDoctorProfilePic(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': '*/*',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getHospitalListFromSearch(String url, String param) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;

    print(_baseUrl + url);
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);

      print('response' + response.toString());
      responseJson = _returnResponse(response);

      print('responseJson' + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getDocumentImage(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      print(_baseUrl + url);
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getDoctorsListFromSearch(String url, String param) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response =
          await http.get(_baseUrl + url + param, headers: requestHeaders);

      print('response' + response.toString());
      responseJson = _returnResponse(response);

      print('responseJson' + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getFamilyMembersList(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getProfileInfo(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        /* var responseJson = convert.jsonDecode(response.body.toString());
        print(responseJson);
        return responseJson; */

        print(response.headers['content-type']);

        var responseJson;
        if (response.headers['content-type'] == 'image/jpg' ||
            response.headers['content-type'] == 'image/png' ||
            response.headers['content-type'] == 'image/*' ||
            response.headers['content-type'] == 'audio/mp3') {
          /* String base64 = convert.base64Encode(response.bodyBytes);
          responseJson = convert.base64Decode(base64);*/

          print(response.headers['content-type']);
          print(response.bodyBytes);

          responseJson = response.bodyBytes;
        } else {
          responseJson = convert.jsonDecode(response.body.toString());
          print(responseJson);
        }
        return responseJson;

      case 201:
        var responseJson = convert.jsonDecode(response.body.toString());
        return responseJson;

      case 400:
        var responseJson = convert.jsonDecode(response.body.toString());
        return responseJson;
      case 401:
        var responseJson = convert.jsonDecode(response.body.toString());

        if (responseJson['message'] == Constants.STR_OTPMISMATCHED) {
          print(responseJson['message']);
          //Get.snackbar('Message', responseJson['message']);
          return responseJson;
        } else {
          PreferenceUtil.clearAllData().then((value) {
            Get.offAll(SignInScreen());
            Get.snackbar('Message', 'Logged into other Device');
          });
        }

        //PageNavigator.goToPermanent(context, '/dashboard_screen');
        break;

      case 403:
        PreferenceUtil.clearAllData().then((value) {
          Get.offAll(SignInScreen());
          Get.snackbar('Message', 'Logged into other Device');
        });
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> saveMediaData(String url, String jsonBody) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken,
    };

    print(_baseUrl + url);
    var responseJson;
    var response;
    try {
      response = await http.post(_baseUrl + url,
          body: jsonBody, headers: requestHeaders);

      responseJson = _returnResponse(response);

      print(_returnResponse(response));
      // responseJson = response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> saveImageToServerClone(String url, File file, String filePath,
      String metaID, String jsonBody) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Dio dio = new Dio();

    dio.options.headers['accept'] = 'application/json';
    dio.options.headers['content-Type'] = 'multipart/form-data';

    dio.options.headers["authorization"] = authToken;
    String fileNoun = file.path.split('/').last;

    FormData formData = new FormData.fromMap({
      "mediaMetaId": metaID,
      "file": await MultipartFile.fromFile(file.path, filename: fileNoun)
    });
    var response = await dio.post(_baseUrl + url, data: formData);

    print('content' + response.toString());

    return response.data;
  }

  Future<dynamic> signUpPage(
      String url, Map<String, dynamic> mapForSignUp) async {
    Dio dio = new Dio();

    dio.options.headers['accept'] = 'application/json';
    dio.options.headers['content-Type'] = 'multipart/form-data';
    FormData formData = new FormData.fromMap(mapForSignUp);
    var response = await dio.post(_baseUrl + url, data: formData);

    print('content' + response.toString());

    return response.data;
  }

  Future<dynamic> addUserLinking(String url, String jsonData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN),
    };

    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> addUserDeLinking(String url, String jsonData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN),
    };

    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> updateFamilyUserProfile(String url) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response =
          await http.put(_baseUrl + url, body: '', headers: requestHeaders);
      responseJson = _returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> updateRelationShipUserInFamilyLinking(
      String url, String jsonData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.put(_baseUrl + url,
          body: jsonData, headers: requestHeaders);
      responseJson = _returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getCustomRoles(String url) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': '*/*',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> saveImageToServerClone1(
      String url, File file, String jsonBody) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Dio dio = new Dio();

    dio.options.headers['accept'] = 'application/json';
    dio.options.headers['content-Type'] = 'multipart/form-data';

    dio.options.headers["authorization"] = authToken;
    String fileNoun = file.path.split('/').last;

    FormData formData = new FormData.fromMap({
      "profilePic": await MultipartFile.fromFile(file.path, filename: fileNoun)
    });
    var response = await dio.put(_baseUrl + url, data: formData);

    print('content' + response.toString());

    return response.data;
  }

  Future<dynamic> moveMetaDataToOtherUser(String url, String jsonBody) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken,
    };

    print(_baseUrl + url);
    var responseJson;
    var response;
    try {
      response = await http.post(_baseUrl + url,
          body: jsonBody, headers: requestHeaders);

      responseJson = _returnResponse(response);

      print(_returnResponse(response));
      // responseJson = response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> updateMediaData(String url, String jsonBody) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken,
    };

    print(_baseUrl + url);
    var responseJson;
    var response;
    try {
      response = await http.put(_baseUrl + url,
          body: jsonBody, headers: requestHeaders);

      responseJson = _returnResponse(response);

      print(_returnResponse(response));
      // responseJson = response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<List<dynamic>> getDocumentImageList(
      String url, List<MediaMasterIds> metaMasterIdList) async {
    var imagesList = new List<dynamic>();
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    for (int i = 0; i < metaMasterIdList.length; i++) {
      Map<String, String> requestHeaders = {
        'accept': 'application/json',
        'Authorization': authToken,
      };

      var responseJson;
      try {
        print(_baseUrl + url);
        final response = await http.get(_baseUrl + url + metaMasterIdList[i].id,
            headers: requestHeaders);
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

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': authToken,
    };

    print(_baseUrl + url);
    var responseJson;
    var response;
    try {
      response = await http.put(_baseUrl + url, headers: requestHeaders);

      responseJson = _returnResponse(response);

      print(_returnResponse(response));
      // responseJson = response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getSearchMediaFromServer(String url, String param) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': authToken,
    };

    var responseJson;
    try {
      final response =
          await http.get(_baseUrl + url + param, headers: requestHeaders);

      print('response' + response.toString());
      responseJson = _returnResponse(response);

      print('responseJson' + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> saveImageAndGetDeviceInfo(String url, File file,
      String filePath, String metaID, String jsonBody) async {
    String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    Dio dio = new Dio();

    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = authToken;
    String fileNoun = file.path.split('/').last;

    FormData formData = new FormData.fromMap({
      "mediaMetaInfo": metaID,
      "file": await MultipartFile.fromFile(file.path, filename: fileNoun)
    });
    var response = await dio.post(_baseUrl + url, data: formData);

    print('content' + response.toString());

    return response.data;
  }
}

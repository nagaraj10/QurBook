import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/resources/network/AppException.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HubApiProvider {
  final String _baseUrl = BASE_URL;

  Future<dynamic> getHubList() async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID_MAIN);
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.get(
        '${CommonUtil.BASE_URL_QURHUB}user-hub/$userId',
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

  Future<dynamic> saveDevice(String hubId, String deviceId, String nickName,
      String userId, String deviceType) async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    // var userId = PreferenceUtil.getStringValue(KEY_USERID_MAIN);
    var data = {
      DEVICE_ID: deviceId,
      DEVICE_TYPE: deviceType,
      USER_HUB_ID: hubId,
      USER_ID: userId,
      DEVICE_NAME: nickName,
      ADDITION_DETAILS: {}
    };

    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.post(
        '${CommonUtil.BASE_URL_QURHUB}user-device',
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

  Future<dynamic> unPairHub(String hubId) async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID_MAIN);
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

  Future<dynamic> unPairDevice(String deviceId) async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID_MAIN);

    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.delete(
        '${CommonUtil.BASE_URL_QURHUB}user-device/' + deviceId,
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

  Future<dynamic> callHubIdConfig(String hubId, String nickName) async {
    http.Response responseJson;
    await PreferenceUtil.init();
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      var data = {
        SERIAL_NUMBER: hubId,
        NICK_NAME: nickName,
        ADDITION_DETAILS: {},
      };
      responseJson = await ApiServices.post(
        '${CommonUtil.BASE_URL_QURHUB}user-hub',
        headers: header,
        body: json.encode(data),
        timeOutSeconds: 50,
      );

      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return responseJson;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> callCreateVirtualHub() async {
    http.Response responseJson;
    await PreferenceUtil.init();
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      var data = {
        ISVIRTUALHUB: true,
      };
      responseJson = await ApiServices.post(
        '${CommonUtil.BASE_URL_QURHUB}user-hub',
        headers: header,
        body: json.encode(data),
        timeOutSeconds: 50,
      );

      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return responseJson;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e) {
      return null;
    }
  }
}

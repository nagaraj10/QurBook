import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:myfhb/QurHub/Controller/add_network_controller.dart';
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
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
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

  Future<dynamic> saveDevice(
      String hubId, String deviceId, String nickName,String userId) async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    // var userId = PreferenceUtil.getStringValue(KEY_USERID);
    var data = {
      "deviceId": deviceId,
      "userHubId": hubId,
      "userId": userId,
      "additionalDetails": {}
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

  Future<dynamic> unPairDevice(String deviceId) async {
    http.Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);

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

  Future<dynamic> callConnectWifi(String wifiName, String password) async {
    try {
      final AddNetworkController addNetworkController = Get.find();
      http.Response responseJson;

      responseJson = await ApiServices.post(
        "http://${addNetworkController.strIpAddress.value}/save?J=1&A=$wifiName&K=$password&Action=Save",
        timeOutSeconds: 50,
      );

      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return responseJson;
      }
    } catch (e) {}
  }

  Future<dynamic> callHubId() async {
    try {
      http.Response responseJson;
      if (Platform.isIOS) {
        responseJson = await ApiServices.get(
          GET_HUB_ID,
        );
      } else {
        final AddNetworkController addNetworkController = Get.find();
        var headers = {"accept-content": "application/json"};
        responseJson = await ApiServices.get(
          "http://${addNetworkController.strIpAddress.value}/gethubid",
          headers: headers,
        );
      }
      return responseJson;
    } catch (e) {
      print(e.toString());
      return "";
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
}

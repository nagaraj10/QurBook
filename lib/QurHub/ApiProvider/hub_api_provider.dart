import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/resources/network/AppException.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:http/http.dart';

class HubApiProvider {
  final String _baseUrl = BASE_URL;

  Future<dynamic> getHubList() async {
    Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.get(
        'https://dwtg3mk9sjz8epmqfo.vsolgmi.com/qur-hub/user-hub/$userId',
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
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> saveDevice(String deviceId) async {
    Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    var data = {
      "deviceId": "34f51378-4316-48a6-adea-fc519c619a5b",
      "userHubId": deviceId,
      "userId": userId,
      "additionalDetails": {}
    };
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.post(
        'https://dwtg3mk9sjz8epmqfo.vsolgmi.com/qur-hub/user-device',
        headers: header,
        body: data,
      );
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return null;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> unPairHub(String hubId) async {
    Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    var data = {"userHubId": hubId};
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.post(
        'https://dwtg3mk9sjz8epmqfo.vsolgmi.com/qur-hub/user-hub/unpair-hub',
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
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> unPairDevice(String deviceId) async {
    Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);

    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = await ApiServices.delete(
        'https://dwtg3mk9sjz8epmqfo.vsolgmi.com/qur-hub/user-device/' +
            deviceId,
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
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> callConnectWifi(String wifiName, String password) async {
    try {
      Response responseJson;
      var headers = {"accept-content": "application/json"};

      print("Header $headers");

      var body = {
        "": "",
        /*"A": "${wifiName.toString().trim()}",
        "K": "${password.toString().trim()}",
        "Action": "Save",
        "J": "1",*/
      };

      print("body $body");

      responseJson = await ApiServices.post(
        "http://192.168.99.79/save?J=1&A=$wifiName&K=$password&Action=Save",
        /*headers: headers,
        body: jsonEncode(body),*/
        timeOutSeconds: 50,
      );

      /*return responseJson;*/

      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> callHubId() async {
    try {
      Response responseJson;
      var headers = {"accept-content": "application/json"};

      print("Header $headers");

      responseJson = await ApiServices.get(
        "http://192.168.99.79/gethubid",
        headers: headers,
      );

      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return responseJson;
      }

      /*return responseJson;*/
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> callHubIdConfig(String hubId, String nickName) async {
    Response responseJson;
    final url = qr_hub + '/';
    await PreferenceUtil.init();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      var body = {
        "serialNumber": "${hubId.trim()}",
        "niceName": "${nickName.trim()}",
        "additionalDetails": "",
      };
      responseJson = await ApiServices.post(
        'https://dwtg3mk9sjz8epmqfo.vsolgmi.com/qur-hub/user-hub',
        headers: header,
        body: jsonEncode(body),
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
      print("callHubIdConfig ${e.toString()}");
      return null;
    }
  }
}

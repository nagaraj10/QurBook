import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
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
        'https://dwtg3mk9sjz8epmqfo.vsolgmi.com/qur-hub/user-hub/a21962d9-a07b-47c3-a3ba-523897cfe8c1',
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
    var data={
      "deviceId" : "34f51378-4316-48a6-adea-fc519c619a5b",
      "userHubId":deviceId,
      "userId":userId,
      "additionalDetails":{}
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
    var data={
      "userHubId" : hubId
    };
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
    var data={
      "userHubId" : deviceId
    };
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


}

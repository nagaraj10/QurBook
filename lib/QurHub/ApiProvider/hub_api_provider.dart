import 'dart:convert';
import 'dart:io';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/HeaderRequest.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/variable_constant.dart';
import '../../src/resources/network/AppException.dart';
import '../../src/resources/network/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HubApiProvider {
  final String _baseUrl = BASE_URL;

  Future<dynamic> getHubList() async {
    try {
      final userId = PreferenceUtil.getStringValue(KEY_USERID_MAIN);
      final header = await HeaderRequest().getRequestHeadersWithoutOffset();
      final responseJson = await ApiServices.get(
        '${CommonUtil.BASE_URL_QURHUB}user-hub/$userId',
        headers: header,
      );
      printInfo(info: responseJson!.body);
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return null;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      return null;
    }
  }

  Future<dynamic> saveNewDevice(Map data) async {
    try {
      final header = await HeaderRequest().getRequestHeadersWithoutOffset();
      final body = json.encode(data);
      printInfo(info: body);
      final responseJson = await ApiServices.post(
        '${CommonUtil.BASE_URL_QURHUB}user-device',
        headers: header,
        body: body,
      );
      if (responseJson!.statusCode == 200) {
        return responseJson;
      }
      return null;
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      return null;
    }
  }

  Future<dynamic> saveDevice(
    String hubId,
    String deviceId,
    String nickName,
    String userId,
    String deviceType,
    String source,
  ) async {
    http.Response responseJson;
    final data = {
      DEVICE_ID: deviceId,
      DEVICE_TYPE: deviceType,
      //USER_HUB_ID: hubId,
      USER_ID: userId,
      DEVICE_NAME: nickName,
      ADDITION_DETAILS: {},
      DEVICE_SOURCE: source,
    };
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      final body = json.encode(data);
      printInfo(info: body);
      responseJson = (await ApiServices.post(
        '${CommonUtil.BASE_URL_QURHUB}user-device',
        headers: header,
        body: body,
      ))!;
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return null;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      return null;
    }
  }

  // Future<dynamic> unPairHub(String hubId) async {
  //   http.Response responseJson;
  //   try {
  //     final userId = PreferenceUtil.getStringValue(KEY_USERID_MAIN);
  //     final data = {"userHubId": hubId};
  //     final header = await HeaderRequest().getRequestHeadersWithoutOffset();
  //     responseJson = await ApiServices.post(
  //       '${CommonUtil.BASE_URL_QURHUB}user-hub/unpair-hub',
  //       headers: header,
  //       body: json.encode(data),
  //     );
  //     if (responseJson.statusCode == 200) {
  //       return responseJson;
  //     } else {
  //       return null;
  //     }
  //   } on SocketException {
  //     throw FetchDataException(strNoInternet);
  //   } catch (e,stackTrace) {
  //     return null;
  //   }
  // }

  Future<dynamic> unPairDevice(String deviceId) async {
    http.Response responseJson;
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      responseJson = (await ApiServices.delete(
        '${CommonUtil.BASE_URL_QURHUB}user-device/' + deviceId,
        headers: header,
      ))!;
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return null;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      return null;
    }
  }

  Future<dynamic> callCreateVirtualHub() async {
    try {
      final header = await HeaderRequest().getRequestHeadersWithoutOffset();
      final data = {
        ISVIRTUALHUB: true,
      };
      final responseJson = await ApiServices.post(
        '${CommonUtil.BASE_URL_QURHUB}user-hub',
        headers: header,
        body: json.encode(data),
        timeOutSeconds: 50,
      );
      if (responseJson!.statusCode == 200) {
        return responseJson;
      } else {
        return responseJson;
      }
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      return null;
    }
  }
}

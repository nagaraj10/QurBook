import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../common/CommonUtil.dart';
import '../../../constants/HeaderRequest.dart';
import '../../../constants/fhb_query.dart';
import '../../../constants/variable_constant.dart';
import '../../../src/resources/network/AppException.dart';
import '../../../src/resources/network/api_services.dart';
import '../../BpScan/model/QurHomeBpScanResult.dart';
import '../Models/ble_data_model.dart';

class BleConnectApiProvider {
  Future<dynamic> saveDevice(
    String hubId,
    String deviceId,
    String nickName,
    String userId,
  ) async {
    http.Response responseJson;
    final data = {
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
    try {
      final data = {"userHubId": hubId};
      final header = await HeaderRequest().getRequestHeadersWithoutOffset();
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
    try {
      final header = await HeaderRequest().getRequestHeadersWithoutOffset();
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

  Future<bool> uploadBleDataReadings(BleDataModel bleDataModel) async {
    http.Response responseJson;
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlotWithUserId();
      var body = json.encode(bleDataModel);
      responseJson = await ApiServices.post(
        CommonUtil.BASE_URL_QURHUB + qr_BLEDataUpload,
        headers: header,
        body: body,
      );
      if (responseJson.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e) {
      printError(info: e.toString());
    }
    return false;
  }

  Future<bool> uploadBleBPDataReadings(
      {String ackLocal,
      String hubId,
      String eId,
      String uId,
      QurHomeBpScanResult qurHomeBpScanResult}) async {
    http.Response responseJson;
    try {
      var header = await HeaderRequest().getRequestHeadersTimeSlotWithUserId();
      var body = json.encode(
            {
              "Status": "Measurement",
              "hubId": hubId,
              "deviceId": qurHomeBpScanResult.deviceAddress,
              "deviceType": "BP",
              "eid": eId,
              "uid": uId,
              "ackLocal": ackLocal,
              "Data": {
                "Systolic":
                    qurHomeBpScanResult?.measurementRecords[0].systolicKey,
                "Diastolic":
                    qurHomeBpScanResult?.measurementRecords[0].diastolicKey,
                "Pulse": qurHomeBpScanResult?.measurementRecords[0].pulseRateKey
              }
            },
          ),
          responseJson = await ApiServices.post(
            CommonUtil.BASE_URL_QURHUB + qr_BLEDataUpload,
            headers: header,
            body: body,
          );
      if (responseJson.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
      return false;
    } catch (e) {
      return false;
    }
  }
}

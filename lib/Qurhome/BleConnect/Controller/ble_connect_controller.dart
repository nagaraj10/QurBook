import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/Models/add_network_model.dart';
import 'package:myfhb/QurHub/Models/hub_list_response.dart';
import 'package:myfhb/Qurhome/BleConnect/ApiProvider/ble_connect_api_provider.dart';
import 'package:myfhb/Qurhome/BleConnect/Models/ble_data_model.dart';
import 'package:myfhb/feedback/Model/FeedbackCategoriesTypeModel.dart';
import 'package:myfhb/feedback/Model/FeedbackTypeModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BleConnectController extends GetxController {
  final _apiProvider = BleConnectApiProvider();
  var loadingData = false.obs;
  FeedbackTypeModel feedbackType;
  HubListResponse hubListResponse;
  FeedbackCategoryModel selectedType;
  BleDataModel bleDataModel;
  var isBleScanning = false.obs;
  var strBleData = "".obs;
  var errorMessage = "".obs;
  var strProgressMessage = "".obs;
  FlutterToast toast = FlutterToast();

  getBleConnectData(BuildContext context) async {
    try {
      strProgressMessage.value =
          "Scanning the bluetooth device and get the readings";
      errorMessage.value = "";
      loadingData.value = true;
      isBleScanning.value = true;
      strBleData.value = "";
      const platform = MethodChannel('bleConnect');
      try {
        var result = await platform.invokeMethod('bleconnect');
        printInfo(info: "Result from $result");
        isBleScanning.value = false;
        if (result != null &&
            validString(result.toString().toLowerCase())
                .contains("measurement")) {
          loadingData.value = false;
          bleDataModel = BleDataModel.fromJson(jsonDecode(result));
          strBleData.value += "Status ${validString(bleDataModel.status.toString())}\n" +
              "HubId ${validString(bleDataModel.hubId.toString())}\n" +
              "DeviceId ${validString(bleDataModel.deviceId.toString())}\n" +
              "DeviceType ${validString(bleDataModel.deviceType.toString())}\n" +
              "SPO2 Value${validString(bleDataModel.data.sPO2.toString())}\n" +
              "Pulse Value ${validString(bleDataModel.data.pulse.toString())}\n";
          print("BLE RESULT ${bleDataModel}");
          uploadBleData(context);
        } else if (result != null &&
            validString(result.toString().toLowerCase())
                .contains("connected")) {
          toast.getToast(validString(result.toString()), Colors.green);
        } else {
          loadingData.value = false;
          errorMessage.value =
              "Please turn on your bluetooth device and re-try again";
        }
      } on PlatformException catch (e) {}
    } catch (e) {
      loadingData.value = false;
      errorMessage.value = "${e.toString()}";
    }
  }

  String validString(String strText) {
    try {
      if (strText == null)
        return "";
      else if (strText.trim().isEmpty)
        return "";
      else
        return strText.trim();
    } catch (e) {}
    return "";
  }


  uploadBleData(BuildContext context) async {
    try {
      strProgressMessage.value = "uploading the ble data readings...";
      errorMessage.value = "";
      loadingData.value = true;
      http.Response response =
          await _apiProvider.uploadBleDataReadings(bleDataModel);
      if (response.statusCode == 200) {
        loadingData.value = false;
        print("uploadBleData response ${json.decode(response.body)}");
        BleDataResponseModel bleDataResponseModel =
            BleDataResponseModel.fromJson(json.decode(response.body));
        if (bleDataResponseModel.isSuccess) {
          toast.getToast(
              validString("SPO2 value updated successfully"), Colors.green);
        } else {
          toast.getToast(validString(response.body), Colors.red);
        }
      } else {
        loadingData.value = false;
        toast.getToast(validString(response.body), Colors.red);
      }
    } catch (e) {
      loadingData.value = false;
      toast.getToast(validString(e.toString()), Colors.red);
    }
  }
}

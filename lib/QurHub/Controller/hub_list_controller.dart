import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:http/http.dart' as http;

import '../../Qurhome/BleConnect/Controller/ble_connect_controller.dart';
import '../../constants/fhb_constants.dart';
import '../../feedback/Model/FeedbackCategoriesTypeModel.dart';
import '../../feedback/Model/FeedbackTypeModel.dart';
import '../../feedback/Provider/FeedbackApiProvider.dart';
import '../ApiProvider/hub_api_provider.dart';
import '../Models/add_network_model.dart';
import '../Models/hub_list_response.dart';
import '../View/add_device_screen.dart';
import '../View/hub_list_screen.dart';

class HubListController extends GetxController {
  final _apiProvider = HubApiProvider();
  var loadingData = false.obs;
  var searchingBleDevice = false.obs;
  FeedbackTypeModel feedbackType;
  HubListResponse hubListResponse;
  FeedbackCategoryModel selectedType;
  var catSelected = false.obs;
  var isFromQurHomeinQurBook = false.obs;
  FlutterToast toast = FlutterToast();
  static const stream = EventChannel('QurbookBLE/stream');
  StreamSubscription _timerSubscription;
  var foundBLE = false.obs;
  var bleMacId = "".obs;
  var bleDeviceType = "".obs;
  var hubId = "".obs;
  var virtualHubId = "";

  getHubList() async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.getHubList();
      if (response == null) {
        // failed to get the data, we are showing the error on UI
      } else {
        hubListResponse = HubListResponse.fromJson(json.decode(response.body));
        virtualHubId = hubListResponse.result.hub.serialNumber;
      }
      loadingData.value = false;
      update(["newUpdate"]);
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

  unPairHub(String hubId) async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.unPairHub(hubId);
      if (response == null) {
        FlutterToast().getToast('Oops Something went wrong', Colors.red);
      } else {
        getHubList();
      }
      loadingData.value = false;
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

  unPairDevice(String deviceId) async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.unPairDevice(deviceId);
      if (response == null) {
        FlutterToast().getToast('Oops Something went wrong', Colors.red);
      } else {
        getHubList();
      }
      loadingData.value = false;
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

  setRecordType(FeedbackCategoryModel selected) {
    catSelected.value = false;
    selectedType = selected;
    catSelected.value = true;
  }

  removeSelectedType() {
    selectedType = null;
    catSelected.value = false;
  }

  callCreateVirtualHub(BuildContext context) async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.callCreateVirtualHub();
      if (response.statusCode == 200) {
        loadingData.value = false;
        AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(response.body));
        if (addNetworkModel.isSuccess) {
          //toast.getToast(validString(addNetworkModel.message), Colors.green);
          getHubList();
        } else {
          toast.getToast(validString(addNetworkModel.message), Colors.red);
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

  navigateToHubListScreen(bool isFromQurHomeInQurBook) async {
    try {
      isFromQurHomeinQurBook.value = isFromQurHomeInQurBook;
      getHubList();
      Get.to(
        HubListScreen(),
      );
    } catch (e) {}
  }

  navigateToAddDeviceScreen() async {
    try {
      Navigator.push(
        Get.context,
        MaterialPageRoute(
            builder: (context) => AddDeviceScreen(hubId: hubId.value)),
      ).then((value) => {getHubList()});
    } catch (e) {}
  }

  void checkForConnectedDevices() {
    try {
      searchingBleDevice.value = true;
      _enableTimer();
      BleConnectController bleController = Get.put(BleConnectController());
      bleController.getBleConnectData(Get.context);
      Future.delayed(Duration(seconds: 12)).then((value) {
        searchingBleDevice.value = false;
        if (!foundBLE.value) {
          disableTimer();
          toast.getToast(NoDeviceFound, Colors.red);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void disableTimer() {
    try {
      if (_timerSubscription != null) {
        _timerSubscription.cancel();
        _timerSubscription = null;
      }
    } catch (e) {
      print(e);
    }
  }

  void _enableTimer() {
    try {
      bleMacId.value = "";
      _timerSubscription ??= stream.receiveBroadcastStream().listen((val) {
        print(val);
        List<String> receivedValues = val.split('|');
        if ((receivedValues ?? []).length > 0) {
          switch ((receivedValues.first ?? "")) {
            case "enablebluetooth":
              FlutterToast().getToast(
                  receivedValues.last ?? 'Request Timeout', Colors.red);
              break;
            case "permissiondenied":
              FlutterToast().getToast(
                  receivedValues.last ?? 'Request Timeout', Colors.red);
              break;
            case "scanstarted":
              FlutterToast().getToast(
                  receivedValues.last ?? 'Request Timeout', Colors.red);
              break;
            case "connectionfailed":
              FlutterToast().getToast(
                  receivedValues.last ?? 'Request Timeout', Colors.red);
              break;
            case "macid":
              bleMacId.value = validString(receivedValues.last);
              break;
            case "bleDeviceType":
              bleDeviceType.value = validString(receivedValues.last);
              foundBLE.value = true;
              disableTimer();
              searchingBleDevice.value = false;
              List<UserDeviceCollection> userDeviceCollection = [];
              if (hubListResponse.result != null &&
                  hubListResponse.result.userDeviceCollection != null &&
                  hubListResponse.result.userDeviceCollection.length > 0) {
                userDeviceCollection =
                    hubListResponse.result.userDeviceCollection;
                final index = userDeviceCollection.indexWhere((element) =>
                    validString(element.device.serialNumber) == bleMacId.value);
                if (index >= 0) {
                  toast.getToast(DeviceAlreadyMapped, Colors.red);
                } else {
                  navigateToAddDeviceScreen();
                }
              } else {
                navigateToAddDeviceScreen();
              }
              break;

            case "disconnected":
              FlutterToast().getToast(
                  receivedValues.last ?? 'Request Timeout', Colors.red);
              break;

            default:
              FlutterToast().getToast(
                  receivedValues.last ?? 'Request Timeout', Colors.red);
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }
}

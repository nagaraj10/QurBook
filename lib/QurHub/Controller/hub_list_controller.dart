import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_constants.dart';
import '../ApiProvider/hub_api_provider.dart';
import '../Models/add_network_model.dart';
import '../Models/hub_list_response.dart';
import '../View/add_device_screen.dart';
import '../View/hub_list_screen.dart';

class HubListController extends GetxController {
  final _apiProvider = HubApiProvider();
  var loadingData = false.obs;
  var searchingBleDevice = false.obs;
  HubListResponse hubListResponse;
  var isFromQurHomeinQurBook = true.obs;
  FlutterToast toast = FlutterToast();
  static const stream = EventChannel('QurbookBLE/stream');
  StreamSubscription _timerSubscription;
  var foundBLE = false.obs;
  var bleMacId = "".obs;
  var bleDeviceType = "".obs;
  var bleDeviceTypeName = "".obs;
  var hubId = "".obs;
  var virtualHubId = "";
  var eid;
  var uid;
  var searchingBleDeviceMsg = "".obs;
  // BleConnectController bleController = Get.put(BleConnectController());

  getHubList({bool isShowProgress = true}) async {
    try {
      if (isShowProgress) {
        loadingData.value = true;
      }
      http.Response response = await _apiProvider.getHubList();
      if (response == null) {
        // failed to get the data, we are showing the error on UI
      } else {
        hubListResponse = HubListResponse.fromJson(json.decode(response.body));
        if (hubListResponse.result != null &&
            hubListResponse.result.hub != null) {
          virtualHubId =
              CommonUtil().validString(hubListResponse.result.hub.serialNumber);
        }
      }
      if (isShowProgress) {
        loadingData.value = false;
        update(["newUpdate"]);
      }
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

  Future<bool> callCreateVirtualHub() async {
    try {
      //loadingData.value = true;
      http.Response response = await _apiProvider.callCreateVirtualHub();
      if (response.statusCode == 200) {
        //loadingData.value = false;
        AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(response.body));
        if (addNetworkModel.isSuccess) {
          //toast.getToast(validString(addNetworkModel.message), Colors.green);
          getHubList(isShowProgress: false);
          return true;
        } else {
          toast.getToast(
              CommonUtil().validString(addNetworkModel.message), Colors.red);
          searchingBleDevice.value = false;
          return false;
        }
      } else {
        //loadingData.value = false;
        toast.getToast(CommonUtil().validString(response.body), Colors.red);
        searchingBleDevice.value = false;
        return false;
      }
    } catch (e) {
      //loadingData.value = false;
      toast.getToast(CommonUtil().validString(e.toString()), Colors.red);
      searchingBleDevice.value = false;
      return false;
    }
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

  checkForConnectedDevices({bool isHaveVirtualHub = true}) async {
    try {
      foundBLE.value = false;
      if (Platform.isAndroid) {
        bool serviceEnabled = await CommonUtil().checkGPSIsOn();
        bool isBluetoothEnable = false;
        isBluetoothEnable = await CommonUtil().checkBluetoothIsOn();
        if (!isBluetoothEnable) {
          FlutterToast().getToast(
              'Please turn on your bluetooth and try again', Colors.red);
          return;
        } else if (!serviceEnabled) {
          FlutterToast().getToast(
              'Please turn on your GPS location services and try again',
              Colors.red);
          return;
        }
      }
      searchingBleDevice.value = true;
      if (!isHaveVirtualHub) {
        searchingBleDeviceMsg.value = SettingUpTheDevice;
        var response = await callCreateVirtualHub();
        if (response) {
          hubId.value = CommonUtil().validString(
              hubListResponse.result != null ? hubListResponse.result.id : "");
        } else {
          return;
        }
      }
      searchingBleDeviceMsg.value = ScanningForDevices;
      // _enableTimer();
      // bleController.getBleConnectData(Get.context);
      // Future.delayed(Duration(seconds: 25)).then((value) {
      //   searchingBleDevice.value = false;
      //   if (!foundBLE.value) {
      //     disableTimer();
      //     bleController.stopBleScan();
      //     toast.getToast(NoDeviceFound, Colors.red);
      //   }
      // });
    } catch (e) {
      print(e);
    }
  }

  // void disableTimer() {
  //   try {
  //     if (_timerSubscription != null) {
  //       _timerSubscription.cancel();
  //       _timerSubscription = null;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void _enableTimer() {
  //   try {
  //     bleMacId.value = "";
  //     _timerSubscription ??= stream.receiveBroadcastStream().listen((val) {
  //       print(val);
  //       List<String> receivedValues = val.split('|');
  //       if ((receivedValues ?? []).length > 0) {
  //         switch ((receivedValues.first ?? "")) {
  //           case "enablebluetooth":
  //             FlutterToast().getToast(
  //                 receivedValues.last ?? 'Request Timeout', Colors.red);
  //             break;
  //           case "permissiondenied":
  //             FlutterToast().getToast(
  //                 receivedValues.last ?? 'Request Timeout', Colors.red);
  //             break;
  //           case "scanstarted":
  //             // FlutterToast().getToast(
  //             //     receivedValues.last ?? 'Request Timeout', Colors.red);
  //             break;
  //           case "connectionfailed":
  //             FlutterToast().getToast(
  //                 receivedValues.last ?? 'Request Timeout', Colors.red);
  //             break;
  //           case "macid":
  //             bleMacId.value = CommonUtil().validString(receivedValues.last);
  //             break;
  //           case "bleDeviceType":
  //             bleDeviceType.value =
  //                 CommonUtil().validString(receivedValues.last);
  //             bleDeviceTypeName.value = getDeviceTypeName(
  //                 CommonUtil().validString(receivedValues.last));
  //             foundBLE.value = true;
  //             disableTimer();
  //             bleController.stopBleScan();
  //             searchingBleDevice.value = false;
  //             List<UserDeviceCollection> userDeviceCollection = [];
  //             if ((hubListResponse.result?.userDeviceCollection ?? []).length >
  //                 0) {
  //               userDeviceCollection =
  //                   hubListResponse.result.userDeviceCollection;
  //               final index = userDeviceCollection.indexWhere((element) =>
  //                   CommonUtil().validString(element.device.serialNumber) ==
  //                   bleMacId.value);
  //               if (index >= 0) {
  //                 toast.getToast(DeviceAlreadyMapped, Colors.red);
  //               } else {
  //                 navigateToAddDeviceScreen();
  //               }
  //             } else {
  //               navigateToAddDeviceScreen();
  //             }
  //             break;

  //           case "disconnected":
  //             // FlutterToast().getToast(
  //             //     receivedValues.last ?? 'Request Timeout', Colors.red);
  //             break;

  //           default:
  //           // FlutterToast().getToast(
  //           //     receivedValues.last ?? 'Request Timeout', Colors.red);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  String getDeviceTypeName(String deviceType) {
    try {
      switch (deviceType) {
        case 'SPO2':
          return 'Pulse Oximeter';
          break;
        case 'BP':
          return 'BP Monitor';
          break;
      }
    } catch (e) {
      return "";
    }
    return "";
  }
}

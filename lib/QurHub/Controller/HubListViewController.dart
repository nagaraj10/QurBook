import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:http/http.dart' as http;

import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../src/ui/SheelaAI/Controller/SheelaAIController.dart';
import '../../src/ui/SheelaAI/Services/SheelaAIBLEServices.dart';
import '../ApiProvider/hub_api_provider.dart';
import '../Models/add_network_model.dart';
import '../Models/hub_list_response.dart';
import '../View/AddDeviceView.dart';
import 'AddDeviceViewController.dart';

class HubListViewController extends GetxController {
  RxBool loadingData = false.obs;
  RxBool searchingBleDevice = false.obs;
  HubListResponse hubListResponse;
  final _apiProvider = HubApiProvider();
  SheelaBLEController _bleController;
  String bleMacId = "";
  String bleDeviceType = "";
  String eid;
  String uid;

  @override
  onInit() {
    super.onInit();
  }

  getHubList() async {
    if (!Get.isRegistered<SheelaAIController>()) {
      Get.lazyPut(() => SheelaAIController());
    }
    if (!Get.isRegistered<SheelaBLEController>()) {
      Get.lazyPut(() => SheelaBLEController());
    }
    _bleController = Get.find();
    try {
      loadingData.value = true;
      hubListResponse = null;
      http.Response response = await _apiProvider.getHubList();
      if (response.statusCode != 200 || (response.body ?? "").isEmpty) {
        hubListResponse = null;
        return;
      }
      hubListResponse = HubListResponse.fromJson(json.decode(response.body));
      printInfo(
          info: hubListResponse.result.userDeviceCollection.length.toString());
      loadingData.value = false;
    } catch (e) {
      hubListResponse = null;
      print(e.toString());
      loadingData.value = false;
    }
  }

  Future<bool> callCreateVirtualHub() async {
    try {
      http.Response response = await _apiProvider.callCreateVirtualHub();
      if (response.statusCode != 200 || (response.body ?? "").isEmpty) {
        FlutterToast().getToast(
          CommonUtil().validString(
            response.body,
          ),
          Colors.red,
        );
        return false;
      }
      AddNetworkModel addNetworkModel =
          AddNetworkModel.fromJson(json.decode(response.body));
      if (addNetworkModel.isSuccess) {
        return true;
      } else {
        FlutterToast().getToast(
          CommonUtil().validString(
            addNetworkModel.message,
          ),
          Colors.red,
        );
        return false;
      }
    } catch (e) {
      FlutterToast().getToast(
        CommonUtil().validString(
          e.toString(),
        ),
        Colors.red,
      );
      return false;
    }
  }

  checkForConnectedDevices() async {
    try {
      bleMacId = null;
      bleDeviceType = null;
      if (Platform.isAndroid) {
        bool serviceEnabled = await CommonUtil().checkGPSIsOn();
        if (!serviceEnabled) {
          FlutterToast().getToast(
            'Please turn on your GPS location services and try again',
            Colors.red,
          );
          return;
        }
        bool isBluetoothEnable = false;
        isBluetoothEnable = await CommonUtil().checkBluetoothIsOn();
        if (!isBluetoothEnable) {
          FlutterToast().getToast(
            'Please turn on your bluetooth and try again',
            Colors.red,
          );
          return;
        }
      }
      if (hubListResponse?.result?.hub == null) {
        loadingData.value = true;
        bool response = await callCreateVirtualHub();
        loadingData.value = false;
        if (!response) {
          return;
        }
      }
      _bleController.addingDevicesInHublist = true;
      searchingBleDevice.value = true;
      _bleController.setupListenerForReadings();
      Future.delayed(
        const Duration(
          seconds: 30,
        ),
      ).then(
        (value) {
          if (searchingBleDevice.isFalse) {
            return;
          }
          searchingBleDevice.value = false;
          if ((bleMacId ?? '').isEmpty && (bleDeviceType ?? '').isEmpty) {
            _bleController.stopScanning();
            FlutterToast().getToast(
              NoDeviceFound,
              Colors.red,
            );
          }
        },
      );
    } catch (e) {
      printError(info: e.toString());
      searchingBleDevice.value = false;
    }
  }

  unPairDevice(String deviceId) async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.unPairDevice(deviceId);
      if (response == null) {
        FlutterToast().getToast('Oops Something went wrong', Colors.red);
      }
      loadingData.value = false;
      Future.delayed(const Duration(microseconds: 10)).then((value) {
        getHubList();
      });
    } catch (e) {
      printError(info: e.toString());
      loadingData.value = false;
    }
  }

  navigateToAddDeviceScreen() {
    if (searchingBleDevice.isFalse &&
        (bleMacId ?? '').isNotEmpty &&
        (bleDeviceType ?? '').isNotEmpty) {
      if (_bleController.checkForParedDevice()) {
        FlutterToast().getToast(
          DeviceAlreadyMapped,
          Colors.red,
        );
        return;
      }
      Get.to(
        () => AddDeviceView(),
        binding: BindingsBuilder(
          () => Get.lazyPut(
            () => AddDeviceViewController(),
          ),
        ),
      ).then(
        (value) => getHubList(),
      );
    }
  }
}

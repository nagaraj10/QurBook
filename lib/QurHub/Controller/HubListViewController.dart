import 'dart:async';
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
  HubListResponse? hubListResponse;
  final _apiProvider = HubApiProvider();
  late SheelaBLEController _bleController;
  String? bleMacId = "";
  String? bleDeviceType = "";
  String? manufacturer = "";
  String? eid;
  String? uid;
  RxBool isUserHasParedDevice = false.obs;

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
      http.Response response = await (_apiProvider.getHubList());
      if (response.statusCode != 200 || (response.body).isEmpty) {
        hubListResponse = null;
        isUserHasParedDevice.value = false;
        return;
      }
      hubListResponse = HubListResponse.fromJson(json.decode(response.body));
      final devicesList = (hubListResponse?.result ?? []);
      if (devicesList.isNotEmpty) {
        isUserHasParedDevice.value = true;
      } else {
        isUserHasParedDevice.value = false;
      }
      loadingData.value = false;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      hubListResponse = null;
      isUserHasParedDevice.value = false;
      print(e.toString());
      loadingData.value = false;
    }
  }

  Future<bool> callCreateVirtualHub() async {
    try {
      http.Response response = await _apiProvider.callCreateVirtualHub();
      if (response.statusCode != 200 || (response.body).isEmpty) {
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
      if (addNetworkModel.isSuccess!) {
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
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

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
            strTurnOnGPS,
            Colors.red,
          );
          return;
        }
        bool? isBluetoothEnable = false;
        isBluetoothEnable = await (CommonUtil().checkBluetoothIsOn());
        if (!(isBluetoothEnable ?? false)) {
          FlutterToast().getToast(
            pleaseTurnOnYourBluetoothAndTryAgain,
            Colors.red,
          );
          return;
        }
      }
      _bleController.stopScanning();
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
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      printError(info: e.toString());
      searchingBleDevice.value = false;
    }
  }

  unPairDevice(String deviceId) async {
    try {
      loadingData.value = true;
      http.Response? response = (await _apiProvider.unPairDevice(deviceId));
      if (response == null) {
        FlutterToast().getToast('Oops Something went wrong', Colors.red);
      }
      loadingData.value = false;
      await Future.delayed(Duration(microseconds: 10));
      getHubList();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      printError(info: e.toString());
      loadingData.value = false;
    }
  }

  navigateToAddDeviceScreen() {
    if (searchingBleDevice.isFalse &&
        (bleMacId ?? '').isNotEmpty &&
        (bleDeviceType ?? '').isNotEmpty) {
      if (_bleController.checkForParedDevice()) {
        // FlutterToast().getToast(
        //   DeviceAlreadyMapped,
        //   Colors.red,
        // );
        return;
      }
      _bleController.stopScanning();
      Get.to(
        () => AddDeviceView(),
        binding: BindingsBuilder(
          () => Get.lazyPut(
            () => AddDeviceViewController(),
          ),
        ),
      )!
          .then(
        (value) {
          _bleController.stopScanning();
          getHubList();
          bleMacId = "";
        },
      );
    } else {
      FlutterToast().getToast('Oops Something went wrong', Colors.red);
    }
  }
}

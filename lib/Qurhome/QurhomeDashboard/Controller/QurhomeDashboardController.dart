import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/BleConnect/Controller/ble_connect_controller.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart';
import '../../../src/ui/bot/view/sheela_arguments.dart';

class QurhomeDashboardController extends GetxController {
  var currentSelectedIndex = 0.obs;
  var appBarTitle = 'Hello User'.obs;
  var isLoading = false.obs;
  static const stream = EventChannel('QurbookBLE/stream');
  StreamSubscription _timerSubscription;

  void _enableTimer() {
    _timerSubscription ??= stream.receiveBroadcastStream().listen((val) {
      print(val);
    });
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void checkForConnectedDevices() {
    BleConnectController bleController = Get.put(BleConnectController());
    _enableTimer();
    bleController.getBleConnectData(Get.context);
    //Device Connected
    // Get.toNamed(
    //   rt_Sheela,
    //   arguments: SheelaArgument(
    //     takeActiveDeviceReadings: true,
    //   ),
    // );

    // //Device Not Connected
    // Get.toNamed(
    //   rt_Sheela,
    //   arguments: SheelaArgument(
    //     sheelaInputs: requestSheelaForpo,
    //   ),
    // );
  }

  void updateTabIndex(int newIndex) {
    currentSelectedIndex.value = newIndex;
    switch (currentSelectedIndex.value) {
      case 0:
        appBarTitle = 'Hello User'.obs;
        break;
      case 1:
        appBarTitle = 'Hello User'.obs;
        break;
      case 2:
        appBarTitle = 'Vitals'.obs;
        break;
      case 3:
        appBarTitle = 'Symptoms'.obs;
        break;
    }
  }
}

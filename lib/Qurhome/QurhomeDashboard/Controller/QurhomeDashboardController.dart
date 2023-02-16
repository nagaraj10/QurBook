
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../QurHub/Controller/HubListViewController.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/router_variable.dart';
import '../../../src/model/user/MyProfileModel.dart';
import '../../../src/ui/SheelaAI/Controller/SheelaAIController.dart';
import '../../../src/ui/SheelaAI/Models/sheela_arguments.dart';
import '../../../src/ui/SheelaAI/Services/SheelaAIBLEServices.dart';

class QurhomeDashboardController extends GetxController {
  var currentSelectedIndex = 0.obs;
  var appBarTitle = ' '.obs;
  static const streamAppointment = EventChannel('ScheduleAppointment/stream');
  StreamSubscription? _appointmentSubscription;
  late HubListViewController hubController;
  late SheelaBLEController _sheelaBLEController;
  Timer? _bleTimer;

  @override
  void onInit() {
    if (!Get.isRegistered<SheelaAIController>()) {
      Get.put(SheelaAIController());
    }
    if (!Get.isRegistered<SheelaBLEController>()) {
      Get.put(SheelaBLEController());
    }
    if (!Get.isRegistered<HubListViewController>()) {
      Get.put(HubListViewController());
    }
    _sheelaBLEController = Get.find();
    getHubDetails();
    updateBLETimer();
    super.onInit();
  }

  setActiveQurhomeTo({required bool status}) {
    PreferenceUtil.saveIfQurhomeisAcive(
      qurhomeStatus: status,
    );
  }

  @override
  void onClose() {
    // _disableTimer();
    //bleController.stopBleScan();
    updateBLETimer(Enable: false);
    super.onClose();
  }

  updateBLETimer({bool Enable = true}) {
    if (Enable) {
      if (_bleTimer != null) return;
      _bleTimer = Timer.periodic(
          const Duration(
            seconds: 20,
          ), (time) {
        if (Get.find<SheelaAIController>().isSheelaScreenActive) {
          return;
        }
        _sheelaBLEController.setupListenerForReadings();
      });
    } else {
      _sheelaBLEController.stopScanning();
      _sheelaBLEController.stopTTS();
      _bleTimer!.cancel();
      _bleTimer = null;
    }
  }

  getHubDetails() async {
    hubController = Get.find<HubListViewController>();
    await hubController.getHubList();
    _sheelaBLEController.setupListenerForReadings();
  }

  void updateTabIndex(int newIndex) {
    currentSelectedIndex.value = newIndex;
    MyProfileModel myProfile;
    String fulName = '';
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE)!;
      fulName = myProfile.result != null
          ? myProfile.result!.firstName!.capitalizeFirstofEach +
              ' ' +
              myProfile.result!.lastName!.capitalizeFirstofEach
          : '';
    } catch (e) {}
    switch (currentSelectedIndex.value) {
      case 0:
        appBarTitle = '$fulName'.obs;
        updateBLETimer();
        break;
      case 1:
        appBarTitle = '$fulName'.obs;
        updateBLETimer();
        break;
      case 2:
        appBarTitle = 'Vitals'.obs;
        updateBLETimer(Enable: false);
        break;
      case 3:
        appBarTitle = 'Symptoms'.obs;
        updateBLETimer(Enable: false);
        break;
    }
  }

  void getValuesNativeAppointment() {
    _appointmentSubscription ??=
        streamAppointment.receiveBroadcastStream().listen((val) {
      print(val);
      List<String>? receivedValues = val.split('|');
      if ((receivedValues ?? []).length > 0) {
        switch ((receivedValues!.first ?? "")) {
          case "scheduleAppointment":
            if (PreferenceUtil.getIfQurhomeisAcive()) {
              redirectToSheelaScheduleAppointment();
            }
            break;
        }
      }
    });
    if (Platform.isIOS) {
      const platform = MethodChannel(APPOINTMENT_DETAILS);
      platform.setMethodCallHandler((call) {
        if (call.method == APPOINTMENT_DETAILS) {
          if (PreferenceUtil.getIfQurhomeisAcive()) {
            redirectToSheelaScheduleAppointment();
          }
        }
      } as Future<dynamic> Function(MethodCall)?);
    }
  }

  void redirectToSheelaScheduleAppointment() {
    Get.toNamed(
      rt_Sheela,
      arguments: SheelaArgument(scheduleAppointment: true),
    );
  }
}

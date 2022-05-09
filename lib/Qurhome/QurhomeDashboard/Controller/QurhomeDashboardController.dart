import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/Controller/hub_list_controller.dart';
import 'package:myfhb/Qurhome/BleConnect/Controller/ble_connect_controller.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import '../../../src/ui/bot/view/sheela_arguments.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/common/CommonUtil.dart';

class QurhomeDashboardController extends GetxController {
  var currentSelectedIndex = 0.obs;
  var appBarTitle = ' '.obs;
  static const stream = EventChannel('QurbookBLE/stream');
  StreamSubscription _timerSubscription;
  var foundBLE = false.obs;
  var movedToNextScreen = false;
  String bleMacId;
  HubListController hubController;

  @override
  void onInit() {
    getHubDetails();
    super.onInit();
  }

  @override
  void onClose() {
    _disableTimer();
    super.onClose();
  }

  getHubDetails() {
    hubController = Get.find<HubListController>();
    hubController.getHubList();
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void _enableTimer(bool isFromVitalsList) {
    _timerSubscription ??= stream.receiveBroadcastStream().listen((val) {
      int milliSeconds = 100;
      print(val);
      List<String> receivedValues = val.split('|');
      if ((receivedValues ?? []).length > 0) {
        switch ((receivedValues.first ?? "")) {
          case "enablebluetooth":
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;
          case "permissiondenied":
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;
          case "scanstarted":
            /*FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);*/
            break;
          case "connectionfailed":
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;
          case "macid":
            bleMacId = validString(receivedValues.last);
            hubController.bleMacId.value = bleMacId;
            break;
          case "connected":
            // FlutterToast()
            //     .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            if (!isFromVitalsList) {
              milliSeconds = 0;
              LoaderClass.hideLoadingDialog(Get.context);
            }
            foundBLE.value = true;
            movedToNextScreen = true;
            _disableTimer();
            if (checkForParedDevice()) {
              Future.delayed(Duration(milliseconds: milliSeconds))
                  .then((value) {
                Get.toNamed(
                  rt_Sheela,
                  arguments: SheelaArgument(
                    takeActiveDeviceReadings: true,
                  ),
                );
              }).then((_) {
                var regController = Get.find<QurhomeRegimenController>();
                regController.getRegimenList();
              });
            } else {
              FlutterToast().getToastForLongTime(
                'No device found',
                Colors.red,
              );
            }
            break;

          case "disconnected":
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;

          default:
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
        }
      }
    });
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

  bool checkForParedDevice() {
    try {
      var userDeviceCollection =
          hubController.hubListResponse.result.userDeviceCollection;

      final index = userDeviceCollection.indexWhere(
        (element) => validString(element.device.serialNumber) == bleMacId,
      );
      return index >= 0;
    } catch (e) {
      return false;
    }
  }

  void checkForConnectedDevices(
    bool isFromVitalsList, {
    String eid,
    String uid,
  }) {
    try {
      int seconds = 180;
      if (!isFromVitalsList) {
        seconds = 10;
        LoaderClass.showLoadingDialog(Get.context);
      }
      foundBLE.value = false;
      movedToNextScreen = false;
      _enableTimer(isFromVitalsList);
      BleConnectController bleController = Get.put(BleConnectController());
      hubController.eid = eid;
      hubController.uid = uid;
      bleController.getBleConnectData(Get.context);

      Future.delayed(Duration(seconds: seconds)).then((value) {
        if (!foundBLE.value && !movedToNextScreen) {
          _disableTimer();

          if (!isFromVitalsList) {
            LoaderClass.hideLoadingDialog(Get.context);
            //Device Not Connected
            Get.toNamed(
              rt_Sheela,
              arguments: SheelaArgument(
                eId: eid,
              ),
            );
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void updateTabIndex(int newIndex) {
    currentSelectedIndex.value = newIndex;
    MyProfileModel myProfile;
    String fulName = '';
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      fulName = myProfile.result != null
          ? myProfile.result.firstName.capitalizeFirstofEach +
              ' ' +
              myProfile.result.lastName.capitalizeFirstofEach
          : '';
    } catch (e) {}
    switch (currentSelectedIndex.value) {
      case 0:
        appBarTitle = '$fulName'.obs;
        break;
      case 1:
        appBarTitle = '$fulName'.obs;
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

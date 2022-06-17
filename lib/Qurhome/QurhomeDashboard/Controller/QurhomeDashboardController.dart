import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/Controller/hub_list_controller.dart';
import 'package:myfhb/Qurhome/BleConnect/Controller/ble_connect_controller.dart';
import 'package:myfhb/Qurhome/BpScan/model/QurHomeBpScanResult.dart';
import 'package:myfhb/Qurhome/QurHomeVitals/viewModel/VitalDetailController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/constants/fhb_constants.dart';
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
  static const streamBp = EventChannel('QurbookBLE/stream');
  StreamSubscription _timerSubscription;
  StreamSubscription _bpPressureSubscription;
  var foundBLE = false.obs;
  var movedToNextScreen = false;
  var isDialogShowing = false.obs;
  String bleMacId;
  HubListController hubController;
  var regController;
  QurHomeBpScanResult qurHomeBpScanResultModel;
  var qurHomeBpScanResult = [].obs;
  BleConnectController bleController = Get.put(BleConnectController());

  @override
  void onInit() {
    getHubDetails();
    PreferenceUtil.saveIfQurhomeisAcive(
      qurhomeStatus: true,
    );

    super.onInit();
  }

  @override
  void onClose() {
    PreferenceUtil.saveIfQurhomeisAcive(
      qurhomeStatus: false,
    );
    _disableTimer();
    //bleController.stopBleScan();
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
    if (_bpPressureSubscription != null) {
      _bpPressureSubscription.cancel();
      _bpPressureSubscription = null;
    }
  }

  void _enableTimer(bool isFromVitalsList) {
    _timerSubscription ??= stream.receiveBroadcastStream().listen((val) {
      // int milliSeconds = 100;
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
          case "bleDeviceType":
            hubController.bleDeviceType.value =
                validString(receivedValues.last);
            break;
          case "connected":
            if (hubController.bleDeviceType.value.toLowerCase() ==
                "SPO2".toLowerCase()) {
              foundBLE.value = true;
              movedToNextScreen = true;
              _disableTimer();
              bleController.stopBleScan();
              if (checkForParedDevice(isFromBp: false)) {
                if (isDialogShowing.value) {
                  Get.back();
                }
                Get.toNamed(
                  rt_Sheela,
                  arguments: SheelaArgument(
                    takeActiveDeviceReadings: true,
                  ),
                ).then((_) async {
                  if (isFromVitalsList) {
                    await Future.delayed(Duration(seconds: 2));
                    VitalDetailController vitalController = Get.find();
                    vitalController.fetchOXYDetailsQurHome(
                      filter: filterApiDay,
                      isLoading: true,
                    );
                  } else {
                    regController.getRegimenList();
                  }
                });
              } else {
                Get.back();
                FlutterToast().getToastForLongTime(
                  'No device found',
                  Colors.red,
                );
              }
            }
            break;
          case "measurement":
            if (hubController.bleDeviceType.value.toLowerCase() ==
                "BP".toLowerCase()) {
              try {
                _disableTimer();
                var josnResult = convert.jsonDecode(receivedValues.last);
                qurHomeBpScanResultModel =
                    QurHomeBpScanResult.fromJson(josnResult);
                qurHomeBpScanResultModel.deviceAddress = bleMacId;
                qurHomeBpScanResultModel?.measurementRecords;
                if ((qurHomeBpScanResultModel?.measurementRecords ?? [])
                        .length >
                    0) {
                  if (checkForParedDevice()) {
                    Get.back();
                    Get.toNamed(
                      rt_Sheela,
                      arguments: SheelaArgument(
                        takeActiveDeviceReadings: false,
                        isFromBpReading: true,
                      ),
                    ).then((_) async {
                      if (isFromVitalsList) {
                        await Future.delayed(Duration(seconds: 2));
                        VitalDetailController vitalController = Get.find();
                        vitalController.fetchBPDetailsQurHome(
                          filter: filterApiDay,
                          isLoading: true,
                        );
                      } else {
                        regController.getRegimenList();
                      }
                    });
                  } else {
                    Get.back();
                    FlutterToast().getToastForLongTime(
                      'No device found',
                      Colors.red,
                    );
                  }
                }
              } catch (e) {
                printError(info: e.toString());
              }
            }
            break;
          case "disconnected":
            // FlutterToast()
            //     .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;

          default:
          // FlutterToast()
          //     .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
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

  bool checkForParedDevice({bool isFromBp, String bleBPMacId}) {
    try {
      var userDeviceCollection =
          hubController.hubListResponse.result.userDeviceCollection;
      //var activeUser = PreferenceUtil.getStringValue(KEY_USERID);
      var index = -1;
      if (Platform.isAndroid) {
        index = userDeviceCollection.indexWhere(
            (element) => (validString(element.device.serialNumber) ==
                (isFromBp
                    ? bleBPMacId
                    : bleMacId)) /*&&
            ((element.userId ?? '') == activeUser)*/
            );
      } else {
        index = userDeviceCollection.indexWhere(
            (element) => (validString(element.device.serialNumber) ==
                bleMacId) /*&&
            ((element.userId ?? '') == activeUser)*/
            );
      }

      return index >= 0;
    } catch (e) {
      return false;
    }
  }

  checkForConnectedDevices(
    bool isFromVitalsList, {
    String eid,
    String uid,
  }) async {
    try {
      if (Platform.isAndroid) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        bool isBluetoothEnable = false;
        const platform = MethodChannel(IS_BP_ENABLE_CHECK);
        isBluetoothEnable = await platform.invokeMethod(IS_BP_ENABLE_CHECK);
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
      regController = Get.find<QurhomeRegimenController>();
      isDialogShowing.value = true;
      CommonUtil().dialogForScanDevices(
        Get.context,
        onPressCancel: () {
          foundBLE.value = false;
          movedToNextScreen = false;
          _disableTimer();
          bleController.stopBleScan();
          Get.back();
          isDialogShowing.value = false;
        },
        onPressManual: () {
          _disableTimer();
          bleController.stopBleScan();
          Get.back();
          isDialogShowing.value = false;
          if (!isFromVitalsList) {
            //Device Not Connected
            Get.toNamed(
              rt_Sheela,
              arguments: SheelaArgument(
                eId: eid,
              ),
            ).then(
              (_) async {
                if (isFromVitalsList) {
                  await Future.delayed(Duration(seconds: 2));
                  VitalDetailController vitalController = Get.find();
                  vitalController.fetchOXYDetailsQurHome(
                    filter: filterApiDay,
                    isLoading: true,
                  );
                } else {
                  regController.getRegimenList();
                }
              },
            );
          }
        },
        title: strConnectPulseMeter,
        isFromVital: isFromVitalsList,
      );
      foundBLE.value = false;
      movedToNextScreen = false;
      _enableTimer(isFromVitalsList);
      hubController.eid = eid;
      hubController.uid = uid;
      bleController.getBleConnectData(Get.context);
    } catch (e) {
      print(e);
    }
  }

  void updateTabIndex(int newIndex) {
    currentSelectedIndex.value = newIndex;
    MyProfileModel myProfile;
    String fulName = '';
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
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

  Future<void> checkForBpConnection({bool isFromVitals}) async {
    if (Platform.isAndroid) {
      _getPermissionValuesNative();
      callNativeBpValues(isFromVitals: isFromVitals);
    } else {
      _enableTimer(isFromVitals);
      foundBLE.value = false;
      movedToNextScreen = false;
    }
    CommonUtil().dialogForScanDevices(
      Get.context,
      onPressManual: () {
        stopBpScan();
        Get.toNamed(
          rt_Sheela,
          arguments: SheelaArgument(
            eId: hubController.eid,
          ),
        ).then((_) async {
          if (isFromVitals) {
            await Future.delayed(Duration(seconds: 2));
            VitalDetailController vitalController = Get.find();
            vitalController.fetchBPDetailsQurHome(
              filter: filterApiDay,
              isLoading: true,
            );
          } else {
            regController.getRegimenList();
          }
        });
      },
      onPressCancel: () async {
        stopBpScan();
      },
      title: strConnectBpMeter,
      isFromVital: isFromVitals,
    );
  }

  void _getPermissionValuesNative() {
    _bpPressureSubscription ??= streamBp.receiveBroadcastStream().listen((val) {
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
          default:
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
        }
      }
    });
  }

  callNativeBpValues({bool isFromVitals}) async {
    try {
      const platform = MethodChannel(ISBPCONNECT);
      var result = await platform.invokeMethod(ISBPCONNECT);
      var josnResult = convert.jsonDecode(result.toString());
      qurHomeBpScanResultModel = QurHomeBpScanResult.fromJson(josnResult);
      qurHomeBpScanResult.value = qurHomeBpScanResultModel?.measurementRecords;
      if (qurHomeBpScanResultModel != null) {
        if (qurHomeBpScanResultModel?.measurementRecords != null) {
          if (qurHomeBpScanResultModel?.measurementRecords?.length > 0 ?? 0) {
            if (checkForParedDevice(
                isFromBp: true,
                bleBPMacId: qurHomeBpScanResultModel?.deviceAddress)) {
              Get.back();
              Get.toNamed(
                rt_Sheela,
                arguments: SheelaArgument(
                  takeActiveDeviceReadings: false,
                  isFromBpReading: true,
                ),
              ).then((_) async {
                if (isFromVitals) {
                  await Future.delayed(Duration(seconds: 2));
                  VitalDetailController vitalController = Get.find();
                  vitalController.fetchBPDetailsQurHome(
                    filter: filterApiDay,
                    isLoading: true,
                  );
                } else {
                  regController.getRegimenList();
                }
              });
            } else {
              Get.back();
              FlutterToast().getToastForLongTime(
                'No device found',
                Colors.red,
              );
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  scanBpSessionStart({bool isFromVitals}) async {
    if (Platform.isIOS) {
      checkForBpConnection(isFromVitals: isFromVitals);
    } else {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      bool isBluetoothEnable = false;
      bool isLocationGranted = false;
      const platform = MethodChannel(IS_BP_ENABLE_CHECK);
      isBluetoothEnable = await platform.invokeMethod(IS_BP_ENABLE_CHECK);
      /*var permissionStatus =
      await CommonUtil.askPermissionForLocation(isLocation: false);*/
      if (!isBluetoothEnable) {
        FlutterToast().getToast(
            'Please turn on your bluetooth and try again', Colors.red);
        return;
      } else if (!serviceEnabled) {
        FlutterToast().getToast(
            'Please turn on your GPS location services and try again',
            Colors.red);
        return;
      } else {
        checkForBpConnection(isFromVitals: isFromVitals);
      }
    }
  }

  stopBpScan() async {
    Get.back();
    if (Platform.isIOS) {
      _disableTimer();
      //need to cancel the session
    } else {
      const platform = MethodChannel(IS_BP_SCAN_CANCEL);
      var result = await platform.invokeMethod(IS_BP_SCAN_CANCEL);
      print("scan_cancel_result$result");
    }
  }
}

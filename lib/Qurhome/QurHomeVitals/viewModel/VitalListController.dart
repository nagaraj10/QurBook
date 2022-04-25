import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Qurhome/BleConnect/Controller/ble_connect_controller.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/device_integration/model/LastMeasureSync.dart';
import 'package:myfhb/device_integration/viewModel/getGFDataFromFHBRepo.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/ui/bot/view/sheela_arguments.dart';
import 'package:flutter/material.dart';

class VitalListController extends GetxController {
  final GetGFDataFromFHBRepo _helperRepo = GetGFDataFromFHBRepo();
  ApiBaseHelper _helper = ApiBaseHelper();
  var loadingData = false.obs;
  var timerProgress = 1.0.obs;
  static const stream = EventChannel('QurbookBLE/stream');
  StreamSubscription _timerSubscription;
  var foundBLE = false.obs;
  var isShowTimerDialog = true.obs;

  Future<LastMeasureSyncValues> fetchDeviceDetails() async {
    try {
      var resp = await _helperRepo.getLatestDeviceHealthRecord();
      final res = json.encode(resp);
      final response = lastMeasureSyncFromJson(res);
      final result = response.result;
      return result;
    } catch (e) {}
  }

  Future<GetDeviceSelectionModel> getDeviceSelection(
      {String userIdFromBloc}) async {
    var userId;
    if (userIdFromBloc != null) {
      userId = userIdFromBloc;
    } else {
      userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }

    final response = await _helper.getDeviceSelection(query.qr_user_profile +
        query.qr_user +
        query.qr_my_profile +
        query.qr_member_id +
        userId);
    return GetDeviceSelectionModel.fromJson(response);
  }

  updateTimerValue(double value) async {
    try {
      timerProgress.value = value;
    } catch (e) {
      print(e);
    }
  }

  updateisShowTimerDialog(bool value) async {
    try {
      isShowTimerDialog.value = value;
    } catch (e) {
      print(e);
    }
  }

  void checkForConnectedDevices(
      AnimationController animationController, StreamController<int> _events) {
    try {
      foundBLE.value = false;
      _enableTimer(animationController, _events);
      BleConnectController bleController = Get.put(BleConnectController());
      bleController.getBleConnectData(Get.context);
      Future.delayed(Duration(seconds: 10)).then((value) {
        if (!foundBLE.value) {
          _disableTimer();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _disableTimer() {
    try {
      if (_timerSubscription != null) {
        _timerSubscription.cancel();
        _timerSubscription = null;
      }
    } catch (e) {
      print(e);
    }
  }

  void _enableTimer(
      AnimationController animationController, StreamController<int> _events) {
    try {
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
            case "connected":
              foundBLE.value = true;
              _disableTimer();
              try {
                animationController.stop();
                _events.close();
                Navigator.pop(Get.context);
              } catch (e) {
                print(e);
              }
              Get.toNamed(
                rt_Sheela,
                arguments: SheelaArgument(
                  takeActiveDeviceReadings: true,
                ),
              );
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

import 'package:myfhb/Device_Integration/services/syncHealthKitData.dart';
import 'package:myfhb/device_integration/services/syncGoogleFitData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class DeviceDataHelper {
  SyncGoogleFitData _syncGoogleFitData = SyncGoogleFitData();
  SyncHealthKitData _syncHealthKitData = SyncHealthKitData();

  Future<bool> isGoogleFitSignedIn() async {
    return await _syncGoogleFitData.isGoogleFitSignedIn();
  }

  Future<bool> activateGoogleFit() async {
    bool bRet = await _syncGoogleFitData.activateGoogleFit();
    if (!bRet) {
      Fluttertoast.showToast(
          msg: 'Failed to activate GoogleFit', backgroundColor: Colors.red);
    }
    return bRet;
  }

  Future<bool> deactivateGoogleFit() async {
    bool bRet = await _syncGoogleFitData.deactivateGoogleFit();
    if (!bRet) {
      Fluttertoast.showToast(
          msg: 'Failed to deactivate GoogleFit', backgroundColor: Colors.red);
    }
    return bRet;
  }

  Future<void> syncGoogleFit() async {
    try {
      bool bRet = await _syncGoogleFitData.syncGoogleFitData();
      if (bRet) {
        Fluttertoast.showToast(
            msg: 'Syncing Health Data from Google Fit completed',
            backgroundColor: Colors.green);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '${e}', backgroundColor: Colors.red);
    }
  }

  Future<void> activateHealthKit() async {
    try {
      await _syncHealthKitData.activateHealthKit();
    } catch (e) {
      Fluttertoast.showToast(msg: '${e}', backgroundColor: Colors.red);
    }
  }

  Future<void> deactivateHealthKit() async {
    //     //todo
  }

  Future<void> syncHealthKit() async {
    try {
      bool bRet = await _syncHealthKitData.syncHealthKitData();
      if (bRet) {
        Fluttertoast.showToast(
            msg: 'Syncing Health Data from Apple Health completed',
            backgroundColor: Colors.green);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '${e}', backgroundColor: Colors.red);
    }
  }
}

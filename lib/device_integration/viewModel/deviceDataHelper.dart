import '../../Device_Integration/services/syncHealthKitData.dart';
import '../services/syncGoogleFitData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class DeviceDataHelper {
  final SyncGoogleFitData _syncGoogleFitData = SyncGoogleFitData();
  final SyncHealthKitData _syncHealthKitData = SyncHealthKitData();

  Future<bool> isGoogleFitSignedIn() async {
    return await _syncGoogleFitData.isGoogleFitSignedIn();
  }

  Future<bool> activateGoogleFit() async {
    var bRet = await _syncGoogleFitData.activateGoogleFit();
    if (!bRet) {
      await Fluttertoast.showToast(
          msg: 'Failed to activate GoogleFit', backgroundColor: Colors.red);
    }
    return bRet;
  }

  Future<bool> deactivateGoogleFit() async {
    var bRet = await _syncGoogleFitData.deactivateGoogleFit();
    if (!bRet) {
      await Fluttertoast.showToast(
          msg: 'Failed to deactivate GoogleFit', backgroundColor: Colors.red);
    }
    return bRet;
  }

  Future<void> syncGoogleFit() async {
    try {
      final bRet = await _syncGoogleFitData.syncGoogleFitData();
      if (bRet) {
        await Fluttertoast.showToast(
            msg: 'Syncing Health Data from Google Fit completed',
            backgroundColor: Colors.green);
      }
    } catch (e) {
      await Fluttertoast.showToast(msg: '$e', backgroundColor: Colors.red);
    }
  }

  Future<void> activateHealthKit() async {
    try {
      await _syncHealthKitData.activateHealthKit();
    } catch (e) {
      await Fluttertoast.showToast(msg: '$e', backgroundColor: Colors.red);
    }
  }

  Future<void> deactivateHealthKit() async {
    //     //todo
  }

  Future<void> syncHealthKit() async {
    try {
      var bRet = await _syncHealthKitData.syncHealthKitData();
      if (bRet) {
        await Fluttertoast.showToast(
            msg: 'Syncing Health Data from Apple Health completed',
            backgroundColor: Colors.green);
      }
    } catch (e) {
      await Fluttertoast.showToast(msg: '$e', backgroundColor: Colors.red);
    }
  }
}

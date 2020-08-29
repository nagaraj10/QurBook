import 'package:myfhb/Device_Integration/services/syncHealthKitData.dart';
import 'package:myfhb/device_integration/services/syncGoogleFitData.dart';

class DeviceDataHelper {
  SyncGoogleFitData _syncGoogleFitData = SyncGoogleFitData();
  SyncHealthKitData _syncHealthKitData = SyncHealthKitData();

  Future<bool> isGoogleFitSignedIn() async {
    return await _syncGoogleFitData.isGoogleFitSignedIn();
  }

  Future<bool> activateGoogleFit() async {
    return await _syncGoogleFitData.activateGoogleFit();
  }

  Future<bool> deactivateGoogleFit() async {
    return await _syncGoogleFitData.deactivateGoogleFit();
  }

  Future<void> syncGoogleFit() async {
    await _syncGoogleFitData.syncGoogleFitData();
  }

  Future<void> activateHealthKit() async {
    await _syncHealthKitData.activateHealthKit();
  }

  Future<void> deactivateHealthKit() async {
    //     //todo
  }

  Future<void> syncHealthKit() async {
    await _syncHealthKitData.syncHealthKitData();
  }
}

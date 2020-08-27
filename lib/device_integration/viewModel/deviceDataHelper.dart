import 'package:myfhb/Device_Integration/services/syncHealthKitData.dart';
import 'package:myfhb/device_integration/services/syncGoogleFitData.dart';

class DeviceDataHelper {
  SyncGoogleFitData _syncGoogleFitData = SyncGoogleFitData();
  SyncHealthKitData _syncHealthKitData = SyncHealthKitData();

  Future<bool> isGFSignedIn() async {
    return await _syncGoogleFitData.isGFSignedIn();
  }

  Future<bool> activateGF() async {
    return await _syncGoogleFitData.activateGF();
  }

  Future<bool> deactivateGF() async {
    return await _syncGoogleFitData.deactivateGF();
  }

  Future<void> syncGF() async {
    await _syncGoogleFitData.syncGFData();
  }

  Future<void> activateHKT() async {
    await _syncHealthKitData.activateHKT();
  }

  Future<void> deactivateHKT() async {
    //     //todo
  }

  Future<void> syncHKT() async {
    await _syncHealthKitData.syncHKTData();
  }
}

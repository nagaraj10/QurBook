import 'package:myfhb/device_integration/services/syncGoogleFitData.dart';

class DeviceDataHelper {
  SyncGoogleFitData _syncGoogleFitData = SyncGoogleFitData();

  Future<void> activateGF() async {
    await _syncGoogleFitData.activateGF();
  }

  Future<void> deactivateGF() async {
    await _syncGoogleFitData.deactivateGF();
  }

  Future<void> syncGF() async {
    String startTime = "1577894746000";
    String endTime = "1585497946000";

    // to do get start Time and end time from last sync time
    await _syncGoogleFitData.syncGFData(startTime, endTime);
  }

  Future<void> activateHKT() async {
    //todo
  }

  Future<void> deactivateHKT() async {
    //todo
  }

  Future<void> syncHKT() async {
    // todo
  }
}

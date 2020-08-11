import 'package:myfhb/Device_Integration/services/syncHealthKitData.dart';
import 'package:myfhb/device_integration/services/syncGoogleFitData.dart';

class DeviceDataHelper {
  SyncGoogleFitData _syncGoogleFitData = SyncGoogleFitData();
  SyncHealthKitData _syncHealthKitData = SyncHealthKitData();

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
    await _syncHealthKitData.activateHKT();
  }

  Future<void> deactivateHKT() async {
    //todo
    DateTime startDate = DateTime.utc(2020, 07, 01);
    DateTime endDate = DateTime.now();
    await _syncHealthKitData.syncHKT(startDate, endDate);
  }

  Future<void> syncHKT() async {
    // todo
  }
}

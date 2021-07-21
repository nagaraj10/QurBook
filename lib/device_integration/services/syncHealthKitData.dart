import '../../Device_Integration/services/fetchHealthKitData.dart';
import '../../src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import '../../constants/fhb_query.dart' as query;
import '../model/myFHBResponseModel.dart';
import 'dart:convert' show json;
import '../model/LastSyncResponse.dart';

class SyncHealthKitData {
  FetchHealthKitData _hkHelper;
  DeviceHealthRecord _deviceHealthRecord;

  SyncHealthKitData() {
    _hkHelper = FetchHealthKitData();
  }

  Future<void> activateHealthKit() async {
    try {
      await _hkHelper.activateHealthKit();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateHealthKit() async {
    //todo
  }

  Future<bool> syncHealthKitData() async {
    DateTime startDate;
    var endDate = DateTime.now();

    final DateTime lastSynctime = await getLastSynctime();

    endDate = DateTime.now();
    final currentdate = DateTime.now();
    final startT = DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    if (lastSynctime == null) {
      startDate = startT;
    } else {
      final newstartT = DateTime(lastSynctime.year, lastSynctime.month,
          lastSynctime.day, lastSynctime.hour, lastSynctime.minute + 1);

      startDate = newstartT;
    }

    try {
      var weightParams = await _hkHelper.getWeightData(startDate, endDate);
      if (weightParams != null) {
        print(
            '-------------------------weight-------------------------------------');
        print(weightParams);
        await postHealthKitData(weightParams);
      }

      final bloodGlucoseParams =
          await _hkHelper.getBloodGlucoseData(startDate, endDate);
      if (bloodGlucoseParams != null) {
        await postHealthKitData(bloodGlucoseParams);
      }

      var bpParams = await _hkHelper.getBloodPressureData(startDate, endDate);
      if (bpParams != null) {
        await postHealthKitData(bpParams);
      }

      final bloodOxygenParams =
          await _hkHelper.getBloodOxygenData(startDate, endDate);
      if (bloodOxygenParams != null) {
        await postHealthKitData(bloodOxygenParams);
      }

      var bodyTemperatureParams =
          await _hkHelper.getBodyTemperature(startDate, endDate);
      if (bodyTemperatureParams != null) {
        await postHealthKitData(bodyTemperatureParams);
      }

      // String heartRateParams =
      //     await _hkHelper.getHeartRateData(startDate, endDate);
      // if (heartRateParams != null) {
      //   await postHealthKitData(heartRateParams);
      // }
      return true;
    } catch (e) {
      throw 'Failed to sync Apple Health Data please try again later';
    }

    // todo
  }

  Future<dynamic> postHealthKitData(String params) async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();
      final response = await _deviceHealthRecord.postDeviceData(params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getLastSynctime() async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();

      final lastsyncDetails =
          await _deviceHealthRecord.getLastsynctime(query.qr_LastSyncHK);
      var jsonstr = json.encode(lastsyncDetails);
      var lastSync = latestSyncFromJson(jsonstr);

      if (!lastSync.isSuccess) return null;
      return lastSync.result.lastSyncDateTime;
    } catch (e) {}
  }
}

import 'package:myfhb/Device_Integration/services/fetchHealthKitData.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/device_integration/model/myFHBResponseModel.dart';
import 'dart:convert' show json;
import 'package:myfhb/device_integration/model/LastSyncResponse.dart';

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
      throw e;
    }
  }

  Future<void> deactivateHealthKit() async {
    //todo
  }

  Future<bool> syncHealthKitData() async {
    DateTime startDate;
    DateTime endDate = DateTime.now();

    DateTime lastSynctime = await getLastSynctime();

    endDate = DateTime.now();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    if (lastSynctime == null) {
      startDate = startT;
    } else {
      var newstartT = new DateTime(lastSynctime.year, lastSynctime.month,
          lastSynctime.day, lastSynctime.hour, lastSynctime.minute + 1);

      startDate = newstartT;
    }

    try {
      String weightParams = await _hkHelper.getWeightData(startDate, endDate);
      if (weightParams != null) {
        print(
            "-------------------------weight-------------------------------------");
        print(weightParams);
        await postHealthKitData(weightParams);
      }

      String bloodGlucoseParams =
          await _hkHelper.getBloodGlucoseData(startDate, endDate);
      if (bloodGlucoseParams != null) {
        await postHealthKitData(bloodGlucoseParams);
      }

      String bpParams =
          await _hkHelper.getBloodPressureData(startDate, endDate);
      if (bpParams != null) {
        await postHealthKitData(bpParams);
      }

      String bloodOxygenParams =
          await _hkHelper.getBloodOxygenData(startDate, endDate);
      if (bloodOxygenParams != null) {
        await postHealthKitData(bloodOxygenParams);
      }

      String bodyTemperatureParams =
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
      throw "Failed to sync Apple Health Data please try again later";
    }

    // todo
  }

  Future<dynamic> postHealthKitData(String params) async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();
      var response = await _deviceHealthRecord.postDeviceData(params);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> getLastSynctime() async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();

      var lastsyncDetails =
          await _deviceHealthRecord.getLastsynctime(query.qr_LastSyncHK);
      String jsonstr = json.encode(lastsyncDetails);
      LatestSync lastSync = latestSyncFromJson(jsonstr);

      if (!lastSync.isSuccess) return null;
      return lastSync.result.lastSyncDateTime;
    } catch (e) {}
  }
}

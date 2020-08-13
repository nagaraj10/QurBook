import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:myfhb/database/services/database_helper.dart';
import 'package:myfhb/Device_Integration/services/fetchHealthKitData.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/device_integration/model/myFHBResponseModel.dart';
import 'dart:convert' show json;

class SyncHealthKitData {
  FetchHealthKitData _hkHelper;
  DeviceHealthRecord _deviceHealthRecord;

  SyncHealthKitData() {
    _hkHelper = FetchHealthKitData();
  }

  Future<void> activateHKT() async {
    try {
      await _hkHelper.activateHKT();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deactivateHKT() async {
    //todo
  }

  Future<void> syncHKTData() async {
    var response = "";
    DateTime startDate = DateTime.utc(2020, 07, 01);
    DateTime endDate = DateTime.now();

    DateTime lastSynctime = await getLastSynctime();

    print("lastsynctime $lastSynctime");

    endDate = DateTime.now();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    print("Start time earlier $startT");
    print("End time $endDate");

    if (lastSynctime == null) {
      startDate = startT;
      print(startDate);
    } else {
      var newstartT = new DateTime(lastSynctime.year, lastSynctime.month,
          lastSynctime.day, lastSynctime.hour, lastSynctime.minute + 1);
      print("Configured start time based on last sync time $newstartT");

      startDate = newstartT;
    }

    try {
      String weightParams = await _hkHelper.getWeightData(startDate, endDate);
      response = await postHKData(weightParams);
      print('post weight data response $response');

      response = "";
      String bloodGlucoseParams =
          await _hkHelper.getBloodGlucoseData(startDate, endDate);
      response = await postHKData(bloodGlucoseParams);
      print('post Glucose data response $response');

      response = "";
      String bpParams =
          await _hkHelper.getBloodPressureData(startDate, endDate);
      response = await postHKData(bpParams);
      print('post BP data response $response');

      response = '';
      String bloodOxygenParams =
          await _hkHelper.getBloodOxygenData(startDate, endDate);
      response = await postHKData(bloodOxygenParams);
      print('post blood Oxygen data response $response');

      response = '';

      String bodyTemperatureParams =
          await _hkHelper.getBodyTemperature(startDate, endDate);

      response = await postHKData(bodyTemperatureParams);
      print('post body temp data response $response');

      response = '';

      String heartRateParams =
          await _hkHelper.getHeartRateData(startDate, endDate);
      response = await postHKData(heartRateParams);
      print('post heart rate data response $response');
    } catch (e) {}

    // todo
  }

  Future<dynamic> postHKData(String params) async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();
      var response = await _deviceHealthRecord.postDeviceData(params);
      return response;
    } catch (e) {
      throw "Sync HealthKit Fit Data to FHB Backend Failed $e";
    }
  }

  Future<dynamic> getLastSynctime() async {
    try {
      print("Getting Last sync time to synchronize data");
      _deviceHealthRecord = DeviceHealthRecord();

      var lastsyncDetails =
          await _deviceHealthRecord.getLastsynctime(query.qr_lastSyncHK);
      String jsonstr = json.encode(lastsyncDetails);
      LastSync lastSync = lastSyncFromJson(jsonstr);

      if (!lastSync.isSuccess) return null;
      print("last sync time ${lastSync.result[0].lastSyncDateTime}");

      return lastSync.result[0].lastSyncDateTime;
    } catch (e) {
      throw "Failed to get Get lastsynctime from FHB DB $e";
    }
  }
}

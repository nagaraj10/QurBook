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
  //for mockito unit testing
  SyncHealthKitData.forTest(var hkHealper, DeviceHealthRecord deviceHelper) {
    _hkHelper = hkHealper;
    _deviceHealthRecord = deviceHelper;
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
    var response;
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
        response = await postHKData(weightParams);
      }
      response = "";
      String bloodGlucoseParams =
          await _hkHelper.getBloodGlucoseData(startDate, endDate);
      if (bloodGlucoseParams != null) {
        response = await postHKData(bloodGlucoseParams);
      }

      response = "";
      String bpParams =
          await _hkHelper.getBloodPressureData(startDate, endDate);
      if (bpParams != null) {
        response = await postHKData(bpParams);
      }
      response = '';
      String bloodOxygenParams =
          await _hkHelper.getBloodOxygenData(startDate, endDate);
      if (bloodOxygenParams != null) {
        response = await postHKData(bloodOxygenParams);
      }
      response = '';

      String bodyTemperatureParams =
          await _hkHelper.getBodyTemperature(startDate, endDate);
      if (bodyTemperatureParams != null) {
        response = await postHKData(bodyTemperatureParams);
      }
      response = '';

      String heartRateParams =
          await _hkHelper.getHeartRateData(startDate, endDate);
      if (heartRateParams != null) {
        response = await postHKData(heartRateParams);
      }
    } catch (e) {}

    // todo
  }

  Future<dynamic> postHKData(String params) async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();
      var response = await _deviceHealthRecord.postDeviceData(params);
      return response;
    } catch (e) {}
  }

  Future<dynamic> getLastSynctime() async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();

      var lastsyncDetails =
          await _deviceHealthRecord.getLastsynctime(query.qr_lastSyncHK);
      String jsonstr = json.encode(lastsyncDetails);
      LastSync lastSync = lastSyncFromJson(jsonstr);

      if (!lastSync.isSuccess) return null;
      return lastSync.result[0].lastSyncDateTime;
    } catch (e) {}
  }
}

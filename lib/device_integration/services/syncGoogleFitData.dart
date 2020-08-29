import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/database/services/database_helper.dart';
import 'package:myfhb/device_integration/services/fetchGoogleFitData.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'package:myfhb/device_integration/model/myFHBResponseModel.dart';
import 'dart:convert' show json;
import 'package:myfhb/constants/fhb_query.dart' as query;

class SyncGoogleFitData {
  GoogleFitData _gfHelper;
  DeviceHealthRecord _deviceHealthRecord;

  SyncGoogleFitData() {
    _gfHelper = GoogleFitData();
  }

  Future<bool> isGoogleFitSignedIn() async {
    return _gfHelper.isSignedIn();
  }

  Future<bool> activateGoogleFit() async {
    return await _gfHelper.signIn();
  }

  Future<bool> deactivateGoogleFit() async {
    return await _gfHelper.signOut();
  }

  Future<bool> syncGoogleFitData() async {
    var response;
    String startTime = "";
    String endTime = "";

    if (!await isGoogleFitSignedIn()) {
      return false;
    }

    DateTime lastSynctime = await getLastSynctime();

    endTime = DateTime.now().millisecondsSinceEpoch.toString();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    if (lastSynctime == null) {
      startTime = startT.millisecondsSinceEpoch.toString();
    } else {
      var newstartT = new DateTime(lastSynctime.year, lastSynctime.month,
          lastSynctime.day, lastSynctime.hour, lastSynctime.minute + 1);
      startTime = newstartT.millisecondsSinceEpoch.toString();
      // To do handle more than 3 months logic
    }
    try {
      String bpParams = await _gfHelper.getBPSummary(startTime, endTime);
      if (bpParams != null) {
        response = await postGoogleFitData(bpParams);
      }

      response = "";
      String weightParams =
          await _gfHelper.getWeightSummary(startTime, endTime);
      if (weightParams != null) {
        response = await postGoogleFitData(weightParams);
      }

      response = "";
      String heartRateParams =
          await _gfHelper.getHeartRateSummary(startTime, endTime);
      if (heartRateParams != null) {
        response = await postGoogleFitData(heartRateParams);
      }

      response = "";
      String glucoseParams =
          await _gfHelper.getBloodGlucoseSummary(startTime, endTime);
      if (glucoseParams != null) {
        response = await postGoogleFitData(glucoseParams);
      }

      response = "";
      String temperatureParams =
          await _gfHelper.getBodyTempSummary(startTime, endTime);
      if (temperatureParams != null) {
        response = await postGoogleFitData(temperatureParams);
      }

      response = "";
      String oxygenParams =
          await _gfHelper.getOxygenSaturationSummary(startTime, endTime);
      if (oxygenParams != null) {
        response = await postGoogleFitData(oxygenParams);
      }
    } catch (e) {}
  }

  Future<dynamic> postGoogleFitData(String params) async {
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
          await _deviceHealthRecord.getLastsynctime(query.qr_LastSyncGF);
      String jsonstr = json.encode(lastsyncDetails);
      LastSync lastSync = lastSyncFromJson(jsonstr);
      if (!lastSync.isSuccess) return null;
      return lastSync.result[0].lastSyncDateTime;
    } catch (e) {}
  }
}

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

  Future<void> activateGF() async {
    bool signedIn = await _gfHelper.isSignedIn();
    await _gfHelper.signIn();
    if (!signedIn) {
      await _gfHelper.signIn();
    } 
  }

  Future<void> deactivateGF() async {
    await _gfHelper.signOut();
  }

  Future<bool> syncGFData() async {
    var response;
    String startTime = "";
    String endTime = "";
    await activateGF();

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
        response = await postGFData(bpParams);
      }

      response = "";
      String weightParams =
          await _gfHelper.getWeightSummary(startTime, endTime);
      if (weightParams != null) {
        response = await postGFData(weightParams);
      }

      response = "";
      String heartRateParams =
          await _gfHelper.getHeartRateSummary(startTime, endTime);
      if (heartRateParams != null) {
        response = await postGFData(heartRateParams);
      }
    } catch (e) {
    }
  }

  Future<dynamic> postGFData(String params) async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();

      var response = await _deviceHealthRecord.postDeviceData(params);

      return response;
    } catch (e) {
    }
  }

  Future<dynamic> getLastSynctime() async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();
      var lastsyncDetails =
          await _deviceHealthRecord.getLastsynctime(query.qr_lastSyncGF);
      String jsonstr = json.encode(lastsyncDetails);
      LastSync lastSync = lastSyncFromJson(jsonstr);
      if (!lastSync.isSuccess) return null;
      return lastSync.result[0].lastSyncDateTime;
    } catch (e) {
    }
  }
}

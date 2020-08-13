import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/database/services/database_helper.dart';
import 'package:myfhb/device_integration/services/fetchGoogleFitData.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'package:myfhb/device_integration/model/myFHBResponseModel.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;
import 'package:myfhb/constants/fhb_query.dart' as query;

class SyncGoogleFitData {
  FetchGoogleFitData _gfHelper;
  DeviceHealthRecord _deviceHealthRecord;

  SyncGoogleFitData() {
    _gfHelper = FetchGoogleFitData();
  }

  Future<void> activateGF() async {
    bool signedIn = await _gfHelper.isSignedIn();
    await _gfHelper.signIn();
    if (!signedIn) {
      print("Signing In to google");
      await _gfHelper.signIn();
    } else {
      print('User Already Signed In');
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

    print("lastsynctime $lastSynctime");

    endTime = DateTime.now().millisecondsSinceEpoch.toString();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    print("Start time earlier $startT");
    print("End time $endTime");

    if (lastSynctime == null) {
      startTime = startT.millisecondsSinceEpoch.toString();
      print(startTime);
    } else {
      var newstartT = new DateTime(lastSynctime.year, lastSynctime.month,
          lastSynctime.day, lastSynctime.hour, lastSynctime.minute + 1);
      print("Configured start time based on last sync time $newstartT");

      startTime = newstartT.millisecondsSinceEpoch.toString();
      // To do handle more than 3 months logic
    }

    print("Start time $startTime");


    String bpParams = await _gfHelper.getBPSummary(startTime, endTime);
    print(bpParams);
    if (bpParams != null) {
      response = await postGFData(bpParams);
      print("response from Blood Pressure Sync $response");
    } else {
      print("There is no Blood Pressure data available to sync in Google Fit");
    }

    response = "";


    String weightParams = await _gfHelper.getWeightSummary(startTime, endTime);
    print(weightParams);
    if (weightParams != null) {
      response = await postGFData(weightParams);
      print("response from Weight Sync $response");
    } else {
      print("There is no weight data available to sync in Google Fit");
    }

    response = "";
    String heartRateParams =
        await _gfHelper.getHeartRateSummary(startTime, endTime);
    print(heartRateParams);
    if (heartRateParams != null) {
      response = await postGFData(heartRateParams);
      print("response from Heart Rate Sync $response");
    } else {
      print("There is no Heart Rate data available to sync in Google Fit");
    }
  }

  Future<dynamic> postGFData(String params) async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();

      var response = await _deviceHealthRecord.postDeviceData(params);

      return response;
    } catch (e) {
      throw "Sync Google Fit Data to FHB Backend Failed $e";
    }
  }

  Future<dynamic> getLastSynctime() async {
    try {
      print("Getting Last sync time to synchronize data");
      _deviceHealthRecord = DeviceHealthRecord();

      var lastsyncDetails = await _deviceHealthRecord.getLastsynctime(query.qr_lastSyncGF);

      print("body $lastsyncDetails");

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

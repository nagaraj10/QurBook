import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/database/services/database_helper.dart';
import 'package:myfhb/device_integration/services/fetchGoogleFitData.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'package:myfhb/device_integration/model/myFHBResponseModel.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;

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

  Future<bool> syncGFData(String startTime, String endTime) async {
    var response;
    String startTime = "";
    String endTime = "";
    await activateGF();

    DateTime lastSynctime = await GetLastSynctime();

    print("lastsynctime $lastSynctime");

    endTime = DateTime.now().millisecondsSinceEpoch.toString();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 1,
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

      //handle more than 3 months logic
    }

    print("Start time $startTime");

    // String startTime = "1577894746000";
    // String endTime = "1585497946000";

    String bpParams = await _gfHelper.getBPSummary(startTime, endTime);
    response = await postGFData(bpParams);
    print("response from BP Sync $response");

    response = "";

    //startTime = "1596911400000";
    //endTime = "1597084200000";

    String weightParams = await _gfHelper.getWeightSummary(startTime, endTime);

    print("WightParam : $weightParams");
    if (weightParams != null) {
      response = await postGFData(weightParams);
      print("response from Weight Sync $response");
    }

    response = "";
    String heartRateParams =
        await _gfHelper.getHeartRateSummary(startTime, endTime);
    //print("Hear Rate Param : $heartRateParams");
    response = await postGFData(heartRateParams);
    print("Response form Heart Sync $response");
  }

  Future<dynamic> postGFData(String params) async {
    try {
      //print("trying to postGFData");
      _deviceHealthRecord = DeviceHealthRecord();
      //var lastsyncDetails = await _deviceHealthRecord.getLastsynctime();
      //print(lastsyncDetails);
      var response = await _deviceHealthRecord.postDeviceData(params);
      //print("response from PostGFData $response");
      return response;
    } catch (e) {
      throw "Sync Google Fit Data to FHB Backend Failed $e";
    }
  }

  Future<dynamic> GetLastSynctime() async {
    try {
      print("Getting Last sync time to synchronize data");
      _deviceHealthRecord = DeviceHealthRecord();

      var lastsyncDetails = await _deviceHealthRecord.getLastsynctime();

      print("body $lastsyncDetails");

      //var response = lastsyncDetails.body;
      String jsonstr = json.encode(lastsyncDetails);

      LastSync lastSync = lastSyncFromJson(jsonstr);
      if (lastSync.response.data.count == 0) return null;
      print(
          "last sync time ${lastSync.response.data.healthRecordInfo[0].lastSyncDateTime}");
      return lastSync.response.data.healthRecordInfo[0].lastSyncDateTime;
    } catch (e) {
      throw "Failed to get Get lastsynctime from FHB DB $e";
    }
  }
}

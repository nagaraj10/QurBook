import 'package:myfhb/device_integration/services/fetchGoogleFitData.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'package:myfhb/device_integration/model/myFHBResponseModel.dart';
import 'package:myfhb/device_integration/model/LastSyncResponse.dart';
import 'dart:convert' show json;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/fhb_parameters.dart' as params;

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
    var response = '';
    String startTime = "";
    String endTime = "";
    String errorString = "";

    if (await isGoogleFitSignedIn()) {
      if (!await _gfHelper.signInSilently()) {
        //if (!await activateGoogleFit()) {
        throw "Failed to login GoogleFit account";
      }
    } else {
      throw "GoogleFit is deactivated. Please activate and sync again";
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
      if (bpParams == params.strDataTypeBP) {
        errorString = '$errorString ${params.strDataTypeBP},';
      } else {
        if (bpParams != null) {
          await postGoogleFitData(bpParams);
        }
      }

      String weightParams =
          await _gfHelper.getWeightSummary(startTime, endTime);
      if (weightParams == params.strWeight) {
        errorString = '$errorString ${params.strWeight},';
      } else {
        if (weightParams != null) {
          await postGoogleFitData(weightParams);
        }
      }

      String heartRateParams =
          await _gfHelper.getHeartRateSummary(startTime, endTime);
      if (heartRateParams == params.strHeartRate) {
        errorString = '$errorString ${params.strHeartRate},';
      } else {
        if (heartRateParams != null) {
          await postGoogleFitData(heartRateParams);
        }
      }

      String glucoseParams =
          await _gfHelper.getBloodGlucoseSummary(startTime, endTime);
      if (glucoseParams == params.strGlusoceLevel) {
        errorString = '$errorString ${params.strGlusoceLevel},';
      } else {
        if (glucoseParams != null) {
          await postGoogleFitData(glucoseParams);
        }
      }

      String temperatureParams =
          await _gfHelper.getBodyTempSummary(startTime, endTime);
      if (temperatureParams == params.strTemperature) {
        errorString = '$errorString ${params.strTemperature},';
      } else {
        if (temperatureParams != null) {
          await postGoogleFitData(temperatureParams);
        }
      }

      String oxygenParams =
          await _gfHelper.getOxygenSaturationSummary(startTime, endTime);
      if (oxygenParams == params.strOxgenSaturation) {
        errorString = '$errorString ${params.strOxgenSaturation},';
      } else {
        if (oxygenParams != null) {
          await postGoogleFitData(oxygenParams);
        }
      }
      if (errorString.isNotEmpty) {
        // throw "$errorString";
      }
      return true;
    } catch (e) {
      throw "Failed to sync GoogleFit Data please try again later";
    }
  }

  Future<dynamic> postGoogleFitData(String params) async {
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
          await _deviceHealthRecord.getLastsynctime(query.qr_LastSyncGF);
      String jsonstr = json.encode(lastsyncDetails);
      LatestSync lastSync = latestSyncFromJson(jsonstr);

      if (!lastSync.isSuccess) {
        return null;
      }
      return lastSync.result.lastSyncDateTime;
    } catch (e) {}
  }
}

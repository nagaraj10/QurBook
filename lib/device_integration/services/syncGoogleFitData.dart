import 'fetchGoogleFitData.dart';
import '../../src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import '../model/myFHBResponseModel.dart';
import '../model/LastSyncResponse.dart';
import 'dart:convert' show json;
import '../../constants/fhb_query.dart' as query;
import '../../constants/fhb_parameters.dart' as params;

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
    final response = '';
    var startTime = '';
    var endTime = '';
    var errorString = '';

    if (await isGoogleFitSignedIn()) {
      if (!await _gfHelper.signInSilently()) {
        //if (!await activateGoogleFit()) {
        throw 'Failed to login GoogleFit account';
      }
    } else {
      throw 'GoogleFit is deactivated. Please activate and sync again';
    }

    final DateTime lastSynctime = await getLastSynctime();

    endTime = DateTime.now().millisecondsSinceEpoch.toString();
    final currentdate = DateTime.now();
    final startT = DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    if (lastSynctime == null) {
      startTime = startT.millisecondsSinceEpoch.toString();
    } else {
      final newstartT = DateTime(lastSynctime.year, lastSynctime.month,
          lastSynctime.day, lastSynctime.hour, lastSynctime.minute + 1);
      startTime = newstartT.millisecondsSinceEpoch.toString();
      // To do handle more than 3 months logic
    }
    try {
      var bpParams = await _gfHelper.getBPSummary(startTime, endTime);
      if (bpParams == params.strDataTypeBP) {
        errorString = '$errorString ${params.strDataTypeBP},';
      } else {
        if (bpParams != null) {
          await postGoogleFitData(bpParams);
        }
      }

      var weightParams = await _gfHelper.getWeightSummary(startTime, endTime);
      if (weightParams == params.strWeight) {
        errorString = '$errorString ${params.strWeight},';
      } else {
        if (weightParams != null) {
          await postGoogleFitData(weightParams);
        }
      }

      var heartRateParams =
          await _gfHelper.getHeartRateSummary(startTime, endTime);
      if (heartRateParams == params.strHeartRate) {
        errorString = '$errorString ${params.strHeartRate},';
      } else {
        if (heartRateParams != null) {
          await postGoogleFitData(heartRateParams);
        }
      }

      var glucoseParams =
          await _gfHelper.getBloodGlucoseSummary(startTime, endTime);
      if (glucoseParams == params.strGlusoceLevel) {
        errorString = '$errorString ${params.strGlusoceLevel},';
      } else {
        if (glucoseParams != null) {
          await postGoogleFitData(glucoseParams);
        }
      }

      final temperatureParams =
          await _gfHelper.getBodyTempSummary(startTime, endTime);
      if (temperatureParams == params.strTemperature) {
        errorString = '$errorString ${params.strTemperature},';
      } else {
        if (temperatureParams != null) {
          await postGoogleFitData(temperatureParams);
        }
      }

      var oxygenParams =
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
      throw 'Failed to sync GoogleFit Data please try again later';
    }
  }

  Future<dynamic> postGoogleFitData(String params) async {
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
          await _deviceHealthRecord.getLastsynctime(query.qr_LastSyncGF);
      final jsonstr = json.encode(lastsyncDetails);
      var lastSync = latestSyncFromJson(jsonstr);

      if (!lastSync.isSuccess) {
        return null;
      }
      return lastSync.result.lastSyncDateTime;
    } catch (e) {}
  }
}

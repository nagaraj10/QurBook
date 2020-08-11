import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:myfhb/database/services/database_helper.dart';
import 'package:myfhb/Device_Integration/services/fetchHealthKitData.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';

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

  Future<void> syncHKT(DateTime startDate, DateTime endDate) async {
    var response = "";

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
      //print("trying to postGFData");
      _deviceHealthRecord = DeviceHealthRecord();
      var response = await _deviceHealthRecord.postDeviceData(params);
      //print("response from PostGFData $response");
      return response;
    } catch (e) {
      throw "Sync HealthKit Fit Data to FHB Backend Failed $e";
    }
  }
}

import 'dart:ffi';

import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'dart:convert' show json;
import 'package:myfhb/constants/fhb_parameters.dart';

class GFDataBaseHelper {
  DeviceHealthRecord _deviceHealthRecord;

  Future<dynamic> postGFData(String params) async {
    try {
      //print("trying to postGFData");
      _deviceHealthRecord = DeviceHealthRecord();
      var response = await _deviceHealthRecord.postDeviceData(params);
      //print("response from PostGFData $response");
      return response;
    } catch (e) {
      throw "Sync Google Fit Data to FHB Backend Failed $e";
    }
  }
}

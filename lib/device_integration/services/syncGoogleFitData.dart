import 'package:myfhb/database/services/database_helper.dart';
import 'package:myfhb/device_integration/services/fetchGoogleFitData.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';

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
    await activateGF();

   // String startTime = "1577894746000";
   // String endTime = "1585497946000";

    String bpParams = await _gfHelper.getBPSummary(startTime, endTime);
    response = await postGFData(bpParams);
    print("response from BP Sync $response");

    response = "";

    String weightParams = await _gfHelper.getWeightSummary(startTime, endTime);
    //print("WightParam : $weightParams");
    response = await postGFData(weightParams);
    print("response from Weight Sync $response");
    
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
      var response = await _deviceHealthRecord.postDeviceData(params);
      //print("response from PostGFData $response");
      return response;
    } catch (e) {
      throw "Sync Google Fit Data to FHB Backend Failed $e";
    }
  }
}

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/NonAdheranceList/NonAdheranceResponseModel.dart';
import 'package:myfhb/src/model/remainderfor_model/RemainderForModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class NonAdheranceRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<RemainderForModel> getRemainderForList() async {

    var response = await _helper.remainderForApi("reference-value/data-codes");
    return RemainderForModel.fromJson(response);
  }

  Future<NonAdheranceResponseModel> getNonAdheranceList() async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var response = await _helper.getNonAdheranceList("activity-master/get-activity-reminder-setting/${userId}?reminderSettingLevel=USER_LEVEL");
    return NonAdheranceResponseModel.fromJson(response);
  }

  Future<NonAdheranceResponseModel> saveNonAdherance(String mins,String patientId,String reminderFor) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var data={
      "remindAfterMins": int.parse(mins),
      "patient": {
        "id": patientId
      },
      "recipientReceiver": {
        "id": userId
      },
      "reminderFor": {
        "id": reminderFor
      },
      "reminderSettingLevel": {
        "id": "4eae1f38-5108-45de-8309-d0147617c625"
      }
    };
    var response = await _helper.saveOrEditNonAdherance("activity-master/activity-reminder-setting",data);
    return NonAdheranceResponseModel.fromJson(response);
  }

  Future<NonAdheranceResponseModel> editNonAdherance(String id,String mins,String patientId,String reminderFor) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var data={
      "id":id,
      "remindAfterMins": mins,
      "patient": {
        "id": patientId
      },
      "recipientReceiver": {
        "id": userId
      },
      "reminderFor": {
        "id": reminderFor
      },
      "reminderSettingLevel": {
        "id": "4eae1f38-5108-45de-8309-d0147617c625"
      }
    };
    var response = await _helper.saveOrEditNonAdherance("activity-master/activity-reminder-setting",data);
    return NonAdheranceResponseModel.fromJson(response);
  }


}

import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/FollowupIn.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Followup {
  String? fee;
  FollowupIn? followupIn;
  int? followupValue;
  String? followupType;

  Followup({this.fee, this.followupIn, this.followupValue, this.followupType});

  Followup.fromJson(Map<String, dynamic> json) {
    try {
      fee = json[parameters.strfee];
      followupIn = json[parameters.strfollowupIn] != null
              ? FollowupIn.fromJson(json[parameters.strfollowupIn])
              : null;
      followupValue = json[parameters.strfollowupValue];
      followupType = json[parameters.strfollowupType];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strfee] = this.fee;
    if (this.followupIn != null) {
      data[parameters.strfollowupIn] = this.followupIn!.toJson();
    }
    data[parameters.strfollowupValue] = this.followupValue;
    data[parameters.strfollowupType] = this.followupType;
    return data;
  }
}

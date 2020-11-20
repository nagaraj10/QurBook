import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/FollowupIn.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Followup {
  String fee;
  FollowupIn followupIn;
  int followupValue;
  String followupType;

  Followup({this.fee, this.followupIn, this.followupValue, this.followupType});

  Followup.fromJson(Map<String, dynamic> json) {
    fee = json[parameters.strfee];
    followupIn = json[parameters.strfollowupIn] != null
        ? new FollowupIn.fromJson(json[parameters.strfollowupIn])
        : null;
    followupValue = json[parameters.strfollowupValue];
    followupType = json[parameters.strfollowupType];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strfee] = this.fee;
    if (this.followupIn != null) {
      data[parameters.strfollowupIn] = this.followupIn.toJson();
    }
    data[parameters.strfollowupValue] = this.followupValue;
    data[parameters.strfollowupType] = this.followupType;
    return data;
  }
}

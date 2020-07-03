import 'package:myfhb/src/model/user/GeneralInfo.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;


class MyProfileData {
  GeneralInfo generalInfo;

  MyProfileData({this.generalInfo});

  MyProfileData.fromJson(Map<String, dynamic> json) {
    generalInfo = json[parameters.strgeneralInfo] != null
        ? new GeneralInfo.fromJson(json[parameters.strgeneralInfo])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.generalInfo != null) {
      data[parameters.strgeneralInfo] = this.generalInfo.toJson();
    }
    return data;
  }
}

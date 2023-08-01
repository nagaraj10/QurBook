
import 'package:myfhb/common/CommonUtil.dart';

import 'LinkedData.dart';
import 'ProfileData.dart';
import '../../constants/fhb_parameters.dart' as parameters;

class SharedToMe {
  ProfileData? profileData;
  LinkedData? linkedData;

  SharedToMe({this.profileData, this.linkedData});

  SharedToMe.fromJson(Map<String, dynamic> json) {
    try {
      profileData = json[parameters.strprofileData] != null
              ? ProfileData.fromJson(json[parameters.strprofileData])
              : null;
      linkedData = json[parameters.strlinkedData] != null
              ? LinkedData.fromJson(json[parameters.strlinkedData])
              : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (profileData != null) {
      data[parameters.strprofileData] = profileData!.toJson();
    }
    if (linkedData != null) {
      data[parameters.strlinkedData] = linkedData!.toJson();
    }
    return data;
  }
}

import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;
import 'LinkedData.dart';
import 'ProfileData.dart';

class Sharedbyme {
  ProfileData? profileData;
  LinkedData? linkedData;

  Sharedbyme({this.profileData, this.linkedData});

  Sharedbyme.fromJson(Map<String, dynamic> json) {
    try {
      profileData = json[parameters.strprofileData] != null
              ? ProfileData.fromJson(json[parameters.strprofileData])
              : null;
      linkedData = json[parameters.strlinkedData] != null
              ? LinkedData.fromJson(json[parameters.strlinkedData])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
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

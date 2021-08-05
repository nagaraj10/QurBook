import 'LinkedData.dart';
import 'ProfileData.dart';
import '../../constants/fhb_parameters.dart' as parameters;

class SharedToMe {
  ProfileData profileData;
  LinkedData linkedData;

  SharedToMe({this.profileData, this.linkedData});

  SharedToMe.fromJson(Map<String, dynamic> json) {
    profileData = json[parameters.strprofileData] != null
        ? ProfileData.fromJson(json[parameters.strprofileData])
        : null;
    linkedData = json[parameters.strlinkedData] != null
        ? LinkedData.fromJson(json[parameters.strlinkedData])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (profileData != null) {
      data[parameters.strprofileData] = profileData.toJson();
    }
    if (linkedData != null) {
      data[parameters.strlinkedData] = linkedData.toJson();
    }
    return data;
  }
}
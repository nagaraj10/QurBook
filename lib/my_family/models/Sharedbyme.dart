import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/my_family/models/LinkedData.dart';
import 'package:myfhb/my_family/models/ProfileData.dart';

class Sharedbyme {
  ProfileData profileData;
  LinkedData linkedData;

  Sharedbyme({this.profileData, this.linkedData});

  Sharedbyme.fromJson(Map<String, dynamic> json) {
    profileData = json[parameters.strprofileData] != null
        ? new ProfileData.fromJson(json[parameters.strprofileData])
        : null;
    linkedData = json[parameters.strlinkedData] != null
        ? new LinkedData.fromJson(json[parameters.strlinkedData])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileData != null) {
      data[parameters.strprofileData] = this.profileData.toJson();
    }
    if (this.linkedData != null) {
      data[parameters.strlinkedData] = this.linkedData.toJson();
    }
    return data;
  }
}

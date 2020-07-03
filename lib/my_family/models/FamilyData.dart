import 'package:myfhb/my_family/models/SharedToMe.dart';
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/my_family/models/VirtualUserParent.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class FamilyData {
  List<Sharedbyme> sharedbyme;
  List<SharedToMe> sharedToMe;
  VirtualUserParent virtualUserParent;

  FamilyData({this.sharedbyme, this.sharedToMe, this.virtualUserParent});

  FamilyData.fromJson(Map<String, dynamic> json) {
    if (json[parameters.strsharedbyme] != null) {
      sharedbyme = new List<Sharedbyme>();
      json[parameters.strsharedbyme].forEach((v) {
        sharedbyme.add(new Sharedbyme.fromJson(v));
      });
    }
    if (json[parameters.strsharedToMe] != null) {
      sharedToMe = new List<SharedToMe>();
      json[parameters.strsharedToMe].forEach((v) {
        sharedToMe.add(new SharedToMe.fromJson(v));
      });
    }
    virtualUserParent = json[parameters.strvirtualUserParent] != null
        ? new VirtualUserParent.fromJson(json[parameters.strvirtualUserParent])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sharedbyme != null) {
      data[parameters.strsharedbyme] = this.sharedbyme.map((v) => v.toJson()).toList();
    }
    if (this.sharedToMe != null) {
      data[parameters.strsharedToMe] = this.sharedToMe.map((v) => v.toJson()).toList();
    }
    if (this.virtualUserParent != null) {
      data[parameters.strvirtualUserParent] = this.virtualUserParent.toJson();
    }
    return data;
  }
}


import 'SharedToMe.dart';
import 'Sharedbyme.dart';
import 'VirtualUserParent.dart';
import '../../constants/fhb_parameters.dart' as parameters;

class FamilyData {
  List<Sharedbyme> sharedbyme;
  List<SharedToMe> sharedToMe;
  VirtualUserParent virtualUserParent;

  FamilyData({this.sharedbyme, this.sharedToMe, this.virtualUserParent});

  FamilyData.fromJson(Map<String, dynamic> json) {
    if (json[parameters.strsharedbyme] != null) {
      sharedbyme = List<Sharedbyme>();
      json[parameters.strsharedbyme].forEach((v) {
        sharedbyme.add(Sharedbyme.fromJson(v));
      });
    }
    if (json[parameters.strsharedToMe] != null) {
      sharedToMe = List<SharedToMe>();
      json[parameters.strsharedToMe].forEach((v) {
        sharedToMe.add(SharedToMe.fromJson(v));
      });
    }
    virtualUserParent = json[parameters.strvirtualUserParent] != null
        ? VirtualUserParent.fromJson(json[parameters.strvirtualUserParent])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (sharedbyme != null) {
      data[parameters.strsharedbyme] = sharedbyme.map((v) => v.toJson()).toList();
    }
    if (sharedToMe != null) {
      data[parameters.strsharedToMe] = sharedToMe.map((v) => v.toJson()).toList();
    }
    if (virtualUserParent != null) {
      data[parameters.strvirtualUserParent] = virtualUserParent.toJson();
    }
    return data;
  }
}


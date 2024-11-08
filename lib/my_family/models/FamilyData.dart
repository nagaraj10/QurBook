
import 'package:myfhb/common/CommonUtil.dart';

import 'SharedToMe.dart';
import 'Sharedbyme.dart';
import 'VirtualUserParent.dart';
import '../../constants/fhb_parameters.dart' as parameters;

class FamilyData {
  List<Sharedbyme>? sharedbyme;
  List<SharedToMe>? sharedToMe;
  VirtualUserParent? virtualUserParent;

  FamilyData({this.sharedbyme, this.sharedToMe, this.virtualUserParent});

  FamilyData.fromJson(Map<String, dynamic> json) {
    try {
      if (json[parameters.strsharedbyme] != null) {
            sharedbyme = <Sharedbyme>[];
            json[parameters.strsharedbyme].forEach((v) {
              sharedbyme!.add(Sharedbyme.fromJson(v));
            });
          }
      if (json[parameters.strsharedToMe] != null) {
            sharedToMe = <SharedToMe>[];
            json[parameters.strsharedToMe].forEach((v) {
              sharedToMe!.add(SharedToMe.fromJson(v));
            });
          }
      virtualUserParent = json[parameters.strvirtualUserParent] != null
              ? VirtualUserParent.fromJson(json[parameters.strvirtualUserParent])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (sharedbyme != null) {
      data[parameters.strsharedbyme] = sharedbyme!.map((v) => v.toJson()).toList();
    }
    if (sharedToMe != null) {
      data[parameters.strsharedToMe] = sharedToMe!.map((v) => v.toJson()).toList();
    }
    if (virtualUserParent != null) {
      data[parameters.strvirtualUserParent] = virtualUserParent!.toJson();
    }
    return data;
  }
}


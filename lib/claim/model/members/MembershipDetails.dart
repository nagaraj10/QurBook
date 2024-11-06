
import 'package:myfhb/claim/model/members/MembershipResult.dart';
import 'package:myfhb/common/CommonUtil.dart';

class MemberShipDetails {
  bool? isSuccess;
  List<MemberShipResult>? result;

  MemberShipDetails({this.isSuccess, this.result});

  MemberShipDetails.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <MemberShipResult>[];
            json['result'].forEach((v) {
              result!.add(new MemberShipResult.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



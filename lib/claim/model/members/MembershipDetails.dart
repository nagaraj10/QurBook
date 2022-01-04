import 'package:myfhb/claim/model/members/MembershipResult.dart';

class MemberShipDetails {
  bool isSuccess;
  List<MemberShipResult> result;

  MemberShipDetails({this.isSuccess, this.result});

  MemberShipDetails.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<MemberShipResult>();
      json['result'].forEach((v) {
        result.add(new MemberShipResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



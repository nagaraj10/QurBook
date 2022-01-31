import 'package:myfhb/claim/model/claimexpiry/ClaimExpiryResult.dart';

class ClaimExpiryResponse {
  bool isSuccess;
  String message;
  List<ClaimExpiryResult> result;

  ClaimExpiryResponse({this.isSuccess, this.result});

  ClaimExpiryResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json.containsKey('message')) {
      message = json['message'];
    }
    if (json.containsKey('result')) {
      if (json['result'] != null) {
        result = <ClaimExpiryResult>[];
        json['result'].forEach((v) {
          result.add(new ClaimExpiryResult.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;

    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

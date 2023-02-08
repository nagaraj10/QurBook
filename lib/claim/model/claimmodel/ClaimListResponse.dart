
import 'package:myfhb/claim/model/claimmodel/ClaimListResult.dart';

class ClaimListResponse {
  bool? isSuccess;
  String? message;
  List<ClaimListResult>? result;

  ClaimListResponse({this.isSuccess, this.result});

  ClaimListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if(json.containsKey('message')){
      message = json['message'];

    }
    if(json.containsKey('result')) {
      if (json['result'] != null) {
        result = new List<ClaimListResult>();
        json['result'].forEach((v) {
          result!.add(new ClaimListResult.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




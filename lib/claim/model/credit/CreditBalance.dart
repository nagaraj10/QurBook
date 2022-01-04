import 'package:myfhb/claim/model/credit/CreditBalanceResult.dart';

class CreditBalance {
  bool isSuccess;
  CreditBalanceResult result;

  CreditBalance({this.isSuccess, this.result});

  CreditBalance.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new CreditBalanceResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}


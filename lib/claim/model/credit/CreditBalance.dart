
import 'package:myfhb/claim/model/credit/CreditBalanceResult.dart';
import 'package:myfhb/common/CommonUtil.dart';

class CreditBalance {
  bool? isSuccess;
  CreditBalanceResult? result;

  CreditBalance({this.isSuccess, this.result});

  CreditBalance.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result =
          json['result'] != null ? CreditBalanceResult.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}


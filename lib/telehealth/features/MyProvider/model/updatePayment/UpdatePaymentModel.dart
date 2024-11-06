
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/UpdatePaymentResult.dart';

class UpdatePaymentModel {
  bool? isSuccess;
  UpdatePaymentResult? result;

  UpdatePaymentModel({this.isSuccess, this.result});

  UpdatePaymentModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result =
          json['result'] != null ? UpdatePaymentResult.fromJson(json['result']) : null;
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




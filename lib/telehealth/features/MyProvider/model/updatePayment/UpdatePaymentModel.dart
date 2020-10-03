import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/UpdatePaymentResult.dart';

class UpdatePaymentModel {
  bool isSuccess;
  UpdatePaymentResult result;

  UpdatePaymentModel({this.isSuccess, this.result});

  UpdatePaymentModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new UpdatePaymentResult.fromJson(json['result']) : null;
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




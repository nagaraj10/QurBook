import 'package:myfhb/telehealth/features/MyProvider/model/appointments/PaymentStatusModel.dart';

class PaymentModel {
  String id;
  PaymentStatusModel paymentStatus;
  String createdOn;
  bool isActive;
  String purpose;
  String paidAmount;
  String transactionDateTime;
  String paymentReference;
  String paidDate;
  String receiptUrl;
  String lastModifiedOn;

  PaymentModel(
      {this.id,
        this.paymentStatus,
        this.createdOn,
        this.isActive,
        this.purpose,
        this.paidAmount,
        this.transactionDateTime,
        this.paymentReference,
        this.paidDate,
        this.receiptUrl,
        this.lastModifiedOn});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentStatus = json['paymentStatus'] != null
        ? new PaymentStatusModel.fromJson(json['paymentStatus'])
        : null;
    createdOn = json['createdOn'];
    isActive = json['isActive'];
    purpose = json['purpose'];
    paidAmount = json['paidAmount'];
    transactionDateTime = json['transactionDateTime'];
    paymentReference = json['paymentReference'];
    paidDate = json['paidDate'];
    receiptUrl = json['receiptUrl'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.paymentStatus != null) {
      data['paymentStatus'] = this.paymentStatus.toJson();
    }
    data['createdOn'] = this.createdOn;
    data['isActive'] = this.isActive;
    data['purpose'] = this.purpose;
    data['paidAmount'] = this.paidAmount;
    data['transactionDateTime'] = this.transactionDateTime;
    data['paymentReference'] = this.paymentReference;
    data['paidDate'] = this.paidDate;
    data['receiptUrl'] = this.receiptUrl;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}
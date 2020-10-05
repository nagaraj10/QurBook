import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/paymentMode.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/refundStatus.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class Refund {
  String createdOn;
  bool isActive;
  PaymentMode paymentMode;
  String refundAmount;
  RefundStatus refundStatus;
  String totalAmount;
  String transactionDateTime;
  String paymentReference;
  String refundReason;
  dynamic refundReference;
  dynamic refundedDate;
  dynamic receiptUrl;
  dynamic lastModifiedOn;
  String id;

  Refund(
      {this.createdOn,
        this.isActive,
        this.paymentMode,
        this.refundAmount,
        this.refundStatus,
        this.totalAmount,
        this.transactionDateTime,
        this.paymentReference,
        this.refundReason,
        this.refundReference,
        this.refundedDate,
        this.receiptUrl,
        this.lastModifiedOn,
        this.id});

  Refund.fromJson(Map<String, dynamic> json) {
    createdOn = json[parameters.strCreatedOn];
    isActive = json[parameters.strIsActive];
    paymentMode = json[parameters.strPaymentMode] != null
        ? new PaymentMode.fromJson(json[parameters.strPaymentMode])
        : null;
    refundAmount = json[parameters.strRefundAmount];
    refundStatus = json[parameters.strRefundStatus] != null
        ? new RefundStatus.fromJson(json[parameters.strRefundStatus])
        : null;
    totalAmount = json[parameters.strTotalAmount];
    transactionDateTime = json[parameters.strTransactionDateTime];
    paymentReference = json[parameters.strPaymentReference];
    refundReason = json[parameters.strRefundReason];
    refundReference = json[parameters.strRefundReference];
    refundedDate = json[parameters.strRefundedDate];
    receiptUrl = json[parameters.strReceiptUrl];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    id = json[parameters.strId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strIsActive] = this.isActive;
    if (this.paymentMode != null) {
      data[parameters.strPaymentMode] = this.paymentMode.toJson();
    }
    data[parameters.strRefundAmount] = this.refundAmount;
    if (this.refundStatus != null) {
      data[parameters.strRefundStatus] = this.refundStatus.toJson();
    }
    data[parameters.strTotalAmount] = this.totalAmount;
    data[parameters.strTransactionDateTime] = this.transactionDateTime;
    data[parameters.strPaymentReference] = this.paymentReference;
    data[parameters.strRefundReason] = this.refundReason;
    data[parameters.strRefundReference] = this.refundReference;
    data[parameters.strRefundedDate] = this.refundedDate;
    data[parameters.strReceiptUrl] = this.receiptUrl;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strId] = this.id;
    return data;
  }
}
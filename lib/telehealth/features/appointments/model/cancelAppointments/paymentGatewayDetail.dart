import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/cancelResponseInfo.dart';
import 'package:myfhb/telehealth/features/appointments/model/createdBy.dart';

import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class PaymentGatewayDetail {
  String sourceId;
  String sourceCode;
  String paymentGatewayRequestId;
  CancelResponseInfo responseInfo;
  CreatedBy createdBy;
  String createdOn;
  CreatedBy lastModifiedBy;
  String lastModifiedOn;
  bool isActive;
  String id;

  PaymentGatewayDetail(
      {this.sourceId,
        this.sourceCode,
        this.paymentGatewayRequestId,
        this.responseInfo,
        this.createdBy,
        this.createdOn,
        this.lastModifiedBy,
        this.lastModifiedOn,
        this.isActive,
        this.id});

  PaymentGatewayDetail.fromJson(Map<String, dynamic> json) {
    sourceId = json[parameters.strSourceId];
    sourceCode = json[parameters.strSourceCode];
    paymentGatewayRequestId = json[parameters.strPaymentGatewayRequestId];
    responseInfo = json[parameters.strResponseInfo] != null
        ? new CancelResponseInfo.fromJson(json[parameters.strResponseInfo])
        : null;
    createdBy = json[[parameters.strCreatedBy]] != null
        ? new CreatedBy.fromJson(json[parameters.strCreatedBy])
        : null;
    createdOn = json[parameters.strCreatedOn];
    lastModifiedBy = json[parameters.strlastModifiedBy] != null
        ? new CreatedBy.fromJson(json[parameters.strlastModifiedBy])
        : null;
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isActive = json[parameters.strIsActive];
    id = json[parameters.strId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strSourceId] = this.sourceId;
    data[parameters.strSourceCode] = this.sourceCode;
    data[parameters.strPaymentGatewayRequestId] = this.paymentGatewayRequestId;
    if (this.responseInfo != null) {
      data[parameters.strResponseInfo] = this.responseInfo.toJson();
    }
    if (this.createdBy != null) {
      data[parameters.strCreatedBy] = this.createdBy.toJson();
    }
    data[parameters.strCreatedOn] = this.createdOn;
    if (this.lastModifiedBy != null) {
      data[parameters.strlastModifiedBy] = this.lastModifiedBy.toJson();
    }
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strId] = this.id;
    return data;
  }
}
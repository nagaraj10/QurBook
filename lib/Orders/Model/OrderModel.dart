import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderModel {
  String orderId;
  DateTime date;
  String feePaid;
  List<String> plans;
  String paymentReferenceId;
  String paymentStatus;
  OrderModel({
    this.orderId,
    this.date,
    this.feePaid,
    this.plans,
    this.paymentReferenceId,
    this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'date': date,
      'feePaid': feePaid,
      'plans': plans,
      'paymentReferenceId': paymentReferenceId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      date: map['date'] != null
          ? DateTime.tryParse(
              map['date'],
            ).toLocal()
          : null,
      feePaid: map['feePaid'] ?? '',
      plans: List<String>.from(map['plans'] ?? [])
        ..removeWhere((element) => element == null),
      paymentReferenceId: map['paymentReferenceId'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, date: $date, feePaid: $feePaid, plans: $plans, paymentReferenceId: $paymentReferenceId,paymentStatus:$paymentStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.orderId == orderId &&
        other.date == date &&
        other.feePaid == feePaid &&
        listEquals(other.plans, plans) &&
        other.paymentReferenceId == paymentReferenceId;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        date.hashCode ^
        feePaid.hashCode ^
        plans.hashCode ^
        paymentReferenceId.hashCode;
  }
}

class OrderDataModel {
  bool isSuccess;
  List<OrderModel> result;
  OrderDataModel({
    this.isSuccess,
    this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'isSuccess': isSuccess,
      'result': result?.map((x) => x.toMap())?.toList(),
    };
  }

  factory OrderDataModel.fromMap(Map<String, dynamic> map) {
    return OrderDataModel(
      isSuccess: map['isSuccess'] ?? false,
      result: List<OrderModel>.from(
          map['result']?.map((x) => OrderModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDataModel.fromJson(String source) =>
      OrderDataModel.fromMap(json.decode(source));

  @override
  String toString() => 'OrderDataModel(isSuccess: $isSuccess, result: $result)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderDataModel &&
        other.isSuccess == isSuccess &&
        listEquals(other.result, result);
  }

  @override
  int get hashCode => isSuccess.hashCode ^ result.hashCode;
}

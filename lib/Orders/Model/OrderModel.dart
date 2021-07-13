import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderModel {
  String orderId;
  String title;
  String imageURL;
  String description;
  String purchaseDate;
  String totalAmount;
  List<OrderPlan> plans;
  OrderModel({
    this.orderId,
    this.title,
    this.imageURL,
    this.description,
    this.purchaseDate,
    this.totalAmount,
    this.plans,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'title': title,
      'imageURL': imageURL,
      'description': description,
      'purchaseDate': purchaseDate,
      'totalAmount': totalAmount,
      'plans': plans?.map((x) => x.toMap())?.toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      title: map['title'],
      imageURL: map['imageURL'],
      description: map['description'],
      purchaseDate: map['purchaseDate'],
      totalAmount: map['totalAmount'],
      plans:
          List<OrderPlan>.from(map['plans']?.map((x) => OrderPlan.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, title: $title, imageURL: $imageURL, description: $description, purchaseDate: $purchaseDate, totalAmount: $totalAmount, plans: $plans)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.orderId == orderId &&
        other.title == title &&
        other.imageURL == imageURL &&
        other.description == description &&
        other.purchaseDate == purchaseDate &&
        other.totalAmount == totalAmount &&
        listEquals(other.plans, plans);
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        title.hashCode ^
        imageURL.hashCode ^
        description.hashCode ^
        purchaseDate.hashCode ^
        totalAmount.hashCode ^
        plans.hashCode;
  }
}

class OrderPlan {
  String title;
  String price;
  OrderPlan({
    this.title,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
    };
  }

  factory OrderPlan.fromMap(Map<String, dynamic> map) {
    return OrderPlan(
      title: map['title'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderPlan.fromJson(String source) =>
      OrderPlan.fromMap(json.decode(source));

  @override
  String toString() => 'OrderPlan(title: $title, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderPlan && other.title == title && other.price == price;
  }

  @override
  int get hashCode => title.hashCode ^ price.hashCode;
}

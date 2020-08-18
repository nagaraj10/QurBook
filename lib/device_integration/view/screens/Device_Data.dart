import 'package:flutter/cupertino.dart';

class DeviceData {
  final String title;
  final String icon;
  int status;
  bool isSelected;
  String value_name;
  String value1;
  String value2;
  Color color;
  DeviceData(
      {this.title,
      this.icon,
      this.status,
      this.isSelected,
      this.value_name,
      this.value1,
      this.value2,
      this.color});
  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
        title: json['title'],
        icon: json['icon'],
        status: json['status'],
        isSelected: json['isSelected'],
        value_name: json['value_name'],
        value1: json['value1'],
        value2: json['value2'],
        color: json['color']);
  }
}

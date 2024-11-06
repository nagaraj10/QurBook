import 'package:flutter/cupertino.dart';

class TroubleShootingModel {
  String name = '';
  bool isPass = false;
 late Widget widget;

  TroubleShootingModel(String name, bool isPass, Widget widget) {
    this.name = name;
    this.isPass = isPass;
    this.widget = widget;
  }
}

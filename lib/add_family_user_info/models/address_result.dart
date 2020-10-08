

import 'package:myfhb/common/CommonConstants.dart';

class AddressResult {
  String id;
  String code;
  String name;

  AddressResult({this.id, this.code, this.name});

  AddressResult.fromJson(Map<String, dynamic> json) {
    id = json[CommonConstants.strId];
    code = json[CommonConstants.strCode];
    name = json[CommonConstants.strName];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonConstants.strId] = this.id;
    data[CommonConstants.strCode] = this.code;
    data[CommonConstants.strName] = this.name;
    return data;
  }
}

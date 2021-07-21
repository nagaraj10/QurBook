

import '../../common/CommonConstants.dart';

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
    final data = <String, dynamic>{};
    data[CommonConstants.strId] = id;
    data[CommonConstants.strCode] = code;
    data[CommonConstants.strName] = name;
    return data;
  }
}

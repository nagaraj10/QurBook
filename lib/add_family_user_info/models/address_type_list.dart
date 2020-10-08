import 'package:myfhb/add_family_user_info/models/address_result.dart';
import 'package:myfhb/common/CommonConstants.dart';

class AddressTypeResult {
  bool isSuccess;
  List<AddressResult> result;

  AddressTypeResult({this.isSuccess, this.result});

  AddressTypeResult.fromJson(Map<String, dynamic> json) {
    isSuccess = json[CommonConstants.strSuccess];
    if (json[CommonConstants.strResult] != null) {
      result = new List<AddressResult>();
      json[CommonConstants.strResult].forEach((v) {
        result.add(new AddressResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonConstants.strSuccess] = this.isSuccess;
    if (this.result != null) {
      data[CommonConstants.strResult] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

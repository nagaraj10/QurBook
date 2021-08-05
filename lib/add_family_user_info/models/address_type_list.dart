import 'address_result.dart';
import '../../common/CommonConstants.dart';

class AddressTypeResult {
  bool isSuccess;
  List<AddressResult> result;

  AddressTypeResult({this.isSuccess, this.result});

  AddressTypeResult.fromJson(Map<String, dynamic> json) {
    isSuccess = json[CommonConstants.strSuccess];
    if (json[CommonConstants.strResult] != null) {
      result = <AddressResult>[];
      json[CommonConstants.strResult].forEach((v) {
        result.add(AddressResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[CommonConstants.strSuccess] = isSuccess;
    if (result != null) {
      data[CommonConstants.strResult] = result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

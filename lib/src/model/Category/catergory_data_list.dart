import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/Category/catergory_result.dart';

class CategoryDataList {
  bool isSuccess;
  List<CategoryResult> result;

  CategoryDataList({this.isSuccess, this.result});

  CategoryDataList.fromJson(Map<String, dynamic> json) {
    isSuccess = json[parameters.strIsSuccess];
    if (json[parameters.strResult] != null) {
      result = new List<CategoryResult>();
      json[parameters.strResult].forEach((v) {
        result.add(new CategoryResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsSuccess] = this.isSuccess;
    if (this.result != null) {
      data[parameters.strResult] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

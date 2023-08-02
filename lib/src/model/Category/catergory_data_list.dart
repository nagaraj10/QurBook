
import 'package:myfhb/common/CommonUtil.dart';

import '../../../constants/fhb_parameters.dart' as parameters;
import 'catergory_result.dart';

class CategoryDataList {
  bool? isSuccess;
  List<CategoryResult>? result;

  CategoryDataList({this.isSuccess, this.result});

  CategoryDataList.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json[parameters.strIsSuccess];
      if (json[parameters.strResult] != null) {
            result = <CategoryResult>[];
            json[parameters.strResult].forEach((v) {
              result!.add(CategoryResult.fromJson(v));
            });
          }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strIsSuccess] = isSuccess;
    if (result != null) {
      data[parameters.strResult] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class CategoryResponseList {
  int status;
  bool success;
  String message;
  Response response;

  CategoryResponseList(
      {this.status, this.success, this.message, this.response});

  CategoryResponseList.fromJson(Map<String, dynamic> json) {
     status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = json[parameters.strResponse] != null
        ? new Response.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   data[parameters.strStatus] = this.status;
    data[parameters.strSuccess] = this.success;
    data[parameters.strMessage] = this.message;
    if (this.response != null) {
      data[parameters.strResponse] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  List<CategoryData> data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json[parameters.strCount];
    if (json[parameters.strData] != null) {
      data = new List<CategoryData>();
      json[parameters.strData].forEach((v) {
        data.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
     data[parameters.strCount] = this.count;
    if (this.data != null) {
      data[parameters.strData] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


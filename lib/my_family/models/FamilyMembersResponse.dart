
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/my_family/models/FamilyData.dart';

class FamilyMembersList {
  int status;
  bool success;
  String message;
  Response response;

  FamilyMembersList({this.status, this.success, this.message, this.response});

  FamilyMembersList.fromJson(Map<String, dynamic> json) {
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
  FamilyData data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    data = json[parameters.strData] != null ? new FamilyData.fromJson(json[parameters.strData]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data[parameters.strData] = this.data.toJson();
    }
    return data;
  }
}


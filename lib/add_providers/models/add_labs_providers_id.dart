import 'package:myfhb/add_providers/models/add_more_data.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class AddLabsProvidersId {
  int status;
  bool success;
  String message;
  Response response;

  AddLabsProvidersId({this.status, this.success, this.message, this.response});

  AddLabsProvidersId.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = json[parameters.strResponse] != null
        ? new Response.fromJson(json[parameters.strResponse])
        : null;
  }
}

class Response {
  int count;
  AddMoreData data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json[parameters.strCount];

    Map<String, dynamic> dic;
    if (json[parameters.strData] != null) {
      dic = json[parameters.strData];
      data = AddMoreData.fromJson(dic);
    } 
  }
}


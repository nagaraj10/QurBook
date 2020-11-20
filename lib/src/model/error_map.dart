import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfhb/authentication/model/error_response_model.dart';

class ErrorMap {
  dynamic createErrorJsonString(http.Response response) {
    ErrorModelResponse errorModelResponse =
        ErrorModelResponse.fromJson(jsonDecode(response.body));
    Map<String, dynamic> errorJson = new Map();
    errorJson["status"] = errorModelResponse.status;
    errorJson["message"] = errorModelResponse.message;
    errorJson['success'] = errorModelResponse.success;

    return errorJson;
  }

  dynamic spocketException() {
    Map<String, dynamic> errorJson = new Map();
    errorJson["status"] = 100;
    errorJson["message"] = 'Something went Wrong';
    errorJson['success'] = false;

    return errorJson;
  }
}

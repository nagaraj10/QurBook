import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../authentication/model/error_response_model.dart';

class ErrorMap {
  dynamic createErrorJsonString(http.Response response) {
    final errorModelResponse =
        ErrorModelResponse.fromJson(jsonDecode(response.body));
    var errorJson = Map<String, dynamic>();
    errorJson['status'] = errorModelResponse.status;
    errorJson['message'] = errorModelResponse.message;
    errorJson['success'] = errorModelResponse.success;

    return errorJson;
  }

  dynamic spocketException() {
    final Map<String, dynamic> errorJson = {};
    errorJson['status'] = 100;
    errorJson['message'] = 'Something went Wrong';
    errorJson['success'] = false;

    return errorJson;
  }
}

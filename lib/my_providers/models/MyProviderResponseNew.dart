import 'MyProviderResponseData.dart';

class MyProvidersResponse {
  bool isSuccess;
  String message;
  MyProvidersResponseData result;

  MyProvidersResponse({this.isSuccess, this.message, this.result});

  MyProvidersResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json.containsKey('result')) {
      result = json['result'] != null
          ? MyProvidersResponseData.fromJson(json['result'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (result != null) {
      data['result'] = result.toJson();
    }
    return data;
  }
}

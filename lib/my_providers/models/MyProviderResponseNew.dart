import 'package:myfhb/my_providers/models/MyProviderResponseData.dart';

class MyProvidersResponse {
  bool isSuccess;
  String message;
  MyProvidersResponseData result;

  MyProvidersResponse({this.isSuccess, this.message, this.result});

  MyProvidersResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'] != null
        ? new MyProvidersResponseData.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

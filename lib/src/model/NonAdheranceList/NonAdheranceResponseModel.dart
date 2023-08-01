
import 'package:myfhb/common/CommonUtil.dart';

import 'Result.dart';

class NonAdheranceResponseModel {
  NonAdheranceResponseModel({
      bool? isSuccess, 
      String? message, 
      List<Result>? result,}){
    _isSuccess = isSuccess;
    _message = message;
    _result = result;
}

  NonAdheranceResponseModel.fromJson(dynamic json) {
    try {
      _isSuccess = json['isSuccess'];
      _message = json['message'];
      if (json['result'] != null) {
            _result = [];
            json['result'].forEach((v) {
              _result!.add(Result.fromJson(v));
            });
          }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }
  bool? _isSuccess;
  String? _message;
  List<Result>? _result;

  bool? get isSuccess => _isSuccess;
  String? get message => _message;
  List<Result>? get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = _isSuccess;
    map['message'] = _message;
    if (_result != null) {
      map['result'] = _result!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
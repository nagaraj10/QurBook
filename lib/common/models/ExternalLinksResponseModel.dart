import 'Result.dart';

class ExternalLinksResponseModel {
  ExternalLinksResponseModel({
      bool isSuccess, 
      List<Result> result,}){
    _isSuccess = isSuccess;
    _result = result;
}

  ExternalLinksResponseModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      _result = [];
      json['result'].forEach((v) {
        _result.add(Result.fromJson(v));
      });
    }
  }
  bool _isSuccess;
  List<Result> _result;

  bool get isSuccess => _isSuccess;
  List<Result> get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = _isSuccess;
    if (_result != null) {
      map['result'] = _result.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
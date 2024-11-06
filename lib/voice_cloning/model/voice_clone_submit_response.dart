import 'package:myfhb/common/CommonUtil.dart';

class VoiceCloneAssignmentResponseModel {
  VoiceCloneAssignmentResponseModel({
    bool? isSuccess,
    String? message,
  }) {
    _isSuccess = isSuccess;
    _message = message;
  }

  VoiceCloneAssignmentResponseModel.fromJson(dynamic json) {
    try {
      _isSuccess = json['isSuccess'];
      _message = json['message'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
  bool? _isSuccess;
  String? _message;

  bool? get isSuccess => _isSuccess;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = _isSuccess;
    map['message'] = _message;
    return map;
  }
}

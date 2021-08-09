import 'package:myfhb/user_plans/model/user_plan_info_model.dart';

class UserPlansResponseModel {
  UserPlansResponseModel({
    this.isSuccess,
    this.result,
  });

  final bool isSuccess;
  final List<UserPlanInfoModel> result;

  factory UserPlansResponseModel.fromJson(Map<String, dynamic> json) =>
      UserPlansResponseModel(
        isSuccess: json['isSuccess'],
        result: json['result'] != null
            ? List<UserPlanInfoModel>.from(
                json['result']?.map((x) => UserPlanInfoModel.fromJson(x ?? {})))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'result': List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

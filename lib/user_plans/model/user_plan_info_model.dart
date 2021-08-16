class UserPlanInfoModel {
  const UserPlanInfoModel({
    this.userId,
    this.userLinkId,
    this.planStartDate,
    this.planPackageName,
    this.planPackageTags,
    this.packageDuration,
    this.packageId,
  });

  final int userId;
  final String userLinkId;
  final DateTime planStartDate;
  final String planPackageName;
  final String planPackageTags;
  final int packageDuration;
  final int packageId;

  factory UserPlanInfoModel.fromJson(Map<String, dynamic> json) =>
      UserPlanInfoModel(
        userId: json['userId'],
        userLinkId: json['userLinkId'],
        planStartDate: DateTime.parse(json['planStartDate']),
        planPackageName: json['planPackageName'],
        planPackageTags: json['planPackageTags'],
        packageDuration: json['packageDuration'],
        packageId: json['packageId'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userLinkId': userLinkId,
        'planStartDate':
            '${planStartDate.year.toString().padLeft(4, '0')}-${planStartDate.month.toString().padLeft(2, '0')}-${planStartDate.day.toString().padLeft(2, '0')}',
        'planPackageName': planPackageName,
        'planPackageTags': planPackageTags,
        'packageDuration': packageDuration,
        'packageId': packageId,
      };
}

class ActivityStatusModel {
  bool isSuccess;
  List<ActivityStatusResult> result;

  ActivityStatusModel({this.isSuccess, this.result});

  ActivityStatusModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = <ActivityStatusResult>[];
      json['result'].forEach((v) {
        result.add(new ActivityStatusResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivityStatusResult {
  String planStatus;
  String curDate;

  ActivityStatusResult({this.planStatus, this.curDate});

  ActivityStatusResult.fromJson(Map<String, dynamic> json) {
    planStatus = json['PlanStatus'];
    curDate = json['CurDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PlanStatus'] = this.planStatus;
    data['CurDate'] = this.curDate;
    return data;
  }
}
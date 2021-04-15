class MyPlanListModel {
  bool isSuccess;
  String message;
  List<MyPlanListResult> result;

  MyPlanListModel({this.isSuccess, this.message, this.result});

  MyPlanListModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<MyPlanListResult>();
      json['result'].forEach((v) {
        result.add(new MyPlanListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyPlanListResult {
  String planPackage;
  String provider;
  String startDate;
  bool planExpired;

  MyPlanListResult({this.planPackage, this.provider, this.startDate,this.planExpired});

  MyPlanListResult.fromJson(Map<String, dynamic> json) {
    planPackage = json['planPackage'];
    provider = json['provider'];
    startDate = json['startDate'];
    planExpired = json['planExpired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planPackage'] = this.planPackage;
    data['provider'] = this.provider;
    data['startDate'] = this.startDate;
    data['startDate'] = this.planExpired;
    return data;
  }
}
class AddPlanSuccessResponse {
  bool isSuccess;
  String result;

  AddPlanSuccessResponse({this.isSuccess, this.result});

  AddPlanSuccessResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['result'] = this.result;
    return data;
  }
}
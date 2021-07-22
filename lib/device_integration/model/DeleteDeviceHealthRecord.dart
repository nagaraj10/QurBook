class DeleteDeviceHealthRecord {
  bool isSuccess;

  DeleteDeviceHealthRecord({this.isSuccess});

  DeleteDeviceHealthRecord.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    return data;
  }
}
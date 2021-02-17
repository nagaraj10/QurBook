class DeleteDeviceHealthRecord {
  bool isSuccess;

  DeleteDeviceHealthRecord({this.isSuccess});

  DeleteDeviceHealthRecord.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    return data;
  }
}
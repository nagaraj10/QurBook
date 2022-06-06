class Payload {
  String type;
  String priority;
  String userId;
  String meetingId;
  String patientId;
  String patientName;
  String patientPicture;
  String userName;
  /*String doctorId;
  String doctorPicture;*/
  String callType;
  String isWeb;
  String patientPhoneNumber;

  Payload(
      {this.type,
      this.priority,
      this.userId,
      this.meetingId,
      this.patientId,
      this.patientName,
      this.patientPicture,
      this.userName,
      /*this.doctorId,
      this.doctorPicture,*/
      this.callType,
      this.isWeb,
      this.patientPhoneNumber});

  Payload.fromJson(Map<String, dynamic> json) {
    try {
      type = json['type'];
      priority = json['priority'];
      userId = json['userId'];
      meetingId = json['meetingId'];
      patientId = json['patientId'];
      patientName = json['patientName'];
      patientPicture = json['patientPicture'];
      userName = json['userName'];
      /*doctorId = json['doctorId'];
      doctorPicture = json['doctorPicture'];*/
      callType = json['callType'];
      isWeb = json['isWeb'];
      patientPhoneNumber = json['patientPhoneNumber'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['type'] = this.type;
      data['priority'] = this.priority;
      data['userId'] = this.userId;
      data['meetingId'] = this.meetingId;
      data['patientId'] = this.patientId;
      data['patientName'] = this.patientName;
      data['patientPicture'] = this.patientPicture;
      data['userName'] = this.userName;
      /*data['doctorId'] = this.doctorId;
      data['doctorPicture'] = this.doctorPicture;*/
      data['callType'] = this.callType;
      data['isWeb'] = this.isWeb;
      data['patientPhoneNumber'] = this.patientPhoneNumber;
    } catch (e) {
      print(e);
    }
    return data;
  }
}

class UpdatedInfo {
  String bookingId;
  String actualStartDateTime;
  String actualEndDateTime;

  UpdatedInfo(
      {this.bookingId, this.actualStartDateTime, this.actualEndDateTime});

  UpdatedInfo.fromJson(Map<String, dynamic> json) {
    bookingId = json['id'];
    actualStartDateTime = json['actualStartDateTime'];
    actualEndDateTime = json['actualEndDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.bookingId;
    data['actualStartDateTime'] = this.actualStartDateTime;
    data['actualEndDateTime'] = this.actualEndDateTime;
    return data;
  }
}

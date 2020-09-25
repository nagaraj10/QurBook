class HealthRecordCollection {
  String id;
  String fileType;
  String healthRecordUrl;
  bool isActive;

  HealthRecordCollection(
      {this.id, this.fileType, this.healthRecordUrl, this.isActive});

  HealthRecordCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileType = json['fileType'];
    healthRecordUrl = json['healthRecordUrl'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileType'] = this.fileType;
    data['healthRecordUrl'] = this.healthRecordUrl;
    data['isActive'] = this.isActive;
    return data;
  }
}

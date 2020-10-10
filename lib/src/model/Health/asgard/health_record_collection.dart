class HealthRecordCollection {
  String id;
  String fileType;
  String healthRecordUrl;
  bool isActive;
  String createdOn;
  String createdBy;

  HealthRecordCollection({this.id,
    this.fileType,
    this.healthRecordUrl,
    this.isActive,
    this.createdOn,
    this.createdBy});

  HealthRecordCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileType = json['fileType'];
    healthRecordUrl = json['healthRecordUrl'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileType'] = this.fileType;
    data['healthRecordUrl'] = this.healthRecordUrl;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['createdBy'] = this.createdBy;
    return data;
  }
}
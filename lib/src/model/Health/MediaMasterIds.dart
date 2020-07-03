class MediaMasterIds {
  String id;
  String fileType;

  MediaMasterIds({this.id, this.fileType});

  MediaMasterIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileType = json['fileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileType'] = this.fileType;
    return data;
  }
}
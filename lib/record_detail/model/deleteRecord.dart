class DeleteRecord {
  List<String> mediaMetaIds;

  DeleteRecord({this.mediaMetaIds});

  DeleteRecord.fromJson(Map<String, dynamic> json) {
    mediaMetaIds = json['mediaMetaIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaMetaIds'] = this.mediaMetaIds;
    return data;
  }
}

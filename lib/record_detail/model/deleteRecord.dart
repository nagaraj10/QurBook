class DeleteRecord {
  List<String> mediaMetaIds;
  List<String> mediaMasterIds;

  DeleteRecord({this.mediaMetaIds,this.mediaMasterIds});

  DeleteRecord.fromJson(Map<String, dynamic> json) {
    mediaMetaIds = json['mediaMetaIds'].cast<String>();
    mediaMasterIds=json['mediaMasterIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaMetaIds'] = this.mediaMetaIds;
    data['mediaMasterIds']=this.mediaMasterIds;
    return data;
  }
}

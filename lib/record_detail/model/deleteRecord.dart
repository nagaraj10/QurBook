import '../../constants/fhb_parameters.dart' as parameters;

class DeleteRecord {
  List<String> mediaMetaIds;
  List<String> mediaMasterIds;

  DeleteRecord({this.mediaMetaIds,this.mediaMasterIds});

  DeleteRecord.fromJson(Map<String, dynamic> json) {
    mediaMetaIds = json[parameters.strMediaMetaIds].cast<String>();
    mediaMasterIds=json[parameters.strmediaMasterIds].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strMediaMetaIds] = mediaMetaIds;
    data[parameters.strmediaMasterIds]=mediaMasterIds;
    return data;
  }
}

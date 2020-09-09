import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Notes {
  Notes({
    this.mediaMetaId,
  });

  String mediaMetaId;

  Notes.fromJson(Map<String, dynamic> json) {
    mediaMetaId = json[parameters.strmediaMetaId] == null
        ? null
        : json[parameters.strmediaMetaId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    {
      data[parameters.strmediaMetaId] = this.mediaMetaId;
      return data;
    }
  }
}

class GetMetaFileURLModel {
  int status;
  bool success;
  String message;
  Response response;

  GetMetaFileURLModel({this.status, this.success, this.message, this.response});

  GetMetaFileURLModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  Data data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<MediaMasterInfo> mediaMasterInfo;

  Data({this.mediaMasterInfo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['mediaMasterInfo'] != null) {
      mediaMasterInfo = new List<MediaMasterInfo>();
      json['mediaMasterInfo'].forEach((v) {
        mediaMasterInfo.add(new MediaMasterInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediaMasterInfo != null) {
      data['mediaMasterInfo'] =
          this.mediaMasterInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MediaMasterInfo {
  String mediaMetaId;
  String mediaMasterId;
  String fileType;
  String fileContent;

  MediaMasterInfo(
      {this.mediaMetaId, this.mediaMasterId, this.fileType, this.fileContent});

  MediaMasterInfo.fromJson(Map<String, dynamic> json) {
    mediaMetaId = json['mediaMetaId'];
    mediaMasterId = json['mediaMasterId'];
    fileType = json['fileType'];
    fileContent = json['fileContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaMetaId'] = this.mediaMetaId;
    data['mediaMasterId'] = this.mediaMasterId;
    data['fileType'] = this.fileType;
    data['fileContent'] = this.fileContent;
    return data;
  }
}
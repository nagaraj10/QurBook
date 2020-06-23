class SavedMetaDataResponse {
  int status;
  bool success;
  String message;
  Response response;

  SavedMetaDataResponse(
      {this.status, this.success, this.message, this.response});

  SavedMetaDataResponse.fromJson(Map<String, dynamic> json) {
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
  SavedMediaData data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data =
        json['data'] != null ? new SavedMediaData.fromJson(json['data']) : null;
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

class SavedMediaData {
  String mediaMetaID;

  SavedMediaData({this.mediaMetaID});

  SavedMediaData.fromJson(Map<String, dynamic> json) {
    mediaMetaID = json['mediaMetaID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaMetaID'] = this.mediaMetaID;
    return data;
  }
}

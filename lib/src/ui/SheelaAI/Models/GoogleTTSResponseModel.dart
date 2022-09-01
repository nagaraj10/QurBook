class GoogleTTSResponseModel {
  bool isSuccess;
  Payload payload;

  GoogleTTSResponseModel({this.isSuccess, this.payload});

  GoogleTTSResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    payload =
        json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
    }
    return data;
  }
}

class Payload {
  String audioContent;

  Payload({this.audioContent});

  Payload.fromJson(Map<String, dynamic> json) {
    audioContent = json['audioContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audioContent'] = this.audioContent;
    return data;
  }
}

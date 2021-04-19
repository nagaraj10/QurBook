class OtherInfo {
  OtherInfo({
    this.needPhoto,
    this.needAudio,
    this.needVideo,
    this.needFile,
  });

  int needPhoto;
  int needAudio;
  int needVideo;
  int needFile;

  OtherInfo.fromJson(Map<String, dynamic> json) {
    needPhoto = json['NeedPhoto'];
    needAudio = json['NeedAudio'];
    needVideo = json['NeedVideo'];
    needFile = json['NeedFile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NeedPhoto'] = this.needPhoto;
    data['NeedAudio'] = this.needAudio;
    data['NeedVideo'] = this.needVideo;
    data['NeedFile'] = this.needFile;
    return data;
  }
}

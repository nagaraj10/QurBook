

class SheelaVoiceIdModel {
  bool? isSuccess;
  Result? result;

  SheelaVoiceIdModel({this.isSuccess, this.result});

  SheelaVoiceIdModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess']??false;
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? id;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedBy;
  String? lastModifiedOn;
  VoiceClone? voiceClone;

  Result(
      {this.id,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedBy,
        this.lastModifiedOn,
        this.voiceClone});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id']??'';
    isActive = json['isActive']??false;
    createdBy = json['createdBy']??'';
    createdOn = json['createdOn']??'';
    lastModifiedBy = json['lastModifiedBy']??'';
    lastModifiedOn = json['lastModifiedOn']??'';
    voiceClone = json['voiceClone'] != null
        ? new VoiceClone.fromJson(json['voiceClone'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.voiceClone != null) {
      data['voiceClone'] = this.voiceClone!.toJson();
    }
    return data;
  }
}

class VoiceClone {
  String? id;
  String? voiceId;
  AdditionalInfo? additionalInfo;
  String? url;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedBy;
  String? lastModifiedOn;

  VoiceClone(
      {this.id,
        this.voiceId,
        this.additionalInfo,
        this.url,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedBy,
        this.lastModifiedOn});

  VoiceClone.fromJson(Map<String, dynamic> json) {
    id = json['id']??'';
    voiceId = json['voiceId']??'';
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    url = json['url']??'';
    isActive = json['isActive']??false;
    createdBy = json['createdBy']??'';
    createdOn = json['createdOn']??'';
    lastModifiedBy = json['lastModifiedBy']??'';
    lastModifiedOn = json['lastModifiedOn']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['voiceId'] = this.voiceId;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
    }
    data['url'] = this.url;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class AdditionalInfo {
  int? fileSize;
  String? fileType;

  AdditionalInfo({this.fileSize, this.fileType});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    fileSize = json['fileSize'];
    fileType = json['fileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileSize'] = this.fileSize;
    data['fileType'] = this.fileType;
    return data;
  }
}

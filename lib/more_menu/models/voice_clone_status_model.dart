class VoiceCloneStatusModel {
  bool? isSuccess;
  Result? result;

  VoiceCloneStatusModel({this.isSuccess, this.result});

  VoiceCloneStatusModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
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
  String? status;
  AdditionalInfo? additionalInfo;
  String? createdOn;
  String? description;
  String? url;

  Result(
      {this.id,
      this.status,
      this.additionalInfo,
      this.createdOn,
      this.description,
      this.url});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    createdOn = json['createdOn'];
    description = json['description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
    }
    data['createdOn'] = this.createdOn;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

class AdditionalInfo {
  int? fileSize;
  String? fileType;
  String? reason;

  AdditionalInfo({this.fileSize, this.fileType});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    fileSize = json['fileSize'];
    fileType = json['fileType'];
    reason = json['declineReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileSize'] = this.fileSize;
    data['fileType'] = this.fileType;
    data['declineReason'] = this.reason;
    return data;
  }
}

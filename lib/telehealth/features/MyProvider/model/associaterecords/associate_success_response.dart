class AssociateSuccessResponse {
  bool isSuccess;
  List<Result> result;

  AssociateSuccessResponse({this.isSuccess, this.result});

  AssociateSuccessResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String id;
  List<HealthRecordShareDetailCollection> healthRecordShareDetailCollection;

  Result({this.id, this.healthRecordShareDetailCollection});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['healthRecordShareDetailCollection'] != null) {
      healthRecordShareDetailCollection =
          new List<HealthRecordShareDetailCollection>();
      json['healthRecordShareDetailCollection'].forEach((v) {
        healthRecordShareDetailCollection
            .add(new HealthRecordShareDetailCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.healthRecordShareDetailCollection != null) {
      data['healthRecordShareDetailCollection'] = this
          .healthRecordShareDetailCollection
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class HealthRecordShareDetailCollection {
  String healthRecordShare;
  String status;
  String startDateTime;
  HealthRecordShareStatus healthRecordShareStatus;
  ModeOfShare modeOfShare;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;
  HealthRecordShareStatus healthRecordMetadata;
  String endDateTime;
  String id;

  HealthRecordShareDetailCollection(
      {this.healthRecordShare,
      this.status,
      this.startDateTime,
      this.healthRecordShareStatus,
      this.modeOfShare,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.healthRecordMetadata,
      this.endDateTime,
      this.id});

  HealthRecordShareDetailCollection.fromJson(Map<String, dynamic> json) {
    healthRecordShare = json['healthRecordShare'];
    status = json['status'];
    startDateTime = json['startDateTime'];
    healthRecordShareStatus = json['healthRecordShareStatus'] != null
        ? new HealthRecordShareStatus.fromJson(json['healthRecordShareStatus'])
        : null;
    modeOfShare = json['modeOfShare'] != null
        ? new ModeOfShare.fromJson(json['modeOfShare'])
        : null;
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    healthRecordMetadata = json['healthRecordMetadata'] != null
        ? new HealthRecordShareStatus.fromJson(json['healthRecordMetadata'])
        : null;
    endDateTime = json['endDateTime'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthRecordShare'] = this.healthRecordShare;
    data['status'] = this.status;
    data['startDateTime'] = this.startDateTime;
    if (this.healthRecordShareStatus != null) {
      data['healthRecordShareStatus'] = this.healthRecordShareStatus.toJson();
    }
    if (this.modeOfShare != null) {
      data['modeOfShare'] = this.modeOfShare.toJson();
    }
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.healthRecordMetadata != null) {
      data['healthRecordMetadata'] = this.healthRecordMetadata.toJson();
    }
    data['endDateTime'] = this.endDateTime;
    data['id'] = this.id;
    return data;
  }
}

class HealthRecordShareStatus {
  String id;

  HealthRecordShareStatus({this.id});

  HealthRecordShareStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class ModeOfShare {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;
  ReferenceData referenceData;

  ModeOfShare(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.sortOrder,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.referenceData});

  ModeOfShare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    sortOrder = json['sortOrder'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    referenceData = json['referenceData'] != null
        ? new ReferenceData.fromJson(json['referenceData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['sortOrder'] = this.sortOrder;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.referenceData != null) {
      data['referenceData'] = this.referenceData.toJson();
    }
    return data;
  }
}

class ReferenceData {
  String id;
  String code;
  String name;
  String description;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;

  ReferenceData(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn});

  ReferenceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';

class GetRecordIdsFilter {
  bool isSuccess;
  List<Result> result;

  GetRecordIdsFilter({this.isSuccess, this.result});

  GetRecordIdsFilter.fromJson(Map<String, dynamic> json) {
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
  String healthRecordTypeId;
  String healthRecordTypeName;
  Metadata metadata;
  String userId;
  bool isBookmarked;
  bool isDraft;
  bool isVisible;
  bool isActive;
  bool isCompleted;
  String doctorId;
  String createdOn;
  List<HealthRecordCollection> healthRecordCollection;

  Result(
      {this.id,
        this.healthRecordTypeId,
        this.healthRecordTypeName,
        this.metadata,
        this.userId,
        this.isBookmarked,
        this.isDraft,
        this.isVisible,
        this.isActive,
        this.isCompleted,
        this.doctorId,
        this.createdOn,
        this.healthRecordCollection});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    healthRecordTypeId = json['healthRecordTypeId'];
    healthRecordTypeName = json['healthRecordTypeName'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    userId = json['userId'];
    isBookmarked = json['isBookmarked'];
    isDraft = json['isDraft'];
    isVisible = json['isVisible'];
    isActive = json['isActive'];
    isCompleted = json['isCompleted'];
    doctorId = json['doctorId'];
    createdOn = json['createdOn'];
    if (json['healthRecordCollection'] != null) {
      healthRecordCollection = new List<HealthRecordCollection>();
      json['healthRecordCollection'].forEach((v) {
        healthRecordCollection.add(new HealthRecordCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['healthRecordTypeId'] = this.healthRecordTypeId;
    data['healthRecordTypeName'] = this.healthRecordTypeName;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    data['userId'] = this.userId;
    data['isBookmarked'] = this.isBookmarked;
    data['isDraft'] = this.isDraft;
    data['isVisible'] = this.isVisible;
    data['isActive'] = this.isActive;
    data['isCompleted'] = this.isCompleted;
    data['doctorId'] = this.doctorId;
    data['createdOn'] = this.createdOn;
    if (this.healthRecordCollection != null) {
      data['healthRecordCollection'] =
          this.healthRecordCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Metadata {
  HealthRecordCategory healthRecordCategory;
  HealthRecordType healthRecordType;
  String memoText;
  bool hasVoiceNotes;
  String dateOfVisit;
  bool isDraft;
  String sourceName;
  String memoTextRaw;
  String idType;
  String fileName;

  Metadata(
      {this.healthRecordCategory,
        this.healthRecordType,
        this.memoText,
        this.hasVoiceNotes,
        this.dateOfVisit,
        this.isDraft,
        this.sourceName,
        this.memoTextRaw,
        this.idType,
        this.fileName});

  Metadata.fromJson(Map<String, dynamic> json) {
    healthRecordCategory = json['healthRecordCategory'] != null
        ? new HealthRecordCategory.fromJson(json['healthRecordCategory'])
        : null;
    healthRecordType = json['healthRecordType'] != null
        ? new HealthRecordType.fromJson(json['healthRecordType'])
        : null;
    memoText = json['memoText'];
    hasVoiceNotes = json['hasVoiceNotes'];
    dateOfVisit = json['dateOfVisit'];
    isDraft = json['isDraft'];
    sourceName = json['sourceName'];
    memoTextRaw = json['memoTextRaw'];
    idType = json['idType'];
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.healthRecordCategory != null) {
      data['healthRecordCategory'] = this.healthRecordCategory.toJson();
    }
    if (this.healthRecordType != null) {
      data['healthRecordType'] = this.healthRecordType.toJson();
    }
    data['memoText'] = this.memoText;
    data['hasVoiceNotes'] = this.hasVoiceNotes;
    data['dateOfVisit'] = this.dateOfVisit;
    data['isDraft'] = this.isDraft;
    data['sourceName'] = this.sourceName;
    data['memoTextRaw'] = this.memoTextRaw;
    data['idType'] = this.idType;
    data['fileName'] = this.fileName;
    return data;
  }
}

class HealthRecordCategory {
  String id;
  String categoryName;
  String categoryDescription;
  String logo;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isDisplay;
  bool isCreate;
  bool isRead;
  bool isEdit;
  bool isDelete;

  HealthRecordCategory(
      {this.id,
        this.categoryName,
        this.categoryDescription,
        this.logo,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.isDisplay,
        this.isCreate,
        this.isRead,
        this.isEdit,
        this.isDelete});

  HealthRecordCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    categoryDescription = json['categoryDescription'];
    logo = json['logo'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isDisplay = json['isDisplay'];
    isCreate = json['isCreate'];
    isRead = json['isRead'];
    isEdit = json['isEdit'];
    isDelete = json['isDelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['categoryDescription'] = this.categoryDescription;
    data['logo'] = this.logo;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isDisplay'] = this.isDisplay;
    data['isCreate'] = this.isCreate;
    data['isRead'] = this.isRead;
    data['isEdit'] = this.isEdit;
    data['isDelete'] = this.isDelete;
    return data;
  }
}

class HealthRecordType {
  String id;
  String name;
  String description;
  String logo;
  String categoryId;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isDisplay;
  bool isCreate;
  bool isRead;
  bool isEdit;
  bool isDelete;
  bool isManualTranscription;
  bool isAITranscription;

  HealthRecordType(
      {this.id,
        this.name,
        this.description,
        this.logo,
        this.categoryId,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.isDisplay,
        this.isCreate,
        this.isRead,
        this.isEdit,
        this.isDelete,
        this.isManualTranscription,
        this.isAITranscription});

  HealthRecordType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logo = json['logo'];
    categoryId = json['categoryId'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isDisplay = json['isDisplay'];
    isCreate = json['isCreate'];
    isRead = json['isRead'];
    isEdit = json['isEdit'];
    isDelete = json['isDelete'];
    isManualTranscription = json['isManualTranscription'];
    isAITranscription = json['isAITranscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['logo'] = this.logo;
    data['categoryId'] = this.categoryId;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isDisplay'] = this.isDisplay;
    data['isCreate'] = this.isCreate;
    data['isRead'] = this.isRead;
    data['isEdit'] = this.isEdit;
    data['isDelete'] = this.isDelete;
    data['isManualTranscription'] = this.isManualTranscription;
    data['isAITranscription'] = this.isAITranscription;
    return data;
  }
}

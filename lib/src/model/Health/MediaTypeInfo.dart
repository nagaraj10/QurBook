import '../../../constants/fhb_parameters.dart' as parameters;

class MediaTypeInfo {
  String categoryId;
  String createdOn;
  String description;
  String id;
  bool isAITranscription;
  bool isActive;
  bool isCreate;
  bool isDelete;
  bool isDisplay;
  bool isEdit;
  bool isManualTranscription;
  bool isRead;
  String lastModifiedOn;
  int localid;
  String logo;
  String name;
  String url;

  MediaTypeInfo(
      {this.categoryId,
      this.createdOn,
      this.description,
      this.id,
      this.isAITranscription,
      this.isActive,
      this.isCreate,
      this.isDelete,
      this.isDisplay,
      this.isEdit,
      this.isManualTranscription,
      this.isRead,
      this.lastModifiedOn,
      this.localid,
      this.logo,
      this.name,
      this.url});

  MediaTypeInfo.fromJson(Map<String, dynamic> json) {
    categoryId = json[parameters.strcategoryId];
    createdOn = json[parameters.strCreatedOn];
    description = json[parameters.strDescription];
    id = json[parameters.strId];
    isAITranscription = json[parameters.strisAITranscription];
    if (json[parameters.strIsActive] is bool) {
      isActive = json[parameters.strIsActive];
    } else {
      isActive = true;
    }

    isCreate = json[parameters.strIsCreate];
    isDelete = json[parameters.strIsDelete];
    isDisplay = json[parameters.strIsDisplay];
    isEdit = json[parameters.strIsEdit];
    isManualTranscription = json[parameters.strisManualTranscription];
    isRead = json[parameters.strIsRead];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    localid = json[parameters.strlocalid];
    logo = json[parameters.strLogo];
    name = json[parameters.strName];
    url = json[parameters.strurl];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strcategoryId] = categoryId;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strDescription] = description;
    data[parameters.strId] = id;
    data[parameters.strisAITranscription] = isAITranscription;
    data[parameters.strIsActive] = isActive;
    data[parameters.strIsCreate] = isCreate;
    data[parameters.strIsDelete] = isDelete;
    data[parameters.strIsDisplay] = isDisplay;
    data[parameters.strIsEdit] = isEdit;
    data[parameters.strisManualTranscription] = isManualTranscription;
    data[parameters.strIsRead] = isRead;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strlocalid] = localid;
    data[parameters.strLogo] = logo;
    data[parameters.strName] = name;
    data[parameters.strurl] = url;
    return data;
  }
}


import '../../constants/fhb_parameters.dart' as parameters;

class MediaTypeInfo {
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

  MediaTypeInfo(
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
    logo = json[parameters.strLogo];
    name = json[parameters.strName];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
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
    data[parameters.strLogo] = logo;
    data[parameters.strName] = name;
    return data;
  }}

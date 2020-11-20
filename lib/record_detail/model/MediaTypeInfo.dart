import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strcategoryId] = this.categoryId;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strDescription] = this.description;
    data[parameters.strId] = this.id;
    data[parameters.strisAITranscription] = this.isAITranscription;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strIsCreate] = this.isCreate;
    data[parameters.strIsDelete] = this.isDelete;
    data[parameters.strIsDisplay] = this.isDisplay;
    data[parameters.strIsEdit] = this.isEdit;
    data[parameters.strisManualTranscription] = this.isManualTranscription;
    data[parameters.strIsRead] = this.isRead;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strLogo] = this.logo;
    data[parameters.strName] = this.name;
    return data;
  }}

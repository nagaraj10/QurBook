import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
    data[parameters.strlocalid] = this.localid;
    data[parameters.strLogo] = this.logo;
    data[parameters.strName] = this.name;
    data[parameters.strurl] = this.url;
    return data;
  }
}


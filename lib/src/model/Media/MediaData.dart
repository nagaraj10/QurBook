import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class MediaData {
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

  MediaData(
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

  MediaData.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
    description = json[parameters.strDescription];
    logo = json[parameters.strLogo];
    categoryId = json[parameters.strcategoryId];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isDisplay = json[parameters.strIsDisplay];
    isCreate = json[parameters.strIsCreate];
    isRead = json[parameters.strIsRead];
    isEdit = json[parameters.strIsEdit];
    isDelete = json[parameters.strIsDelete];
    isManualTranscription = json[parameters.strisManualTranscription];
    isAITranscription = json[parameters.strisAITranscription];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strName] = this.name;
    data[parameters.strDescription] = this.description;
    data[parameters.strLogo] = this.logo;
    data[parameters.strcategoryId] = this.categoryId;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strIsDisplay] = this.isDisplay;
    data[parameters.strIsCreate] = this.isCreate;
    data[parameters.strIsRead] = this.isRead;
    data[parameters.strIsEdit] = this.isEdit;
    data[parameters.strIsDelete] = this.isDelete;
    data[parameters.strisManualTranscription] = this.isManualTranscription;
    data[parameters.strisAITranscription] = this.isAITranscription;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return id +
        name +
        description +
        logo +
        categoryId +
        isActive.toString() +
        createdOn +
        lastModifiedOn +
        isDisplay.toString() +
        isCreate.toString() +
        isRead.toString() +
        isEdit.toString() +
        isDelete.toString() +
        isManualTranscription.toString() +
        isAITranscription.toString();
  }
}

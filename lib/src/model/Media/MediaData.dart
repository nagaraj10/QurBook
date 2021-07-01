import '../../../constants/fhb_parameters.dart' as parameters;

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
    final data = <String, dynamic>{};
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    data[parameters.strDescription] = description;
    data[parameters.strLogo] = logo;
    data[parameters.strcategoryId] = categoryId;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strIsDisplay] = isDisplay;
    data[parameters.strIsCreate] = isCreate;
    data[parameters.strIsRead] = isRead;
    data[parameters.strIsEdit] = isEdit;
    data[parameters.strIsDelete] = isDelete;
    data[parameters.strisManualTranscription] = isManualTranscription;
    data[parameters.strisAITranscription] = isAITranscription;
    return data;
  }

  @override
  String toString() {
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

import '../../../constants/fhb_parameters.dart' as parameters;

class CategoryResult {
  String id;
  String categoryName;
  String categoryDescription;
  String logo;
  bool isDisplay;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isCreate;
  bool isRead;
  bool isEdit;
  bool isDelete;

  CategoryResult(
      {this.id,
      this.categoryName,
      this.categoryDescription,
      this.logo,
      this.isDisplay,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.isCreate,
      this.isRead,
      this.isEdit,
      this.isDelete});

  CategoryResult.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    categoryName = json[parameters.strCategoryName];
    categoryDescription = json[parameters.strCategoryDesc];
    logo = json[parameters.strLogo];
    isDisplay = json[parameters.strIsDisplay];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    if (json.containsKey(parameters.strIsCreate)) {
      isCreate = json[parameters.strIsCreate];
    }
    if (json.containsKey(parameters.strIsRead)) {
      isRead = json[parameters.strIsRead];
    }
    if (json.containsKey(parameters.strIsEdit)) {
      isEdit = json[parameters.strIsEdit];
    }
    if (json.containsKey(parameters.strIsDelete)) {
      isDelete = json[parameters.strIsDelete];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strId] = id;
    data[parameters.strCategoryName] = categoryName;
    data[parameters.strCategoryDesc] = categoryDescription;
    data[parameters.strLogo] = logo;
    data[parameters.strIsDisplay] = isDisplay;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    if (data.containsKey(parameters.strIsCreate)) {
      data[parameters.strIsCreate] = isCreate;
    }
    if (data.containsKey(parameters.strIsRead)) {
      data[parameters.strIsRead] = isRead;
    }
    if (data.containsKey(parameters.strIsEdit)) {
      data[parameters.strIsEdit] = isEdit;
    }
    if (data.containsKey(parameters.strIsDelete)) {
      data[parameters.strIsDelete] = isDelete;
    }

    return data;
  }
}

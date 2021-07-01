import '../../../constants/fhb_parameters.dart' as parameters;

class CategoryData {
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

  CategoryData(
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

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    categoryName = json[parameters.strCategoryName];
    categoryDescription = json[parameters.strCategoryDesc];
    logo = json[parameters.strLogo];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isDisplay = json[parameters.strIsDisplay];
    isCreate = json[parameters.strIsCreate];
    isRead = json[parameters.strIsRead];
    isEdit = json[parameters.strIsEdit];
    isDelete = json[parameters.strIsDelete];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strCategoryName] = categoryName;
    data[parameters.strCategoryDesc] = categoryDescription;
    data[parameters.strLogo] = logo;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strIsDisplay] = isDisplay;
    data[parameters.strIsCreate] = isCreate;
    data[parameters.strIsRead] = isRead;
    data[parameters.strIsEdit] = isEdit;
    data[parameters.strIsDelete] = isDelete;
    return data;
  }
}

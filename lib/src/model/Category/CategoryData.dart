import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strCategoryName] = this.categoryName;
    data[parameters.strCategoryDesc] = this.categoryDescription;
    data[parameters.strLogo] = this.logo;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strIsDisplay] = this.isDisplay;
    data[parameters.strIsCreate] = this.isCreate;
    data[parameters.strIsRead] = this.isRead;
    data[parameters.strIsEdit] = this.isEdit;
    data[parameters.strIsDelete] = this.isDelete;
    return data;
  }
}

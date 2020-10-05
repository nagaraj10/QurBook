import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strCategoryName] = this.categoryName;
    data[parameters.strCategoryDesc] = this.categoryDescription;
    data[parameters.strLogo] = this.logo;
    data[parameters.strIsDisplay] = this.isDisplay;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    if (data.containsKey(parameters.strIsCreate))
      data[parameters.strIsCreate] = this.isCreate;
    if (data.containsKey(parameters.strIsRead))
      data[parameters.strIsRead] = this.isRead;
    if (data.containsKey(parameters.strIsEdit))
      data[parameters.strIsEdit] = this.isEdit;
    if (data.containsKey(parameters.strIsDelete))
      data[parameters.strIsDelete] = this.isDelete;

    return data;
  }
}

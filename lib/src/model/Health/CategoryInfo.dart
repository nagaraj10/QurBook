import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class CategoryInfo {
  String categoryDescription;
  String categoryName;
  String id;
  bool isCreate;
  bool isDelete;
  bool isDisplay;
  bool isEdit;
  bool isRead;
  String logo;
  String url;
  int localid;
  bool isActive;

  CategoryInfo(
      {this.categoryDescription,
      this.categoryName,
      this.id,
      this.isCreate,
      this.isDelete,
      this.isDisplay,
      this.isEdit,
      this.isRead,
      this.logo,
      this.url,
      this.localid,
      this.isActive});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    categoryDescription = json[parameters.strCategoryDesc];
    categoryName = json[parameters.strCategoryName];
    id = json[parameters.strId];
    isCreate = json[parameters.strIsCreate];
    isDelete = json[parameters.strIsDelete];
    isDisplay = json[parameters.strIsDisplay];
    isEdit = json[parameters.strIsEdit];
    isRead = json[parameters.strIsRead];
    logo = json[parameters.strLogo];
    url = json[parameters.strurl];
    localid = json[parameters.strlocalid];
    isActive = json[parameters.strIsActive];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strCategoryDesc] = this.categoryDescription;
    data[parameters.strCategoryName] = this.categoryName;
    data[parameters.strId] = this.id;
    data[parameters.strIsCreate] = this.isCreate;
    data[parameters.strIsDelete] = this.isDelete;
    data[parameters.strIsDisplay] = this.isDisplay;
    data[parameters.strIsEdit] = this.isEdit;
    data[parameters.strIsRead] = this.isRead;
    data[parameters.strLogo] = this.logo;
    data[parameters.strurl] = this.url;
    data[parameters.strlocalid] = this.localid;
    data[parameters.strIsActive] = this.isActive;

    return data;
  }
}
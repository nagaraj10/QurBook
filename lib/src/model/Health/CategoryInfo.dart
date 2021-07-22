import '../../../constants/fhb_parameters.dart' as parameters;

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
    categoryDescription = json[parameters.strCategoryDesc] ?? '';
    categoryName = json[parameters.strCategoryName] ?? '';
    id = json[parameters.strId] ?? '';
    isCreate = json[parameters.strIsCreate]!=null?json[parameters.strurl]:false;
    isDelete = json[parameters.strIsDelete]!=null?json[parameters.strurl]:false;
    isDisplay = json[parameters.strIsDisplay]!=null?json[parameters.strurl]:false;
    isEdit = json[parameters.strIsEdit]!=null?json[parameters.strurl]:false;
    isRead = json[parameters.strIsRead]!=null?json[parameters.strurl]:false;
    logo = json[parameters.strLogo] ?? '';
    url = json[parameters.strurl] ?? '';
    localid = json[parameters.strlocalid] ?? 0;
    isActive = json[parameters.strIsActive]!=null?json[parameters.strurl]:false;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strCategoryDesc] = categoryDescription;
    data[parameters.strCategoryName] = categoryName;
    data[parameters.strId] = id;
    data[parameters.strIsCreate] = isCreate;
    data[parameters.strIsDelete] = isDelete;
    data[parameters.strIsDisplay] = isDisplay;
    data[parameters.strIsEdit] = isEdit;
    data[parameters.strIsRead] = isRead;
    data[parameters.strLogo] = logo;
    data[parameters.strurl] = url;
    data[parameters.strlocalid] = localid;
    data[parameters.strIsActive] = isActive;

    return data;
  }
}
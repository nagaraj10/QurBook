class UserRoleCollection3 {
  String id;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  UserRoleCollection3(
      {this.id, this.isActive, this.createdOn, this.lastModifiedOn});

  UserRoleCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}
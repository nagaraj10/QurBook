class ReminderSettingLevel {
  ReminderSettingLevel({
      String id, 
      String code, 
      String name, 
      String description, 
      int sortOrder, 
      bool isActive, 
      String createdBy, 
      String createdOn, 
      dynamic lastModifiedOn,}){
    _id = id;
    _code = code;
    _name = name;
    _description = description;
    _sortOrder = sortOrder;
    _isActive = isActive;
    _createdBy = createdBy;
    _createdOn = createdOn;
    _lastModifiedOn = lastModifiedOn;
}

  ReminderSettingLevel.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _name = json['name'];
    _description = json['description'];
    _sortOrder = json['sortOrder'];
    _isActive = json['isActive'];
    _createdBy = json['createdBy'];
    _createdOn = json['createdOn'];
    _lastModifiedOn = json['lastModifiedOn'];
  }
  String _id;
  String _code;
  String _name;
  String _description;
  int _sortOrder;
  bool _isActive;
  String _createdBy;
  String _createdOn;
  dynamic _lastModifiedOn;

  String get id => _id;
  String get code => _code;
  String get name => _name;
  String get description => _description;
  int get sortOrder => _sortOrder;
  bool get isActive => _isActive;
  String get createdBy => _createdBy;
  String get createdOn => _createdOn;
  dynamic get lastModifiedOn => _lastModifiedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['name'] = _name;
    map['description'] = _description;
    map['sortOrder'] = _sortOrder;
    map['isActive'] = _isActive;
    map['createdBy'] = _createdBy;
    map['createdOn'] = _createdOn;
    map['lastModifiedOn'] = _lastModifiedOn;
    return map;
  }

}
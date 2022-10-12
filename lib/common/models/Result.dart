import 'ConfigurationData.dart';

class Result {
  Result({
      String id, 
      String code, 
      String name, 
      ConfigurationData configurationData, 
      bool isActive, 
      String createdOn, 
      dynamic lastModifiedOn,}){
    _id = id;
    _code = code;
    _name = name;
    _configurationData = configurationData;
    _isActive = isActive;
    _createdOn = createdOn;
    _lastModifiedOn = lastModifiedOn;
}

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _name = json['name'];
    _configurationData = json['configurationData'] != null ? ConfigurationData.fromJson(json['configurationData']) : null;
    _isActive = json['isActive'];
    _createdOn = json['createdOn'];
    _lastModifiedOn = json['lastModifiedOn'];
  }
  String _id;
  String _code;
  String _name;
  ConfigurationData _configurationData;
  bool _isActive;
  String _createdOn;
  dynamic _lastModifiedOn;

  String get id => _id;
  String get code => _code;
  String get name => _name;
  ConfigurationData get configurationData => _configurationData;
  bool get isActive => _isActive;
  String get createdOn => _createdOn;
  dynamic get lastModifiedOn => _lastModifiedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['name'] = _name;
    if (_configurationData != null) {
      map['configurationData'] = _configurationData.toJson();
    }
    map['isActive'] = _isActive;
    map['createdOn'] = _createdOn;
    map['lastModifiedOn'] = _lastModifiedOn;
    return map;
  }

}
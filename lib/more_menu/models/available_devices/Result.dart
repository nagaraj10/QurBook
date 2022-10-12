import 'SystemConfiguration.dart';

class Result {
  Result({
      String name, 
      bool isPaired, 
      String externalSourceId, 
      List<SystemConfiguration> systemConfiguration,}){
    _name = name;
    _isPaired = isPaired;
    _externalSourceId = externalSourceId;
    _systemConfiguration = systemConfiguration;
}

  Result.fromJson(dynamic json) {
    _name = json['name'];
    _isPaired = json['isPaired'];
    _externalSourceId = json['externalSourceId'];
    if (json['systemConfiguration'] != null) {
      _systemConfiguration = [];
      json['systemConfiguration'].forEach((v) {
        _systemConfiguration.add(SystemConfiguration.fromJson(v));
      });
    }
  }
  String _name;
  bool _isPaired;
  String _externalSourceId;
  List<SystemConfiguration> _systemConfiguration;

  String get name => _name;
  bool get isPaired => _isPaired;
  String get externalSourceId => _externalSourceId;
  List<SystemConfiguration> get systemConfiguration => _systemConfiguration;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['isPaired'] = _isPaired;
    map['externalSourceId'] = _externalSourceId;
    if (_systemConfiguration != null) {
      map['systemConfiguration'] = _systemConfiguration.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
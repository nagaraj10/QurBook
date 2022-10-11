import 'ConfigData.dart';

class ConfigurationData {
  ConfigurationData({
      List<ConfigData> configData,}){
    _configData = configData;
}

  ConfigurationData.fromJson(dynamic json) {
    if (json['configData'] != null) {
      _configData = [];
      json['configData'].forEach((v) {
        _configData.add(ConfigData.fromJson(v));
      });
    }
  }
  List<ConfigData> _configData;

  List<ConfigData> get configData => _configData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_configData != null) {
      map['configData'] = _configData.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
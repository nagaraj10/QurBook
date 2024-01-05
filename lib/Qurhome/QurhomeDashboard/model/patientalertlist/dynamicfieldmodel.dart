import 'package:myfhb/common/CommonUtil.dart';

class DynamicFieldModel {
  dynamic? amax;
  dynamic? amin;
  dynamic? type;
  dynamic? vmax;
  dynamic? vmin;
  int? alarm;
  dynamic? value;
  dynamic? display;
  dynamic? description;
  dynamic seq;
  dynamic commonValue;
  dynamic title;

  DynamicFieldModel(
      {this.amax,
      this.amin,
      this.type,
      this.vmax,
      this.vmin,
      this.alarm,
      this.value,
      this.display,
      this.description});

  DynamicFieldModel.fromJson(String title, Map<String, dynamic> json) {
    try {
      title = title;
      amax = json.containsKey('amax') ? json['amax'] : '';
      seq = json.containsKey('seq') ? json['seq'] : '';

      amin = json.containsKey('amin') ? json['amin'] : '';
      type = json.containsKey('type') ? json['type'] : '';
      vmax = json.containsKey('vmax') ? json['vmax'] : '';
      vmin = json.containsKey('vmin') ? json['vmin'] : '';
      alarm = json.containsKey('alarm') ? json['alarm'] : 0;
      value = json.containsKey('value') ? json['value'] : '';
      display = json.containsKey('display') ? json['display'] : '';
      description = json.containsKey('description') ? json['description'] : '';
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amax'] = this.amax;
    data['amin'] = this.amin;
    data['type'] = this.type;
    data['vmax'] = this.vmax;
    data['vmin'] = this.vmin;
    data['alarm'] = this.alarm;
    data['value'] = this.value;
    data['display'] = this.display;
    data['description'] = this.description;
    data['seq'] = this.seq;

    return data;
  }
}

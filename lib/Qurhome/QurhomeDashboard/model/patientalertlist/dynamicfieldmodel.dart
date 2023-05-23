class DynamicFieldModel {
  String? amax;
  String? amin;
  String? type;
  String? vmax;
  String? vmin;
  int? alarm;
  String? value;
  String? display;
  String? description;
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
    title = title;
    amax = json['amax'];
    amin = json['amin'];
    type = json['type'];
    vmax = json['vmax'];
    vmin = json['vmin'];
    alarm = json['alarm'];
    value = json['value'];
    display = json['display'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amax'] = this.amax;
    data['amin'] = this.amin;
    data['type'] = this.type;
    data['vmax'] = this.vmax;
    data['vmin'] = this.vmin;
    data['alarm'] = this.alarm;
    data['value'] = this.value;
    data['display'] = this.display;
    data['description'] = this.description;
    return data;
  }
}

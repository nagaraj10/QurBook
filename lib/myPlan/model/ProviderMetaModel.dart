class ProviderMetaModel {
  String icon;

  ProviderMetaModel({this.icon});

  ProviderMetaModel.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['icon'] = icon;
    return data;
  }
}

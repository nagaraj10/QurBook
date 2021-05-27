class ProviderMetaModel {
  String icon;

  ProviderMetaModel({this.icon});

  ProviderMetaModel.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    return data;
  }
}

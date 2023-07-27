
import 'package:myfhb/common/CommonUtil.dart';

class ProviderMetaModel {
  String? icon;

  ProviderMetaModel({this.icon});

  ProviderMetaModel.fromJson(Map<String, dynamic> json) {
    try {
      icon = json['icon'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['icon'] = icon;
    return data;
  }
}

import 'package:myfhb/common/CommonUtil.dart';

class BookedAdditionalInfo {
  BookedAdditionalInfo({
    this.title,
    this.Address,
    this.description,
    this.serviceType,
    this.fee,
    this.provider_name,
    this.healthOrganizationId,
  });

  String? title;
  String? Address;
  String? description;
  String? serviceType;
  String? lab_name;
  String? provider_name;
  String? healthOrganizationId;

  int? fee;

  BookedAdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      title = json.containsKey('title') ? json["title"] : '';
      Address = json.containsKey('Address') ? json["Address"] : '';
      description = json.containsKey('description') ? json["description"] : '';
      serviceType = json.containsKey('serviceType') ? json["serviceType"] : '';
      lab_name = json.containsKey('lab_name') ? json["lab_name"] : '';
      provider_name =
          json.containsKey('provider_name') ? json["provider_name"] : null;
      healthOrganizationId = json.containsKey('healthOrganizationId')
          ? json["healthOrganizationId"]
          : null;

      fee = json.containsKey('fee') ? json["fee"] : 0;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = title;
    data['Address'] = Address;
    data['description'] = description;
    data['serviceType'] = serviceType;
    data['lab_name'] = lab_name;

    data['fee'] = fee;
  }
}

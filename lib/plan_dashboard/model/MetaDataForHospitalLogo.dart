
import 'package:myfhb/common/CommonUtil.dart';

class MetaDataForHospitalLogo {
  String? icon;
  String? address;
  String? city;
  String? zip;
  String? descriptionURL;
  String? siteURL;

  MetaDataForHospitalLogo(
      {this.icon,
        this.address,
        this.city,
        this.zip,
        this.descriptionURL,
        this.siteURL});

  MetaDataForHospitalLogo.fromJson(Map<String, dynamic> json) {
    try {
      icon = json['icon'];
      address = json['Address'];
      city = json['City'];
      zip = json['Zip'];
      descriptionURL = json['DescriptionURL'];
      siteURL = json['SiteURL'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['icon'] = icon;
    data['Address'] = address;
    data['City'] = city;
    data['Zip'] = zip;
    data['DescriptionURL'] = descriptionURL;
    data['SiteURL'] = siteURL;
    return data;
  }
}
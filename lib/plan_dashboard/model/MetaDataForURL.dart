
import 'package:myfhb/common/CommonUtil.dart';

class MetaDataForURL {
  String? icon;
  String? details;
  String? description;
  String? descriptionURL;
  String? diseases;
  String? diseaseIcon;
  String? doctorName;

  MetaDataForURL(
      {this.icon, this.details, this.description, this.descriptionURL,this.diseases,this.diseaseIcon,this.doctorName});

  MetaDataForURL.fromJson(Map<String, dynamic> json) {
    try {
      icon = json['icon'];
      details = json['Details'];
      description = json['Description'];
      descriptionURL = json['DescriptionURL'];
      diseases = json['Disease'];
      diseaseIcon = json['DiseaseIcon'];
      doctorName = json['DoctorName'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['icon'] = icon;
    data['Details'] = details;
    data['Description'] = description;
    data['DescriptionURL'] = descriptionURL;
    data['Disease'] = diseases;
    data['DiseaseIcon'] = diseaseIcon;
    data['DoctorName'] = doctorName;
    return data;
  }
}
class MetaDataForURL {
  String icon;
  String details;
  String description;
  String descriptionURL;
  String diseases;
  String diseaseIcon;
  String doctorName;

  MetaDataForURL(
      {this.icon, this.details, this.description, this.descriptionURL,this.diseases,this.diseaseIcon,this.doctorName});

  MetaDataForURL.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    details = json['Details'];
    description = json['Description'];
    descriptionURL = json['DescriptionURL'];
    diseases = json['Disease'];
    diseaseIcon = json['DiseaseIcon'];
    doctorName = json['DoctorName'];
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
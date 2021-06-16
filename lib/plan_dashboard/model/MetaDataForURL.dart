class MetaDataForURL {
  String icon;
  String details;
  String description;
  String descriptionURL;
  String diseases;
  String diseaseIcon;

  MetaDataForURL(
      {this.icon, this.details, this.description, this.descriptionURL,this.diseases,this.diseaseIcon});

  MetaDataForURL.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    details = json['Details'];
    description = json['Description'];
    descriptionURL = json['DescriptionURL'];
    diseases = json['Disease'];
    diseaseIcon = json['DiseaseIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['Details'] = this.details;
    data['Description'] = this.description;
    data['DescriptionURL'] = this.descriptionURL;
    data['Disease'] = this.diseases;
    data['DiseaseIcon'] = this.diseaseIcon;
    return data;
  }
}
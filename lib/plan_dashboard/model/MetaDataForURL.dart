class MetaDataForURL {
  String icon;
  String details;
  String description;
  String descriptionURL;

  MetaDataForURL(
      {this.icon, this.details, this.description, this.descriptionURL});

  MetaDataForURL.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    details = json['Details'];
    description = json['Description'];
    descriptionURL = json['DescriptionURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['Details'] = this.details;
    data['Description'] = this.description;
    data['DescriptionURL'] = this.descriptionURL;
    return data;
  }
}
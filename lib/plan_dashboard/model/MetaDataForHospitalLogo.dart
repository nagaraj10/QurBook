class MetaDataForHospitalLogo {
  String icon;
  String address;
  String city;
  String zip;
  String descriptionURL;
  String siteURL;

  MetaDataForHospitalLogo(
      {this.icon,
        this.address,
        this.city,
        this.zip,
        this.descriptionURL,
        this.siteURL});

  MetaDataForHospitalLogo.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    address = json['Address'];
    city = json['City'];
    zip = json['Zip'];
    descriptionURL = json['DescriptionURL'];
    siteURL = json['SiteURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['Address'] = this.address;
    data['City'] = this.city;
    data['Zip'] = this.zip;
    data['DescriptionURL'] = this.descriptionURL;
    data['SiteURL'] = this.siteURL;
    return data;
  }
}
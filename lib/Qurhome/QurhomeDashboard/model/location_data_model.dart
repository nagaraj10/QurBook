class LocationDataModel {
  String status;
  String country;
  String countryCode;
  String region;
  String regionName;
  String city;
  String zip;
  double lat;
  double lon;
  String timezone;
  String isp;
  String org;
  String as;
  String query;

  LocationDataModel(
      {this.status,
      this.country,
      this.countryCode,
      this.region,
      this.regionName,
      this.city,
      this.zip,
      this.lat,
      this.lon,
      this.timezone,
      this.isp,
      this.org,
      this.as,
      this.query});

  LocationDataModel.fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      country = json['country'];
      countryCode = json['countryCode'];
      region = json['region'];
      regionName = json['regionName'];
      city = json['city'];
      zip = json['zip'];
      lat = json['lat'];
      lon = json['lon'];
      timezone = json['timezone'];
      isp = json['isp'];
      org = json['org'];
      as = json['as'];
      query = json['query'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['status'] = this.status;
      data['country'] = this.country;
      data['countryCode'] = this.countryCode;
      data['region'] = this.region;
      data['regionName'] = this.regionName;
      data['city'] = this.city;
      data['zip'] = this.zip;
      data['lat'] = this.lat;
      data['lon'] = this.lon;
      data['timezone'] = this.timezone;
      data['isp'] = this.isp;
      data['org'] = this.org;
      data['as'] = this.as;
      data['query'] = this.query;
    } catch (e) {
      print(e);
    }
    return data;
  }
}

class Location {
  String latitude;
  String longitude;
  String addressLine;
  String countryName;
  String countryCode;
  String featureName;
  String postalCode;
  String adminArea;
  String subAdminArea;
  String locality;
  String subLocality;
  String thoroughfare;
  String subThoroughfare;

  Location(
      {this.latitude,
      this.longitude,
      this.addressLine,
      this.countryName,
      this.countryCode,
      this.featureName,
      this.postalCode,
      this.adminArea,
      this.subAdminArea,
      this.locality,
      this.subLocality,
      this.thoroughfare,
      this.subThoroughfare});

  Location.fromJson(Map<String, dynamic> json) {
    try {
      latitude = json['latitude'];
      longitude = json['longitude'];
      addressLine = json['addressLine'];
      countryName = json['countryName'];
      countryCode = json['countryCode'];
      featureName = json['featureName'];
      postalCode = json['postalCode'];
      adminArea = json['adminArea'];
      subAdminArea = json['subAdminArea'];
      locality = json['locality'];
      subLocality = json['subLocality'];
      thoroughfare = json['thoroughfare'];
      subThoroughfare = json['subThoroughfare'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['latitude'] = this.latitude;
      data['longitude'] = this.longitude;
      data['addressLine'] = this.addressLine;
      data['countryName'] = this.countryName;
      data['countryCode'] = this.countryCode;
      data['featureName'] = this.featureName;
      data['postalCode'] = this.postalCode;
      data['adminArea'] = this.adminArea;
      data['subAdminArea'] = this.subAdminArea;
      data['locality'] = this.locality;
      data['subLocality'] = this.subLocality;
      data['thoroughfare'] = this.thoroughfare;
      data['subThoroughfare'] = this.subThoroughfare;
    } catch (e) {
      print(e);
    }
    return data;
  }
}

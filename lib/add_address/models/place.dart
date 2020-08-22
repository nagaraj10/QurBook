import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;

class Place {
  final String title;
  final String description;
  final String placeId;

  Place({this.title, this.description, this.placeId});

  Place.fromJson(Map<String, dynamic> json)
      : this.title = json[parameters.strTerms][0][parameters.strvalue],
        this.description = json[parameters.strDescription],
        this.placeId = json[parameters.strplace_id];

  Map<String, dynamic> toMap() {
    return {
      parameters.strtitle: this.title,
      parameters.strDescription: this.description,
      parameters.strplaceId: this.placeId,
    };
  }
}

class PlaceDetail {
  final String placeId;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final String name;
  final double rating;
  final String vicinity;
  final String website;
  final String url;
  final double lat;
  final double lng;

  PlaceDetail({
    this.placeId,
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.name,
    this.rating,
    this.vicinity,
    this.website = '',
    this.url,
    this.lat,
    this.lng,
  });

  PlaceDetail.fromJson(Map<String, dynamic> json)
      : this.placeId = json[parameters.strplace_id],
        this.formattedAddress = json[parameters.strformatted_address],
        this.formattedPhoneNumber = json[parameters.strformatted_phone_number],
        this.name = json[parameters.strName],
        this.rating = json[parameters.strrating].toDouble(),
        this.vicinity = json[parameters.strvicinity],
        this.website = json[parameters.strWebsite] ?? '',
        this.url = json[parameters.strurl] ?? '',
        this.lat = json[parameters.strgeometry][parameters.strlocation]
            [parameters.strlat],
        this.lng = json[parameters.strgeometry][parameters.strlocation]
            [parameters.strlng];

  Map<String, dynamic> toMap() {
    return {
      parameters.strplaceId: this.placeId,
      variable.strformateedAddress: this.formattedAddress,
      variable.strformateedPhoneNumber: this.formattedPhoneNumber,
      parameters.strName: this.name,
      parameters.strrating: this.rating,
      parameters.strvicinity: this.vicinity,
      parameters.strWebsite: this.website,
      parameters.strurl: this.url,
      parameters.strlat: this.lat,
      parameters.strlng: this.lng,
    };
  }
}

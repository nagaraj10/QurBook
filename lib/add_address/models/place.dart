import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/variable_constant.dart' as variable;

class Place {
  final String title;
  final String description;
  final String placeId;

  Place({this.title, this.description, this.placeId});

  Place.fromJson(Map<String, dynamic> json)
      : title = json[parameters.strTerms][0][parameters.strvalue],
        description = json[parameters.strDescription],
        placeId = json[parameters.strplace_id];

  Map<String, dynamic> toMap() {
    return {
      parameters.strtitle: title,
      parameters.strDescription: description,
      parameters.strplaceId: placeId,
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
      : placeId = json[parameters.strplace_id],
        formattedAddress = json[parameters.strformatted_address],
        formattedPhoneNumber = json[parameters.strformatted_phone_number],
        name = json[parameters.strName],
        rating = json[parameters.strrating].toDouble(),
        vicinity = json[parameters.strvicinity],
        website = json[parameters.strWebsite] ?? '',
        url = json[parameters.strurl] ?? '',
        lat = json[parameters.strgeometry][parameters.strlocation]
            [parameters.strlat],
        lng = json[parameters.strgeometry][parameters.strlocation]
            [parameters.strlng];

  Map<String, dynamic> toMap() {
    return {
      parameters.strplaceId: placeId,
      variable.strformateedAddress: formattedAddress,
      variable.strformateedPhoneNumber: formattedPhoneNumber,
      parameters.strName: name,
      parameters.strrating: rating,
      parameters.strvicinity: vicinity,
      parameters.strWebsite: website,
      parameters.strurl: url,
      parameters.strlat: lat,
      parameters.strlng: lng,
    };
  }
}

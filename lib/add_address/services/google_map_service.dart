import 'dart:convert';

import 'package:myfhb/src/resources/network/api_services.dart';
import '../models/place.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';

import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/webservice_call.dart';
import '../../constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/resources/network/api_services.dart';

class GoogleMapServices {
  final String sessionToken;

  GoogleMapServices({this.sessionToken});

  Future<List<Place>> getSuggestions(String query) async {
    final webserviceCall = WebserviceCall();

    final response = await ApiServices.get(
        webserviceCall.getQueryForSuggestion(sessionToken, query));
    var responseData = json.decode(response.body);
    var predictions = responseData[parameters.strpredictions];

    var suggestions = <Place>[];

    for (var i = 0; i < predictions.length; i++) {
      var place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }

    return suggestions;
  }

  Future<PlaceDetail> getPlaceDetail(String placeId, String token) async {
    final webserviceCall = WebserviceCall();

    final response = await ApiServices.get(
        webserviceCall.getQueryForPlaceDetail(placeId, token));
    var responseData = json.decode(response.body);
    var result = responseData[parameters.dataResult];

    final placeDetail = PlaceDetail.fromJson(result);

    return placeDetail;
  }

  static Future<String> getAddrFromLocation(double lat, double lng) async {
    final webserviceCall = WebserviceCall();

    final response =
        await ApiServices.get(webserviceCall.queryAddrFromLocation(lat, lng));
    var responseData = json.decode(response.body);
    var formattedAddr =
        responseData[parameters.strresults][0][parameters.strformatted_address];

    return formattedAddr;
  }

  static String getStaticMap(double latitude, double longitude) {
    return '${CommonUtil.GOOGLE_STATIC_MAP_URL}$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=${GoogleApiKey.place_key}';
  }
}

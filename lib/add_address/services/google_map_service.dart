import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myfhb/add_address/models/place.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';

import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/webservice_call.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;




class GoogleMapServices {
  final String sessionToken;

  GoogleMapServices({this.sessionToken});


  Future<List<Place>> getSuggestions(String query) async {
    
  WebserviceCall webserviceCall=new WebserviceCall();

    final http.Response response = await http.get(webserviceCall.getQueryForSuggestion(sessionToken,query));
    final responseData = json.decode(response.body);
    final predictions = responseData[parameters.strpredictions];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }

    return suggestions;
  }

  Future<PlaceDetail> getPlaceDetail(String placeId, String token) async {
      WebserviceCall webserviceCall=new WebserviceCall();


    final http.Response response = await http.get(webserviceCall.getQueryForPlaceDetail( placeId,  token));
    final responseData = json.decode(response.body);
    final result = responseData[parameters.strresult];

    final PlaceDetail placeDetail = PlaceDetail.fromJson(result);

    return placeDetail;
  }

  static Future<String> getAddrFromLocation(double lat, double lng) async {
     WebserviceCall webserviceCall=new WebserviceCall();


    final http.Response response = await http.get(webserviceCall.queryAddrFromLocation(lat,lng));
    final responseData = json.decode(response.body);
    final formattedAddr = responseData[parameters.strresults][0][parameters.strformatted_address];

    return formattedAddr;
  }

  static String getStaticMap(double latitude, double longitude) {
    return '${CommonUtil.GOOGLE_STATIC_MAP_URL}$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=${GoogleApiKey.place_key}';
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myfhb/add_address/models/place.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/ui/MyRecordClone.dart';

class GoogleMapServices {
  final String sessionToken;

  GoogleMapServices({this.sessionToken});

  Future<List<Place>> getSuggestions(String query) async {
    final String baseUrl =
        CommonUtil.GOOGLE_MAP_URL;
    String type = 'establishment';
    String url =
        '$baseUrl?input=$query&key=${GoogleApiKey.place_key}&type=$type&radius=500&language=en&components=country:IN&sessiontoken=$sessionToken';


    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final predictions = responseData['predictions'];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }

    return suggestions;
  }

  Future<PlaceDetail> getPlaceDetail(String placeId, String token) async {
    final String baseUrl =
        CommonUtil.GOOGLE_MAP_PLACE_DETAIL_URL;
    String url =
        '$baseUrl?key=${GoogleApiKey.place_key}&place_id=$placeId&language=ko&sessiontoken=$token';

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final result = responseData['result'];

    final PlaceDetail placeDetail = PlaceDetail.fromJson(result);

    return placeDetail;
  }

  static Future<String> getAddrFromLocation(double lat, double lng) async {
    final String baseUrl = CommonUtil.GOOGLE_ADDRESS_FROM__LOCATION_URL;
    String url =
        '$baseUrl?latlng=$lat,$lng&key=${GoogleApiKey.place_key}&language=ko';

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final formattedAddr = responseData['results'][0]['formatted_address'];

    return formattedAddr;
  }

  static String getStaticMap(double latitude, double longitude) {
    return '${CommonUtil.GOOGLE_STATIC_MAP_URL}$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=${GoogleApiKey.place_key}';
  }
}

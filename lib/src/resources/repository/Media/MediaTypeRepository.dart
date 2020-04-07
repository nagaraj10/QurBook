import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

//import 'dart:convert' as convert;

class MediaTypeRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<MediaTypesResponse> getMediaType() async {
    final response = await _helper
        .getMediaTypes("mediaTypes/?sortBy=name.asc&offset=0&limit=100");
    return MediaTypesResponse.fromJson(response);
  }

  Future<dynamic> getDoctorProfile(String doctorsId) async {
    final response = await _helper
        .getDoctorProfilePic("doctors/" + doctorsId + "/getprofilepic");
    return response;
  }

  Future<dynamic> getDocumentImage(String metaMasterID) async {
    final response = await _helper.getDocumentImage(
        "mediameta/" + Constants.USER_ID + "/getRawMedia/" + metaMasterID);
    return response;
  }
}

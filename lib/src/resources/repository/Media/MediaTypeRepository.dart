import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
//import 'dart:convert' as convert;

class MediaTypeRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<MediaTypesResponse> getMediaType() async {
    final response = await _helper.getMediaTypes(query.qr_mediaTypes +
        query.qr_sortByQ +
        query.qr_name_asc +
        query.qr_And +
        query.qr_offset +
        0.toString() +
        query.qr_slash +
        query.qr_limit +
        100.toString());
    return MediaTypesResponse.fromJson(response);
  }

  Future<dynamic> getDoctorProfile(String doctorsId) async {
    final response = await _helper.getDoctorProfilePic(
        query.qr_doctors + doctorsId + query.qr_slash + query.qr_profilePic);
    return response;
  }

  Future<dynamic> getDocumentImage(String metaMasterID) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getDocumentImage(query.qr_mediameta +
        userID +
        query.qr_slash +
        query.qr_rawMedia +
        metaMasterID);
    return response;
  }
}

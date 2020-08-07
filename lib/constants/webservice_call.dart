import 'dart:io';

import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as variable;
import 'package:myfhb/common/CommonUtil.dart';

class WebserviceCall {
  String getQueryToUpdateDoctor(bool isPreferred, String providerId) {
    String query;
    if (isPreferred) {
      query = variable.qr_MedicallPrefernce +
          variable.qr_entityDoctor +
          variable.qr_add +
          providerId +
          variable.qr_default +
          providerId;
    } else {
      query = variable.qr_MedicallPrefernce +
          variable.qr_entityDoctor +
          variable.qr_add +
          providerId;
    }

    return query;
  }

  String getUrlToUpdateDoctor(String userID) {
    String query;
    query = variable.qr_Userprofile + userID + variable.qr_slash;

    return query;
  }

  String getQueryToUpdateHospital(bool isPreferred, String providerId) {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    String query;
    if (isPreferred) {
      query = variable.qr_MedicallPrefernce +
          variable.qr_entityHospital +
          variable.qr_add +
          providerId +
          variable.qr_default +
          providerId;
    } else {
      query = variable.qr_MedicallPrefernce +
          variable.qr_entityHospital +
          variable.qr_add +
          providerId;
    }

    query = variable.qr_Userprofile + userID + variable.qr_sections + query;

    return query;
  }

  String getQueryToUpdateLab(bool isPreferred, String providerId) {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    String query;
    if (isPreferred) {
      query = variable.qr_MedicallPrefernce +
          variable.qr_entityHospital +
          variable.qr_add +
          providerId +
          variable.qr_default +
          providerId;
    } else {
      query = variable.qr_MedicallPrefernce +
          variable.qr_entityHospital +
          variable.qr_add +
          providerId;
    }

    query = variable.qr_Userprofile + userID + variable.qr_sections + query;

    return query;
  }

  String getQueryBookmarkRecord() {
    String query = '';
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    query = variable.qr_mediameta +
        userID +
        variable.qr_slash +
        variable.qr_updatebookmark;
    return query;
  }

  String getQueryForMediaType() {
    String query = '';
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    query = variable.qr_users +
        userID +variable.qr_slash+
        variable.qr_search +
        variable.qr_healthRecords +
        variable.qr_keyword;


    return query;
  }

  String getQueryForFamilyMemberList() {
    String query = '';
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    query = variable.qr_Userprofile +
        userID +
        variable.qr_slash +
        variable.qr_picture;


    return query;
  }

  String getQueryForPostUserDelinking() {
    String query = '';
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    query = variable.qr_userDelinking + userID + variable.qr_slash;


    return query;
  }

  String getQueryForSuggestion(String sessionToken, String query) {
    final String baseUrl = CommonUtil.GOOGLE_MAP_URL;
    String type = 'establishment';
    String url =
        '$baseUrl?input=$query&key=${GoogleApiKey.place_key}&type=$type&radius=500&language=en&components=country:IN&sessiontoken=$sessionToken';

    return url;
  }

  String getQueryForPlaceDetail(String placeId, String token) {
    final String baseUrl = CommonUtil.GOOGLE_MAP_PLACE_DETAIL_URL;
    String url =
        '$baseUrl?key=${GoogleApiKey.place_key}&place_id=$placeId&language=ko&sessiontoken=$token';

    return url;
  }

  String queryAddrFromLocation(double lat, double lng) {
    final String baseUrl = CommonUtil.GOOGLE_ADDRESS_FROM__LOCATION_URL;
    String url =
        '$baseUrl?latlng=$lat,$lng&key=${GoogleApiKey.place_key}&language=ko';

    return url;
  }

  String getQueryToUpdateProfile(
      String userID,
      String name,
      String phoneNo,
      String email,
      String gender,
      String bloodGroup,
      String dateOfBirth,
      File profilePic,
      String firstName,
      String middleName,
      String lastName) {
    String query;
    query = variable.qr_generalInfo +
        variable.qr_DSlash +
        variable.qr_gender +
        gender +
        variable.qr_OSlash +
        variable.qr_bloodgroup +
        bloodGroup +
        variable.qr_OSlash +
        variable.qr_dateOfBirth +
        dateOfBirth +
        variable.qr_OSlash +
        variable.qr_name +
        name +
        variable.qr_OSlash +
        variable.qr_firstName +
        firstName +
        variable.qr_OSlash +
        variable.qr_middleName +
        middleName +
        variable.qr_OSlash +
        variable.qr_lastname +
        lastName +
        variable.qr_OSlash +
        variable.qr_email +
        email;

    /*query =
        variable.qr_sections +
        query;*/

    return query;
  }
}

import 'dart:convert';
import 'dart:io';

import '../add_family_user_info/models/update_relatiosnship_model.dart';
import '../common/CommonConstants.dart';
import '../common/CommonUtil.dart';
import '../common/PreferenceUtil.dart';
import 'fhb_constants.dart' as Constants;
import 'fhb_query.dart' as variable;
import '../src/model/user/AddressTypeModel.dart';
import '../src/model/user/MyProfileModel.dart';

class WebserviceCall {
  String getQueryToUpdateDoctor(bool isPreferred, String providerId) {
    String query;
    if (isPreferred) {
      query =
          "${variable.qr_MedicallPrefernce}${variable.qr_entityDoctor}${variable.qr_add}$providerId${variable.qr_default}$providerId";
    } else {
      query =
          "${variable.qr_MedicallPrefernce}${variable.qr_entityDoctor}${variable.qr_add}$providerId";
    }

    return query;
  }

  String getUrlToUpdateDoctor(String userID) {
    String query;
    query = '${variable.qr_Userprofile}$userID${variable.qr_slash}';

    return query;
  }

  String getQueryDoctorUpdate(String userID) {
    String query;
    query =
        '${variable.qr_User}${variable.qr_slash}$userID${variable.qr_sections}${variable.qr_generalInfo}';

    return query;
  }

  String getUrlToUpdateDoctorNew(String userID) {
    String query;
    query =
        '${variable.qr_User}${variable.qr_slash}$userID${variable.qr_section}${variable.qr_medicalPreferences}';

    return query;
  }

  String getQueryToUpdateHospital(bool isPreferred, String providerId) {
    var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    String query;
    if (isPreferred) {
      query =
          "${variable.qr_MedicallPrefernce}${variable.qr_entityHospital}${variable.qr_add}$providerId${variable.qr_default}$providerId";
    } else {
      query =
          "${variable.qr_MedicallPrefernce}${variable.qr_entityHospital}${variable.qr_add}$providerId";
    }

    //query ="${variable.qr_Userprofile}${userID}${variable.qr_sections}${query}";

    return query;
  }

  String getQueryToUpdateLab(bool isPreferred, String providerId) {
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    String query;
    if (isPreferred) {
      query =
          "${variable.qr_MedicallPrefernce}${variable.qy_entitylab}${variable.qr_add}$providerId${variable.qr_default}$providerId";
    } else {
      query =
          "${variable.qr_MedicallPrefernce}${variable.qy_entitylab}${variable.qr_add}$providerId";
    }

    //query ="${variable.qr_Userprofile}${userID}${variable.qr_sections}${query}";

    return query;
  }

  String getQueryBookmarkRecord() {
    var query = '';

    query =
        "${variable.qr_health_record}${variable.qr_slash}${variable.qr_bookmark_healthrecord}";
    return query;
  }

  String getQueryForMediaType() {
    var query = '';
    var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    query =
        "${variable.qr_users}$userID${variable.qr_slash}${variable.qr_search}${variable.qr_healthRecords}${variable.qr_keyword}";

    return query;
  }

  String getQueryForFamilyMemberList() {
    var query = '';
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    query =
        "${variable.qr_Userprofile}$userID${variable.qr_slash}${variable.qr_picture}";

    return query;
  }

  String getQueryForFamilyMemberListNew() {
    var query = '';
    var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    query =
        "${variable.qr_User}${variable.qr_slash}$userID${variable.qr_slash}${variable.qr_myconnection}";

    return query;
  }

  String getQueryForAlreadySelectedFamilyMembers(String voiceCloneId) => 'voice-clone/fetch-user-mapping/$voiceCloneId';

  String getQueryForPostUserDelinking() {
    var query = '';
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    query = "${variable.qr_userDelinking}$userID${variable.qr_slash}";

    return query;
  }

  String getQueryForSuggestion(String sessionToken, String query) {
    final baseUrl = CommonUtil.GOOGLE_MAP_URL;
    final type = 'establishment';
    final url =
        '$baseUrl${variable.qr_input}$query${variable.qr_And}${variable.qr_key}${GoogleApiKey.place_key}${variable.qr_And}${variable.qr_type}$type&${variable.qr_placequery}$sessionToken';

    return url;
  }

  String getQueryForPlaceDetail(String placeId, String token) {
    final baseUrl = CommonUtil.GOOGLE_MAP_PLACE_DETAIL_URL;
    var url =
        '$baseUrl${variable.qr_ques}${variable.qr_key}${GoogleApiKey.place_key}${variable.qr_And}${variable.qr_placedid}$placeId${variable.qr_And}${variable.qr_lang_ko}${variable.qr_And}${variable.qr_sessiontoken}$token';

    return url;
  }

  String queryAddrFromLocation(double lat, double lng) {
    final baseUrl = CommonUtil.GOOGLE_ADDRESS_FROM__LOCATION_URL;
    var url =
        '$baseUrl${variable.qr_ques}${variable.qr_latlng}$lat,$lng${variable.qr_And}${variable.qr_key}${GoogleApiKey.place_key}${variable.qr_And}${variable.qr_lang_ko}';

    return url;
  }

  String getQueryToUpdateProfile(
      String? userID,
      String? name,
      String? phoneNo,
      String? email,
      String? gender,
      String? bloodGroup,
      String? dateOfBirth,
      File? profilePic,
      String? firstName,
      String? middleName,
      String? lastName,
      String? cityId,
      String? stateId,
      String? addressLine1,
      String? addressLine2,
      String? zipcode,
      bool fromFamily) {
    String query;
    query =
        "${variable.qr_generalInfo}${variable.qr_DSlash}${variable.qr_gender}$gender${variable.qr_OSlash}${variable.qr_bloodgroup}$bloodGroup${variable.qr_OSlash}${variable.qr_dateOfBirth}$dateOfBirth${variable.qr_OSlash}${variable.qr_name}$name${variable.qr_OSlash}${variable.qr_firstName}$firstName${variable.qr_OSlash}${variable.qr_middleName}$middleName${variable.qr_OSlash}${variable.qr_lastname}$lastName${variable.qr_OSlash}${variable.qr_email}$email";

    if (fromFamily) {
      query = query +
          "${variable.qr_OSlash}${variable.qr_CityId}$cityId${variable.qr_OSlash}${variable.qr_StateId}$stateId${variable.qr_OSlash}${variable.qr_AddressLine2}$addressLine2${variable.qr_OSlash}${variable.qr_AddressLine1}$addressLine1${variable.qr_OSlash}${variable.qr_pincode}$zipcode";
    }
    /*query =
        variable.qr_sections +
        query;*/

    return query;
  }

  String getQueryForUserUpdate(String userID) {
    String query;
    query =
        '${variable.qr_User}${variable.qr_slash}$userID${variable.qr_section}${variable.qr_generalInfo}';

    return query;
  }

  String makeJsonForUpdateProfile(
      String? userID,
      String? name,
      String? phoneNo,
      String? email,
      String? gender,
      String? bloodGroup,
      String? dateOfBirth,
      File? profilePic,
      String? firstName,
      String? middleName,
      String? lastName,
      String? cityId,
      String? stateId,
      bool isUpdate,
      String? addressLine1,
      String? addressLine2,
      String? zipcode,
      MyProfileModel? myProfileModel,
      UpdateRelationshipModel? relationship) {
    final input = {};
    input[variable.qr_gender_p] = gender;
    input[variable.qr_bloodgroup_p] = bloodGroup;
    input[variable.qr_dateOfBirth_p] = dateOfBirth;
    input[variable.qr_name_p] = name;
    input[variable.qr_firstName_p] = firstName;
    input[variable.qr_middleName_p] = middleName;
    input[variable.qr_lastname_p] = lastName;
    input[variable.qr_email_p] = email;
    final query = json.encode(input);

    final profileResult = myProfileModel?.result;

    final queryProfile = profileResult?.toJson();
    if (isUpdate) {
      // NOTE if user try to update the role this would change
      final relationshipCollection = {
        'userRelationshipCollection': [relationship?.toJson()]
      };
      queryProfile?.addAll(relationshipCollection);
    }

    profileResult?.userAddressCollection3![0].addressType = AddressType(
      id: '22f814a7-5b72-41aa-b5f7-7d2cd38d5da4',
      code: 'RESADD',
      name: 'Resident Address',
      description: 'Resident Address',
      isActive: true,
      createdBy: userID,
      createdOn: CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now(),
          isIndianTime: true),
    );

    //TOD O here only check user add/update flow for removing the id from useraddresscollection
    var copyOfQueryProfile = queryProfile;
    final Map<String, dynamic> addressObj =
        copyOfQueryProfile!['userAddressCollection3'][0];
    if (!isUpdate && addressObj['id'] == null) {
      addressObj.removeWhere((key, value) => key == 'id');
    } else if (addressObj['id'] == null) {
      addressObj.removeWhere((key, value) => key == 'id');
    }
    print('final objects $copyOfQueryProfile id has been removed');
    var profilequery = json.encode(copyOfQueryProfile);
    profilequery = profilequery.replaceAll('\n', '');

    return profilequery.toString();
  }

  String getQueryForPostUserDelinkingNew() {
    var query = '';
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    query =
        "${variable.qr_userlinking}${variable.qr_slash}${variable.qr_delink}";

    return query;
  }
}

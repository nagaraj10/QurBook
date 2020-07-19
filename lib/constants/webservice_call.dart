import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as variable;

class WebserviceCall {
  String getQueryToUpdateDoctor(bool isPreferred, String providerId) {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

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

    print('*************' + query);
    return query;
  }

  String getUrlToUpdateDoctor(){
    String query;
        String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
query=variable.qr_Userprofile + userID +variable.qr_slash;

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
    print('*************' + query);
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
    print('*************' + query);
    return query;
  }

  String getQueryBookmarkRecord() {
    String query = '';
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    query = variable.qr_mediameta + userID + variable.qr_updatebookmark;
    return query;
  }

  String getQueryForMediaType() {
    String query = '';
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    query = variable.qr_users +
        userID +
        variable.qr_search +
        variable.qr_healthRecords +
        variable.qr_keyword;
    return query;
  }

  String getQueryForFamilyMemberList() {
    String query = '';
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    query = variable.qr_Userprofile + userID +variable.qr_slash + variable.qr_picture;
    return query;
  }

  String getQueryForPostUserDelinking(){

     String query = '';
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    query=variable.qr_userDelinking+userID+'/';
    return query;
  }
}

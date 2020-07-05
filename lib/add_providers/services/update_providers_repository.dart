import 'package:myfhb/add_providers/models/update_providers_id.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class UpdateProvidersRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  // 1
  // Doctors
  Future<UpdateProvidersId> updateDoctorsIdWithUserDetails(
      String providerId, bool isPreferred) async {
    String query = '';
    if (isPreferred) {
      query = 'medicalPreferences||entity=doctorIds|add=$providerId|setDefault=$providerId';
    } else {
      query = 'medicalPreferences||entity=doctorIds|add=$providerId';
    }

    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper
        .updateProviders("userProfiles/$userID/?sections=${query}");
    return UpdateProvidersId.fromJson(response);
  }

  // 2
  // Hospitals
  Future<UpdateProvidersId> updateHospitalsIdWithUserDetails(
      String providerId, bool isPreferred) async {
    String query = '';
    if (isPreferred) {
      query = "medicalPreferences||entity=hospitalIds|add=" +
          providerId +
          "|setDefault=" +
          providerId;
    } else {
      query = "medicalPreferences||entity=hospitalIds|add=" + providerId;
    }

    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper
        .updateProviders("userProfiles/$userID/?sections=${query}");
    return UpdateProvidersId.fromJson(response);
  }

  // 3
  // Labs
  Future<UpdateProvidersId> updateLabsIdWithUserDetails(
      String providerId, bool isPreferred) async {
    String query = '';

    if (isPreferred) {
      query = "medicalPreferences||entity=laboratoryIds|add=" +
          providerId +
          "|setDefault=" +
          providerId;
    } else {
      query = "medicalPreferences||entity=laboratoryIds|add=" + providerId;
    }

    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper
        .updateProviders("userProfiles/$userID/?sections=${query}");
    return UpdateProvidersId.fromJson(response);
  }
}

import 'package:myfhb/add_providers/models/update_providers_id.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class AddProvidersRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  // 1
  // Doctors
  Future<UpdateProvidersId> updateDoctorsIdWithUserDetails(
      String providerId) async {
    String query = "medicalPreferences||entity=doctorIds|add=" + providerId;

    final response = await _helper.updateProviders(
        "userProfiles/${Constants.USER_ID}/?sections=${query}");
    return UpdateProvidersId.fromJson(response);
  }

  // 2
  // Hospitals
  Future<UpdateProvidersId> updateHospitalsIdWithUserDetails(
      String providerId) async {
    String query = "medicalPreferences||entity=hospitalIds|add=" + providerId;

    final response = await _helper.updateProviders(
        "userProfiles/${Constants.USER_ID}/?sections=${query}");
    return UpdateProvidersId.fromJson(response);
  }

  // 3
  // Labs
  Future<UpdateProvidersId> updateLabsIdWithUserDetails(
      String providerId) async {
    String query = "medicalPreferences||entity=laboratoryIds|add=" + providerId;

    final response = await _helper.updateProviders(
        "userProfiles/${Constants.USER_ID}/?sections=${query}");
    return UpdateProvidersId.fromJson(response);
  }
}

import 'package:myfhb/add_providers/models/update_providers_id.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/webservice_call.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class UpdateProvidersRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webserviceCall = new WebserviceCall();

  // 1
  // Doctors
  Future<UpdateProvidersId> updateDoctorsIdWithUserDetails(
      String providerId, bool isPreferred) async {
    // final response = await _helper .updateProviders("userProfiles/$userID/?sections=${query}");
    String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.updateTeleHealthProviders(webserviceCall.getUrlToUpdateDoctor(userID),
        webserviceCall.getQueryToUpdateDoctor(isPreferred, providerId));

    return UpdateProvidersId.fromJson(response);
  }

  // 2
  // Hospitals
  Future<UpdateProvidersId> updateHospitalsIdWithUserDetails(
      String providerId, bool isPreferred) async {
    final response = await _helper.updateProviders(
        webserviceCall.getQueryToUpdateHospital(isPreferred, providerId));
    return UpdateProvidersId.fromJson(response);
  }

  // 3
  // Labs
  Future<UpdateProvidersId> updateLabsIdWithUserDetails(
      String providerId, bool isPreferred) async {
    final response = await _helper.updateProviders(
        webserviceCall.getQueryToUpdateLab(isPreferred, providerId));
    return UpdateProvidersId.fromJson(response);
  }
}

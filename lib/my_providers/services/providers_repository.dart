import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';

class ProvidersListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  Future<MyProvidersResponseList> getMedicalPreferencesList() async {
    final response =
        await _helper.getMedicalPreferencesList("userProfiles/$userID/");
    return MyProvidersResponseList.fromJson(response);
  }


  Future<TelehealthProviderModel> getTelehealthDoctorsList() async {
    final response =
        await _helper.getTelehealthDoctorsList("userProfiles/ac9d114d-8e01-4c09-8d74-88b990ded4c3/?sections=medicalPreferences");
    return TelehealthProviderModel.fromJson(response);
  }
}

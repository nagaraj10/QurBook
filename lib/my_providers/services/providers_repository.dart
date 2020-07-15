import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';
import 'dart:convert' as convert;

class ProvidersListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  Future<MyProvidersResponseList> getMedicalPreferencesList() async {
    final response =
        await _helper.getMedicalPreferencesList("userProfiles/$userID/");
    return MyProvidersResponseList.fromJson(response);
  }

  Future<TelehealthProviderModel> getTelehealthDoctorsList() async {
    final response = await _helper.getTelehealthDoctorsList(
        "userProfiles/bde140db-0ffc-4be6-b4c0-5e44b9f54535/?sections=medicalPreferences");
    return TelehealthProviderModel.fromJson(response);
  }

  Future<DoctorBookMarkedSucessModel> bookMarkDoctor(
      bool condition, DoctorIds doctorIds) async {
    var bookMark = {};
    bookMark['doctorPatientMappingId'] = doctorIds.doctorPatientMappingId;
    if(doctorIds.isDefault){
    bookMark['isDefault'] = false;

    }else{
    bookMark['isDefault'] = true;

    }

    var jsonString = convert.jsonEncode(bookMark);
    final response = await _helper .bookMarkDoctor("doctorpatientmapping/updateDefaultProvider",jsonString);
    return DoctorBookMarkedSucessModel.fromJson(response);
  }
}

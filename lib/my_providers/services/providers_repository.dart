import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';
import 'dart:convert' as convert;

import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/fhb_query.dart' as query;

class ProvidersListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  Future<MyProvidersResponseList> getMedicalPreferencesList() async {
    final response = await _helper.getMedicalPreferencesList(
        query.qr_Userprofile + userID + query.qr_slash);
    return MyProvidersResponseList.fromJson(response);
  }

  Future<TelehealthProviderModel> getTelehealthDoctorsList() async {
    final response = await _helper.getTelehealthDoctorsList(
        query.qr_Userprofile +
            "bde140db-0ffc-4be6-b4c0-5e44b9f54535" +
            query.qr_slash +
            query.qr_sections +
            query.qr_medicalPreferences);
    return TelehealthProviderModel.fromJson(response);
  }

  Future<DoctorBookMarkedSucessModel> bookMarkDoctor(
      bool condition, DoctorIds doctorIds) async {
    var bookMark = {};
    bookMark[parameters.strdoctorPatientMappingId] =
        doctorIds.doctorPatientMappingId;
    if (doctorIds.isDefault) {
      bookMark[parameters.strisDefault] = false;
    } else {
      bookMark[parameters.strisDefault] = true;
    }

    var jsonString = convert.jsonEncode(bookMark);
    final response = await _helper.bookMarkDoctor(
        query.qr_doctorpatientmapping + query.qr_updateDefaultProvider,
        jsonString);
    return DoctorBookMarkedSucessModel.fromJson(response);
  }
}

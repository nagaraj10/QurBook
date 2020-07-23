import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'dart:convert' as convert;

import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';

class ProvidersListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  Future<MyProvidersResponseList> getMedicalPreferencesList() async {
    final response = await _helper.getMedicalPreferencesList(
        query.qr_Userprofile + userID + query.qr_slash);
    return MyProvidersResponseList.fromJson(response);
  }

  Future<TelehealthProviderModel> getTelehealthDoctorsList() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getTelehealthDoctorsList(
        query.qr_Userprofile +
            userID +
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

  Future<DoctorTimeSlotsModel> getTelehealthSlotsList(
      String date, String doctorId) async {
    var slotInput = {};
    slotInput[parameters.strDate] = query.qr_slot_date;
    slotInput[parameters.strDoctorId] =query.qr_docId_val;

    var jsonString = convert.jsonEncode(slotInput);
    final response = await _helper.getTimeSlotsList(
       query.qr_doctorslot+query.qr_availability, jsonString);
    return DoctorTimeSlotsModel.fromJson(response);
  }
}

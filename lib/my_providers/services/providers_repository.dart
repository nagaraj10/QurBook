import 'dart:convert' as convert;

import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/AssociateRecordResponse.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/AvailableTimeSlotsModel.dart';
import 'file:///C:/Users/fmohamed/Documents/Flutter%20Projects/asgard_myfhb/lib/telehealth/features/MyProvider/model/appointments/CreateAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/UpdatePaymentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';

class ProvidersListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  // String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
  String userID = CommonConstants.NEW_USER_ID;

  Future<MyProvidersResponse> getMedicalPreferencesList() async {
    final response = await _helper.getMedicalPreferencesList(query.qr_user +
        userID +
        query.qr_sections +
        query.qr_medicalPreferences);
    return MyProvidersResponse.fromJson(response);
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

  Future<AssociateRecordsResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var associateRecord = {};
    //var parentAppoint = {};
    associateRecord[qr_doctorid] = doctorId;
    associateRecord[qr_userid] = userID;
    associateRecord[qr_mediaMetaId] = healthRecords;
    var jsonString = convert.jsonEncode(associateRecord);
    print(jsonString + '******************');
    final response = await _helper.associateRecords(qr_sharerecord, jsonString);
    return AssociateRecordsResponse.fromJson(response);
  }
}

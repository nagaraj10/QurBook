import 'dart:convert' as convert;

import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/AssociateRecordResponse.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/associaterecords/associate_success_response.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';

class ProvidersListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  //String userID = CommonConstants.NEW_USER_ID;

  Future<MyProvidersResponse> getMedicalPreferencesList() async {
    final response = await _helper.getMedicalPreferencesList(query.qr_user +
        userID +
        query.qr_sections +
        query.qr_medicalPreferences);
    return MyProvidersResponse.fromJson(response);
  }

  Future<TelehealthProviderModel> getTelehealthDoctorsList() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getTelehealthDoctorsList(query.qr_User +
        userID +
        query.qr_slash +
        query.qr_sections +
        query.qr_medicalPreferences);
    return TelehealthProviderModel.fromJson(response);
  }

  Future<DoctorBookMarkedSucessModel> bookMarkDoctor(
      Doctors doctorIds, bool isPreferred, String isFrom) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var bookMark = {};
    bookMark[parameters.strpatient] = userID;
    bookMark[parameters.strdoctor] = doctorIds.id;
    bookMark[parameters.healthOrganization] = null;
    if(isFrom=='ListItem'){
      if (doctorIds.isDefault) {
        bookMark[parameters.strisDefault] = false;
      } else {
        bookMark[parameters.strisDefault] = true;
      }
    }else{
      if (isPreferred) {
        bookMark[parameters.strisDefault] = true;
      } else {
        bookMark[parameters.strisDefault] = false;
      }
    }
    var jsonString = convert.jsonEncode(bookMark);
    final response = await _helper.bookMarkDoctor(
        query.qr_patient_update_default + doctorIds.providerPatientMappingId,
        jsonString);
    return DoctorBookMarkedSucessModel.fromJson(response);
  }

  Future<DoctorBookMarkedSucessModel> bookMarkHealthOrganizaton(
      Hospitals hospitals, bool isPreferred, String isFrom) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var bookMark = {};
    bookMark[parameters.strpatient] = userID;
    bookMark[parameters.strdoctor] = null;
    bookMark[parameters.healthOrganization] = hospitals.id;
    if(isFrom=='ListItem'){
      if (hospitals.isDefault) {
        bookMark[parameters.strisDefault] = false;
      } else {
        bookMark[parameters.strisDefault] = true;
      }
    }else{
      if (isPreferred) {
        bookMark[parameters.strisDefault] = true;
      } else {
        bookMark[parameters.strisDefault] = false;
      }
    }

    var jsonString = convert.jsonEncode(bookMark);
    final response = await _helper.bookMarkDoctor(
        query.qr_patient_update_default + hospitals.providerPatientMappingId,
        jsonString);
    return DoctorBookMarkedSucessModel.fromJson(response);
  }

  Future<AssociateSuccessResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var associateRecord = {};
    //var parentAppoint = {};
    associateRecord[qr_shareToProvider] = doctorId;
    associateRecord[qr_shareFromUser] = userID;
    associateRecord[qr_metadata] = healthRecords;
    var jsonString = convert.jsonEncode(associateRecord);
    print(jsonString + '******************');
    String queryForUrl = qr_sharerecord + qr_shareToType + qr_Doctor;
    final response = await _helper.associateRecords(queryForUrl, jsonString);
    return AssociateSuccessResponse.fromJson(response);
  }

  Future<HealthOrganizationModel> getHealthOrganizationFromDoctor(
      String doctorId) async {
    print(doctorId);
    final response = await _helper
        .getHealthOrgApi(query.qr_provider_mapping + qr_doctor + doctorId);
    return HealthOrganizationModel.fromJson(response);
  }
}

import 'dart:convert' as convert;

import 'package:myfhb/chat_socket/constants/const_socket.dart';

import '../../common/CommonConstants.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/fhb_query.dart';
import '../../constants/fhb_query.dart' as query;
import '../models/Doctors.dart';
import '../models/GetDoctorsByIdModel.dart';
import '../models/Hospitals.dart';
import '../models/MyProviderResponseNew.dart';
import '../../src/model/Health/asgard/health_record_list.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import '../../telehealth/features/MyProvider/model/AssociateRecordResponse.dart';
import '../../telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import '../../telehealth/features/MyProvider/model/DoctorsFromHospitalModel.dart';
import '../../telehealth/features/MyProvider/model/associaterecords/associate_success_response.dart';
import '../../telehealth/features/MyProvider/model/associaterecords/associate_update_success_response.dart';
import '../../telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationModel.dart';
import '../../telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import '../../telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';
import '../../telehealth/features/appointments/model/historyModel.dart';
import '../../telehealth/features/chat/model/AppointmentDetailModel.dart';

class ProvidersListRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  AppointmentResult appointments;

  Future<MyProvidersResponse> getMedicalPreferencesList({String userId}) async {
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var response = await _helper.getMedicalPreferencesList(query.qr_user +
        (userId ?? userID) +
        query.qr_sections +
        query.qr_medicalPreferences);
    return MyProvidersResponse.fromJson(response);
  }

  Future<MyProvidersResponse> getMedicalPreferencesForDoctors(
      {String userId}) async {
    var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var response = await _helper.getMedicalPreferencesList(query.qr_user +
        (userId ?? userID) +
        query.qr_sections +
        query.qr_medicalPreferences +
        qr_module_equal +
        qr_Doctor);
    return MyProvidersResponse.fromJson(response);
  }

  Future<MyProvidersResponse> getMedicalPreferencesForHospital(
      {String userId}) async {
    var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var response = await _helper.getMedicalPreferencesList(query.qr_user +
        (userId ?? userID) +
        query.qr_sections +
        query.qr_medicalPreferences +
        qr_module_equal +
        qr_healthOrg);
    return MyProvidersResponse.fromJson(response);
  }

  Future<MyProvidersResponse> getMedicalPreferencesForAll(
      {String userId}) async {
    var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var response = await _helper.getMedicalPreferencesList(query.qr_user +
        (userId ?? userID) +
        query.qr_sections +
        query.qr_medicalPreferences +
        qr_module_equal +
        qr_all);
    return MyProvidersResponse.fromJson(response);
  }

  Future<TelehealthProviderModel> getTelehealthDoctorsList() async {
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.getTelehealthDoctorsList(query.qr_User +
        userID +
        query.qr_slash +
        query.qr_sections +
        query.qr_medicalPreferences);
    return TelehealthProviderModel.fromJson(response);
  }

  Future<DoctorBookMarkedSucessModel> bookMarkDoctor(Doctors doctorIds,
      bool isPreferred, String isFrom, List<String> selectedCategories) async {
    var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final bookMark = {};
    bookMark[parameters.strpatient] = userID;
    bookMark[parameters.strdoctor] = doctorIds.id;
    bookMark[parameters.healthOrganization] = null;
    if (isFrom == 'ListItem') {
      if (doctorIds.isDefault) {
        bookMark[parameters.strisDefault] = false;
        bookMark['sharedCategories'] = null;
      } else {
        bookMark[parameters.strisDefault] = true;
        bookMark['sharedCategories'] = selectedCategories;
      }
    } else {
      if (isPreferred) {
        bookMark[parameters.strisDefault] = true;
        bookMark['sharedCategories'] = selectedCategories;
      } else {
        bookMark[parameters.strisDefault] = false;
        bookMark['sharedCategories'] = null;
      }
    }
    final jsonString = convert.jsonEncode(bookMark);
    var response = await _helper.bookMarkDoctor(
        query.qr_patient_update_default + doctorIds.providerPatientMappingId,
        jsonString);
    return DoctorBookMarkedSucessModel.fromJson(response);
  }

  Future<DoctorBookMarkedSucessModel> bookMarkHealthOrganizaton(
      Hospitals hospitals,
      bool isPreferred,
      String isFrom,
      List<String> selectedCategories) async {
    var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final bookMark = {};
    bookMark[parameters.strpatient] = userID;
    bookMark[parameters.strdoctor] = null;
    bookMark[parameters.healthOrganization] = hospitals.id;
    if (isFrom == 'ListItem') {
      if (hospitals.isDefault) {
        bookMark[parameters.strisDefault] = false;
        bookMark['sharedCategories'] = null;
      } else {
        bookMark[parameters.strisDefault] = true;
        bookMark['sharedCategories'] = selectedCategories;
      }
    } else {
      if (isPreferred) {
        bookMark[parameters.strisDefault] = true;
        bookMark['sharedCategories'] = selectedCategories;
      } else {
        bookMark[parameters.strisDefault] = false;
        bookMark['sharedCategories'] = null;
      }
    }

    final jsonString = convert.jsonEncode(bookMark);
    var response = await _helper.bookMarkDoctor(
        query.qr_patient_update_default + hospitals.providerPatientMappingId,
        jsonString);
    return DoctorBookMarkedSucessModel.fromJson(response);
  }

  Future<AssociateSuccessResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    // String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final associateRecord = {};
    //var parentAppoint = {};
    associateRecord[qr_shareToProvider] = doctorId;
    associateRecord[qr_shareFromUser] = userId;
    associateRecord[qr_metadata] = healthRecords;
    final jsonString = convert.jsonEncode(associateRecord);
    print(jsonString + '******************');
    final queryForUrl = qr_sharerecord + qr_shareToType + qr_Doctor;
    var response = await _helper.associateRecords(queryForUrl, jsonString);
    return AssociateSuccessResponse.fromJson(response);
  }

  Future<AssociateUpdateSuccessResponse> associateUpdateRecords(
      String bookingID, HealthResult healthResult) async {
    // String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final associateRecord = {};
    final associateRecordDetails = {};
    var associateRecordDetailsArr = [];
    //var parentAppoint = {};
    associateRecord[qr_str_id] = bookingID;
    associateRecordDetails[qr_healthRecordMetaData] = healthResult.id;
    associateRecordDetails[qr_healthRecordType] =
        healthResult.healthRecordTypeId;

    associateRecordDetailsArr = [associateRecordDetails];
    associateRecord[qr_health_record_ref] = associateRecordDetailsArr;

    final jsonString = convert.jsonEncode(associateRecord);
    print(jsonString + '******************');
    final queryForUrl = qr_bookAppointment + qr_update_appointment_records;
    var response =
        await _helper.associateUpdateRecords(queryForUrl, jsonString);
    return AssociateUpdateSuccessResponse.fromJson(response);
  }

  Future<HealthOrganizationModel> getHealthOrganizationFromDoctor(
      String doctorId) async {
    print(doctorId);
    var response = await _helper
        .getHealthOrgApi(query.qr_provider_mapping + qr_doctor + doctorId);
    return HealthOrganizationModel.fromJson(response);
  }

  Future<DoctorListFromHospitalModel> getDoctorsFromHospital(
      String healthOrgId) async {
    var response = await _helper
        .getDoctorsFromHospital(qr_doctor + ar_doctor_list + healthOrgId);
    return DoctorListFromHospitalModel.fromJson(response);
  }

  Future<AppointmentDetailModel> getAppointmentDetail(
      String doctorId, String patientId, String careCoorId,String isNormalChatUserList) async {
    var carCooApiId = null;
    carCooApiId = careCoorId != '' ? careCoorId : 'null';
    var response = await _helper.getAppointmentDetail(appointmentSlash +
        patientIdEqualTo +
        patientId +
        doctorIdEqualTo +
        doctorId +
        isDoctor +
        careCoordiantorId +
        carCooApiId+isNormalChatList+isNormalChatUserList);
    return AppointmentDetailModel.fromJson(response);
  }

  Future<GetDoctorsByIdModel> getDoctorsByID({String doctorId}) async {
    var response = await _helper.getDoctorsByIdNew(qr_doctor + doctorId);
    return GetDoctorsByIdModel.fromJson(response);
  }
}

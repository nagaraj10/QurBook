import 'package:flutter/cupertino.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/AssociateRecordResponse.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorsFromHospitalModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/associaterecords/associate_success_response.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/associaterecords/associate_update_success_response.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';

class MyProviderViewModel extends ChangeNotifier {
  List<GetAllPatientsModel> mockDoctors = List<GetAllPatientsModel>();
  List<DoctorIds> doctorIdsList = new List();
  List<DateSlotTimings> dateSlotTimings = new List();
  List<TelehealthProviderModel> teleHealthProviderModel = new List();
  AssociateSuccessResponse associateRecordResponse = AssociateSuccessResponse();
  AssociateUpdateSuccessResponse associateUpdateRecordResponse =
      AssociateUpdateSuccessResponse();
  List<HealthOrganizationResult> healthOrganizationResult = List();
  List<ResultFromHospital> doctorsFromHospital = List();

  ProvidersListRepository _providersListRepository = ProvidersListRepository();

  String userID;
  Future<List<DoctorIds>> fetchProviderDoctors() async {
    try {
      TelehealthProviderModel myProvidersResponseList =
          await _providersListRepository.getTelehealthDoctorsList();

      doctorIdsList = myProvidersResponseList
          .response.data.medicalPreferences.preferences.doctorIds;
      return doctorIdsList;
    } catch (e) {}
  }

  Future<bool> bookMarkDoctor(
      Doctors doctorIds, bool isPreferred, String isFrom,List<String> selectedCategories) async {
    DoctorBookMarkedSucessModel doctorBookMarkedSucessModel =
        await _providersListRepository.bookMarkDoctor(
            doctorIds, isPreferred, isFrom,selectedCategories);

    return doctorBookMarkedSucessModel.isSuccess;
  }

  Future<bool> bookMarkHealthOrg(
      Hospitals hospitals, bool isPreferred, String isFrom,List<String> selectedCategories) async {
    bool condition;

    DoctorBookMarkedSucessModel doctorBookMarkedSucessModel =
        await _providersListRepository.bookMarkHealthOrganizaton(
            hospitals, isPreferred, isFrom,selectedCategories);

    return doctorBookMarkedSucessModel.isSuccess;
  }

  List<DoctorIds> getFilterDoctorList(String doctorName) {
    List<DoctorIds> filterDoctorData = new List();
    for (DoctorIds doctorData in doctorIdsList) {
      if (doctorData.name
              .toLowerCase()
              .trim()
              .contains(doctorName.toLowerCase().trim()) ||
          doctorData.specialization
              .toLowerCase()
              .trim()
              .contains(doctorName.toLowerCase().trim()) ||
          doctorData.city
              .toLowerCase()
              .trim()
              .contains(doctorName.toLowerCase().trim())) {
        filterDoctorData.add(doctorData);
      }
    }
    return filterDoctorData;
  }

  Future<AssociateSuccessResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    try {
      AssociateSuccessResponse bookAppointmentModel =
          await _providersListRepository.associateRecords(
              doctorId, userId, healthRecords);
      associateRecordResponse = bookAppointmentModel;
      return associateRecordResponse;
    } catch (e) {}
  }

  Future<AssociateUpdateSuccessResponse> associateUpdateRecords(
      String bookingID, HealthResult healthResult) async {
    try {
      AssociateUpdateSuccessResponse bookAppointmentModel =
          await _providersListRepository.associateUpdateRecords(
              bookingID, healthResult);
      associateUpdateRecordResponse = bookAppointmentModel;
      return associateUpdateRecordResponse;
    } catch (e) {}
  }

  Future<HealthOrganizationModel> getHealthOrgFromDoctor(
      String doctorId) async {
    try {
      HealthOrganizationModel healthOrganizationModel =
          await _providersListRepository
              .getHealthOrganizationFromDoctor(doctorId);

      //healthOrganizationResult = healthOrganizationModel.result;
      return healthOrganizationModel;
    } catch (e) {}
  }

  Future<List<ResultFromHospital>> getDoctorsFromHospital(
      String healthOrgId) async {
    try {
      DoctorListFromHospitalModel doctorListFromHospitalModel =
          await _providersListRepository.getDoctorsFromHospital(healthOrgId);

      doctorsFromHospital = doctorListFromHospitalModel.result;
      return doctorsFromHospital;
    } catch (e) {}
  }

  List<Hospitals> getHospitalName(
      {List<Hospitals> hospitalList, String query}) {
    List<Hospitals> dummySearchHospitalList = List();
    dummySearchHospitalList = hospitalList
        .where((element) => element.name
            .toLowerCase()
            .trim()
            .contains(query.toLowerCase().trim()))
        .toList();
    return dummySearchHospitalList;
  }
}

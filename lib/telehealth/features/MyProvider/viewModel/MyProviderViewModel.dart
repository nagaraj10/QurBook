import 'package:flutter/cupertino.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/AssociateRecordResponse.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/associaterecords/associate_success_response.dart';
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
  List<HealthOrganizationResult> healthOrganizationResult = List();

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
      Doctors doctorIds, bool isPreferred, String isFrom) async {
    DoctorBookMarkedSucessModel doctorBookMarkedSucessModel =
        await _providersListRepository.bookMarkDoctor(
            doctorIds, isPreferred, isFrom, userID);

    return doctorBookMarkedSucessModel.isSuccess;
  }

  Future<bool> bookMarkHealthOrg(
      Hospitals hospitals, bool isPreferred, String isFrom) async {
    bool condition;

    DoctorBookMarkedSucessModel doctorBookMarkedSucessModel =
        await _providersListRepository.bookMarkHealthOrganizaton(
            hospitals, isPreferred, isFrom);

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

  Future<List<HealthOrganizationResult>> getHealthOrgFromDoctor(
      String doctorId) async {
    try {
      HealthOrganizationModel healthOrganizationModel =
          await _providersListRepository
              .getHealthOrganizationFromDoctor(doctorId);

      healthOrganizationResult = healthOrganizationModel.result;
      return healthOrganizationResult;
    } catch (e) {}
  }
}

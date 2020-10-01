import 'package:flutter/cupertino.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/AssociateRecordResponse.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';

class MyProviderViewModel extends ChangeNotifier {
  List<GetAllPatientsModel> mockDoctors = List<GetAllPatientsModel>();
  List<DoctorIds> doctorIdsList = new List();
  List<DateSlotTimings> dateSlotTimings = new List();
  List<TelehealthProviderModel> teleHealthProviderModel = new List();
  AssociateRecordsResponse associateRecordResponse = AssociateRecordsResponse();

  ProvidersListRepository _providersListRepository = ProvidersListRepository();

  Future<List<DoctorIds>> fetchProviderDoctors() async {
    try {
      TelehealthProviderModel myProvidersResponseList =
          await _providersListRepository.getTelehealthDoctorsList();

      doctorIdsList = myProvidersResponseList
          .response.data.medicalPreferences.preferences.doctorIds;
      return doctorIdsList;
    } catch (e) {}
  }

  Future<bool> bookMarkDoctor(bool condition, DoctorIds doctorIds) async {
    bool condition;

    DoctorBookMarkedSucessModel doctorBookMarkedSucessModel =
        await _providersListRepository.bookMarkDoctor(condition, doctorIds);

    return doctorBookMarkedSucessModel.success;
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

  Future<AssociateRecordsResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    try {
      AssociateRecordsResponse bookAppointmentModel =
          await _providersListRepository.associateRecords(
              doctorId, userId, healthRecords);
      associateRecordResponse = bookAppointmentModel;
      return associateRecordResponse;
    } catch (e) {}
  }
}

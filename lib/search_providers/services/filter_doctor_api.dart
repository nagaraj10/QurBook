import 'dart:async';
import 'dart:convert';

import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_query.dart' as query;
import '../../my_providers/models/UserAddressCollection.dart';
import '../../src/model/user/State.dart' as s;
import '../../src/resources/network/ApiBaseHelper.dart';
import '../models/doctor_list_response_new.dart';
import '../models/doctor_specialization_model.dart';
import '../models/hospital_list_response_new.dart';
import '../screens/doctor_filter_request_model.dart';

// Class responsible for handling API calls related to doctor filtering
class FilterDoctorApi {
  // Fetches the list of cities based on the provided stateName
  Future<List<String>> getCityList(String stateName) async {
    final cityList = <City>[]; // City class assumed to exist
    final stateBasedCityList = <City>[];
    final uniqueCity = <String>{};

    // Fetch city list from API
    final response = await ApiBaseHelper().getCityList('city');

    if (response['isSuccess']) {
      cityList.clear();
      for (var code in response['result']) {
        if (code['state']['name'] == stateName) {
          stateBasedCityList.add(City(name: code['name']));
        } else {
          cityList.add(City(name: code['name']));
        }
      }
    }

    for (final city in stateBasedCityList.isEmpty ? cityList : stateBasedCityList) {
      if (city.name != null && city.name!.isNotEmpty) {
        uniqueCity.add(city.name!);
      }
    }
    return uniqueCity.toList();
  }

  // Fetches the list of states based on the provided cityName
  Future<List<String>> getStateList(String cityName) async {
    final uniqueState = <String>{};
    final stateList = <s.State>[]; // s.State class assumed to exist
    final cityBasedStateList = <s.State>[];

    // Fetch state list from API
    final response = await ApiBaseHelper().getStateList('state');

    if (response['isSuccess']) {
      stateList.clear();
      for (var code in response['result']) {
        for (var city in code['cityCollection']) {
          if (city['name'] == cityName) {
            cityBasedStateList.add(s.State(name: code['name']));
          } else {
            stateList.add(s.State(name: code['name']));
          }
        }
      }
    }

    for (final stateName in cityBasedStateList.isNotEmpty ? cityBasedStateList : stateList) {
      if (stateName.name != null && stateName.name!.isNotEmpty) {
        uniqueState.add(stateName.name!);
      }
    }
    return uniqueState.toList();
  }

  // Fetches the list of doctor specializations based on the provided searchText
  Future<List<String>> getDoctorSpecializationList(String searchText) async {
    final uniqueSpecializations = <String>{};
    final doctorSpecializationList = <DoctorSpecialization>[]; // DoctorSpecialization class assumed to exist

    // Fetch doctor specialization list from API
    final response = await ApiBaseHelper().doctorSpecializationList(
      'doctor/search-doctor-specialization?searchText=$searchText',
    );

    if (response['isSuccess']) {
      response['result'].forEach(
        (f) {
          doctorSpecializationList.add(DoctorSpecialization.fromJson(f));
        },
      );
    }

    for (final doctor in doctorSpecializationList) {
      if (doctor.specialization != null && doctor.specialization!.isNotEmpty) {
        uniqueSpecializations.add(doctor.specialization!);
      }
    }
    return uniqueSpecializations.toList();
  }

  // Fetches the list of filtered doctors based on the provided DoctorFilterRequestModel
  Future<List<DoctorsListResult>> getFilterDoctorList(
    DoctorFilterRequestModel doctorFilterRequestModel,
  ) async {
    final doctorFilterList = <DoctorsListResult>[];
    // Fetch filtered doctor list from API
    final response = await ApiBaseHelper().doctorFilterList('doctor/service-request/list', json.encode(doctorFilterRequestModel));

    doctorFilterList.clear();
    if (response['isSuccess']) {
      if (response['result']['data']['isSuccess']) {
        response['result']['data']['entities'].forEach(
          (f) {
            doctorFilterList.add(DoctorsListResult.fromJson(f));
          },
        );
      }
    }
    return doctorFilterList.toList();
  }

  // Fetches the list of hospitals based on the provided stateName and cityName
  Future<List<String>> getHospitalList(String stateName, String cityName) async {
    const limit = 50;
    const skip = 1;
    final hospitalList = <String>[];
    final stateBasedHospitalList = <String>[];
    final uniqueHospital = <String>{};

    // Fetch hospital list from API using search parameters
    var response = await ApiBaseHelper().getHospitalListFromSearchNew(
        "${query.qr_patient_update_default}${query.qr_list}${query.qr_healthOrganizationList}${query.qr_skip}${skip.toString()}${query.qr_And}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_halthOrganization}${Constants.STR_HEALTHORG_HOSPID}");

    // Assuming HospitalsSearchListResponse and HospitalsSearchListResponse.fromJson are defined
    final hospitalListResponse = HospitalsSearchListResponse.fromJson(response);

    for (final hospital in hospitalListResponse.result ?? []) {
      if (cityName.isNotEmpty && stateName.isNotEmpty) {
        if (hospital.cityName == cityName && hospital.stateName == stateName) {
          stateBasedHospitalList.add(hospital.healthOrganizationName);
        }
      } else if (cityName.isNotEmpty) {
        if (hospital.cityName == cityName) {
          stateBasedHospitalList.add(hospital.healthOrganizationName);
        }
      } else if (stateName.isNotEmpty) {
        if (hospital.stateName == stateName) {
          stateBasedHospitalList.add(hospital.healthOrganizationName);
        }
      } else {
        hospitalList.add(hospital.healthOrganizationName);
      }
    }

    for (final city in stateBasedHospitalList.isEmpty ? hospitalList : stateBasedHospitalList) {
      if (city.isNotEmpty) {
        uniqueHospital.add(city);
      }
    }
    return uniqueHospital.toList();
  }
}

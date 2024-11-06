import 'dart:async';
import 'dart:convert';

import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/search_providers/models/labs_list_response_new.dart';

import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_parameters.dart'as parameters;
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
    // To sort a list of cities alphabetically
   return uniqueCity.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
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
    // To sort a list of states alphabetically
    return uniqueState.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
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
    try {
      final response = await ApiBaseHelper().doctorFilterList(doctor_service_request_list, json.encode(doctorFilterRequestModel),);
      doctorFilterList.clear();
      if (response[parameters.strSuccess]) {
        response[parameters.dataResult][parameters.strData].forEach(
              (f) {
            doctorFilterList.add(DoctorsListResult.fromJson(f));
          },
        );
      }
    } catch (e) {}
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


  // Define a Future method named 'getFilterLabListResult' that takes a 'DoctorFilterRequestModel' as a parameter
  Future<List<LabListResult>> getFilterLabListResult(
      DoctorFilterRequestModel doctorFilterRequestModel,
      ) async {
    // Create an empty list to store LabListResult objects
    final labListFilterResult = <LabListResult>[];

    try {
      // Make an asynchronous call to the labFilterList method from the ApiBaseHelper class
      final response = await ApiBaseHelper().labFilterList(
        lab_service_request_list,                  // Use the lab_service_request_list constant as the URL
        json.encode(doctorFilterRequestModel),    // Encode the DoctorFilterRequestModel as JSON and provide it as the data
      );

      // Clear the existing labListFilterResult list
      labListFilterResult.clear();

      // Check if the response indicates success
      if (response[parameters.strSuccess]) {
        // Iterate through entities in the response and convert them to LabListResult objects
        response[parameters.dataResult][parameters.strData].forEach(
              (f) {
            labListFilterResult.add(LabListResult.fromJson(f));
          },
        );
      }
    } catch (e) {
      // Catch and ignore any exceptions that occur during the process
    }

    // Return the list of LabListResult objects
    return labListFilterResult.toList();
  }



}

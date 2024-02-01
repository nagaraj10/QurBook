import 'dart:async';
import 'dart:convert';

import 'package:myfhb/my_providers/models/UserAddressCollection.dart';
import 'package:myfhb/search_providers/models/doctor_list_response_new.dart';
import 'package:myfhb/search_providers/models/doctor_specialization_model.dart';
import 'package:myfhb/search_providers/models/hospital_list_response_new.dart';
import 'package:myfhb/search_providers/screens/doctor_filter_request_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/model/user/State.dart' as s;
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_query.dart' as query;

class FilterDoctorApi {
  Future<List<String>> getCityList(String stateName) async {
    final cityList = <City>[];
    final stateBasedCityList = <City>[];
    final uniqueCity = <String>{};
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

  Future<List<String>> getStateList(String cityName) async {
    final uniqueState = <String>{};
    final stateList = <s.State>[];
    final cityBasedStateList = <s.State>[];

    //
    // for (final city in stateBasedCityList.isEmpty ? cityList : stateBasedCityList) {
    //   if (city.name != null && city.name!.isNotEmpty) {
    //     uniqueCity.add(city.name!);
    //   }
    // }

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

  Future<List<String>> getDoctorSpecializationList(String searchText) async {
    final uniqueSpecializations = <String>{};
    final doctorSpecializationList = <DoctorSpecialization>[];
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

  Future<List<DoctorsListResult>> getFilterDoctorList(
    DoctorFilterRequestModel doctorFilterRequestModel,
  ) async {
    List<DoctorsListResult> doctorFilterList = [];
    final response = await ApiBaseHelper().doctorFilterList('doctor/service-request/list', json.encode(doctorFilterRequestModel));
    doctorFilterList.clear();
    if (response['isSuccess']) {
      if (response['result']['data']["isSuccess"]) {
        response['result']['data']["entities"].forEach(
          (f) {
            doctorFilterList.add(DoctorsListResult.fromJson(f));
          },
        );
      }
    }
    return doctorFilterList.toList();
  }

  Future<List<String>> getHospitalList(String stateName, String cityName) async {
    const limit = 50;
    const skip = 1;
    final hospitalList = <String>[];
    final stateBasedHospitalList = <String>[];
    final uniqueHospital = <String>{};
    var response = await ApiBaseHelper().getHospitalListFromSearchNew(
        "${query.qr_patient_update_default}${query.qr_list}${query.qr_healthOrganizationList}${query.qr_skip}${skip.toString()}${query.qr_And}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_halthOrganization}${Constants.STR_HEALTHORG_HOSPID}");
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

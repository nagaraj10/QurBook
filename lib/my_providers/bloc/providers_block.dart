import 'dart:async';

import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/GetDoctorsByIdModel.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

class ProvidersBloc implements BaseBloc {
  ProvidersListRepository _providersListRepository;
  StreamController _providersListControlller;

  StreamSink<ApiResponse<MyProvidersResponse>> get providersListSink =>
      _providersListControlller.sink;
  Stream<ApiResponse<MyProvidersResponse>> get providersListStream =>
      _providersListControlller.stream;

  List<Doctors> doctors = new List();
  List<Hospitals> hospitals = new List();
  List<Hospitals> labs = new List();

  @override
  void dispose() {
    _providersListControlller?.close();
  }

  ProvidersBloc() {
    _providersListControlller =
        StreamController<ApiResponse<MyProvidersResponse>>();
    _providersListRepository = ProvidersListRepository();
  }

  Future<MyProvidersResponse> getMedicalPreferencesList({String userId}) async {
    // providersListSink.add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    MyProvidersResponse myProvidersResponseList;
    try {
      myProvidersResponseList = await _providersListRepository
          .getMedicalPreferencesList(userId: userId);
      doctors = myProvidersResponseList.result.doctors;
      // hospitals = myProvidersResponseList.result.hospitals;
      // labs = myProvidersResponseList.result.labs;
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return myProvidersResponseList;
  }

  Future<MyProvidersResponse> getMedicalPreferencesForDoctors({String userId}) async {
    // providersListSink.add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    MyProvidersResponse myProvidersResponseList;
    try {
      myProvidersResponseList = await _providersListRepository
          .getMedicalPreferencesForDoctors(userId: userId);
      doctors = myProvidersResponseList.result.doctors;
      // hospitals = myProvidersResponseList.result.hospitals;
      // labs = myProvidersResponseList.result.labs;
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return myProvidersResponseList;
  }

  Future<MyProvidersResponse> getMedicalPreferencesForHospital({String userId}) async {
    // providersListSink.add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    MyProvidersResponse myProvidersResponseList;
    try {
      myProvidersResponseList = await _providersListRepository
          .getMedicalPreferencesForHospital(userId: userId);
      //doctors = myProvidersResponseList.result.doctors;
      // hospitals = myProvidersResponseList.result.hospitals;
      // labs = myProvidersResponseList.result.labs;
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return myProvidersResponseList;
  }

  Future<MyProvidersResponse> getMedicalPreferencesAll({String userId}) async {
    // providersListSink.add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    MyProvidersResponse myProvidersResponseList;
    try {
      myProvidersResponseList = await _providersListRepository
          .getMedicalPreferencesForAll(userId: userId);
      //doctors = myProvidersResponseList.result.doctors;
      // hospitals = myProvidersResponseList.result.hospitals;
      // labs = myProvidersResponseList.result.labs;
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return myProvidersResponseList;
  }

  List<Doctors> getFilterDoctorListNew(String doctorName) {
    List<Doctors> filterDoctorData = new List();
    for (Doctors doctorData in doctors) {
      if (doctorData.user.name != null && doctorData.user.name != '') {
        String speciality = doctorData.doctorProfessionalDetailCollection !=
                null
            ? doctorData.doctorProfessionalDetailCollection.length > 0
                ? doctorData.doctorProfessionalDetailCollection[0].specialty !=
                        null
                    ? doctorData
                        .doctorProfessionalDetailCollection[0].specialty.name
                    : ''
                : ''
            : "";
        String address = doctorData.user != null
            ? doctorData.user.userAddressCollection3 != null
                ? doctorData.user.userAddressCollection3.length > 0
                    ? doctorData.user.userAddressCollection3[0].city != null
                        ? doctorData.user.userAddressCollection3[0].city.name
                        : ''
                    : ''
                : ''
            : '';
        if (doctorData.user.name
                .toLowerCase()
                .trim()
                .contains(doctorName.toLowerCase().trim()) ||
            (speciality != '' &&
                speciality
                    .toLowerCase()
                    .trim()
                    .contains(doctorName.toLowerCase().trim())) ||
            address
                .toLowerCase()
                .trim()
                .contains(doctorName.toLowerCase().trim())) {
          filterDoctorData.add(doctorData);
        }
      }
    }
    return filterDoctorData;
  }

  Future<GetDoctorsByIdModel> getDoctorsById({String doctorId}) async {
    GetDoctorsByIdModel getDoctorsByIdModel;
    try {
      getDoctorsByIdModel = await _providersListRepository
          .getDoctorsByID(doctorId: doctorId);
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return getDoctorsByIdModel;
  }
}

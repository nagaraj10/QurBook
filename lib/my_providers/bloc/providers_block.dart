import 'dart:async';

import '../models/Doctors.dart';
import '../models/GetDoctorsByIdModel.dart';
import '../models/Hospitals.dart';
import '../models/MyProviderResponseNew.dart';
import '../models/my_providers_response_list.dart';
import '../services/providers_repository.dart';
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../constants/variable_constant.dart' as variable;

class ProvidersBloc implements BaseBloc {
  ProvidersListRepository _providersListRepository;
  StreamController _providersListControlller;
  StreamController _providershospitalListControlller;

  StreamSink<ApiResponse<MyProvidersResponse>> get providersListSink =>
      _providersListControlller.sink;
  Stream<ApiResponse<MyProvidersResponse>> get providersListStream =>
      _providersListControlller.stream;

  StreamSink<ApiResponse<MyProvidersResponse>> get providershospitalListSink =>
      _providershospitalListControlller.sink;
  Stream<ApiResponse<MyProvidersResponse>> get providershospitalListStream =>
      _providershospitalListControlller.stream;

  List<Doctors> doctors = [];
  List<Hospitals> hospitals = List();
  List<Hospitals> labs = [];

  @override
  void dispose() {
    _providersListControlller?.close();
    _providershospitalListControlller?.close();
  }

  ProvidersBloc() {
    _providersListControlller =
        StreamController<ApiResponse<MyProvidersResponse>>();
    _providershospitalListControlller =
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

  Future<MyProvidersResponse> getMedicalPreferencesForDoctors(
      {String userId}) async {
    providersListSink
        .add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    MyProvidersResponse myProvidersResponseList;
    try {
      myProvidersResponseList = await _providersListRepository
          .getMedicalPreferencesForDoctors(userId: userId);
      try {
        doctors = myProvidersResponseList.result?.doctors;
      } catch (e) {}
      providersListSink.add(ApiResponse.completed(myProvidersResponseList));

      // hospitals = myProvidersResponseList.result.hospitals;
      // labs = myProvidersResponseList.result.labs;
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return myProvidersResponseList;
  }

  Future<MyProvidersResponse> getMedicalPreferencesForHospital(
      {String userId}) async {
    providershospitalListSink.add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    MyProvidersResponse myProvidersResponseList;
    try {
      myProvidersResponseList = await _providersListRepository
          .getMedicalPreferencesForHospital(userId: userId);

      try {
        hospitals = myProvidersResponseList.result?.hospitals;
      } catch (e) {}

      providershospitalListSink.add(ApiResponse.completed(myProvidersResponseList));

      //doctors = myProvidersResponseList.result.doctors;
      // hospitals = myProvidersResponseList.result.hospitals;
      // labs = myProvidersResponseList.result.labs;
    } catch (e) {
      providershospitalListSink.add(ApiResponse.error(e.toString()));
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
    final filterDoctorData = List<Doctors>();
    for (final doctorData in doctors) {
      if (doctorData.user.name != null && doctorData.user.name != '') {
        var speciality = doctorData.doctorProfessionalDetailCollection !=
            null
            ? doctorData.doctorProfessionalDetailCollection.isNotEmpty
            ? doctorData.doctorProfessionalDetailCollection[0].specialty !=
            null
            ? doctorData
            .doctorProfessionalDetailCollection[0].specialty.name
            : ''
            : ''
            : '';
        final address = doctorData.user != null
            ? doctorData.user.userAddressCollection3 != null
            ? doctorData.user.userAddressCollection3.isNotEmpty
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
      getDoctorsByIdModel =
      await _providersListRepository.getDoctorsByID(doctorId: doctorId);
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return getDoctorsByIdModel;
  }
}

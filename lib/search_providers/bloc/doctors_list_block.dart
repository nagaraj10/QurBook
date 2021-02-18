import 'dart:async';

import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/search_providers/models/doctor_list_response_new.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

import '../models/doctors_list_response.dart';
import '../services/doctors_list_repository.dart';

class DoctorsListBlock implements BaseBloc {
  DoctorsListRepository _doctorsListRepository;
  StreamController _doctorsListController;
  StreamController _doctorsListNewController;

  StreamController _doctorsProfileImageControlller;

  StreamSink<ApiResponse<DoctorsListResponse>> get doctorsListSink =>
      _doctorsListController.sink;
  Stream<ApiResponse<DoctorsListResponse>> get doctorsStream =>
      _doctorsListController.stream;

  StreamSink<ApiResponse<DoctorsSearchListResponse>> get doctorsListNewSink =>
      _doctorsListNewController.sink;
  Stream<ApiResponse<DoctorsSearchListResponse>> get doctorsNewStream =>
      _doctorsListNewController.stream;

  @override
  void dispose() {
    _doctorsListController?.close();
    _doctorsListNewController?.close();
  }

  DoctorsListBlock() {
    _doctorsListController =
        StreamController<ApiResponse<DoctorsListResponse>>();

    _doctorsListNewController =
        StreamController<ApiResponse<DoctorsSearchListResponse>>();

    _doctorsListRepository = new DoctorsListRepository();
  }

  getDoctorsList(String param) async {
    doctorsListSink.add(ApiResponse.loading(variable.strGetDoctorsList));
    try {
      DoctorsListResponse userHealthResponseList =
          await _doctorsListRepository.getDoctorsListFromSearch(param);
      doctorsListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      doctorsListSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<DoctorsSearchListResponse> getDoctorsListNew(
      String param, bool isSkipUnknown) async {
    DoctorsSearchListResponse userHealthResponseList;
    doctorsListNewSink.add(ApiResponse.loading(variable.strGetDoctorsList));
    try {
      userHealthResponseList = await _doctorsListRepository
          .getDoctorsListFromSearchNew(param, isSkipUnknown);
      doctorsListNewSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      doctorsListNewSink.add(ApiResponse.error(e.toString()));
    }
    return userHealthResponseList;
  }

  Future<DoctorsListResponse> getDoctorObjUsingId(String doctorsId) async {
    DoctorsListResponse doctorsListResponse;
    doctorsListSink.add(ApiResponse.loading(variable.strGetDoctorById));
    try {
      doctorsListResponse =
          await _doctorsListRepository.getDoctorUsingId(doctorsId);
      doctorsListSink.add(ApiResponse.completed(doctorsListResponse));
    } catch (e) {
      doctorsListSink.add(ApiResponse.error(e.toString()));
    }

    return doctorsListResponse;
  }
}

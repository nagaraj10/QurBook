import 'dart:async';

import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

import '../models/doctors_list_response.dart';
import '../services/doctors_list_repository.dart';

class DoctorsListBlock implements BaseBloc {
  DoctorsListRepository _doctorsListRepository;
  StreamController _doctorsListController;
  StreamController _doctorsProfileImageControlller;

  StreamSink<ApiResponse<DoctorsListResponse>> get doctorsListSink =>
      _doctorsListController.sink;
  Stream<ApiResponse<DoctorsListResponse>> get doctorsStream =>
      _doctorsListController.stream;

  @override
  void dispose() {
    _doctorsListController?.close();
  }

  DoctorsListBlock() {
    _doctorsListController =
        StreamController<ApiResponse<DoctorsListResponse>>();

    _doctorsListRepository = new DoctorsListRepository();
  }

  getDoctorsList(String param) async {
    doctorsListSink.add(ApiResponse.loading('Signing in user'));
    try {
      DoctorsListResponse userHealthResponseList =
          await _doctorsListRepository.getDoctorsListFromSearch(param);
      doctorsListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      doctorsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  Future<DoctorsListResponse> getDoctorObjUsingId(String doctorsId) async {
    DoctorsListResponse doctorsListResponse;
    doctorsListSink.add(ApiResponse.loading('Signing in user'));
    try {
      doctorsListResponse =
          await _doctorsListRepository.getDoctorUsingId(doctorsId);
      doctorsListSink.add(ApiResponse.completed(doctorsListResponse));
    } catch (e) {
      doctorsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }

    return doctorsListResponse;
  }
}

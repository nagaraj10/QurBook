
import 'dart:async';

import '../../constants/variable_constant.dart' as variable;
import '../models/doctor_list_response_new.dart';
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/resources/network/ApiResponse.dart';

import '../models/doctors_list_response.dart';
import '../services/doctors_list_repository.dart';

class DoctorsListBlock implements BaseBloc {
  late DoctorsListRepository _doctorsListRepository;
  StreamController? _doctorsListController;
  StreamController? _doctorsListNewController;

  StreamController? _doctorsProfileImageControlller;

  StreamSink<ApiResponse<DoctorsListResponse>> get doctorsListSink =>
      _doctorsListController!.sink as StreamSink<ApiResponse<DoctorsListResponse>>;
  Stream<ApiResponse<DoctorsListResponse>> get doctorsStream =>
      _doctorsListController!.stream as Stream<ApiResponse<DoctorsListResponse>>;

  StreamSink<ApiResponse<DoctorsSearchListResponse>> get doctorsListNewSink =>
      _doctorsListNewController!.sink as StreamSink<ApiResponse<DoctorsSearchListResponse>>;
  Stream<ApiResponse<DoctorsSearchListResponse>> get doctorsNewStream =>
      _doctorsListNewController!.stream as Stream<ApiResponse<DoctorsSearchListResponse>>;

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

    _doctorsListRepository = DoctorsListRepository();
  }

  getDoctorsList(String param) async {
    doctorsListSink.add(ApiResponse.loading(variable.strGetDoctorsList));
    try {
      var userHealthResponseList =
          await _doctorsListRepository.getDoctorsListFromSearch(param);
      doctorsListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      doctorsListSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<DoctorsSearchListResponse?> getDoctorsListNew(
      String? param, bool? isSkipUnknown) async {
    DoctorsSearchListResponse? userHealthResponseList;
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

  Future<DoctorsListResponse?> getDoctorObjUsingId(String doctorsId) async {
    DoctorsListResponse? doctorsListResponse;
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

  Future<DoctorsSearchListResponse?> getExistingDoctorList(
      String limit) async {
    DoctorsSearchListResponse? userHealthResponseList;
    doctorsListNewSink.add(ApiResponse.loading(variable.strGetDoctorsList));
    try {
      userHealthResponseList = await _doctorsListRepository
          .getExistingDoctorsListFromSearchNew(limit);
      doctorsListNewSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      doctorsListNewSink.add(ApiResponse.error(e.toString()));
    }
    return userHealthResponseList;
  }
}

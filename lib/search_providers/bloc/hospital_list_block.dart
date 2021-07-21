import 'dart:async';

import '../../constants/variable_constant.dart' as variable;
import '../models/hospital_list_response.dart';
import '../models/hospital_list_response_new.dart';
import '../services/hospital_list_repository.dart';
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/resources/network/ApiResponse.dart';

class HospitalListBlock implements BaseBloc {
  HospitalListRepository _hospitalListRepository;
  StreamController _hospitalListController;
  StreamController _hospitalProfileImageControlller;
  StreamController _hospitalListNewController;

  StreamSink<ApiResponse<HospitalListResponse>> get hospitalListSink =>
      _hospitalListController.sink;
  Stream<ApiResponse<HospitalListResponse>> get hospitalStream =>
      _hospitalListController.stream;

  StreamSink<ApiResponse<HospitalsSearchListResponse>>
      get hospitalListNewSink => _hospitalListNewController.sink;
  Stream<ApiResponse<HospitalsSearchListResponse>> get hospitalNewStream =>
      _hospitalListNewController.stream;

  @override
  void dispose() {
    _hospitalListController?.close();
  }

  HospitalListBlock() {
    _hospitalListController =
        StreamController<ApiResponse<HospitalListResponse>>();

    _hospitalListNewController =
        StreamController<ApiResponse<HospitalsSearchListResponse>>();

    _hospitalListRepository = HospitalListRepository();
  }

  getHospitalList(String param) async {
    hospitalListSink.add(ApiResponse.loading(variable.strGetHospitalList));
    try {
      var hospitalListResponse =
          await _hospitalListRepository.getHospitalFromSearch(param);
      hospitalListSink.add(ApiResponse.completed(hospitalListResponse));
    } catch (e) {
      hospitalListSink.add(ApiResponse.error(e.toString()));
    }
  }

  getHospitalListNew(String param) async {
    hospitalListNewSink.add(ApiResponse.loading(variable.strGetHospitalList));
    try {
      var hospitalListResponse =
          await _hospitalListRepository.getHospitalFromSearchNew(param);
      hospitalListNewSink.add(ApiResponse.completed(hospitalListResponse));
    } catch (e) {
      hospitalListNewSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<HospitalListResponse> getHospitalObjectusingId(
      String hospitalId) async {
    HospitalListResponse hospitalListResponse;
    hospitalListSink.add(ApiResponse.loading(variable.strGetHospitalById));
    try {
      hospitalListResponse =
          await _hospitalListRepository.gethopitalFromId(hospitalId);
      hospitalListSink.add(ApiResponse.completed(hospitalListResponse));
    } catch (e) {
      hospitalListSink.add(ApiResponse.error(e.toString()));
    }

    return hospitalListResponse;
  }

  getExistingHospitalListNew(String hospitalId) async {
    hospitalListNewSink.add(ApiResponse.loading(variable.strGetHospitalList));
    try {
      final hospitalListResponse = await _hospitalListRepository
          .getExistingHospitalFromSearchNew(hospitalId);
      hospitalListNewSink.add(ApiResponse.completed(hospitalListResponse));
    } catch (e) {
      hospitalListNewSink.add(ApiResponse.error(e.toString()));
    }
  }
}

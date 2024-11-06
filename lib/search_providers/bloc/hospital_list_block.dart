
import 'dart:async';

import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/variable_constant.dart' as variable;
import '../models/hospital_list_response.dart';
import '../models/hospital_list_response_new.dart';
import '../services/hospital_list_repository.dart';
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/resources/network/ApiResponse.dart';

class HospitalListBlock implements BaseBloc {
  late HospitalListRepository _hospitalListRepository;
  StreamController? _hospitalListController;
  StreamController? _hospitalProfileImageControlller;
  late StreamController _hospitalListNewController;

  StreamSink<ApiResponse<HospitalListResponse>> get hospitalListSink =>
      _hospitalListController!.sink as StreamSink<ApiResponse<HospitalListResponse>>;
  Stream<ApiResponse<HospitalListResponse>> get hospitalStream =>
      _hospitalListController!.stream as Stream<ApiResponse<HospitalListResponse>>;

  StreamSink<ApiResponse<HospitalsSearchListResponse>>
      get hospitalListNewSink => _hospitalListNewController.sink as StreamSink<ApiResponse<HospitalsSearchListResponse>>;
  Stream<ApiResponse<HospitalsSearchListResponse>> get hospitalNewStream =>
      _hospitalListNewController.stream as Stream<ApiResponse<HospitalsSearchListResponse>>;

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
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      hospitalListSink.add(ApiResponse.error(e.toString()));
    }
  }

  getHospitalListNew(String? param) async {
    hospitalListNewSink.add(ApiResponse.loading(variable.strGetHospitalList));
    try {
      var hospitalListResponse =
          await _hospitalListRepository.getHospitalFromSearchNew(param);
      hospitalListNewSink.add(ApiResponse.completed(hospitalListResponse));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      hospitalListNewSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<HospitalListResponse?> getHospitalObjectusingId(
      String hospitalId) async {
    HospitalListResponse? hospitalListResponse;
    hospitalListSink.add(ApiResponse.loading(variable.strGetHospitalById));
    try {
      hospitalListResponse =
          await _hospitalListRepository.gethopitalFromId(hospitalId);
      hospitalListSink.add(ApiResponse.completed(hospitalListResponse));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

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
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      hospitalListNewSink.add(ApiResponse.error(e.toString()));
    }
  }
}

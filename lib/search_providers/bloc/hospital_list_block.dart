import 'dart:async';

import 'package:myfhb/search_providers/models/hospital_list_response.dart';
import 'package:myfhb/search_providers/services/hospital_list_repository.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

export 'package:myfhb/search_providers/models/hospital_list_response.dart'
    show Data;

class HospitalListBlock implements BaseBloc {
  HospitalListRepository _hospitalListRepository;
  StreamController _hospitalListController;
  StreamController _hospitalProfileImageControlller;

  StreamSink<ApiResponse<HospitalListResponse>> get hospitalListSink =>
      _hospitalListController.sink;
  Stream<ApiResponse<HospitalListResponse>> get hospitalStream =>
      _hospitalListController.stream;

  @override
  void dispose() {
    _hospitalListController?.close();
  }

  HospitalListBlock() {
    _hospitalListController =
        StreamController<ApiResponse<HospitalListResponse>>();

    _hospitalListRepository = new HospitalListRepository();
  }

  getHospitalList(String param) async {
    hospitalListSink.add(ApiResponse.loading('Signing in user'));
    try {
      HospitalListResponse hospitalListResponse =
          await _hospitalListRepository.getHospitalFromSearch(param);
      hospitalListSink.add(ApiResponse.completed(hospitalListResponse));
    } catch (e) {
      hospitalListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }
}

import 'dart:async';

import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/search_providers/models/labs_list_response.dart';
import 'package:myfhb/search_providers/models/labs_list_response_new.dart';
import 'package:myfhb/search_providers/services/labs_list_repository.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

class LabsListBlock implements BaseBloc {
  LabsListRepository _labsListRepository;
  StreamController _labsListController;

  StreamSink<ApiResponse<LabsListResponse>> get labListSink =>
      _labsListController.sink;
  Stream<ApiResponse<LabsListResponse>> get labStream =>
      _labsListController.stream;

  StreamController _labsListNewController;

  StreamSink<ApiResponse<LabsSearchListResponse>> get labListNewSink =>
      _labsListNewController.sink;
  Stream<ApiResponse<LabsSearchListResponse>> get labNewStream =>
      _labsListNewController.stream;

  @override
  void dispose() {
    _labsListController?.close();
  }

  LabsListBlock() {
    _labsListController = StreamController<ApiResponse<LabsListResponse>>();
    _labsListNewController =
        StreamController<ApiResponse<LabsSearchListResponse>>();

    _labsListRepository = new LabsListRepository();
  }

  getLabsList(String param) async {
    labListSink.add(ApiResponse.loading(variable.strGetLabList));
    try {
      LabsListResponse labsListResponse =
          await _labsListRepository.getLabsFromSearch(param);
      labListSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      labListSink.add(ApiResponse.error(e.toString()));
    }
  }

  getLabsListNew(String param) async {
    labListNewSink.add(ApiResponse.loading(variable.strGetLabList));
    try {
      LabsSearchListResponse labsListResponse =
          await _labsListRepository.getLabsFromSearchNew(param);
      labListNewSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      labListNewSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<LabsListResponse> getLabsListUsingID(String labId) async {
    LabsListResponse labsListResponse;
    labListSink.add(ApiResponse.loading(variable.strGetLabById));
    try {
      labsListResponse = await _labsListRepository.getLabsFromId(labId);
      labListSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      labListSink.add(ApiResponse.error(e.toString()));
    }
    return labsListResponse;
  }
}

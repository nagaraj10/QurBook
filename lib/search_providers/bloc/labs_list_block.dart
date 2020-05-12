import 'dart:async';

import 'package:myfhb/search_providers/models/labs_list_response.dart';
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

  @override
  void dispose() {
    _labsListController?.close();
  }

  LabsListBlock() {
    _labsListController = StreamController<ApiResponse<LabsListResponse>>();

    _labsListRepository = new LabsListRepository();
  }

  getLabsList(String param) async {
    labListSink.add(ApiResponse.loading('Signing in user'));
    try {
      LabsListResponse labsListResponse =
          await _labsListRepository.getLabsFromSearch(param);
      labListSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      labListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  Future<LabsListResponse> getLabsListUsingID(String labId) async {
    LabsListResponse labsListResponse;
    labListSink.add(ApiResponse.loading('Signing in user'));
    try {
      labsListResponse = await _labsListRepository.getLabsFromId(labId);
      labListSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      labListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
    return labsListResponse;
  }
}


import 'dart:async';

import 'package:myfhb/search_providers/models/CityListModel.dart';

import '../../constants/variable_constant.dart' as variable;
import '../models/labs_list_response.dart';
import '../models/labs_list_response_new.dart';
import '../services/labs_list_repository.dart';
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/resources/network/ApiResponse.dart';

class LabsListBlock implements BaseBloc {
  late LabsListRepository _labsListRepository;
  StreamController? _labsListController;

  StreamSink<ApiResponse<LabsListResponse>> get labListSink =>
      _labsListController!.sink as StreamSink<ApiResponse<LabsListResponse>>;
  Stream<ApiResponse<LabsListResponse>> get labStream =>
      _labsListController!.stream as Stream<ApiResponse<LabsListResponse>>;

  late StreamController _labsListNewController;

  StreamSink<ApiResponse<LabsSearchListResponse>> get labListNewSink =>
      _labsListNewController.sink as StreamSink<ApiResponse<LabsSearchListResponse>>;
  Stream<ApiResponse<LabsSearchListResponse>> get labNewStream =>
      _labsListNewController.stream as Stream<ApiResponse<LabsSearchListResponse>>;

  StreamController _cityListNewController;

  StreamSink<ApiResponse<CityListModel>> get cityListNewSink =>
      _cityListNewController.sink;
  Stream<ApiResponse<CityListModel>> get cityNewStream =>
      _cityListNewController.stream;

  @override
  void dispose() {
    _labsListController?.close();
  }

  LabsListBlock() {
    _labsListController = StreamController<ApiResponse<LabsListResponse>>();
    _labsListNewController =
        StreamController<ApiResponse<LabsSearchListResponse>>();
    _cityListNewController =
        StreamController<ApiResponse<CityListModel>>();

    _labsListRepository = LabsListRepository();
  }

  getLabsList(String param) async {
    labListSink.add(ApiResponse.loading(variable.strGetLabList));
    try {
      final labsListResponse =
          await _labsListRepository.getLabsFromSearch(param);
      labListSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      labListSink.add(ApiResponse.error(e.toString()));
    }
  }

  getLabsListNew(String param,bool isFromCreateTicket) async {
    labListNewSink.add(ApiResponse.loading(variable.strGetLabList));
    try {
      final labsListResponse =
          await _labsListRepository.getLabsFromSearchNew(param,isFromCreateTicket);
      labListNewSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      labListNewSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<LabsListResponse?> getLabsListUsingID(String labId) async {
    LabsListResponse? labsListResponse;
    labListSink.add(ApiResponse.loading(variable.strGetLabById));
    try {
      labsListResponse = await _labsListRepository.getLabsFromId(labId);
      labListSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      labListSink.add(ApiResponse.error(e.toString()));
    }
    return labsListResponse;
  }

  getExistingLabsListNew(String param,bool isFromCreateTicket) async {
    labListNewSink.add(ApiResponse.loading(variable.strGetLabList));
    try {
      var labsListResponse =
          await _labsListRepository.getExistingLabsFromSearchNew(param,isFromCreateTicket);
      labListNewSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      labListNewSink.add(ApiResponse.error(e.toString()));
    }
  }

  getCityList(String param) async {
    cityListNewSink.add(ApiResponse.loading(variable.strGetCityList));
    try {
      var labsListResponse = await _labsListRepository.getCityList(param);
      cityListNewSink.add(ApiResponse.completed(labsListResponse));
    } catch (e) {
      cityListNewSink.add(ApiResponse.error(e.toString()));
    }
  }
}

import 'dart:async';

import 'package:myfhb/common/CommonUtil.dart';

import '../../bookmark_record/bloc/bookmarkRecordBloc.dart';
import '../models/my_family_detail_view_repository.dart';
import '../../src/model/Category/CategoryResponseList.dart';
import '../../src/model/Category/catergory_data_list.dart';
import '../../src/model/Health/UserHealthResponseList.dart';
import '../../src/model/Health/asgard/health_record_list.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../constants/router_variable.dart' as router;

class MyFamilyDetailViewBloc implements BaseBloc {
  StreamController? _healthReportListController;
  StreamController? _categoryController;
  StreamController? _categoryControllers;
  StreamController? _healthListControlllers;

  // 1

  StreamSink<ApiResponse<UserHealthResponseList>> get healthReportListSink =>
      _healthReportListController!.sink
          as StreamSink<ApiResponse<UserHealthResponseList>>;

  Stream<ApiResponse<UserHealthResponseList>> get healthReportStream =>
      _healthReportListController!.stream
          as Stream<ApiResponse<UserHealthResponseList>>;

  // 2
  StreamSink<ApiResponse<CategoryResponseList>> get categoryListSink =>
      _categoryController!.sink
          as StreamSink<ApiResponse<CategoryResponseList>>;

  Stream<ApiResponse<CategoryResponseList>> get categoryListStream =>
      _categoryController!.stream as Stream<ApiResponse<CategoryResponseList>>;

  //3

  StreamSink<ApiResponse<CategoryDataList>> get categoryListSinks =>
      _categoryControllers!.sink as StreamSink<ApiResponse<CategoryDataList>>;

  Stream<ApiResponse<CategoryDataList>> get categoryListStreams =>
      _categoryControllers!.stream as Stream<ApiResponse<CategoryDataList>>;

  StreamSink<ApiResponse<HealthRecordList>> get healthReportListSinks =>
      _healthListControlllers!.sink
          as StreamSink<ApiResponse<HealthRecordList>>;
  Stream<ApiResponse<HealthRecordList>> get healthReportStreams =>
      _healthListControlllers!.stream as Stream<ApiResponse<HealthRecordList>>;

  late MyFamilyDetailViewRepository _healthReportListForUserRepository;

  String? userId;

  @override
  void dispose() {
    _healthReportListController?.close();
    _categoryController?.close();
    _categoryControllers?.close();
    _healthListControlllers?.close();
  }

  MyFamilyDetailViewBloc() {
    _healthReportListForUserRepository = MyFamilyDetailViewRepository();

    _healthReportListController =
        StreamController<ApiResponse<UserHealthResponseList>>();

    _categoryController = StreamController<ApiResponse<CategoryResponseList>>();
    _categoryControllers = StreamController<ApiResponse<CategoryDataList>>();

    _healthListControlllers = StreamController<ApiResponse<HealthRecordList>>();
  }

  getHelthReportList() async {
    healthReportListSink.add(ApiResponse.loading(variable.strFetchingHealth));
    try {
      final userHealthResponseList =
          await _healthReportListForUserRepository.getHealthReportList(userId!);
      healthReportListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());

      healthReportListSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<HealthRecordList?> getHelthReportLists(String userId) async {
    HealthRecordList? userHealthResponseList;
    healthReportListSinks
        .add(ApiResponse.loading(variable.strGettingHealthRecords));
    try {
      userHealthResponseList =
          await _healthReportListForUserRepository.getHealthReportLists(userId);
      healthReportListSinks.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());

      healthReportListSinks.add(ApiResponse.error(e.toString()));
    }
    return userHealthResponseList;
  }

  Future<CategoryResponseList?> getCategoryList() async {
    categoryListSink.add(ApiResponse.loading(variable.strFetchCategory));

    CategoryResponseList? categoryResponseList;

    try {
      categoryResponseList =
          await _healthReportListForUserRepository.getCategoryList();
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());

      categoryListSink.add(ApiResponse.error(e.toString()));
    }

    return categoryResponseList;
  }

  Future<CategoryDataList?> getCategoryLists() async {
    categoryListSinks.add(ApiResponse.loading(variable.strFetchCategory));

    CategoryDataList? categoryResponseList;

    try {
      categoryResponseList =
          await _healthReportListForUserRepository.getCategoryLists();
      categoryListSinks.add(ApiResponse.completed(categoryResponseList));
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());

      categoryListSinks.add(ApiResponse.error(e.toString()));
    }

    return categoryResponseList;
  }
}

import 'dart:async';

import 'package:myfhb/bookmark_record/bloc/bookmarkRecordBloc.dart';
import 'package:myfhb/my_family_detail_view/models/my_family_detail_view_repository.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Category/catergory_data_list.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;

class MyFamilyDetailViewBloc implements BaseBloc {
  StreamController _healthReportListController;
  StreamController _categoryController;
  StreamController _categoryControllers;


  // 1

  StreamSink<ApiResponse<UserHealthResponseList>> get healthReportListSink =>
      _healthReportListController.sink;

  Stream<ApiResponse<UserHealthResponseList>> get healthReportStream =>
      _healthReportListController.stream;

  // 2
  StreamSink<ApiResponse<CategoryResponseList>> get categoryListSink =>
      _categoryController.sink;

  Stream<ApiResponse<CategoryResponseList>> get categoryListStream =>
      _categoryController.stream;


  //3

  StreamSink<ApiResponse<CategoryDataList>> get categoryListSinks =>
      _categoryControllers.sink;

  Stream<ApiResponse<CategoryDataList>> get categoryListStreams =>
      _categoryControllers.stream;

  MyFamilyDetailViewRepository _healthReportListForUserRepository;

  String userId;

  @override
  void dispose() {

    _healthReportListController?.close();
    _categoryController?.close();
    _categoryControllers?.close();

  }

  MyFamilyDetailViewBloc() {
    _healthReportListForUserRepository = MyFamilyDetailViewRepository();

    _healthReportListController =
        StreamController<ApiResponse<UserHealthResponseList>>();

    _categoryController = StreamController<ApiResponse<CategoryResponseList>>();
    _categoryController = StreamController<ApiResponse<CategoryDataList>>();
  }

  getHelthReportList() async {
    healthReportListSink.add(ApiResponse.loading(variable.strFetchingHealth));
    try {
      UserHealthResponseList userHealthResponseList =
          await _healthReportListForUserRepository.getHealthReportList(userId);
      healthReportListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      healthReportListSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<CategoryResponseList> getCategoryList() async {
    categoryListSink.add(ApiResponse.loading(variable.strFetchCategory));

    CategoryResponseList categoryResponseList;

    try {
      categoryResponseList =
          await _healthReportListForUserRepository.getCategoryList();
    } catch (e) {
      categoryListSink.add(ApiResponse.error(e.toString()));
    }

    return categoryResponseList;
  }

  Future<CategoryDataList> getCategoryLists() async {
    categoryListSink.add(ApiResponse.loading(variable.strFetchCategory));

    CategoryDataList categoryResponseList;

    try {
      categoryResponseList =
      await _healthReportListForUserRepository.getCategoryLists();
    } catch (e) {
      categoryListSink.add(ApiResponse.error(e.toString()));
    }

    return categoryResponseList;
  }
}

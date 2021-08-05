import 'dart:async';

import '../../../common/PreferenceUtil.dart';
import '../../../constants/fhb_parameters.dart';
import '../Authentication/LoginBloc.dart';
import '../../model/Category/CategoryResponseList.dart';
import '../../model/Category/catergory_data_list.dart';
import '../../resources/network/ApiResponse.dart';
import '../../resources/repository/CategoryRepository/CategoryResponseListRepository.dart';

import '../../../constants/variable_constant.dart' as variable;
import '../../../constants/fhb_constants.dart' as Constants;

class CategoryListBlock implements BaseBloc {
  CategoryResponseListRepository _categoryResponseListRepository;
  StreamController _categoryListControlller;
  StreamController _categoryListControlllers;

  StreamSink<ApiResponse<CategoryResponseList>> get categoryListSink =>
      _categoryListControlller.sink;
  Stream<ApiResponse<CategoryResponseList>> get categoryListStream =>
      _categoryListControlller.stream;

  StreamSink<ApiResponse<CategoryDataList>> get categoryListSinks =>
      _categoryListControlllers.sink;
  Stream<ApiResponse<CategoryDataList>> get categoryListStreams =>
      _categoryListControlllers.stream;

  @override
  void dispose() {
    _categoryListControlller?.close();
    _categoryListControlllers?.close();
  }

  CategoryListBlock() {
    _categoryListControlller =
        StreamController<ApiResponse<CategoryResponseList>>();
    _categoryListControlllers =
        StreamController<ApiResponse<CategoryDataList>>();

    _categoryResponseListRepository = CategoryResponseListRepository();
  }

  Future<CategoryResponseList> getCategoryList() async {
    CategoryResponseList categoryResponseList;
    categoryListSink.add(ApiResponse.loading(variable.strGettingCategory));
    try {
      categoryResponseList =
          await _categoryResponseListRepository.getCategoryList();
      categoryListSink.add(ApiResponse.completed(categoryResponseList));
    } catch (e) {
      categoryListSink.add(ApiResponse.error(e.toString()));
    }
    return categoryResponseList;
  }

  Future<CategoryDataList> getCategoryLists() async {
    CategoryDataList categoryDataList;
    categoryListSinks.add(ApiResponse.loading(variable.strGettingCategory));
    try {
      categoryDataList =
          await _categoryResponseListRepository.getCategoryLists();

      await PreferenceUtil.saveCategoryList(
          Constants.KEY_CATEGORYLIST, categoryDataList.result);

      categoryListSinks.add(ApiResponse.completed(categoryDataList));
    } catch (e) {
      categoryListSinks.add(ApiResponse.error(e.toString()));
    }
    return categoryDataList;
  }
}

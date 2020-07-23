import 'dart:async';

import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/CategoryRepository/CategoryResponseListRepository.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;

class CategoryListBlock implements BaseBloc{

  CategoryResponseListRepository _categoryResponseListRepository;
  StreamController _categoryListControlller;

  StreamSink<ApiResponse<CategoryResponseList>> get categoryListSink => _categoryListControlller.sink;
  Stream<ApiResponse<CategoryResponseList>> get categoryListStream => _categoryListControlller.stream;


  
  @override
  void dispose() {
    _categoryListControlller?.close();
  }

  CategoryListBlock(){
      _categoryListControlller = StreamController<ApiResponse<CategoryResponseList>>();
    _categoryResponseListRepository = CategoryResponseListRepository();

  }

  getCategoryList()async{

    categoryListSink.add(ApiResponse.loading(variable.strGettingCategory));
    try {
      CategoryResponseList categoryResponseList = await _categoryResponseListRepository.getCategoryList();
      categoryListSink.add(ApiResponse.completed(categoryResponseList));
    } catch (e) {
      categoryListSink.add(ApiResponse.error(e.toString()));
      
    }

  }



}
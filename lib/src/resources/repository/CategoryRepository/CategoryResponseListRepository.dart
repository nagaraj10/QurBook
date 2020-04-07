import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
//import 'dart:convert' as convert;

class CategoryResponseListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoryResponseList> getCategoryList() async {
    final response = await _helper.getCategoryList("categories/?sortBy=categoryName.asc&offset=0&limit=10");
    return CategoryResponseList.fromJson(response);
  }
}

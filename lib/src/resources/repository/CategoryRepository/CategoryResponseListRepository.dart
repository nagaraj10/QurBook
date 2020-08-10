import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
//import 'dart:convert' as convert;

class CategoryResponseListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoryResponseList> getCategoryList() async {
    int offset = 0;
    int limit = 100;
    final response = await _helper.getCategoryList("${query.qr_categories} ${query.qr_sortByQ } ${query.qr_category_asc } ${query.qr_And} ${query.qr_offset}${offset.toString()}${query.qr_And}${query.qr_limit}${limit.toString()}");
    return CategoryResponseList.fromJson(response);
  }
}

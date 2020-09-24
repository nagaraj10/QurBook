import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/search_providers/models/labs_list_response.dart';
import 'package:myfhb/search_providers/models/labs_list_response_new.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class LabsListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LabsListResponse> getLabsFromSearch(String param) async {
    int limit = 10;
    final response = await _helper.getHospitalListFromSearch(
        "${query.qr_lab}${query.qr_SearchBy}${query.qr_keyword}${param}${query.qr_And}${query.qr_sortBy}${query.qr_name_asc}${query.qr_And}${query.qr_limit}${limit.toString()}",
        param);
    return LabsListResponse.fromJson(response);
  }

  Future<LabsSearchListResponse> getLabsFromSearchNew(String param) async {
    final response = await _helper.getHospitalListFromSearchNew(
        "${query.qr_health_organization}${query.qr_health_Search}${param}${query.qr_id}${CommonConstants.SEARCH_LAB_ID}");
    return LabsSearchListResponse.fromJson(response);
  }

  Future<LabsListResponse> getLabsFromId(String labId) async {
    final response =
        await _helper.getHospitalAndLabUsingId(query.qr_lab, labId);
    return LabsListResponse.fromJson(response);
  }
}

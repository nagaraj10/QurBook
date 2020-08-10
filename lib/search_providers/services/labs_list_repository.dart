import 'package:myfhb/search_providers/models/labs_list_response.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;

class LabsListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LabsListResponse> getLabsFromSearch(String param) async {
    int limit = 10;
    final response = await _helper.getHospitalListFromSearch(
        "${query.qr_lab} ${query.qr_SearchBy} ${query.qr_keyword} ${param} ${query.qr_And}${query.qr_sortBy}${query.qr_name_asc}${query.qr_And} ${query.qr_limit}${limit.toString()}",
        param);
    return LabsListResponse.fromJson(response);
  }

  Future<LabsListResponse> getLabsFromId(String labId) async {
    final response =
        await _helper.getHospitalAndLabUsingId(query.qr_lab, labId);
    return LabsListResponse.fromJson(response);
  }
}

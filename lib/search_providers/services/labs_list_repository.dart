import 'package:myfhb/search_providers/models/labs_list_response.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class LabsListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LabsListResponse> getLabsFromSearch(String param) async {
    final response = await _helper.getHospitalListFromSearch(
        "laboratories/search?keyword=" + param + "&sortBy=name.asc&limit=10",
        param);
    return LabsListResponse.fromJson(response);
  }

  Future<LabsListResponse> getLabsFromId(String labId) async {
    final response =
        await _helper.getHospitalAndLabUsingId("laboratories/", labId);
    return LabsListResponse.fromJson(response);
  }
}

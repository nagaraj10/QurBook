import 'package:myfhb/search_providers/models/HospitalListResponse.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class HospitalListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<HospitalListResponse> getHospitalFromSearch(String param) async {
    final response = await _helper.getHospitalListFromSearch(
        "hospitals/search?keyword=" + param + "&sortBy=name.asc&limit=10",
        param);
    return HospitalListResponse.fromJson(response);
  }
}

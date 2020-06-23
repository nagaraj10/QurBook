import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'DoctorsListResponse.dart';

class DoctorsListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<DoctorsListResponse> getDoctorsListFromSearch(String param) async {
    final response = await _helper.getDoctorsListFromSearch(
        "doctors/search?sortBy=name.asc&offset=0&limit=10&keyword=", param);
    return DoctorsListResponse.fromJson(response);
  }
}

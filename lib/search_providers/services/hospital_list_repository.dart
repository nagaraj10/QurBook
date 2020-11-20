import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/search_providers/models/hospital_list_response.dart';
import 'package:myfhb/search_providers/models/hospital_list_response_new.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class HospitalListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<HospitalListResponse> getHospitalFromSearch(String param) async {
    int limit = 10;

    final response = await _helper.getHospitalListFromSearch(
        "${query.qr_hopitals}${query.qr_SearchBy}${query.qr_keyword}${param}${query.qr_And}${query.qr_sortBy}${query.qr_name_asc}${query.qr_And}${query.qr_limit}${limit.toString()}",
        param);
    return HospitalListResponse.fromJson(response);
  }

  Future<HospitalsSearchListResponse> getHospitalFromSearchNew(
      String param) async {
    int limit = 10;

    final response = await _helper.getHospitalListFromSearchNew(
        "${query.qr_health_organization}${query.qr_health_Search}${query.qr_healthOrgType}${CommonConstants.SEARCH_HOSPIT_ID}${query.qr_limitSearchText}$param${query.qr_sortByDesc}");
    return HospitalsSearchListResponse.fromJson(response);
  }

  Future<HospitalListResponse> gethopitalFromId(String hospitalId) async {
    final response =
        await _helper.getHospitalAndLabUsingId(query.qr_hopitals, hospitalId);
    return HospitalListResponse.fromJson(response);
  }
}

import '../../common/CommonConstants.dart';
import '../../constants/fhb_query.dart' as query;
import '../models/labs_list_response.dart';
import '../models/labs_list_response_new.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class LabsListRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<LabsListResponse> getLabsFromSearch(String param) async {
    var limit = 10;
    var response = await _helper.getHospitalListFromSearch(
        "${query.qr_lab}${query.qr_SearchBy}${query.qr_keyword}$param${query.qr_And}${query.qr_sortBy}${query.qr_name_asc}${query.qr_And}${query.qr_limit}${limit.toString()}",
        param);
    return LabsListResponse.fromJson(response);
  }

  Future<LabsSearchListResponse> getLabsFromSearchNew(String param) async {
    String categories = '[\"LAB\"]';
    var response = await _helper.getHospitalListFromSearchNew(
        "${query.qr_health_organization}${query.qr_health_Search}${query.qr_healthOrgType}${categories}${query.qr_limitSearchText}$param${query.qr_sortByDesc}");
    return LabsSearchListResponse.fromJson(response);
  }

  Future<LabsListResponse> getLabsFromId(String labId) async {
    var response = await _helper.getHospitalAndLabUsingId(query.qr_lab, labId);
    return LabsListResponse.fromJson(response);
  }

  Future<LabsSearchListResponse> getExistingLabsFromSearchNew(
      String healthOrganizationId) async {
    var limit = 50;
    final skip = 1;

    var response = await _helper.getHospitalListFromSearchNew(
        "${query.qr_patient_update_default}${query.qr_list}${query.qr_healthOrganizationList}${query.qr_skip}${skip.toString()}${query.qr_And}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_halthOrganization}$healthOrganizationId");
    return LabsSearchListResponse.fromJson(response);
  }
}

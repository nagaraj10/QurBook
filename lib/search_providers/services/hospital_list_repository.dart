import '../../common/CommonConstants.dart';
import '../../constants/fhb_query.dart' as query;
import '../models/hospital_list_response.dart';
import '../models/hospital_list_response_new.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class HospitalListRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<HospitalListResponse> getHospitalFromSearch(String param) async {
    final limit = 10;

    var response = await _helper.getHospitalListFromSearch(
        "${query.qr_hopitals}${query.qr_SearchBy}${query.qr_keyword}$param${query.qr_And}${query.qr_sortBy}${query.qr_name_asc}${query.qr_And}${query.qr_limit}${limit.toString()}",
        param);
    return HospitalListResponse.fromJson(response);
  }

  Future<HospitalsSearchListResponse> getHospitalFromSearchNew(
      String param) async {
    final limit = 10;
    List<String> selectedOrganization = ["HOSPTL","CLINIC"];

String categories='[\"HOSPTL\",\"CLINIC\"]';
    var response = await _helper.getHospitalListFromSearchNew(
        "${query.qr_health_organization}${query.qr_health_Search}${query.qr_healthOrgType}$categories${query.qr_limitSearchText}$param${query.qr_sortByDesc}");
    return HospitalsSearchListResponse.fromJson(response);
  }

  Future<HospitalListResponse> gethopitalFromId(String hospitalId) async {
    var response =
        await _helper.getHospitalAndLabUsingId(query.qr_hopitals, hospitalId);
    return HospitalListResponse.fromJson(response);
  }

  Future<HospitalsSearchListResponse> getExistingHospitalFromSearchNew(
      String healthOrganizationId) async {
    final limit = 50;
    final skip = 1;

    var response = await _helper.getHospitalListFromSearchNew(
        "${query.qr_patient_update_default}${query.qr_list}${query.qr_healthOrganizationList}${query.qr_skip}${skip.toString()}${query.qr_And}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_halthOrganization}$healthOrganizationId");
    return HospitalsSearchListResponse.fromJson(response);
  }
}

import 'package:myfhb/search_providers/models/CityListModel.dart';

import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';

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

  Future<LabsSearchListResponse> getLabsFromSearchNew(String param,bool isFromCreateTicket) async {
    String userID = PreferenceUtil.getStringValue(KEY_USERID)!;
    String patientIdQuery="";
    if(isFromCreateTicket){
      if (CommonUtil.REGION_CODE == 'IN') {
        patientIdQuery="${query.qr_patientEqaul}$userID";
      }
    }

    String categories = '[\"LAB\"]';
    var response = await _helper.getHospitalListFromSearchNew(
        "${query.qr_health_organization}${query.qr_health_Search}${query.qr_healthOrgType}${categories}${query.qr_limitSearchText}$param${query.qr_sortByDesc}${patientIdQuery}");
    return LabsSearchListResponse.fromJson(response);
  }

  Future<LabsListResponse> getLabsFromId(String labId) async {
    var response = await _helper.getHospitalAndLabUsingId(query.qr_lab, labId);
    return LabsListResponse.fromJson(response);
  }

  Future<LabsSearchListResponse> getExistingLabsFromSearchNew(
      String healthOrganizationId,bool isFromCreateTicket) async {
    var limit = 50;
    final skip = 1;
    String patientIdQuery="";
    String userID = PreferenceUtil.getStringValue(KEY_USERID)!;

    if(isFromCreateTicket){
      if (CommonUtil.REGION_CODE == 'IN') {
        patientIdQuery="${query.qr_patientEqaul}$userID";
      }
    }

      var response = await _helper.getHospitalListFromSearchNew(
          "${query.qr_patient_update_default}${query.qr_list}${query.qr_healthOrganizationList}${query.qr_skip}${skip.toString()}${query.qr_And}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_halthOrganization}$healthOrganizationId${patientIdQuery}");
      return LabsSearchListResponse.fromJson(response);


  }

  Future<CityListModel> getCityList(String param) async {
    var response = await _helper.getCityList("${query.get_city_list}$param");
    return CityListModel.fromJson(response);
  }
}

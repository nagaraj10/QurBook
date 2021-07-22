import '../../constants/fhb_query.dart' as query;
import '../models/doctor_list_response_new.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

import '../models/doctors_list_response.dart';

class DoctorsListRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<DoctorsListResponse> getDoctorsListFromSearch(String param) async {
    final offset = 0;
    final limit = 10;
    var response = await _helper.getDoctorsListFromSearch(
        "${query.qr_doctors}${query.qr_SearchBy}${query.qr_sortBy}${query.qr_name_asc}${query.qr_And}${query.qr_offset}${offset.toString()}${query.qr_And}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_keyword}",
        param);
    return DoctorsListResponse.fromJson(response);
  }

  Future<DoctorsSearchListResponse> getDoctorsListFromSearchNew(
      String param, bool isSkipUnknown) async {
    final offset = 0;
    var limit = 10;
    var response = await _helper.getDoctorsListFromSearchNew(
        "${query.qr_doctor}${query.qr_SearchBy}${query.qr_SearchText}$param${query.qr_And}${query.qr_include}${query.qr_personal}${query.qr_And}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_skip}$offset${query.qr_And}${query.qr_sortBy}${query.qr_name_desc}${query.qr_And}${query.qr_isSkipUnknown}$isSkipUnknown");

    return DoctorsSearchListResponse.fromJson(response);
  }

  Future<DoctorsListResponse> getDoctorUsingId(String doctorsId) async {
    var response = await _helper.getDoctorsFromId(query.qr_doctors, doctorsId);
    return DoctorsListResponse.fromJson(response);
  }

  Future<DoctorsSearchListResponse> getExistingDoctorsListFromSearchNew(
      limitValue) async {
    final skip = 1;
    var limit = 40;
    var response = await _helper.getDoctorsListFromSearchNew(
        "${query.qr_patient_update_default}${query.qr_list}${query.qr_doctorlist}${query.qr_skip}${skip.toString()}${query.qr_And}${query.qr_limit}${limit.toString()}");

    return DoctorsSearchListResponse.fromJson(response);
  }

  Future<DoctorsListResult> addDoctorFromProvider(String jsonData) async {
    var response = await _helper.addDoctorFromProvider(
        "${query.qr_doctor}${query.qr_reference_doctor}${query.qr_non_qurpro}",
        jsonData);
    if (response['isSuccess']) {
      return DoctorsListResult.fromJson(response['result']);
    }
  }
}

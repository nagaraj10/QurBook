import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/search_providers/models/doctor_list_response_new.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

import '../models/doctors_list_response.dart';

class DoctorsListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<DoctorsListResponse> getDoctorsListFromSearch(String param) async {
    int offset = 0;
    int limit = 10;
    final response = await _helper.getDoctorsListFromSearch(
        "${query.qr_doctors}${query.qr_SearchBy}${query.qr_sortBy}${query.qr_name_asc}${query.qr_And}${query.qr_offset}${offset.toString()}${query.qr_And}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_keyword}",
        param);
    return DoctorsListResponse.fromJson(response);
  }

  Future<DoctorsSearchListResponse> getDoctorsListFromSearchNew(
      String param) async {
    int offset = 0;
    int limit = 10;
    final response = await _helper.getDoctorsListFromSearchNew(
        "${query.qr_doctor}${query.qr_SearchBy}${query.qr_SearchText}${param}${query.qr_And}${query.qr_include}${query.qr_personal}${query.qr_And}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_skip}${offset}${query.qr_And}${query.qr_sortBy}${query.qr_name_desc}");

    return DoctorsSearchListResponse.fromJson(response);
  }

  Future<DoctorsListResponse> getDoctorUsingId(String doctorsId) async {
    final response =
        await _helper.getDoctorsFromId(query.qr_doctors, doctorsId);
    return DoctorsListResponse.fromJson(response);
  }
}

import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

import '../models/doctors_list_response.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;

import 'package:myfhb/constants/router_variable.dart' as router;

class DoctorsListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<DoctorsListResponse> getDoctorsListFromSearch(String param) async {
    int offset = 0;
    int limit = 10;
    final response = await _helper.getDoctorsListFromSearch(
        "${query.qr_doctors}${query.qr_SearchBy}${query.qr_sortBy}${query.qr_name_asc}${query.qr_And}${query.qr_offset}${offset.toString()}${query.qr_limit}${limit.toString()}${query.qr_And}${query.qr_keyword}",
        param);
    return DoctorsListResponse.fromJson(response);
  }

  Future<DoctorsListResponse> getDoctorUsingId(String doctorsId) async {
    final response =
        await _helper.getDoctorsFromId(query.qr_doctors, doctorsId);
    return DoctorsListResponse.fromJson(response);
  }
}

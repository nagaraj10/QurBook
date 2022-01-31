import 'dart:convert' as convert;
import 'dart:io';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/resources/network/AppException.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:http/http.dart';

class FeedbackApiProvider {
  final String _baseUrl = BASE_URL;
  final url = qr_category + '/' + qr_search + qr_Feedback;
  final typeUrl = qr_reference_value + qr_data_codes;
  Future<dynamic> getFeedbacktypes() async {
    Response responseJson;
    try {
      var header = await HeaderRequest().getRequestHeadersWithoutOffset();
      final body = convert.jsonEncode(["FEEDBACK"]);
      responseJson = await ApiServices.post(
        _baseUrl + typeUrl,
        headers: header,
        body: body,
      );
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return null;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> getFeedbackCat() async {
    Response responseJson;
    try {
      var header = await HeaderRequest().getAuth();
      responseJson = await ApiServices.get(
        _baseUrl + url,
        headers: header,
      );
      if (responseJson.statusCode == 200) {
        return responseJson;
      } else {
        return null;
      }
    } on SocketException {
      throw FetchDataException(strNoInternet);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

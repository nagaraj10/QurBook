
import 'dart:convert';
import 'package:http/http.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../constants/HeaderRequest.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_query.dart';
import '../../../resources/network/api_services.dart';

class SheelAIAPIService {
  static bool useRasaAPI = false;
  String mayaUrl =
      useRasaAPI ? CommonUtil.SHEELA_URL : BASE_URL + qr_sheela_lex;

  Future<Response> SheelaAIAPI(Map<String, dynamic> reqJson) async {
    try {
      String jsonString = jsonEncode(reqJson);
      Map<String, dynamic> headerRequest =
          await HeaderRequest().getRequestHeader();
      // print("-----------------Sheela request---------------------");
      // print(reqJson);
      // print("-----------------Sheela Header---------------------");
      // print(headerRequest);
      var response = await ApiServices.post(
        mayaUrl,
        body: jsonString,
        headers: headerRequest as Map<String, String>?,
      );
      // print("-----------------Sheela response---------------------");
      // print(response.body);
      return response!;
    } catch (e) {
                  CommonUtil().appLogs(message: e.toString());

      throw Exception('$e was thrown');
    }
  }

  Future<Response> getAudioFileTTS(Map<String, dynamic> reqJson) async {
    final urlForTTS = BASE_URL + qr_Google_TTS_Proxy_URL;
    try {
      final jsonString = jsonEncode(reqJson);
      final headerRequest = await HeaderRequest().getRequestHeader();
      // print("-----------------Sheela request---------------------");
      // print(reqJson);
      // print("-----------------Sheela Header---------------------");
      // print(headerRequest);
      final response = await ApiServices.post(
        urlForTTS,
        body: jsonString,
        headers: headerRequest,
      );
      // print("-----------------Sheela response---------------------");
      // print(response.body);
      return response!;
    } catch (e) {
                  CommonUtil().appLogs(message: e.toString());

      throw Exception('$e was thrown');
    }
  }
}

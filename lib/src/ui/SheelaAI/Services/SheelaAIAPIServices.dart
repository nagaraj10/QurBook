import 'dart:convert';
import 'package:http/http.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../constants/HeaderRequest.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_query.dart';
import '../../../resources/network/api_services.dart';

class SheelAIAPIService {
  String mayaUrl = CommonUtil.SHEELA_URL;

  Future<Response> SheelaAIAPI(Map<String, dynamic> reqJson) async {
    try {
      String jsonString = jsonEncode(reqJson);
      Map<String, dynamic> headerRequest =
          await HeaderRequest().getRequesHeaderWithoutToken();
      print("-----------------Sheela request---------------------");
      print(reqJson);
      print("-----------------Sheela Header---------------------");
      print(headerRequest);
      var response = await ApiServices.post(
        mayaUrl,
        body: jsonString,
        headers: headerRequest,
      );
      print("-----------------Sheela response---------------------");
      print(response.body);
      return response;
    } catch (e) {
      throw Exception('$e was thrown');
    }
  }

  Future<Response> getAudioFileTTS(Map<String, dynamic> reqJson) async {
    final urlForTTS = BASE_URL + qr_Google_TTS_Proxy_URL;
    try {
      final jsonString = jsonEncode(reqJson);
      final headerRequest =
          await HeaderRequest().getRequestHeadersAuthContent();
      print("-----------------Sheela request---------------------");
      print(reqJson);
      print("-----------------Sheela Header---------------------");
      print(headerRequest);
      final response = await ApiServices.post(
        urlForTTS,
        body: jsonString,
        headers: headerRequest,
      );
      print("-----------------Sheela response---------------------");
      print(response.body);
      return response;
    } catch (e) {
      throw Exception('$e was thrown');
    }
  }
}

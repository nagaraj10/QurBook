import 'dart:convert';

import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as variable;
import 'package:myfhb/src/resources/network/api_services.dart';

class Service {
  String mayaUrl = CommonUtil.SHEELA_URL;

  Future<dynamic> sendMetaToMaya(Map<String, dynamic> reqJson) async {
    try {
      String jsonString = jsonEncode(reqJson);

      HeaderRequest headerRequest = new HeaderRequest();

      var response = await ApiServices.post(
        mayaUrl,
        body: jsonString,
        headers: await headerRequest.getRequesHeaderWithoutToken(),
      );

      return response;
    } catch (e) {
      throw Exception('$e was thrown');
    }
  }

  Future<dynamic> getAudioFileTTS(Map<String, dynamic> reqJson) async {
    final urlForTTS = Constants.BASE_URL + variable.qr_Google_TTS_Proxy_URL;
    try {
      final jsonString = jsonEncode(reqJson);
      final headerRequest =
          await HeaderRequest().getRequestHeadersAuthContent();
      final response = await ApiServices.post(
        urlForTTS,
        body: jsonString,
        headers: headerRequest,
      );

      return response;
    } catch (e) {
      throw Exception('$e was thrown');
    }
  }

  Future<dynamic> getAudioFileRegiments(Map<String, dynamic> reqJson) async {
    final urlForTTS = Constants.BASE_URL + variable.qr_Google_TTS_Regiment_URL;
    try {
      final jsonString = jsonEncode(reqJson);
      final headerRequest =
          await HeaderRequest().getRequestHeadersAuthContent();
      final response = await ApiServices.post(
        urlForTTS,
        body: jsonString,
        headers: headerRequest,
      );

      return response;
    } catch (e) {
      throw Exception('$e was thrown');
    }
  }
}

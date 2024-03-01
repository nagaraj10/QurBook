
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/SheelaVoiceIdModel.dart';
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
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      throw Exception('$e was thrown');
    }
  }

  Future<Response> SheelaAISynonymsAPI(Map<String, dynamic> reqJson) async {
    try {
      final sheelaSynonymsUrl = BASE_URL + qr_sheela_synonyms;
      // Encode request JSON
      final jsonString = jsonEncode(reqJson);
      // Get request headers
      final Map<String, dynamic> headerRequest =
      await HeaderRequest().getRequestHeader();
      // Make POST request to Sheela AI ValidateSynonyms API
      final response = await ApiServices.post(
        sheelaSynonymsUrl,
        body: jsonString,
        headers: headerRequest as Map<String, String>?,
      );
      return response!;
    } catch (e, stackTrace) {
      // Log any exceptions
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      // Throw the exception
      throw Exception('$e was thrown');
    }
  }


  Future<Response> getAudioFileTTS(Map<String, dynamic> reqJson) async {
    var strVoiceId = await getVoiceId();
    final urlForTTS = BASE_URL + qr_TTS_Proxy_URL;
    try {
      reqJson[qr_voiceId]= strVoiceId??'';
      if(kDebugMode){
        log("getAudioFileTTS voiceId $strVoiceId");
      }
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
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      throw Exception('$e was thrown');
    }
  }

  Future<Response> getTextTranslate(Map<String, dynamic> reqJson) async {
    final urlForTextTranslate = BASE_URL + qr_Text_Translate;
    try {
      final jsonString = jsonEncode(reqJson);
      final headerRequest = await HeaderRequest().getRequestHeader();
      final response = await ApiServices.post(
        urlForTextTranslate,
        body: jsonString,
        headers: headerRequest,
      );
      return response!;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      throw Exception('$e was thrown');
    }
  }

  Future<String?> getVoiceId() async {
    final urlForTextTranslate = BASE_URL + qr_Get_VoiceId;
    try {

      String strUserIdTemp = await PreferenceUtil.getStringValue(KEY_USERID) ?? '';

      final headerRequest = await HeaderRequest().getRequestHeader();
      final response = await ApiServices.get(
        urlForTextTranslate+strUserIdTemp,
        headers: headerRequest,
      );
      if (response?.statusCode == 200) {
        final data = jsonDecode(response?.body??'');
        final SheelaVoiceIdModel sheelaVoiceIdModel =
        SheelaVoiceIdModel.fromJson(data);
        if ((sheelaVoiceIdModel != null) &&
            (sheelaVoiceIdModel.isSuccess ?? false)) {
          return (sheelaVoiceIdModel?.result?.voiceClone?.voiceId ?? '');
        } else {
          return '';
        }
      } else {
        return '';
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      throw Exception('$e was thrown');
    }
  }


}

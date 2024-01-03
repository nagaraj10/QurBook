import 'dart:io';

import 'package:dio/dio.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';

import '../../../constants/fhb_constants.dart' as Constants;
class VoiceCloneServices{
  final String _baseUrl = Constants.BASE_URL;

  Future<dynamic>uploadVoiceClone(String? audioPath) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestHeader: true, responseHeader: true, requestBody: true, responseBody: true));
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers['authorization'] = authToken;
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();
    final file = File(audioPath!);
    final fileName = file.path.split('/').last;
    var multipartFile = await MultipartFile.fromFile(
      '${file.path}',
      filename: '$fileName',
    );
    var formData = FormData.fromMap({
      'userId': '$userId',
      'file': multipartFile,
      'healthOrganizationId': '${CommonUtil().getHealthOrganizationID()}',
    });
    var response;
    try {
      response = await dio.post('${_baseUrl}voice-clone', data: formData);
      if (response.statusCode == 200) {
        print(response.data.toString());
        return response;
      } else {
        return response;
      }
    } on DioError catch (e, stackTrace) {
      print(e.toString());
      print(e);
      return response;
    }
  }
}
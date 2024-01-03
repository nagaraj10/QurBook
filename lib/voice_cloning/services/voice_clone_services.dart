import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/common_response_model.dart';
import '../../constants/variable_constant.dart' as variable;

import '../../../constants/fhb_constants.dart' as Constants;
class VoiceCloneServices{
  final String _baseUrl = Constants.BASE_URL;

  Future<CommonResponseModel>uploadVoiceClone(String? audioPath) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var healthorganizationId = PreferenceUtil.getStringValue(Constants.keyHealthOrganizationId);
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestHeader: true, requestBody: true, responseBody: true));
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers['authorization'] = authToken;
    dio.options.headers['Connection'] = 'keep-alive';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();
    final file = File(audioPath!);
    final fileName = file.path.split('/').last;
    var multipartFile = await MultipartFile.fromFile(
      '${file.path}',
      filename: '$fileName',
    );
    var formData = FormData.fromMap({
      'userId':userId,
      'file': multipartFile,
      'healthOrganizationId':healthorganizationId,
    });
    var response;
    try {
      response = await dio.post('${_baseUrl}voice-clone', data: formData);
      if (response.statusCode == 200) {
        print(response.data.toString());
        return CommonResponseModel(
          isSuccess: true,
          message: '',
        );
      } else {
        var errorMessage = response.errorMessage;
        return CommonResponseModel(
          isSuccess: true,
          message: errorMessage??variable.strSomethingWrong,
        );
      }
    } on DioError catch (e, stackTrace) {
      return CommonResponseModel(
        isSuccess: false,
        message: '${e.message}',
      );
    }
  }
}
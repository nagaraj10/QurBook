import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/common_response_model.dart';
import '../../constants/variable_constant.dart' as variable;

import '../../../constants/fhb_constants.dart' as Constants;

class VoiceCloneServices {
  final String _baseUrl = Constants.BASE_URL;

  Future<CommonResponseModel> uploadVoiceClone(String? audioPath) async {
    // Retrieve authentication token, user ID, and health organization ID from preferences
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var healthOrganizationId =
    PreferenceUtil.getStringValue(Constants.keyHealthOrganizationId);

    // Create a Dio instance for making HTTP requests
    var dio = Dio();

    // Add interceptors to log request and response details during API calls
    dio.interceptors.add(LogInterceptor(
        requestHeader: true, requestBody: true, responseBody: true));

    // Set headers for the request
    dio.options.headers['content-type'] = 'multipart/form-data';
    dio.options.headers['authorization'] = authToken;
    dio.options.headers['Connection'] = 'keep-alive';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    // Get file information from the provided audio path
    final file = File(audioPath!);
    final fileName = file.path.split('/').last;

    // Create a MultipartFile from the file
    var multipartFile = await MultipartFile.fromFile(
      '${file.path}',
      filename: '$fileName',
    );

    // Create form data with necessary parameters
    var formData = FormData.fromMap({
      'userId': userId,
      'file': multipartFile,
      'healthOrganizationId': healthOrganizationId,
    });

    var response;

    try {
      // Make a POST request to the voice-clone endpoint with the form data
      response = await dio.post('${_baseUrl}voice-clone', data: formData);

      // Check the response status code
      if (response.statusCode == 200) {
        // If successful, return a CommonResponseModel with success status and no message
        return CommonResponseModel(
          isSuccess: true,
          message: '',
        );
      } else {
        // If not successful, extract the error message or use a default message
        var errorMessage = response.errorMessage;
        return CommonResponseModel(
          isSuccess: true,
          message: errorMessage ?? variable.strSomethingWrong,
        );
      }
    } on DioError catch (e, stackTrace) {
      // If DioError occurs, return a CommonResponseModel with failure status and the error message
      return CommonResponseModel(
        isSuccess: false,
        message: '${e.message}',
      );
    }
  }
}

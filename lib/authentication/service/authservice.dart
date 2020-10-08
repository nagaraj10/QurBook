import 'dart:io';

import 'package:myfhb/authentication/constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfhb/authentication/model/error_response_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class AuthService {
  String _auth_base_url = 'https://dwtg3mk9sjz8epmqfo.vsolgmi.com/api/auth/';
  HeaderRequest headerRequest = new HeaderRequest();
  Future<dynamic> patientsignupservice(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        _auth_base_url + strSignUpEndpoint,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: json.encode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        String responseString = responseResult[strResult][strUserId];
        await PreferenceUtil.saveString(
            Constants.KEY_USERID_MAIN, responseString);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> patientloginservice(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        _auth_base_url + strSignEndpoint,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        String responseString = responseResult[strResult];
        await PreferenceUtil.saveString(
            Constants.KEY_AUTHTOKEN, responseString);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> resendOtpservice(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        _auth_base_url + strResendConfirmCode,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> forgotPasswordservice(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        _auth_base_url + strKeyForgotPassword,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> forgotConfirmPasswordservice(
      Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        _auth_base_url + strKeyConfirmForgotPassword,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> verifyPatientService(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        _auth_base_url + strUserVerifyEndpoint,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        String responseString = responseResult[strResult];
        await PreferenceUtil.saveString(
            Constants.KEY_AUTHTOKEN, responseString);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> verifyOtpService(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        Constants.BASE_URL + strOtpVerifyEndpoint,
        /* headers: <String, String>{
          c_content_type_key: c_content_type_val,
          c_auth_key:
              '$strBearer ${await PreferenceUtil.getStringValue(strKeyVerifyOtpToken)}',
        }, */
        headers: await headerRequest.getRequestHeadersAuthContents(),
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        String responseString = responseResult[strResult];
        await PreferenceUtil.saveString(
            Constants.KEY_AUTHTOKEN, responseString);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> changePasswordservice(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        _auth_base_url + strKeyChangeUserService,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
          c_auth_key:
              '$strBearer ${await PreferenceUtil.getStringValue(strKeyVerifyOtpService)}',
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> verifyOTPservice(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        Constants.BASE_URL + strKeyVerifyFamilyMemberEP,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
          c_auth_key:
              '$strBearer ${PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)}',
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  dynamic createErrorJsonString(http.Response response) {
    ErrorModelResponse errorModelResponse =
        ErrorModelResponse.fromJson(jsonDecode(response.body));
    Map<String, dynamic> errorJson = new Map();
    errorJson[strStatus] = errorModelResponse.status;
    errorJson[strmessage] = errorModelResponse.message;
    errorJson[strIsSuccess] = errorModelResponse.success;

    return errorJson;
  }

  dynamic spocketException() {
    Map<String, dynamic> errorJson = new Map();
    errorJson[strStatus] = 100;
    errorJson[strmessage] = strWentWrong;
    errorJson[strIsSuccess] = false;

    return errorJson;
  }

  Future<dynamic> verifyUserOtpService(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        Constants.BASE_URL + strUserOtpVerifyEndpoint,
        headers: await headerRequest.getRequestHeadersAuthContents(),
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        var responseResult = jsonDecode(response.body);
        String responseString = responseResult[strResult];
        await PreferenceUtil.saveString(
            Constants.KEY_AUTHTOKEN, responseString);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }
}

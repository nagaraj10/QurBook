import 'dart:io';

import 'package:myfhb/src/resources/network/api_services.dart';

import '../constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/error_response_model.dart';
import '../model/otp_response_model.dart';
import '../model/ivr_number_model.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/HeaderRequest.dart';
import '../../constants/fhb_constants.dart' as Constants;

class AuthService {
  final String _auth_base_url = CommonUtil.BASE_URL_FROM_RES + 'auth/';
  HeaderRequest headerRequest = HeaderRequest();
  Future<dynamic> patientsignupservice(Map<String, dynamic> params) async {
    try {
      var response = await ApiServices.post(
        _auth_base_url + strSignUpEndpoint,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: json.encode(params),
      );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
        final String responseString = responseResult[strResult][strUserId];
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
      var response = await ApiServices.post(
        _auth_base_url + strSignEndpoint,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
        final String responseString = responseResult[strResult];
        await PreferenceUtil.saveString(
            Constants.KEY_AUTHTOKEN, responseString);
        return responseResult;
      } else if (response.statusCode == 500) {
        final responseResult = jsonDecode(response.body);
        final String responseString = responseResult[strResult];
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
      var response = await ApiServices.post(
        _auth_base_url + strResendConfirmCode,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> resendOtpserviceForAddingFamilyMember(
      Map<String, dynamic> params) async {
    var path = Constants.BASE_URL + strResendGenerateOTP;
    var headers = await headerRequest.getRequestHeadersAuthContents();
    try {
      final response = await ApiServices.post(path,
          headers: headers, body: jsonEncode(params));
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
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
      var response = await ApiServices.post(
        _auth_base_url + strKeyForgotPassword,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
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
      var response = await ApiServices.post(
        _auth_base_url + strKeyConfirmForgotPassword,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
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
      var response = await ApiServices.post(
        _auth_base_url + strUserVerifyEndpoint,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
        final String responseString = responseResult[strResult];
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
      var response = await ApiServices.post(
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
        final responseResult = jsonDecode(response.body);
        final String responseString = responseResult[strResult];
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
      var response = await ApiServices.post(
        _auth_base_url + strKeyChangeUserService,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
          c_auth_key:
              '$strBearer ${PreferenceUtil.getStringValue(strKeyVerifyOtpService)}',
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
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
      var response = await ApiServices.post(
        Constants.BASE_URL + strKeyVerifyFamilyMemberEP,
        headers: <String, String>{
          c_content_type_key: c_content_type_val,
          c_auth_key:
              '$strBearer ${PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)}',
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  dynamic createErrorJsonString(http.Response response) {
    final errorModelResponse =
        ErrorModelResponse.fromJson(jsonDecode(response.body));
    final errorJson = Map<String, dynamic>();
    errorJson[strStatus] = errorModelResponse.status;
    errorJson[strmessage] = errorModelResponse.message;
    errorJson[strIsSuccess] = errorModelResponse.success;

    return errorJson;
  }

  dynamic spocketException() {
    var errorJson = Map<String, dynamic>();
    errorJson[strStatus] = 100;
    errorJson[strmessage] = strWentWrong;
    errorJson[strIsSuccess] = false;

    return errorJson;
  }

  Future<dynamic> verifyUserOtpService(Map<String, dynamic> params) async {
    try {
      var response = await ApiServices.post(
        Constants.BASE_URL + strUserOtpVerifyEndpoint,
        headers: await headerRequest.getRequestHeadersAuthContents(),
        body: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);
        //String responseString = responseResult[strResult];
        // await PreferenceUtil.saveString(
        //     Constants.KEY_AUTHTOKEN, responseString);
        return responseResult;
      } else {
        return createErrorJsonString(response);
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> addDoctorAsProvider(String jsonBody) async {
    var responseJson;
    var requestHeaders = <String, String>{
      'authorization': PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN),
      'Content-Type': 'application/json'
    };
    try {
      var response = await ApiServices.put(
          Constants.BASE_URL + 'doctor/onboard-existing-entity-acknowledgement',
          body: jsonBody,
          headers: requestHeaders);

      responseJson = jsonDecode(response.body);
    } on SocketException {
      return spocketException();
    }
    return responseJson;
  }

  Future<IvrNumberModel> getIVRNumbers() async {
    var responseJson;
    var requestHeaders = <String, String>{
      'authorization': PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN),
      'Content-Type': 'application/json'
    };
    try {
      var response = await ApiServices.get(
          Constants.BASE_URL + 'authentication-log/get-ivr-number/',
          headers: requestHeaders);
      responseJson = IvrNumberModel.fromJson(jsonDecode(response.body));
    } on SocketException {
      return spocketException();
    }
    return responseJson;
  }

  Future<OtpResponseModel> getOTPFromCall(String phoneNumber) async {
    var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
    try {
      var response = await ApiServices.get(
        Constants.BASE_URL +
            'authentication-log/polling/?phone=${phoneNumber ?? ''}&source=myFHB',
        headers: headerRequest,
      );
      if (response != null) {
        return OtpResponseModel.fromJson(jsonDecode(response.body) ?? {});
      } else {
        return OtpResponseModel(
          isSuccess: false,
        );
      }
    } on SocketException {
      return spocketException();
    }
  }

  Future<dynamic> getApiForAddContactsPatient(
      String url, String jsonBody) async {
    var responseJson;
    var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
    try {
      //! this is need to be uncomment
      var response = await ApiServices.post(Constants.BASE_URL + url,
          headers: headerRequest, body: jsonBody);
      // final response = await ApiServices.post('https://c0f6a853-f0e6-4a92-89b3-8e6cf34f9834.mock.pstmn.io/user/refer-friend',
      //     headers: await headerRequest, body: jsonBody);
      responseJson = jsonDecode(response?.body);
    } on SocketException {
      return spocketException();
    }
    return responseJson;
  }
}

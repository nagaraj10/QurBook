import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/Authentication/OTPEmailResponse.dart';
import 'package:myfhb/src/model/Authentication/OTPResponse.dart';
import 'package:myfhb/src/model/Authentication/SignIn.dart';
import 'package:myfhb/src/model/Authentication/SignOutResponse.dart';
import 'package:myfhb/src/model/Authentication/SignUp.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class AuthenticationRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SignIn> signInUser(String signInData) async {
    final response = await _helper.signIn(query.qr_auth+query.qr_slash+query.qr_signin, signInData);
    try {
      if (response is String) {
        return SignIn.fromJson(convert.jsonDecode(response));
      }
    } catch (e) {}
    return SignIn.fromJson(response);
  }

  Future<OTPResponse> verifyOTP(String otpVerifyData) async {
    final response =
        await _helper.verifyOTP(query.qr_auth+query.qr_slash+query.qr_verifyotp, otpVerifyData);
    return OTPResponse.fromJson(response);
  }

  Future<OTPResponse> generateOTP(String otpVerifyData) async {
    final response =
        await _helper.verifyOTP(query.qr_auth+query.qr_slash+query.qr_generateotp, otpVerifyData);
    return OTPResponse.fromJson(response);
  }

  Future<SignUp> signUpUser(
      String countryCode,
      String phoneNumber,
      String email,
      String gender,
      String name,
      String passsword,
      String bloodGroup,
      String dateOfBirth,
      File file,
      String middleName,
      String lastName) async {
    Map<String, dynamic> mapForSignUp = new Map();
   // mapForSignUp['sourceName'] = CommonConstants.strTrident;
    mapForSignUp[parameters.strCountryCode] = countryCode;
    mapForSignUp[parameters.strPhoneNumber] = phoneNumber;
    mapForSignUp[parameters.strEmail] = email;
    mapForSignUp[parameters.strGender] = gender;
    mapForSignUp[parameters.strfirstName] = name;
    mapForSignUp[parameters.strlastName] = lastName;
    mapForSignUp[parameters.strSourceId] = parameters.strSrcIdVal;
    mapForSignUp[parameters.strEntityId] = parameters.strEntityIdVal;
    mapForSignUp[parameters.strRoleId] = parameters.strRoleIdVal;

    if (middleName != '') mapForSignUp[parameters.strmiddleName] = middleName;

    if (passsword != '') mapForSignUp[parameters.strpassword] = passsword;
    if (bloodGroup != '') mapForSignUp[parameters.strbloodGroup] = bloodGroup;
    if (dateOfBirth != '') mapForSignUp[parameters.strdateOfBirth] = dateOfBirth;
    if (file != null) {
      String fileNoun = file.path.split('/').last;

      mapForSignUp[parameters.strprofilePic] =
          await MultipartFile.fromFile(file.path, filename: fileNoun);
    }
    //ssfinal response;
    
    final response =
        await _helper.signUpPage(query.qr_auth+query.qr_slash+query.qr_signup, mapForSignUp);
    return SignUp.fromJson(response);
  }

  Future<AddFamilyOTPResponse> verifyAddFamilyOTP(String otpVerifyData) async {
    final response = await _helper.verifyAddFamilyOTP(
        query.qr_userlinking+query.qr_verifyotp, otpVerifyData);
    return AddFamilyOTPResponse.fromJson(response);
  }

  Future<SignOutResponse> signOutUser() async {
    final response = await _helper.signoutPage(query.qr_auth+query.qr_slash+query.qr_signout);
    try {
      if (response is String) {
        return SignOutResponse.fromJson(convert.jsonDecode(response));
      }
    } catch (e) {}
    return SignOutResponse.fromJson(response);
  }

  Future<OTPEmailResponse> verifyOTPFromEmail(String verifyEmailOTP) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.verifyOTPFromEmail(
        query.qr_Userprofile+ userID + query.qr_slash+query.qr_verifymail, verifyEmailOTP);
    return OTPEmailResponse.fromJson(response);
  }
}

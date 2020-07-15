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

class AuthenticationRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SignIn> signInUser(String signInData) async {
    final response = await _helper.signIn("authentication/signin", signInData);
    try {
      if (response is String) {
        return SignIn.fromJson(convert.jsonDecode(response));
      }
    } catch (e) {}
    return SignIn.fromJson(response);
  }

  Future<OTPResponse> verifyOTP(String otpVerifyData) async {
    final response =
        await _helper.verifyOTP("authentication/verifyotp", otpVerifyData);
    return OTPResponse.fromJson(response);
  }

  Future<OTPResponse> generateOTP(String otpVerifyData) async {
    final response =
        await _helper.verifyOTP("authentication/generateOTP", otpVerifyData);
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
    mapForSignUp['sourceName'] = CommonConstants.strTrident;
    mapForSignUp['countryCode'] = countryCode;
    mapForSignUp['phoneNumber'] = phoneNumber;
    mapForSignUp['email'] = email;
    mapForSignUp['gender'] = gender;
    mapForSignUp['firstName'] = name;
    mapForSignUp['lastName'] = lastName;
    mapForSignUp['sourceId'] = "e13019a4-1446-441b-8af1-72c40c725548";
    mapForSignUp['entityId'] = "28858877-4710-4dd3-899f-0efe0e9255db";
    mapForSignUp['roleId'] = "285bbe41-3030-4b0e-b914-00e404a77032";

    if (middleName != '') mapForSignUp['middleName'] = middleName;

    if (passsword != '') mapForSignUp['password'] = passsword;
    if (bloodGroup != '') mapForSignUp['bloodGroup'] = bloodGroup;
    if (dateOfBirth != '') mapForSignUp['dateOfBirth'] = dateOfBirth;
    if (file != null) {
      String fileNoun = file.path.split('/').last;

      mapForSignUp["profilePic"] =
          await MultipartFile.fromFile(file.path, filename: fileNoun);
    }
    //ssfinal response;
    
    final response =
        await _helper.signUpPage("authentication/signup", mapForSignUp);
    return SignUp.fromJson(response);
  }

  Future<AddFamilyOTPResponse> verifyAddFamilyOTP(String otpVerifyData) async {
    final response = await _helper.verifyAddFamilyOTP(
        "userLinking/verifyotp", otpVerifyData);
    return AddFamilyOTPResponse.fromJson(response);
  }

  Future<SignOutResponse> signOutUser() async {
    final response = await _helper.signoutPage('authentication/signout');
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
        "userProfiles/" + userID + "/verifyMail", verifyEmailOTP);
    return OTPEmailResponse.fromJson(response);
  }
}

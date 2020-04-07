import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/model/Authentication/OTPResponse.dart';
import 'package:myfhb/src/model/Authentication/SignIn.dart';
import 'package:myfhb/src/model/Authentication/SignOutResponse.dart';
import 'package:myfhb/src/model/Authentication/SignUp.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:dio/dio.dart';

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
      File file) async {
    Map<String, dynamic> mapForSignUp = new Map();
    mapForSignUp['sourceName'] = CommonConstants.strTrident;
    mapForSignUp['countryCode'] = countryCode;
    mapForSignUp['phoneNumber'] = phoneNumber;
    mapForSignUp['email'] = email;
    mapForSignUp['gender'] = gender;
    mapForSignUp['name'] = name;
    if (passsword != '') mapForSignUp['password'] = passsword;
    if (bloodGroup != '') mapForSignUp['bloodGroup'] = bloodGroup;
    if (dateOfBirth != '') mapForSignUp['dateOfBirth'] = dateOfBirth;
    if (file != null) {
      String fileNoun = file.path.split('/').last;

      mapForSignUp["profilePic"] =
          await MultipartFile.fromFile(file.path, filename: fileNoun);
    }
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
}

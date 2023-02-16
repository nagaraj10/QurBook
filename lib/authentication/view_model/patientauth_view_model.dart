import 'package:flutter/cupertino.dart';
import '../../add_family_otp/models/add_family_otp_response.dart';
import '../model/change_password_model.dart';
import '../model/confirm_password_model.dart';
import '../model/forgot_password_model.dart';
import '../model/patientverify_model.dart';
import '../model/patientlogin_model.dart';
import '../model/patientsignup_model.dart';
import '../model/resend_otp_model.dart';
import '../service/authservice.dart';
import 'dart:convert';
import 'package:myfhb/src/resources/network/api_services.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  List<UserContactCollection3> userCollection = [];
  Future<PatientSignUp> registerPatient(Map<String, dynamic> params) async {
    final signupResponse = await _authService.patientsignupservice(params);
    final signup = PatientSignUp.fromJson(signupResponse);
    return signup;
  }

  Future<PatientLogIn> loginPatient(Map<String, dynamic> params) async {
    final signupResponse = await _authService.patientloginservice(params);
    final login = PatientLogIn.fromJson(signupResponse);
    return login;
  }

  Future<PatientSignupOtp> verifyPatient(Map<String, dynamic> params) async {
    final otpResponse = await _authService.verifyPatientService(params);
    var otp = PatientSignupOtp.fromJson(otpResponse);
    return otp;
  }

  Future<PatientSignupOtp> verifyOtp(Map<String, dynamic> params) async {
    final otpResponse = await _authService.verifyOtpService(params);
    var otp = PatientSignupOtp.fromJson(otpResponse);
    return otp;
  }

  Future<ResendOtpModel> resendOtp(Map<String, dynamic> params) async {
    final resendResponse = await _authService.resendOtpservice(params);
    final resend = ResendOtpModel.fromJson(resendResponse);
    return resend;
  }

  Future<ResendOtpModel> resendOtpForAddingFamilyMember(
      Map<String, dynamic> params) async {
    final resendResponse =
        await _authService.resendOtpserviceForAddingFamilyMember(params);
    final resend = ResendOtpModel.fromJson(resendResponse);
    return resend;
  }

  Future<PatientForgotPasswordModel> resetPassword(
      Map<String, dynamic> params) async {
    final resetResponse = await _authService.forgotPasswordservice(params);
    final reset = PatientForgotPasswordModel.fromJson(resetResponse);
    return reset;
  }

  Future<PatientConfirmPasswordModel> confirmPassword(
      Map<String, dynamic> params) async {
    final resetResponse =
        await _authService.forgotConfirmPasswordservice(params);
    var reset = PatientConfirmPasswordModel.fromJson(resetResponse);
    return reset;
  }

  Future<ChangePasswordModel> changePassword(
      Map<String, dynamic> params) async {
    final changeResponse = await _authService.changePasswordservice(params);
    var change = ChangePasswordModel.fromJson(changeResponse);
    return change;
  }

  Future<AddFamilyOTPResponse> verifyMyOTP(Map<String, dynamic> params) async {
    final otpResponse = await _authService.verifyUserOtpService(params);
    var response = AddFamilyOTPResponse.fromJson(otpResponse);
    return response;
  }
}

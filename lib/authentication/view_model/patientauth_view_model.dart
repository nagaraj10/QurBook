import 'package:flutter/cupertino.dart';
import 'package:myfhb/authentication/model/patientverify_model.dart';
import 'package:myfhb/authentication/model/patientlogin_model.dart';
import 'package:myfhb/authentication/model/patientsignup_model.dart';
import 'package:myfhb/authentication/model/resend_otp_model.dart';
import 'package:myfhb/authentication/service/authservice.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  List<UserContactCollection3> userCollection = new List();
  Future<PatientSignUp> registerPatient(Map<String, dynamic> params) async {
    var signupResponse = await _authService.patientsignupservice(params);
    PatientSignUp signup = PatientSignUp.fromJson(signupResponse);
    return signup;
  }

  Future<PatientLogIn> loginPatient(Map<String, dynamic> params) async {
    var signupResponse = await _authService.patientloginservice(params);
    PatientLogIn login = PatientLogIn.fromJson(signupResponse);
    return login;
  }

  Future<PatientSignupOtp> verifyPatient(Map<String, dynamic> params) async {
    var otpResponse = await _authService.verifyPatientService(params);
    PatientSignupOtp otp = PatientSignupOtp.fromJson(otpResponse);
    return otp;
  }

  Future<PatientSignupOtp> verifyOtp(Map<String, dynamic> params) async {
    var otpResponse = await _authService.verifyOtpService(params);
    PatientSignupOtp otp = PatientSignupOtp.fromJson(otpResponse);
    return otp;
  }

  Future<ResendOtpModel> resendOtp(Map<String, dynamic> params) async {
    var resendResponse = await _authService.resendOtpservice(params);
    ResendOtpModel resend = ResendOtpModel.fromJson(resendResponse);
    return resend;
  }
}

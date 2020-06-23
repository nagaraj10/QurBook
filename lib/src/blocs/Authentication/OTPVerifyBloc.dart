import 'dart:async';
import 'package:myfhb/src/model/Authentication/OTPEmailResponse.dart';
import 'package:myfhb/src/model/Authentication/OTPResponse.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/AuthenticationRepository.dart';
import 'package:myfhb/src/utils/Validators.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import '../../../common/CommonConstants.dart';

class OTPVerifyBloc with Validators implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _otpVerifyController;

  final _mobileNumberController = BehaviorSubject<String>();

  Function(String) get mobileNumberChanged => _mobileNumberController.sink.add;

  Stream<String> get mobileNumber =>
      _mobileNumberController.stream.transform(mobileNumberValidator);
  Stream<bool> get submitCheck => mobileNumber.map((m) => true);

  StreamSink<ApiResponse<OTPResponse>> get otpSink => _otpVerifyController.sink;
  Stream<ApiResponse<OTPResponse>> get otpStream => _otpVerifyController.stream;

  StreamController _otpFromEmailController;
  StreamSink<ApiResponse<OTPEmailResponse>> get otpFromEmailSink =>
      _otpFromEmailController.sink;
  Stream<ApiResponse<OTPEmailResponse>> get otpFromEmailStream =>
      _otpFromEmailController.stream;

  OTPVerifyBloc() {
    _otpVerifyController = StreamController<ApiResponse<OTPResponse>>();
    _authenticationRepository = AuthenticationRepository();
    _otpFromEmailController = StreamController<ApiResponse<OTPEmailResponse>>();
  }

  @override
  void dispose() {
    _otpVerifyController?.close();
    _otpFromEmailController?.close();
  }

  Future<OTPResponse> verifyOtp(String enteredMobNumber,
      String selectedCountryCode, String otp, bool isFromSignIn) async {
    var verifyOTP = {};
    verifyOTP['sourceName'] = CommonConstants.strTrident;
    verifyOTP['countryCode'] = '+' + selectedCountryCode;
    verifyOTP['phoneNumber'] = enteredMobNumber;
    verifyOTP['otp'] = otp;
    if (isFromSignIn)
      verifyOTP['operation'] = CommonConstants.strOperationSignIN;
    else
      verifyOTP['operation'] = CommonConstants.strOperationSignUp;

    var jsonString = convert.jsonEncode(verifyOTP);

    otpSink.add(ApiResponse.loading('Signing in user'));
    OTPResponse otpResponse;
    try {
      otpResponse = await _authenticationRepository.verifyOTP(jsonString);
    } catch (e) {
      otpSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
    return otpResponse;
  }

  Future<OTPResponse> generateOTP(String enteredMobNumber,
      String selectedCountryCode, bool isFromSignIn) async {
    var verifyOTP = {};
    verifyOTP['sourceName'] = CommonConstants.strTrident;
    verifyOTP['countryCode'] = '+' + selectedCountryCode;
    verifyOTP['phoneNumber'] = enteredMobNumber;
    if (isFromSignIn)
      verifyOTP['operation'] = CommonConstants.strOperationSignIN;
    else
      verifyOTP['operation'] = CommonConstants.strOperationSignUp;

    var jsonString = convert.jsonEncode(verifyOTP);

    otpSink.add(ApiResponse.loading('Signing in user'));
    OTPResponse otpResponse;
    try {
      otpResponse = await _authenticationRepository.generateOTP(jsonString);
    } catch (e) {
      otpSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
    return otpResponse;
  }

  Future<OTPEmailResponse> verifyOTPFromEmail(String otp) async {
    var verifyEmailOTP = {};
    verifyEmailOTP['verificationCode'] = otp;

    var jsonString = convert.jsonEncode(verifyEmailOTP);

    otpFromEmailSink.add(ApiResponse.loading('verify otp'));
    OTPEmailResponse otpEmailResponse;
    try {
      otpEmailResponse =
          await _authenticationRepository.verifyOTPFromEmail(jsonString);
    } catch (e) {
      otpFromEmailSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
    return otpEmailResponse;
  }
}

abstract class BaseBloc {
  void dispose();
}

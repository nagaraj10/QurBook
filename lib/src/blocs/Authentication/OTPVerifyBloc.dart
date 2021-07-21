import 'dart:async';
import '../../model/Authentication/OTPEmailResponse.dart';
import '../../model/Authentication/OTPResponse.dart';
import '../../resources/network/ApiResponse.dart';
import '../../resources/repository/AuthenticationRepository.dart';
import '../../utils/Validators.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import '../../../common/CommonConstants.dart';

import '../../../constants/fhb_parameters.dart' as parameters;
import '../../../constants/variable_constant.dart' as variable;


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
    final verifyOTP = {};
    //verifyOTP['sourceName'] = CommonConstants.strTrident;
    verifyOTP[parameters.strCountryCode] = '+' + selectedCountryCode;
    verifyOTP[parameters.strPhoneNumber] = enteredMobNumber;
    verifyOTP[parameters.strotp] = otp;
      verifyOTP[parameters.strSourceId] = parameters.strSrcIdVal;
    verifyOTP[parameters.strEntityId] =parameters.strEntityIdVal;
    verifyOTP[parameters.strRoleId] = parameters.strRoleIdVal;
    if (isFromSignIn) {
      verifyOTP[parameters.strOperation] = CommonConstants.strOperationSignIN;
    } else {
      verifyOTP[parameters.strOperation] = CommonConstants.strOperationSignUp;
    }

    final jsonString = convert.jsonEncode(verifyOTP);

    otpSink.add(ApiResponse.loading(variable.strVerifyOtp));
    OTPResponse otpResponse;
    try {
      otpResponse = await _authenticationRepository.verifyOTP(jsonString);
    } catch (e) {
      otpSink.add(ApiResponse.error(e.toString()));
    }
    return otpResponse;
  }

  Future<OTPResponse> generateOTP(String enteredMobNumber,
      String selectedCountryCode, bool isFromSignIn) async {
    final verifyOTP = {};
    //verifyOTP['sourceName'] = CommonConstants.strTrident;
    verifyOTP[parameters.strCountryCode] = '+' + selectedCountryCode;
    verifyOTP[parameters.strPhoneNumber] = enteredMobNumber;
     verifyOTP[parameters.strSourceId] = parameters.strSrcIdVal;
    verifyOTP[parameters.strEntityId] =parameters.strEntityIdVal;
    verifyOTP[parameters.strRoleId] = parameters.strRoleIdVal;
    if (isFromSignIn) {
      verifyOTP[parameters.strOperation] = CommonConstants.strOperationSignIN;
    } else {
      verifyOTP[parameters.strOperation] = CommonConstants.strOperationSignUp;
    }

    final jsonString = convert.jsonEncode(verifyOTP);

    otpSink.add(ApiResponse.loading(variable.strGeneratingOtp));
    OTPResponse otpResponse;
    try {
      otpResponse = await _authenticationRepository.generateOTP(jsonString);
    } catch (e) {
      otpSink.add(ApiResponse.error(e.toString()));    }
    return otpResponse;
  }

  Future<OTPEmailResponse> verifyOTPFromEmail(String otp) async {
    final verifyEmailOTP = {};
    verifyEmailOTP[parameters.strverification] = otp;

    final jsonString = convert.jsonEncode(verifyEmailOTP);

    otpFromEmailSink.add(ApiResponse.loading(variable.strVerifyOtp));
    OTPEmailResponse otpEmailResponse;
    try {
      otpEmailResponse =
          await _authenticationRepository.verifyOTPFromEmail(jsonString);
    } catch (e) {
      otpFromEmailSink.add(ApiResponse.error(e.toString()));
    }
    return otpEmailResponse;
  }
}

abstract class BaseBloc {
  void dispose();
}

import 'dart:async';
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

  OTPVerifyBloc() {
    _otpVerifyController = StreamController<ApiResponse<OTPResponse>>();
    _authenticationRepository = AuthenticationRepository();
  }

  @override
  void dispose() {
    _otpVerifyController?.close();
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
}

abstract class BaseBloc {
  void dispose();
}

import 'dart:async';
import 'dart:convert' as convert;

import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/AuthenticationRepository.dart';
import 'package:myfhb/src/utils/Validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class AddFamilyOTPBloc with Validators implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _otpVerifyController;

  final _mobileNumberController = BehaviorSubject<String>();

  Function(String) get mobileNumberChanged => _mobileNumberController.sink.add;

  Stream<String> get mobileNumber =>
      _mobileNumberController.stream.transform(mobileNumberValidator);

  Stream<bool> get submitCheck => mobileNumber.map((m) => true);

  StreamSink<ApiResponse<AddFamilyOTPResponse>> get otpSink =>
      _otpVerifyController.sink;

  Stream<ApiResponse<AddFamilyOTPResponse>> get otpStream =>
      _otpVerifyController.stream;

  String fromClass;

  AddFamilyOTPBloc() {
    _otpVerifyController =
        StreamController<ApiResponse<AddFamilyOTPResponse>>();
    _authenticationRepository = AuthenticationRepository();
  }

  @override
  void dispose() {
    _otpVerifyController?.close();
  }

  Future<AddFamilyOTPResponse> verifyAddFamilyOtp(
      String enteredMobNumber, String selectedCountryCode, String otp) async {
    var verifyOTP = {};
    verifyOTP[variable.strSrcName] = CommonConstants.strTrident;
    verifyOTP[variable.strCountryCode] = '+' + selectedCountryCode;
    verifyOTP[variable.strPhoneNumber] = enteredMobNumber;
    verifyOTP[variable.strOTP] = otp;
    verifyOTP[variable.strOperation] = CommonConstants.user_linking;

    var jsonString = convert.jsonEncode(verifyOTP);

    otpSink.add(ApiResponse.loading(variable.strVerifyOtp));
    AddFamilyOTPResponse addFamilyOTPResponse;

    try {
      addFamilyOTPResponse =
          await _authenticationRepository.verifyAddFamilyOTP(jsonString);
    } catch (e) {
      otpSink.add(ApiResponse.error(e.toString()));
    }
    return addFamilyOTPResponse;
  }
}

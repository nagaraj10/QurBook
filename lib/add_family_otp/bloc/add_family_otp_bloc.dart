import 'dart:async';
import 'dart:convert' as convert;

import '../models/add_family_otp_response.dart';
import '../../common/CommonConstants.dart';
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/resources/repository/AuthenticationRepository.dart';
import '../../src/utils/Validators.dart';
import 'package:rxdart/rxdart.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../constants/fhb_parameters.dart' as parameters;

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
    final verifyOTP = {};
    //verifyOTP[variable.strSrcName] = CommonConstants.strTrident;
    verifyOTP[variable.strCountryCode] = '+' + selectedCountryCode;
    verifyOTP[variable.strPhoneNumber] = enteredMobNumber;
    verifyOTP[variable.strOTP] = otp;
    verifyOTP[variable.strOperation] = CommonConstants.user_linking;
    verifyOTP[parameters.strSourceId] = parameters.strSrcIdVal;
    verifyOTP[parameters.strEntityId] =parameters.strEntityIdVal;
    verifyOTP[parameters.strRoleId] = parameters.strRoleIdVal;

    final jsonString = convert.jsonEncode(verifyOTP);

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

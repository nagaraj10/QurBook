
import 'dart:async';
import 'dart:io';
import 'package:myfhb/common/CommonUtil.dart';

import '../../model/Authentication/SignIn.dart';
import '../../model/Authentication/SignOutResponse.dart';
import '../../model/Authentication/SignUp.dart';
import '../../resources/network/ApiResponse.dart';
import '../../resources/repository/AuthenticationRepository.dart';
import '../../utils/Validators.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import '../../../constants/fhb_parameters.dart' as parameters;
import '../../../constants/variable_constant.dart' as variable;



class LoginBloc with Validators implements BaseBloc {
  late AuthenticationRepository _authenticationRepository;
  StreamController? _loginController;
  StreamController? _signOutController;
  final _mobileNumberController = BehaviorSubject<String>();

  StreamController? _signUpController;

  Function(String) get mobileNumberChanged => _mobileNumberController.sink.add;

  Stream<String> get mobileNumber =>
      _mobileNumberController.stream.transform(mobileNumberValidator);
  Stream<bool> get submitCheck => mobileNumber.map((m) => true);

  StreamSink<ApiResponse<SignIn>> get signInSink => _loginController!.sink as StreamSink<ApiResponse<SignIn>>;
  Stream<ApiResponse<SignIn>> get signInStream => _loginController!.stream as Stream<ApiResponse<SignIn>>;

  StreamSink<ApiResponse<SignUp>> get signUpSink => _signUpController!.sink as StreamSink<ApiResponse<SignUp>>;
  Stream<ApiResponse<SignUp>> get signUpStream => _signUpController!.stream as Stream<ApiResponse<SignUp>>;

  StreamSink<ApiResponse<SignOutResponse>> get signOutSink =>
      _signOutController!.sink as StreamSink<ApiResponse<SignOutResponse>>;
  Stream<ApiResponse<SignOutResponse>> get signOutStream =>
      _signOutController!.stream as Stream<ApiResponse<SignOutResponse>>;

  LoginBloc() {
    _loginController = StreamController<ApiResponse<SignIn>>();
    _authenticationRepository = AuthenticationRepository();
    _signUpController = StreamController<ApiResponse<SignUp>>();
    _signOutController = StreamController<ApiResponse<SignOutResponse>>();
  }

  Future<SignIn?> submit(String phoneNumber, String countryCode) async {
    final signInData = {};
    //signInData['sourceName'] = CommonConstants.strTrident;
    signInData[parameters.strCountryCode] = '+' + countryCode;
    signInData[parameters.strPhoneNumber] = phoneNumber;
    signInData[parameters.strSourceId] = parameters.strSrcIdVal;
    signInData[parameters.strEntityId] =parameters.strEntityIdVal;
    signInData[parameters.strRoleId] = parameters.strRoleIdVal;

    final jsonString = convert.jsonEncode(signInData);

    signInSink.add(ApiResponse.loading(variable.strSignUp));
    SignIn? signIn;
    try {
      signIn = await _authenticationRepository.signInUser(jsonString);
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      signInSink.add(ApiResponse.error(e.toString()));
    }
    return signIn;
  }

  Future<SignUp?> createUser(
      String countryCode,
      String phoneNumber,
      String email,
      String gender,
      String firstName,
      String passsword,
      String bloodGroup,
      String dateOfBirth,
      File file,
      String middleName,
      String lastName) async {
    signUpSink.add(ApiResponse.loading(variable.strCreateuser));
    SignUp? signUp;
    try {
      signUp = await _authenticationRepository.signUpUser(
          countryCode,
          phoneNumber,
          email,
          gender,
          firstName,
          passsword,
          bloodGroup,
          dateOfBirth,
          file,
          middleName,
          lastName);
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      signUpSink.add(ApiResponse.error(e.toString()));
    }
    return signUp;
  }

  Future<SignOutResponse?> logout() async {
    signOutSink.add(ApiResponse.loading(variable.strSignOut));
    SignOutResponse? signOutResponse;
    try {
      signOutResponse = await _authenticationRepository.signOutUser();
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      signInSink.add(ApiResponse.error(e.toString()));
    }

    return signOutResponse;
  }

  @override
  void dispose() {
    _mobileNumberController.close();
    _loginController?.close();
    _signUpController?.close();
    _signOutController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}

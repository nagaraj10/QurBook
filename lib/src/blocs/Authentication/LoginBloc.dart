import 'dart:async';
import 'dart:io';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/model/Authentication/SignIn.dart';
import 'package:myfhb/src/model/Authentication/SignOutResponse.dart';
import 'package:myfhb/src/model/Authentication/SignUp.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/AuthenticationRepository.dart';
import 'package:myfhb/src/utils/Validators.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

class LoginBloc with Validators implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _loginController;
  StreamController _signOutController;
  final _mobileNumberController = BehaviorSubject<String>();

  StreamController _signUpController;

  Function(String) get mobileNumberChanged => _mobileNumberController.sink.add;

  Stream<String> get mobileNumber =>
      _mobileNumberController.stream.transform(mobileNumberValidator);
  Stream<bool> get submitCheck => mobileNumber.map((m) => true);

  StreamSink<ApiResponse<SignIn>> get signInSink => _loginController.sink;
  Stream<ApiResponse<SignIn>> get signInStream => _loginController.stream;

  StreamSink<ApiResponse<SignUp>> get signUpSink => _signUpController.sink;
  Stream<ApiResponse<SignUp>> get signUpStream => _signUpController.stream;

  StreamSink<ApiResponse<SignOutResponse>> get signOutSink =>
      _signOutController.sink;
  Stream<ApiResponse<SignOutResponse>> get signOutStream =>
      _signOutController.stream;

  LoginBloc() {
    _loginController = StreamController<ApiResponse<SignIn>>();
    _authenticationRepository = AuthenticationRepository();
    _signUpController = StreamController<ApiResponse<SignUp>>();
    _signOutController = StreamController<ApiResponse<SignOutResponse>>();
  }

  Future<SignIn> submit(String phoneNumber, String countryCode) async {
    var signInData = {};
    signInData['sourceName'] = CommonConstants.strTrident;
    signInData['countryCode'] = '+' + countryCode;
    signInData['phoneNumber'] = phoneNumber;
    var jsonString = convert.jsonEncode(signInData);

    signInSink.add(ApiResponse.loading('Signing in user'));
    SignIn signIn;
    try {
      signIn = await _authenticationRepository.signInUser(jsonString);
    } catch (e) {
      signInSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
    return signIn;
  }

  Future<SignUp> createUser(
      String countryCode,
      String phoneNumber,
      String email,
      String gender,
      String name,
      String passsword,
      String bloodGroup,
      String dateOfBirth,
      File file) async {
    signUpSink.add(ApiResponse.loading('Signing in user'));
    SignUp signUp;
    try {
      signUp = await _authenticationRepository.signUpUser(
          countryCode,
          phoneNumber,
          email,
          gender,
          name,
          passsword,
          bloodGroup,
          dateOfBirth,
          file);
    } catch (e) {
      signUpSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
    return signUp;
  }

  Future<SignOutResponse> logout() async {
    signOutSink.add(ApiResponse.loading('Sign out'));
    SignOutResponse signOutResponse;
    try {
      signOutResponse = await _authenticationRepository.signOutUser();
    } catch (e) {
      signInSink.add(ApiResponse.error(e.toString()));
      print('Exception PPPPP' + e.toString());
    }

    return signOutResponse;
  }

  @override
  void dispose() {
    _mobileNumberController?.close();
    _loginController?.close();
    _signUpController?.close();
    _signOutController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}

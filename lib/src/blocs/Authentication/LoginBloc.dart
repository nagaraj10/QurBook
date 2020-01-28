import 'dart:async';
import 'package:myfhb/src/model/Authentication/SignIn.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/AuthenticationRepository.dart';
import 'package:myfhb/src/utils/Validators.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

class LoginBloc with Validators implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _loginController;
  final _mobileNumberController = BehaviorSubject<String>();

  Function(String) get mobileNumberChanged => _mobileNumberController.sink.add;

  Stream<String> get mobileNumber =>
      _mobileNumberController.stream.transform(mobileNumberValidator);
  Stream<bool> get submitCheck => mobileNumber.map((m) => true);

  StreamSink<ApiResponse<SignIn>> get signInSink => _loginController.sink;
  Stream<ApiResponse<SignIn>> get signInStream => _loginController.stream;

  LoginBloc() {
    _loginController = StreamController<ApiResponse<SignIn>>();
    _authenticationRepository = AuthenticationRepository();
  }

  submit() async {
    var signInData = {};
    signInData['sourceName'] = 'tridentApp';
    signInData['countryCode'] = '+91';
    signInData['phoneNumber'] = '9840972275';
    var jsonString = convert.jsonEncode(signInData);

    signInSink.add(ApiResponse.loading('Signing in user'));
    try {
      SignIn signIn = await _authenticationRepository.signInUser(jsonString);
      signInSink.add(ApiResponse.completed(signIn));
    } catch (e) {
      signInSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _mobileNumberController?.close();
    _loginController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}

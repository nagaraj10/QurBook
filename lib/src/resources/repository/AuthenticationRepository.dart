import 'package:myfhb/src/model/Authentication/SignIn.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
//import 'dart:convert' as convert;

class AuthenticationRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SignIn> signInUser(String signInData) async {
    final response = await _helper.signIn("authentication/signin", signInData);
    return SignIn.fromJson(response);
  }
}

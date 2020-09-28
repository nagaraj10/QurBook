import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:myfhb/authentication/constants/constants.dart';

class AuthenticationValidator {
  String charValidation(String name, String pattern, String validText) {
    RegExp regexName = new RegExp(pattern);
    if (name.length == 0) {
      return strUserNameCantEmpty;
    } else if (!regexName.hasMatch(name)) {
      return strUserNameValid;
    }
    return null;
  }

  String passwordValidation(String password, String pattern, String validText) {
    RegExp regexPassword = new RegExp(pattern);
    if (password.length == 0) {
      return strPassCantEmpty;
    } else if (password.length < 6) {
      return strPasswordCheck;
    } else if (!regexPassword.hasMatch(password)) {
      return strPasswordMultiChecks;
    }
    return null;
  }

  String confirmPasswordValidation(String password, String confirmpassword,
      String pattern, String validText) {
    RegExp regexPassword = new RegExp(pattern);
    if (password.length == 0) {
      return strPassCantEmpty;
    } else if (password.length < 6) {
      return strPasswordCheck;
    } else if (!regexPassword.hasMatch(password)) {
      return strPasswordMultiChecks;
    } else if (password != confirmpassword) {
      return strConfirmPasswordText;
    }
    return null;
  }

  String emailValidation(String email, String pattern, String validText) {
    RegExp regexEmail = new RegExp(pattern);
    if (email.length == 0) {
      return strEmailCantEmpty;
    } else if (!regexEmail.hasMatch(email)) {
      return strEmailValidText;
    }
    return null;
  }

  String phoneValidation(String phone, String pattern, String validText) {
    RegExp regexPhone = new RegExp(pattern);
    if (phone.length == 0) {
      return strPhoneCantEmpty;
    } else if (!regexPhone.hasMatch(phone)) {
      return strPhoneValidText;
    }
    return null;
  }

  String phoneOtpValidation(String otp, String pattern, String validText) {
    RegExp regexPhone = new RegExp(pattern);
    if (otp.length == 0) {
      return strOtpCantEmpty;
    } else if (otp.length < 6) {
      return strValidOtp;
    } else if (!regexPhone.hasMatch(otp)) {
      return strValidOtp;
    }
    return null;
  }

  Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}

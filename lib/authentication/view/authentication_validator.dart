import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import '../constants/constants.dart';

class AuthenticationValidator {
  String charValidation(String name, String pattern, String validText) {
    var regexName = RegExp(pattern);
    if (name.isEmpty) {
      return strUserNameCantEmpty;
    } else if (!regexName.hasMatch(name)) {
      return strUserNameCantEmpty;
    }
    return null;
  }

  String loginPasswordValidation(
      String password, String pattern, String validText) {
    if (password.isEmpty) {
      return strPassCantEmpty;
    } else if (password.length < 6) {
      return strPasswordCheck;
    }
    return null;
  }

  String passwordValidation(String password, String pattern, String validText) {
    var regexPassword = RegExp(pattern);
    if (password.isEmpty) {
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
    final regexPassword = RegExp(pattern);
    if (password.isEmpty) {
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
    var regexEmail = RegExp(pattern);
    if (email.isEmpty) {
      return strEmailCantEmpty;
    } else if (!regexEmail.hasMatch(email)) {
      return strEmailValidText;
    } else if ('@'.allMatches(email).length > 1) {
      return strEmailValidText;
    }
    return null;
  }

  String phoneValidation(String phone, String pattern, String validText) {
    var regexPhone = RegExp(pattern);
    if (phone.isEmpty) {
      return strPhoneCantEmpty;
    } else if (!regexPhone.hasMatch(phone)) {
      return strPhoneValidText;
    }
    return null;
  }

  String phoneOtpValidation(String otp, String pattern, String validText) {
    final regexPhone = RegExp(pattern);
    if (otp.isEmpty) {
      return strOtpCantEmpty;
    } else if (otp.length < 6) {
      return strValidOtp;
    } else if (!regexPhone.hasMatch(otp)) {
      return strValidOtp;
    }
    return null;
  }

  Future<bool> checkNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}

import 'dart:async';
import 'package:myfhb/constants/db_constants.dart' as DBConstant;
import 'package:myfhb/constants/variable_constant.dart' as variable;

mixin Validators {
  var mobileNumberValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (mobileNumber, sink) {
    String patttern = DBConstant.PRO_PATTERN;
    RegExp regExp = new RegExp(patttern);
    if (!regExp.hasMatch(mobileNumber) && mobileNumber.length < 9) {
      sink.addError(variable.strValidPhoneNumber);
    } else {
      sink.add(mobileNumber);
    }
  });

 
}

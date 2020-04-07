import 'dart:async';

mixin Validators {
  var mobileNumberValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (mobileNumber, sink) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (!regExp.hasMatch(mobileNumber) && mobileNumber.length < 9) {
      sink.addError('Enter a valid mobile number');
    } else {
      sink.add(mobileNumber);
    }
  });

  /*  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 4) {
      sink.add(password);
    } else {
      sink.addError("Password length should be greater than 4 chars.");
    }
  }); */
}

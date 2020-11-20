import 'package:myfhb/constants/variable_constant.dart' as variable;

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, variable.err_comm);
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, variable.err_invalid_req);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message,variable.err_unauthorized);
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, variable.err_invalid_input);
}

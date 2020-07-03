class FetchException implements Exception {
 final _message;
 FetchException([this._message]);

String toString() {
if (_message == null) return "Exception";
  return "Exception: $_message";
 }
}


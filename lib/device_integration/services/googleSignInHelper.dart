import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'dart:io';

class GoogleSignInHelper {
  GoogleSignInAccount m_currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final String _url =
      "https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate";

  GoogleSignInHelper() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      m_currentUser = account;
      print("User accout changed ${m_currentUser.displayName}");
    });
  }

  Future<bool> isSignedIn() async {
    bool signedIn = await _googleSignIn.isSignedIn();
    return signedIn;
  }

  Future<void> handleSignIn() async {
    try {
      if (m_currentUser == null) {
        await _googleSignIn.signIn();
        print("handleSignIn :: Signed in");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> handleScopes() async {
    List<String> Scopes = [];
    Scopes.add("https://www.googleapis.com/auth/fitness.body.read");
    Scopes.add("https://www.googleapis.com/auth/fitness.blood_pressure.read");
    Scopes.add("https://www.googleapis.com/auth/fitness.body_temperature.read");
    Scopes.add(
        "https://www.googleapis.com/auth/fitness.oxygen_saturation.read");
    Scopes.add("https://www.googleapis.com/auth/fitness.blood_glucose.read");
    try {
      if (m_currentUser != null) {
        await _googleSignIn.requestScopes(Scopes);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> handleSignOut() async {
    try {
      bool signedIn = await _googleSignIn.isSignedIn();
      if (signedIn) {
        _googleSignIn.disconnect();
        print("handleSignIn :: Signed Out");
      }
    } catch (e) {}
  }

  Future<dynamic> getDataAggregate(String jsonBody) async {
    var responseJson;
    try {
      final response = await http.post(_url,
          body: jsonBody, headers: await m_currentUser.authHeaders);
      if (response.statusCode != 200) {
        throw "${response.statusCode} and ${response.body}";
      }
      responseJson = response.body;
    } on SocketException {
      throw "No Internet Connection";
    }
    return responseJson;
  }
}

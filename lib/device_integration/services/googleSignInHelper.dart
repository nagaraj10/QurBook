import 'package:google_sign_in/google_sign_in.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import "package:http/http.dart" as http;
import 'dart:io';

class GoogleSignInHelper {
  GoogleSignInAccount m_currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final String _url = gfAggregateURL;

  GoogleSignInHelper() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      m_currentUser = account;
    });
  }

  Future<bool> isSignedIn() async {
    bool signedIn = await _googleSignIn.isSignedIn();
    return signedIn;
  }

  Future<bool> handleSignIn() async {
    try {
      GoogleSignInAccount user = await _googleSignIn.signIn();
      m_currentUser = user;
      if (m_currentUser == null) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> handleScopes() async {
    bool ret = false;
    List<String> Scopes = [];
    Scopes.add(gfscopeBodyRead);
    Scopes.add(gfscopepressureRead);
    Scopes.add(gfscopetempRead);
    Scopes.add(gfscopesaturationRead);
    Scopes.add(gfscopeglucoseRead);
    try {
      if (m_currentUser != null) {
        ret = await _googleSignIn.requestScopes(Scopes);
        if (!ret) {
          await _googleSignIn.disconnect();
        }
      }
    } catch (error) {
      return false;
    }
    return ret;
  }

  Future<bool> handleSignOut() async {
    try {
      bool signedIn = await _googleSignIn.isSignedIn();
      if (signedIn) {
        await _googleSignIn.disconnect();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getDataAggregate(String jsonBody) async {
    var responseJson;
    try {
      if (m_currentUser == null) {
        throw "Failed to login GoogleFit account. Please activate and do sync again";
      }
      final response = await http.post(_url,
          body: jsonBody, headers: await m_currentUser.authHeaders);
      if (response.statusCode != 200) {
        throw "${response.statusCode} and ${response.body}";
      }
      responseJson = response.body;
    } on SocketException {
      throw variable.strNoInternet;
    }
    return responseJson;
  }
}


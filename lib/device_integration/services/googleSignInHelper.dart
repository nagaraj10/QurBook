import 'package:google_sign_in/google_sign_in.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import '../../constants/fhb_parameters.dart';
import '../../constants/variable_constant.dart' as variable;
import 'package:myfhb/src/resources/network/api_services.dart';
import 'dart:io';

class GoogleSignInHelper {
  GoogleSignInAccount m_currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String _url = gfAggregateURL;

  GoogleSignInHelper() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      m_currentUser = account;
    });
  }

  Future<bool> isSignedIn() async {
    var signedIn = await _googleSignIn.isSignedIn();
    return signedIn;
  }

  Future<bool> signInSilently() async {
    try {
      var user = await _googleSignIn.signInSilently();
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

  Future<bool> handleSignIn() async {
    try {
      var user = await _googleSignIn.signIn();
      m_currentUser = user;
      if (m_currentUser == null) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  Future<bool> handleScopes() async {
    var ret = false;
    final Scopes = <String>[];
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
      var signedIn = await _googleSignIn.isSignedIn();
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
        throw 'Failed to login GoogleFit account. Please activate and do sync again';
      }
      var response = await ApiServices.post(
        _url,
        body: jsonBody,
        headers: await m_currentUser.authHeaders,
      );
      if (response.statusCode != 200) {
        throw '${response.statusCode} and ${response.body}';
      }
      responseJson = response.body;
    } on SocketException {
      throw variable.strNoInternet;
    }
    return responseJson;
  }
}

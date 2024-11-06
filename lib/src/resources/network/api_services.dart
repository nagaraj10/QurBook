import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../../authentication/constants/constants.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/HeaderRequest.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/variable_constant.dart';

class ApiServices {
  static Future<Response?> get(String path,
      {Map<String, String>? headers, int timeout = 20}) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';
    _checkRefreshTokenRequired();
    unawaited(_logLastUserAccess());
    try {
      final response = await http
          .get(
            Uri.parse(_baseUrl + path),
            headers: headers,
          )
          .timeout(Duration(seconds: timeout));
      return response;
    } on TimeoutException {
      FlutterToast().getToast('Request Timeout', Colors.red);
    } catch (exception) {
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
      }
    }
  }

  static Future<Response?> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    timeOutSeconds = 20,
  }) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';
    // print(headers);
    // print('jsonBody: ' + body);
    _checkRefreshTokenRequired();
    unawaited(_logLastUserAccess());
    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl + path),
            body: body,
            headers: headers,
            encoding: encoding,
          )
          .timeout(
            Duration(
              seconds: timeOutSeconds,
            ),
          );

      return response;
    } on TimeoutException {
      FlutterToast().getToast('Request Timeout', Colors.red);
    } catch (exception) {
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
      }
    }
  }

  static Future<Response?> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';
    _checkRefreshTokenRequired();
    unawaited(_logLastUserAccess());
    try {
      final response = await http
          .put(
            Uri.parse(_baseUrl + path),
            body: body,
            headers: headers,
            encoding: encoding,
          )
          .timeout(Duration(seconds: 20));
      return response;
    } on TimeoutException {
      FlutterToast().getToast('Request Timeout', Colors.red);
    } catch (exception) {
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
      }
    }
  }

  static Future<Response?> delete(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';
    _checkRefreshTokenRequired();
    unawaited(_logLastUserAccess());
    try {
      final response = await http
          .delete(
            Uri.parse(_baseUrl + path),
            body: body,
            headers: headers,
            encoding: encoding,
          )
          .timeout(Duration(seconds: 20));

      return response;
    } on TimeoutException {
      FlutterToast().getToast('Request Timeout', Colors.red);
    } catch (exception) {
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
      }
    }
  }

  static callRefreshTokenApi() async {
    var headerRequest = await HeaderRequest().getRequestHeader();
    String? refToken = PreferenceUtil.getStringValue(strRefreshToken);
    try {
      var data = {
        'refreshToken': '$refToken',
        'source': 'myFHBMobile',
        'isJWTToken': true
      };
      final response = await http
          .post(
            Uri.parse(BASE_URL + refreshTokenEndPoint),
            body: json.encode(data),
            headers: headerRequest,
          )
          .timeout(
            Duration(
              seconds: 20,
            ),
          );
      if (response.statusCode == 200) {
        final responseResult = jsonDecode(response.body);

        ///Adding a new Jwt token and updating the refresh and Expiry time.
        final String jwtToken = responseResult[strResult][strJwtToken];
        await PreferenceUtil.saveString(KEY_AUTHTOKEN, jwtToken);
        await PreferenceUtil.saveInt(strAuthExpiration,
            parseJwtPayLoad(jwtToken ?? '')[strAuthExpiration]);
        var refToken = responseResult[strResult][strRefreshToken];
        await PreferenceUtil.saveString(strRefreshToken, refToken.toString());

        ///
      }
      return response;
    } on TimeoutException {
      FlutterToast().getToast('Request Timeout', Colors.red);
    } catch (exception) {
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
        print(exception);
      }
    }
  }

  static _checkRefreshTokenRequired() {
    String? refToken = PreferenceUtil.getStringValue(strRefreshToken);
    String? authToken = PreferenceUtil.getStringValue(KEY_AUTHTOKEN);
    if (authToken != null && refToken != null) {
      try {
        final tokenExpireUnixTime =
            PreferenceUtil.getIntValue(strAuthExpiration);
        final backendTimestamp =
            DateTime.fromMillisecondsSinceEpoch(tokenExpireUnixTime! * 1000);
        // Get the current time
        final currentDate = DateTime.now().toLocal();
        // Calculate the difference in minutes between the backend timestamp and current time
        final differenceInMinutes =
            backendTimestamp.difference(currentDate).inMinutes;
        final differenceInDays =
            backendTimestamp.difference(currentDate).inDays;
        // Check if the difference is less than 29 days, not negative (meaning not expired yet),
        // and if the difference in minutes is greater than 0
        // (to ensure that if the user opening on the last day differnce in days will be 0 so checking the minutes>0)
        if (differenceInDays<29 && differenceInDays >= 0 && differenceInMinutes>0) {
          callRefreshTokenApi();
        }
      } catch (e, stackTrace) {
        // Handle exceptions if any
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
  }

  static Future<void> _logLastUserAccess() async {
    const String LAST_ACCESS_KEY =
        'last_access'; // key to store last access time
    const int MAX_ALLOWED_TIME_MS =
        60 * 1000; // maximum allowed time difference

    int lastAccess = PreferenceUtil.getIntValue(LAST_ACCESS_KEY) ??
        (61 * 1000); // get last access time
    int currentTime = DateTime.now().millisecondsSinceEpoch; // get current time

    if (currentTime - lastAccess > MAX_ALLOWED_TIME_MS) {
      // check if time difference exceeds max
      // Make API call to record latest user access

      CommonUtil().saveUserLastAccessTime();
      // Update shared preference with new last access time
      await PreferenceUtil.saveInt(LAST_ACCESS_KEY, currentTime);
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';

class ApiServices {
  static Future<Response> get(String path,
      {Map<String, String> headers, int timeout = 20}) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';

    try {
      final response = await http
          .get(
            Uri.parse(_baseUrl + path),
            headers: headers,
          )
          .timeout(Duration(seconds: timeout));
      await CommonUtil.saveLog(
        message:
            'Request - ${response?.request ?? ''} || Response(${response?.statusCode}) - ${response?.body}',
      );

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      return response;
      // }
    } on TimeoutException {
      FlutterToast().getToast('Request Timeout', Colors.red);
    } catch (exception) {
      await CommonUtil.saveLog(
        isError: true,
        message:
            'Path - ${path ?? ''} || Header - ${headers ?? ''}\n Exception - ${exception ?? ''}',
      );
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
      }
    }
  }

  static Future<Response> post(
    String path, {
    Map<String, String> headers,
    Object body,
    Encoding encoding,
    timeOutSeconds = 20,
  }) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';
    // print(headers);
    // print('jsonBody: ' + body);
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
      CommonUtil.saveLog(
        message:
            'Request - ${response?.request ?? ''} || Response(${response?.statusCode}) - ${response?.body}',
      );
      // if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } on TimeoutException {
      FlutterToast().getToast('Request Timeout', Colors.red);
    } catch (exception) {
      CommonUtil.saveLog(
        isError: true,
        message:
            'Path - ${path ?? ''} || Body - ${body ?? ''}\n Exception - ${exception ?? ''}',
      );
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
      }
    }
  }

  static Future<Response> put(
    String path, {
    Map<String, String> headers,
    Object body,
    Encoding encoding,
  }) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';

    try {
      final response = await http
          .put(
            Uri.parse(_baseUrl + path),
            body: body,
            headers: headers,
            encoding: encoding,
          )
          .timeout(Duration(seconds: 20));
      CommonUtil.saveLog(
        message:
            'Request - ${response?.request ?? ''} || Response(${response?.statusCode}) - ${response?.body}',
      );

      // if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } on TimeoutException {
      FlutterToast().getToast('Request Timeout', Colors.red);
    } catch (exception) {
      CommonUtil.saveLog(
        isError: true,
        message:
            'Path - ${path ?? ''} || Header - ${headers ?? ''} || Body - ${body ?? ''}\n Exception - ${exception ?? ''}',
      );
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
      }
    }
  }

  static Future<Response> delete(
    String path, {
    Map<String, String> headers,
    Object body,
    Encoding encoding,
  }) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';

    try {
      final response = await http
          .delete(
            Uri.parse(_baseUrl + path),
            body: body,
            headers: headers,
            encoding: encoding,
          )
          .timeout(Duration(seconds: 20));

      CommonUtil.saveLog(
        message:
            'Request - ${response?.request ?? ''} || Response(${response?.statusCode}) - ${response?.body}',
      );
      // if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } on TimeoutException {
      FlutterToast().getToast('Request Timeout', Colors.red);
    } catch (exception) {
      CommonUtil.saveLog(
        isError: true,
        message:
            'Path - ${path ?? ''} || Header - ${headers ?? ''} || Body - ${body ?? ''}\n Exception - ${exception ?? ''}',
      );
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
      }
    }
  }
}

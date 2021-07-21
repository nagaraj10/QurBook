import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<Response> get(String path,
      {Map<String, String> headers}) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';
    try {
      final response = await http.get(
        Uri.parse(_baseUrl + path),
        headers: headers,
      );

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      return response;
      // }
    } catch (exception) {
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
  }) async {
    //TODO: use BaseUrl as common after removing baseurl from all method params
    // final String _baseUrl = BASE_URL;
    final String _baseUrl = '';
    try {
      final response = await http.post(
        Uri.parse(_baseUrl + path),
        body: body,
        headers: headers,
        encoding: encoding,
      );

      // if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } catch (exception) {
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
      final response = await http.put(
        Uri.parse(_baseUrl + path),
        body: body,
        headers: headers,
        encoding: encoding,
      );

      // if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } catch (exception) {
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
      final response = await http.delete(
        Uri.parse(_baseUrl + path),
        body: body,
        headers: headers,
        encoding: encoding,
      );

      // if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } catch (exception) {
      if (exception is SocketException) {
        //TODO: handle connection error
      } else {
        //TODO: handle other error
      }
    }
  }
}

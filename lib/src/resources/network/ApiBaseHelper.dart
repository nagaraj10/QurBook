import 'dart:io';
import 'dart:typed_data';

import 'AppException.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class ApiBaseHelper {
  final String _baseUrl = 'https://healthbook.vsolgmi.com/hb/api/v3/';

  Future<dynamic> signIn(String url, String jsonData) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: jsonData, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  /**
   * The below method helps to get categroy list from server using the get method,
   * it contains one parameter which describ ethe URL  type 
   * Created by Parvathi M on 7th Jan 2020
   */

  Future<dynamic> getCategoryList(String url) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': Constants.AUTHENTICATION_TOKEN,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  /**
   * The below method helps to get health record list from server for a particular userID using the get method,
   * it contains one parameter which describ ethe URL  type 
   * Created by Parvathi M on 7th Jan 2020
   */

  Future<dynamic> getHealthRecordList(String url) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': Constants.AUTHENTICATION_TOKEN,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getMediaTypes(String url) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': Constants.AUTHENTICATION_TOKEN,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getDoctorProfilePic(String url) async {
    Map<String, String> requestHeaders = {
      'accept': '*/*',
      'Authorization': Constants.AUTHENTICATION_TOKEN,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getHospitalListFromSearch(String url, String param) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': Constants.AUTHENTICATION_TOKEN,
    };

    var responseJson;

    print(_baseUrl + url);
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);

      print('response' + response.toString());
      responseJson = _returnResponse(response);

      print('responseJson' + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getDocumentImage(String url) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': Constants.AUTHENTICATION_TOKEN,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getDoctorsListFromSearch(String url, String param) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': Constants.AUTHENTICATION_TOKEN,
    };

    var responseJson;
    try {
      final response =
          await http.get(_baseUrl + url + param, headers: requestHeaders);

      print('response' + response.toString());
      responseJson = _returnResponse(response);

      print('responseJson' + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getFamilyMembersList(String url) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Authorization': Constants.AUTHENTICATION_TOKEN,
    };

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: requestHeaders);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson;
        if (response.headers['content-type'] == 'image/*' ||
            response.headers['content-type'] == 'image/jpg') {
          String s = new String.fromCharCodes(response.bodyBytes);
          var outputAsUint8List = new Uint8List.fromList(s.codeUnits);
          responseJson = outputAsUint8List;
        } else {
          responseJson = convert.jsonDecode(response.body.toString());
        }

        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

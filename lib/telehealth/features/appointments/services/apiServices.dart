import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelModel.dart';
import 'dart:convert';
import 'dart:io';

class ApiFetch {
  Future<CancelResponse> cancel() async {
    Map id = {
      "updationType": "cancellation",
      "updatedInfo": {
        "bookingIds": ["Book6614"]
      }
    };
    var body = json.encode(id);
    return await http
        .post('https://dev.healthbook.vsolgmi.com/hb/api/v2/appointments/',
            headers: {"Content-Type": "application/json"}, body: body)
        .then((http.Response response) {
      print(response.body);
      if (response.statusCode == 200) {
        var resReturnCode = CancelResponse.fromJson(jsonDecode(response.body));
        if (resReturnCode.status == 200) {
//          print(resReturnCode.data[1].userId);
          print(response.body);
          return CancelResponse.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to fetch');
        }
      } else {
        throw Exception('Failed to fetch');
      }
    });
  }
}

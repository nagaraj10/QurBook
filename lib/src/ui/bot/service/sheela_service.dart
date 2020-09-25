import 'dart:convert';

import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:http/http.dart' as http;

class Service{
  String mayaUrl = CommonUtil.SHEELA_URL;

  Future<dynamic> sendMetaToMaya(Map<String,dynamic> reqJson) async {
    try {
      String jsonString = jsonEncode(reqJson);

      HeaderRequest headerRequest = new HeaderRequest();

      var response = await http.post(
        mayaUrl,
        body: jsonString,
        headers: await headerRequest.getRequesHeaderWithoutToken(),
      );

      return response;
    } catch (e) {
      throw Exception('$e was thrown');
    }
  }
}

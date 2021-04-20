import 'dart:convert';

import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as variable;
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/models/save_response_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';

class RegimentService {
  static Future<RegimentResponseModel> getRegimentData(
      {String dateSelected}) async {
    final urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      final headerRequest =
          await HeaderRequest().getRequestHeadersAuthContent();
      final response = await http.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            "method": "get",
            "data": "Action=GetUserData&startdate=$dateSelected",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return RegimentResponseModel.fromJson(json.decode(response.body));
      } else {
        return RegimentResponseModel(
          regimentsList: [],
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<SaveResponseModel> saveFormData(
      {String eid, String events}) async {
    final urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      final headerRequest =
          await HeaderRequest().getRequestHeadersAuthContent();
      final response = await http.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            "method": "post",
            "data": "Action=SaveFormForEvent&eid=$eid$events",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return SaveResponseModel.fromJson(json.decode(response.body));
      } else {
        return SaveResponseModel(
          result: SaveResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }

  static Future<FieldsResponseModel> getFormData({String eid}) async {
    final urlForRegiment = Constants.BASE_URL + variable.regiment;
    try {
      final headerRequest =
          await HeaderRequest().getRequestHeadersAuthContent();
      final response = await http.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            "method": "get",
            "data": "Action=GetFormForEvent&eid=$eid",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return FieldsResponseModel.fromJson(json.decode(response.body));
      } else {
        return FieldsResponseModel(
          result: ResultDataModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }
}

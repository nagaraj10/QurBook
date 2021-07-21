import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart';
import 'package:myfhb/telehealth/features/Notifications/model/notification_model.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart';
import 'dart:convert';

class FetchNotificationService {
  final String _baseUrl = Constants.BASE_URL;
  String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

  HeaderRequest headerRequest = new HeaderRequest();

  Future<NotificationModel> fetchNotificationList() async {
    return await ApiServices.get(
      _baseUrl + qr_notification_fetch + DateTime.now().toString(),
      headers: await headerRequest.getRequestHeadersAuthContent(),
    ).then((http.Response response) {
//          print(response.body);
      if (response.statusCode == 200) {
        var responseJson = convert.jsonDecode(response.body.toString());
        var resReturnCode =
            NotificationModel.fromJson(jsonDecode(response.body));
        if (resReturnCode.isSuccess == true) {
          return NotificationModel.fromJson(responseJson);
        } else {
          throw Exception(strFailed);
        }
      } else {
        throw Exception(strFailed);
      }
    });
  }

  Future<dynamic> updateNsActionStatus(dynamic body) async {
    final response = await ApiServices.put(_baseUrl + qr_notification_action,
        headers: await headerRequest.getRequestHeadersAuthContent(),
        body: json.encode(body));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> updateNsOnTapAction(dynamic body) async {
    final response = await ApiServices.put(
        _baseUrl + qr_notification_action_ontap,
        headers: await headerRequest.getRequestHeadersAuthContent(),
        body: json.encode(body));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}

import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart';
import 'package:myfhb/telehealth/features/Notifications/model/notification_model.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart';
import 'package:myfhb/src/utils/language/language_utils.dart';
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
          throw Exception(TranslationConstants.failedToInvoke.t());
        }
      } else {
        throw Exception(TranslationConstants.failedToInvoke.t());
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

  Future<bool> clearNotifications(dynamic body) async {
    final headers = await headerRequest.getRequestHeadersAuthContents();
    print(_baseUrl + qr_notification_clear);
    print(headers);
    final response = await ApiServices.post(
      _baseUrl + qr_notification_clear,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      FlutterToast().getToast(
        'Deleted Notifications successfully.',
        Colors.green,
      );
      return true;
    } else {
      FlutterToast().getToast(
        'Failed to deleted notifications.',
        Colors.red,
      );
      return false;
    }
  }
}

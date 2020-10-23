import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart';
import 'package:myfhb/telehealth/features/Notifications/model/notification_model.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart';

class FetchNotificationService {
  final String _baseUrl = Constants.BASE_URL;
  String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

  HeaderRequest headerRequest = new HeaderRequest();

  Future<NotificationModel> fetchNotificationList() async {

    return await http
        .get(
      _baseUrl + qr_notification_fetch + DateTime.now().toString(),
      headers: await headerRequest.getRequestHeadersAuthContent(),
    )
        .then((http.Response response) {
//          print(response.body);
      if (response.statusCode == 200) {
        var resReturnCode =
        NotificationModel.fromJson(jsonDecode(response.body));
        if (resReturnCode.isSuccess == true) {
          print(response.body);
          return NotificationModel.fromJson(jsonDecode(response.body));
        } else {
          throw Exception(strFailed);
        }
      } else {
        throw Exception(strFailed);
      }
    });
  }
}

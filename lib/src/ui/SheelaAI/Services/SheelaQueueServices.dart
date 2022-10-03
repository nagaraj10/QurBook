import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/SheelaQueueModel.dart';
import 'dart:convert' as convert;
import '../../../../constants/fhb_query.dart';

class SheelaQueueServices {


  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SheelaQueueModel> postNotificationQueue() async {
    var body;
      body = {
        "userId": "03ae3077-4980-4120-9cb0-f1954a956415",
        "payload": {
          "source": "qurplan-dashboard",
          "content": {
            "messageBody": "Sheela has a new message for you",
            "messageTitle": "Hi Seenivasan S"
          },
          "payload": {
            "type": "ack",
            "priority": "high",
            "redirectTo": "sheela|pushMessage",
            "notificationListId": "ab8d9ed3-66d8-4495-9f33-6f729a415cf6"
          },
          "rawMessage": {
            "messageBody": "Please take BP reading",
            "messageTitle": ""
          },
          "messageContent": {
            "messageBody": "Sheela has a new message for you",
            "messageTitle": "Hi Seenivasan S",
            "rawMessageBody": "Please take BP reading",
            "rawMessageTitle": ""
          }
        }
      };


    var jsonString = convert.jsonEncode(body);
    final response =
    await _helper.postNotificationSheelaQueue(qr_sheela_post_queue, jsonString);
    return SheelaQueueModel.fromJson(response);
  }

}

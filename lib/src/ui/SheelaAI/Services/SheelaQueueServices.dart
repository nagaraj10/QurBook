import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/SheelaQueueModel.dart';
import 'dart:convert' as convert;
import '../../../../constants/fhb_query.dart';

class SheelaQueueServices {


  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SheelaQueueModel> postNotificationQueue(String userId,var jsonBody) async {
    var body;
      body = {
        "userId": userId,
        "payload": jsonBody
      };

    var jsonString = convert.jsonEncode(body);
    final response =
    await _helper.postNotificationSheelaQueue(qr_sheela_post_queue, jsonString);
    return SheelaQueueModel.fromJson(response);
  }

}

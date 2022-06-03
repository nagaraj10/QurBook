import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/chat_socket/model/ChatHistoryModel.dart';
import 'package:myfhb/chat_socket/model/GetUserIdModel.dart';
import 'package:myfhb/chat_socket/model/InitChatFamilyModel.dart';
import 'package:myfhb/chat_socket/model/InitChatModel.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/model/AddToCartModel.dart';
import 'package:myfhb/plan_wizard/models/DietPlanModel.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:provider/provider.dart';


class ChatSocketService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ChatHistoryModel> getChatHistory(String userId, String peerId) async {
    var body = {
      "userId": "${userId}",
      "peerId": "${peerId}"
    };
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getChatHistory(
        qr_chat_socket_history, jsonString);
    return ChatHistoryModel.fromJson(response);
  }

  Future<InitChatModel> initNewChat(String userId, String peerId) async {
    var body = {
      "doctorId": "${peerId}",
      "userId": "${userId}"
    };
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.initNewChat(
        qr_chat_socket_init_chat_pat_doc, jsonString);
    return InitChatModel.fromJson(response);
  }

  Future<InitChatFamilyModel> initNewFamilyChat(String userId, String peerId,String familyName) async {
    var body = {
      "caregiverId": "${userId}",
      "caregiverName": "${familyName}",
      "userId": "${peerId}"
    };
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.initNewChat(
        qr_chat_socket_init_chat_pat_family, jsonString);
    return InitChatFamilyModel.fromJson(response);
  }

  Future<GetUserIdModel> getUserIdFromDocId(String docId) async {
    final response = await _helper.getUserIdFromDocId(
        qr_chat_socket_get_user_id_doc + docId +
            qr_chat_socket_get_user_id_doc_include);
    return GetUserIdModel.fromJson(response);
  }
}

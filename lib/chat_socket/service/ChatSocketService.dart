import 'dart:convert' as convert;
import 'package:myfhb/chat_socket/model/UnreadChatCountWithMsgId.dart';
import 'package:myfhb/constants/fhb_parameters.dart';

import '../model/CaregiverPatientChatModel.dart';
import '../model/ChatHistoryModel.dart';
import '../model/GetUnreadCountFamily.dart';
import '../model/GetUserIdModel.dart';
import '../model/InitChatFamilyModel.dart';
import '../model/InitChatModel.dart';
import '../../constants/fhb_query.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class ChatSocketService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ChatHistoryModel?> getChatHistory(
      String userId,
      String peerId,
      String familyUserId,
      bool isCareCoordinator,
      String careCoordiantorId,
      bool isFromFamilyList) async {
    var body;
    if (isFromFamilyList) {
      body = {
        "userId": "${userId}",
        "peerId": isCareCoordinator ? careCoordiantorId : peerId,
        "familyUserId":
            (isCareCoordinator && (familyUserId != null && familyUserId != ''))
                ? familyUserId
                : null
      };
    } else {
      body = {
        "userId": "${userId}",
        "peerId": peerId,
        "familyUserId":
            (familyUserId != null && familyUserId != '') ? familyUserId : null
      };
    }

    var jsonString = convert.jsonEncode(body);
    final response =
        await _helper.getChatHistory(qr_chat_socket_history, jsonString);
    return ChatHistoryModel.fromJson(response);
  }

  Future<InitChatModel> initNewChat(String userId, String peerId) async {
    var body = {"doctorId": "${peerId}", "userId": "${userId}"};
    var jsonString = convert.jsonEncode(body);
    final response =
        await _helper.initNewChat(qr_chat_socket_init_chat_pat_doc, jsonString);
    return InitChatModel.fromJson(response);
  }

  initRRTNotification({
    String? userId,
    String? peerId,
    String? selectedDate,
  }) async {
    final body = {
      "ccId": peerId,
      "userId": userId,
      "preferredDate": selectedDate,
    };
    var jsonString = convert.jsonEncode(body);
    await _helper.initRRTNotification(
      url: qr_init_rrt_notification,
      jsonString: jsonString,
    );
  }

  Future<InitChatFamilyModel> initNewFamilyChat(String userId, String peerId,
      String familyName, bool isCareCoordinator, String careCooId,String familyUserId) async {
    var body = {
      "caregiverId": "${userId}",
      "caregiverName": "${familyName}",
      "userId": isCareCoordinator ? careCooId : peerId,
      "familyUserId": isCareCoordinator ? familyUserId : null
    };
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.initNewChat(
        qr_chat_socket_init_chat_pat_family, jsonString);
    return InitChatFamilyModel.fromJson(response);
  }

  Future<GetUserIdModel> getUserIdFromDocId(String docId) async {
    final response = await _helper.getUserIdFromDocId(
        qr_chat_socket_get_user_id_doc +
            docId +
            qr_chat_socket_get_user_id_doc_include);
    return GetUserIdModel.fromJson(response);
  }

  Future<CaregiverPatientChatModel> getFamilyListMap(String userId) async {
    var body = {
      "id": "${userId}",
    };
    final jsonString = convert.jsonEncode(body);
    final response =
        await _helper.getChatHistory(qr_chat_family_mapping, jsonString);
    return CaregiverPatientChatModel.fromJson(response);
  }

  Future<GetUnreadCountFamily> getUnreadCountFamily(String userId) async {
    var body = {
      "userId": "${userId}",
    };
    var jsonString = convert.jsonEncode(body);
    final response =
        await _helper.getChatHistory(qr_unread_family_chat, jsonString);
    return GetUnreadCountFamily.fromJson(response);
  }

  Future<UnreadChatCountWithMsgId> getUnreadChatWithMsgId(String chatMsgId) async {
    var body = {
      strId: "${chatMsgId}",
    };
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getChatHistory(qr_unread_chat_count_msg_id, jsonString);
    return UnreadChatCountWithMsgId.fromJson(response);
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/chat_socket/model/ChatHistoryModel.dart';
import 'package:myfhb/chat_socket/model/GetUserIdModel.dart';
import 'package:myfhb/chat_socket/model/InitChatModel.dart';
import 'package:myfhb/chat_socket/model/TotalCountModel.dart';
import 'package:myfhb/chat_socket/model/UserChatListModel.dart';
import 'package:myfhb/chat_socket/service/ChatSocketService.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class ChatSocketViewModel extends ChangeNotifier {
  ChatSocketService chocketService = new ChatSocketService();

  final String _baseUrl = BASE_URL;

  List<PayloadChat> userChatList = [];
  List<ChatHistoryResult> chatHistoryList = [];
  List<PayloadChat> chatHistoryCount = [];

  IO.Socket socket;

  int chatTotalCount = 0;

  Future<void> initSocket() async{
    String token = PreferenceUtil.getStringValue(KEY_AUTHTOKEN);
    String userId = PreferenceUtil.getStringValue(KEY_USERID);

    String _socketEndPoint = '';

    if (_baseUrl.contains('/api1/')) {
      _socketEndPoint = _baseUrl.replaceAll("/api1/", "");
    } else {
      _socketEndPoint = _baseUrl.replaceAll("/api/", "");
    }

    if (token != null && userId != null) {
      socket = IO.io(
          _socketEndPoint,
          OptionBuilder()
              .setTransports(['websocket'])
              .setPath('/fhb-chat/socket.io')
              .disableAutoConnect()
              //.setQuery({"userId": userId})
              .setExtraHeaders({'Authorization': 'Bearer ' + token})
              .build());

      //socket.io.options['extraHeaders'] = {'Authorization': 'Bearer ' + token,'userId': userId};
      socket.io.options['query'] = 'userId='+userId.toString();

      socket.connect();

      /*socket.on('connect_error', (data) => print(data));
      socket.on('connect_timeout', (data) => print(data));
      socket.on('connecting', (data) => print(data));
      socket.on('disconnect', (data) => print(data));
      socket.on('error', (data) => print(data));
      socket.on('reconnect', (data) => print(data));
      socket.on('reconnect_attempt', (data) => print(data));
      socket.on('reconnect_failed', (_) => print(_));
      socket.on('reconnect_error', (_) => print(_));

      socket.on('reconnecting', (_) => print(_));
      socket.on('ping', (_) => print(_));
      socket.on('pong', (_) => print(_));

      socket.on('connect', (_) {
        print('socket_chat_connected');
      });*/
    }
  }

  void updateChatUserList(UserChatListModel userChatListModel) {
    userChatList = userChatListModel?.payload;

    notifyListeners();
  }

  /*void updateChatTotalCount(UserChatListModel userChatListModelCount) {
    chatTotalCount  = 0;
    chatHistoryCount = userChatListModelCount?.payload;

    if (chatHistoryCount.isNotEmpty && (chatHistoryCount?.length ?? 0) > 0) {
      for (var i = 0; i < chatHistoryCount.length; i++) {
        if (chatHistoryCount[i]?.unReadCount != null &&
            chatHistoryCount[i]?.unReadCount != '' &&
            chatHistoryCount[i]?.unReadCount != '0') {
          chatTotalCount =
              chatTotalCount + int.parse(chatHistoryCount[i]?.unReadCount);
        }
      }
    }


    notifyListeners();
  }*/

  void updateChatTotalCount(TotalCountModel totalCountModel) {

    chatTotalCount = 0;

    if (totalCountModel != null) {
      if (totalCountModel?.isSuccess && totalCountModel?.payload != null) {
        if (totalCountModel?.payload?.isNotEmpty) {
          if (totalCountModel?.payload[0]?.count != null &&
              totalCountModel?.payload[0]?.count != '') {
            chatTotalCount = int.parse(totalCountModel?.payload[0]?.count??0);
          }
        }
      }
    }

    notifyListeners();
  }

  void updateChatHistoryList(List<ChatHistoryResult> list,
      {bool shouldUpdate: true}) {
    chatHistoryList = list;

    if (shouldUpdate) {
      notifyListeners();
    }
  }

  void messageEmit(ChatHistoryResult list) {
    chatHistoryList.add(list);

    notifyListeners();
  }

  void onReceiveMessage(ChatHistoryResult list) {
    chatHistoryList.add(list);

    notifyListeners();
  }

  Future<ChatHistoryModel> getChatHistory(String peerId) async {
    try {
      var userId = PreferenceUtil.getStringValue(KEY_USERID);

      ChatHistoryModel chatHistoryModel =
          await chocketService.getChatHistory(userId, peerId);

      return chatHistoryModel;
    } catch (e) {}
  }

  Future<InitChatModel> initNewChat(String peerId) async {
    try {
      var userId = PreferenceUtil.getStringValue(KEY_USERID);

      InitChatModel chatHistoryModel =
          await chocketService.initNewChat(userId, peerId);

      return chatHistoryModel;
    } catch (e) {}
  }

  Future<GetUserIdModel> getUserIdFromDocId(String docId) async {
    try {

      GetUserIdModel getUserIdModel =
      await chocketService.getUserIdFromDocId(docId);

      return getUserIdModel;
    } catch (e) {}
  }
}

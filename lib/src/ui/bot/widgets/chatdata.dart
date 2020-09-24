import 'dart:async';

import 'package:myfhb/src/ui/bot/widgets/pleasewait.dart';
import 'package:myfhb/src/ui/bot/widgets/receiver.dart';
import 'package:myfhb/src/ui/bot/widgets/sender.dart';
import '../../../model/bot/ConversationModel.dart';
import 'package:flutter/material.dart';

import '../../../model/bot/ConversationModel.dart';

class ChatData extends StatelessWidget with ChangeNotifier {
  final List<Conversation> conversations;
  ScrollController _controller = new ScrollController();
  ChatData({this.conversations});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 1000),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
    return conversations.length > 0
        ? Container(
            padding: EdgeInsets.only(bottom: 50),
            color: Colors.white70,
            child: ListView.builder(
                    controller: _controller,
                    reverse: false,
                    itemCount: conversations.length,
                    itemBuilder: (BuildContext ctxt, int index) => Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: conversations[index].isMayaSaid
                            ? ReceiverLayout(conversations[index])
                            : SenderLayout(conversations[index]))),
          )
        : PleaseWait();
  }
}

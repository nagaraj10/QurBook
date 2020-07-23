import 'package:flutter/material.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;


class Chat extends StatefulWidget {
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
     return Center(child: Text(variable.strChat),);

  }
}
import 'package:flutter/material.dart';

import '../../../model/bot/ConversationModel.dart';

class MayaConvUI extends StatelessWidget {
  final Conversation c;

  MayaConvUI(this.c);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          c.text,
          style: Theme.of(context).textTheme.body1.apply(
                color: Colors.white,
              ),
        ),
        c?.imageUrl != null
            ? Padding(
                child: Image.network(
                  c?.imageUrl,
                  height: (MediaQuery.of(context).size.width * .6) - 5,
                  width: (MediaQuery.of(context).size.width * .6) - 5,
                  fit: BoxFit.cover,
                ),
                padding: EdgeInsets.all(10),
              )
            : SizedBox(
                height: 0,
                width: 0,
              )
      ],
    );
  }
}

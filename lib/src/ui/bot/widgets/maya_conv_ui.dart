import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';

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
            ? InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FullPhotoScreen(url: c?.imageUrl)));
                },
                child: Padding(
                  child: Image.network(
                    c?.imageUrl,
                    height: (MediaQuery.of(context).size.width * .6) - 5,
                    width: (MediaQuery.of(context).size.width * .6) - 5,
                    fit: BoxFit.cover,
                  ),
                  padding: EdgeInsets.only(left: 5,right: 5),
                ),
              )
            : SizedBox(
                height: 0,
                width: 0,
              )
      ],
    );
  }
}

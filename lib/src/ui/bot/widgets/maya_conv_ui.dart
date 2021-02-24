import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';

import '../../../model/bot/ConversationModel.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

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
                    height: (1.sw * .6) - 5,
                    width: (1.sw * .6) - 5,
                    fit: BoxFit.cover,
                  ),
                  padding: EdgeInsets.only(left: 5, right: 5),
                ),
              )
            : SizedBox(
                height: 0.0.h,
                width: 0.0.h,
              )
      ],
    );
  }
}

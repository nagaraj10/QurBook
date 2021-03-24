import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';

import '../../../model/bot/ConversationModel.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';

class MayaConvUI extends StatelessWidget {
  final Conversation c;
  final int index;

  MayaConvUI(
    this.c,
    this.index,
  );

  Widget buttonWidgets(BuildContext context) {
    if (c?.buttons != null && (c?.buttons?.length ?? 0) > 0) {
      return Wrap(
        spacing: 10,
        children: c.buttons
            .map((buttonData) => InkWell(
                  onTap: () {
                    Provider.of<ChatScreenViewModel>(context, listen: false)
                        .startSheelaFromButton(
                      buttonText: buttonData.title,
                      payload: buttonData.payload,
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        buttonData.title,
                        style: TextStyle(
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                          fontSize: 16.0.sp,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: <Widget>[
              Text(
                c.text,
                style: Theme.of(context).textTheme.body1.apply(
                      color: Colors.white,
                    ),
              ),
              buttonWidgets(context),
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
          ),
        ),
        Container(
          width: 36.0,
          height: 30.0,
          child: InkWell(
            onTap: () async {
              if (!c.isSpeaking) {
                String textToSpeak = '';
                if ((c?.buttons?.length ?? 0) > 0) {
                  textToSpeak = '.';
                  await Future.forEach(c.buttons, (button) async {
                    textToSpeak = textToSpeak + button.title + '.';
                  });
                }
                await Provider.of<ChatScreenViewModel>(context, listen: false)
                    .startTTSEngine(
                  textToSpeak: c.text + textToSpeak,
                  index: index,
                  langCode: c.langCode,
                );
              } else {
                Provider.of<ChatScreenViewModel>(context, listen: false)
                    .stopTTSEngine(
                  index: index,
                );
              }
            },
            child: Icon(
              c.isSpeaking &&
                      (!Provider.of<ChatScreenViewModel>(context).getStopTTS)
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 24.0.sp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

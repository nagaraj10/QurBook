import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';
import 'package:myfhb/widgets/checkout_page.dart';

import '../../../model/bot/ConversationModel.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/constants/router_variable.dart' as routervariable;

class MayaConvUI extends StatelessWidget {
  final Conversation c;
  final int index;

  MayaConvUI(
    this.c,
    this.index,
  );

  Widget buttonWidgets(BuildContext context) {
    if (c?.buttons != null && (c?.buttons?.length ?? 0) > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: c.buttons
            .map(
              (buttonData) => InkWell(
                onTap: ((c.singleuse != null && c.singleuse) &&
                        (c.isActionDone != null && c.isActionDone))
                    ? null
                    : () {
                        if (c.singleuse != null &&
                            c.singleuse &&
                            c.isActionDone != null) {
                          c.isActionDone = true;
                        }
                        buttonData.isSelected = true;

                        if (buttonData?.redirectTo != null &&
                            buttonData.redirectTo.contains('myfamily_list')) {
                          Provider.of<ChatScreenViewModel>(context,
                                  listen: false)
                              .startSheelaFromButton(
                            buttonText: buttonData.title,
                            payload: buttonData.payload,
                            isRedirectionNeed: true,
                          );
                          FlutterToast()
                              .getToast('Redirecting...', Colors.black54);
                          Get.toNamed(
                            routervariable.rt_UserAccounts,
                            arguments: UserAccountsArguments(
                              selectedIndex: 1,
                            ),
                          ).then((value) => Provider.of<ChatScreenViewModel>(
                                  context,
                                  listen: false)
                              .reEnableMicButton());
                        } else if (buttonData?.redirectTo != null &&
                            buttonData.redirectTo.contains('mycart')) {
                          Provider.of<ChatScreenViewModel>(context,
                                  listen: false)
                              .startSheelaFromButton(
                            buttonText: buttonData.title,
                            payload: buttonData.payload,
                            isRedirectionNeed: true,
                          );
                          FlutterToast()
                              .getToast('Redirecting...', Colors.black54);
                          Get.to(CheckoutPage());
                        } else {
                          Provider.of<ChatScreenViewModel>(context,
                                  listen: false)
                              .startSheelaFromButton(
                            buttonText: buttonData.title,
                            payload: buttonData.payload,
                          );
                        }
                      },
                child: Card(
                  color: (buttonData.isSelected ?? false)
                      ? PreferenceUtil.getIfQurhomeisAcive()
                          ? Color(CommonUtil().getQurhomeGredientColor())
                          : Colors.green
                      : ((buttonData.isPlaying ?? false) && c.isSpeaking)
                          ? PreferenceUtil.getIfQurhomeisAcive()
                              ? Color(CommonUtil().getQurhomeGredientColor())
                              : Colors.lightBlueAccent
                          : ((c.singleuse != null && c.singleuse) &&
                                  (c.isActionDone != null && c.isActionDone))
                              ? Colors.white.withOpacity(0.7)
                              : Colors.white,
                  margin: const EdgeInsets.only(top: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    child: Text(
                      buttonData.title,
                      style: TextStyle(
                        color: ((buttonData.isPlaying ?? false) &&
                                    c.isSpeaking) ||
                                (buttonData.isSelected ?? false)
                            ? Colors.white
                            : PreferenceUtil.getIfQurhomeisAcive()
                                ? Color(CommonUtil().getQurhomeGredientColor())
                                : Color(CommonUtil().getMyPrimaryColor()),
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ),
                ),
              ),
            )
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
            crossAxisAlignment: PreferenceUtil.getIfQurhomeisAcive()
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                c.text,
                style: Theme.of(context).textTheme.bodyText1.apply(
                      fontSizeFactor: CommonUtil().isTablet ? 1.6 : 1.0,
                      color: PreferenceUtil.getIfQurhomeisAcive()
                          ? Colors.black
                          : Colors.white,
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
                // if ((c?.buttons?.length ?? 0) > 0) {
                //   textToSpeak = '.';
                //   await Future.forEach(c.buttons, (button) async {
                //     textToSpeak = textToSpeak + button.title + '.';
                //   });
                // }
                await Provider.of<ChatScreenViewModel>(context, listen: false)
                    .startTTSEngine(
                  textToSpeak: c.text + textToSpeak,
                  index: index,
                  langCode: c.langCode,
                  isButtonText: (c.buttons?.length ?? 0) > 0,
                );
                // if (!Provider.of<ChatScreenViewModel>(context, listen: false)
                //     .stopTTS) {
                await Provider.of<ChatScreenViewModel>(context, listen: false)
                    .startButtonsSpeech(
                  index: index,
                  langCode: c.langCode,
                  buttons: c.buttons,
                );
                // }
              } else {
                Provider.of<ChatScreenViewModel>(context, listen: false)
                    .stopTTSEngine(
                  index: index,
                  langCode: c.langCode,
                );
              }
            },
            child: Icon(
              c.isSpeaking ? Icons.pause : Icons.play_arrow,
              size: 24.0.sp,
              color: PreferenceUtil.getIfQurhomeisAcive()
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

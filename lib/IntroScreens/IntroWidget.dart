import 'package:flutter/material.dart';
import 'package:myfhb/IntroScreens/curves.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class IntroWidget extends StatelessWidget {
  String imageForScreen;

  IntroWidget(this.imageForScreen);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopCommonCureveWidget(),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Image.asset(
              imageForScreen,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          height: 1,
          width: 50,
          color: HexColor('2831b1'),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          getStringForIntro(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  String getStringForIntro() {
    switch (imageForScreen) {
      case icon_languageIntro:
        return 'Receive QurPlan in \n your own Language';
        break;
      case icon_qurplanIntro:
        return 'Follow QurPlan and track \n stay healthy!!';
        break;
      case icon_ReminderIntro:
        return 'Voice enabled reminders \n and tracking';
        break;
      case icon_TrustedAnswerIntro:
        return 'Receive trusted answers \n from Clinicians';
        break;
      case icon_SheelaIntro:
        return 'Converse with Sheela about \n your Qurplan and symptoms';
        break;
      default:
        return 'Receive QurPlan in \n your own Language';
    }
  }
}

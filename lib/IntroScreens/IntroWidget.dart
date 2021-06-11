import 'package:flutter/material.dart';
import 'package:myfhb/IntroScreens/curves.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class IntroWidget extends StatelessWidget {
  String imageForScreen;

  IntroWidget(this.imageForScreen);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Image.asset(icon_StickPlanIntro),
        )),
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
          color: Color(CommonUtil().getMyPrimaryColor()),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          getStringForIntro(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  String getStringForIntro() {
    switch (imageForScreen) {
      case icon_languageIntro:
        return 'Subscribe to 150+ personalized health \n care plans from trusted providers';
        break;
      case icon_SheelaIntro:
        return 'One call or chat with your care giver  \n to manage your healthcare needs';
        break;
      case icon_qurplanIntro:
        return 'Just follow your Care plan Regime and \n be on top of your Health Risk';
        break;
      case icon_TrustedAnswerIntro:
        return 'Use Sheela G to record vitals, \n symptoms and disease education';
        break;
      case icon_ReminderIntro:
        return 'Get Peace of mind and Protection for \n you and your family';
        break;

      default:
        return 'Subscribe to 150+ personalized health care plans \n from trusted providers';
    }
  }
}

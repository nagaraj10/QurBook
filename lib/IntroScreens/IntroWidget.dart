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
        return 'Subscribe to 100+ HealthCare plans \n from Trusted Doctors and Hospitals';
        break;
      case icon_SheelaIntro:
        return 'Use Sheela G to Record \n Health Vitals & Receive Trusted Advice';
        break;
      case icon_qurplanIntro:
        return 'Get Assigned a \n Doctor & Caregiver';
        break;
      case icon_TrustedAnswerIntro:
        return 'Follow Health Regimes \n scheduled for the day';
        break;
      case icon_ReminderIntro:
        return 'Video Call & Chat with \n Your Care Team Instantly';
        break;

      default:
        return 'Get Assigned a \n Doctor & Caregiver';
    }
  }
}

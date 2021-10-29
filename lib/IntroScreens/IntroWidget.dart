import 'package:flutter/material.dart';
import '../common/CommonUtil.dart';
import '../constants/variable_constant.dart';

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
        return '1000 Unique Care Plans across 30 Specialities from Trusted Doctors & Hospitals';
        break;
      case icon_SheelaIntro:
        return 'Use Sheela to Record Vitals, \nTrack Symptoms, and Disease Education';
        break;
      case icon_qurplanIntro:
        return 'One Call or Chat with Your Caregiver \n for all Medical Assistance';
        break;
      case icon_TrustedAnswerIntro:
        return 'Follow Your Prescribed Care Regime.\n Stay on Top of Health Risks.';
        break;
      case icon_ReminderIntro:
        return 'Get Peace of Mind & \nProtection for You & Your Family';
        break;

      default:
        return '1000 Unique Care Plans across 30 Specialities from Trusted Doctors & Hospitals';
    }
  }
}

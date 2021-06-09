import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'landing_card.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
        padding: EdgeInsets.symmetric(
          vertical: 10.0.h,
          horizontal: 10.0.w,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0.w,
          mainAxisSpacing: 5.0.w,
        ),
        children: [
          LandingCard(
            title: constants.strYourQurplans,
            lastStatus: 'subtitle text',
            alerts: '',
            icon: variable.icon_my_plan,
            color: Colors.red,
            onPressed: () {},
          ),
          LandingCard(
            title: constants.strYourRegimen,
            lastStatus: 'subtitle text',
            alerts: '',
            icon: variable.icon_my_health_regimen,
            color: Colors.blue,
            onPressed: () {},
          ),
          LandingCard(
            title: constants.strVitals,
            lastStatus: 'subtitle text',
            alerts: '',
            icon: variable.icon_record_my_vitals,
            color: Colors.green,
            onPressed: () {},
          ),
          LandingCard(
            title: constants.strSymptomsCheckIn,
            lastStatus: 'subtitle text',
            alerts: '',
            icon: variable.icon_check_symptoms,
            color: Colors.red,
            onPressed: () {},
          ),
          LandingCard(
            title: constants.strYourFamily,
            lastStatus: 'subtitle text',
            alerts: '',
            icon: variable.icon_my_family,
            color: Colors.red,
            onPressed: () {},
          ),
          LandingCard(
            title: constants.strYourProviders,
            lastStatus: 'subtitle text',
            alerts: '',
            icon: variable.icon_my_providers,
            color: Colors.red,
            onPressed: () {},
          ),
          LandingCard(
            title: constants.strHowVideos,
            lastStatus: 'subtitle text',
            alerts: '',
            icon: variable.icon_how_to_use,
            color: Colors.red,
            onPressed: () {},
          ),
          LandingCard(
            title: constants.strChatWithUs,
            lastStatus: 'subtitle text',
            alerts: '',
            icon: variable.icon_chat_dash,
            color: Colors.red,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

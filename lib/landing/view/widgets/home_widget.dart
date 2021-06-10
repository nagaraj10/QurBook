import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';
import 'landing_card.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;

class HomeWidget extends StatelessWidget {
  // const HomeWidget({
  //   this.title,
  // });
  //
  // final String title;

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 20.0.w,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SizedBox(
            //         height: 20.0.h,
            //       ),
            //       // Text(
            //       //   title ?? "",
            //       //   style: TextStyle(
            //       //     fontSize: 22.0.sp,
            //       //     color: Colors.black,
            //       //   ),
            //       //   overflow: TextOverflow.ellipsis,
            //       // ),
            //       // Text(
            //       //   constants.strNiceDay,
            //       //   style: TextStyle(
            //       //     fontSize: 18.0.sp,
            //       //     color: Colors.black54,
            //       //     fontWeight: FontWeight.bold,
            //       //   ),
            //       //   overflow: TextOverflow.ellipsis,
            //       // ),
            //       // Text(
            //       //   '${CommonUtil().dateConversionToDayMonthDate(DateTime.now())}',
            //       //   style: TextStyle(
            //       //     fontSize: 14.0.sp,
            //       //     color: Colors.black54,
            //       //   ),
            //       //   overflow: TextOverflow.ellipsis,
            //       // ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(
                left: 20.0.w,
                right: 20.0.w,
                top: 10.0.h,
              ),
              child: Text(
                constants.strMyDashboard,
                style: TextStyle(
                  fontSize: 18.0.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Expanded(
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
                    color: Color(CommonConstants.bplightColor),
                    onPressed: () {
                      Get.toNamed(rt_MyPlans);
                    },
                    onAddPressed: () {
                      Get.toNamed(rt_Plans);
                    },
                  ),
                  LandingCard(
                    title: constants.strYourRegimen,
                    lastStatus: 'subtitle text',
                    alerts: '',
                    icon: variable.icon_my_health_regimen,
                    color: Color(CommonConstants.GlucolightColor),
                    onPressed: () {
                      Provider.of<RegimentViewModel>(
                        context,
                        listen: false,
                      ).regimentMode = RegimentMode.Schedule;
                      Get.toNamed(rt_Regimen);
                    },
                  ),
                  LandingCard(
                    title: constants.strVitals,
                    lastStatus: 'subtitle text',
                    alerts: '',
                    icon: variable.icon_record_my_vitals,
                    color: Color(CommonConstants.ThermolightColor),
                    onPressed: () {
                      Get.toNamed(rt_Devices);
                    },
                  ),
                  LandingCard(
                    title: constants.strSymptomsCheckIn,
                    lastStatus: 'subtitle text',
                    alerts: '',
                    icon: variable.icon_check_symptoms,
                    color: Color(CommonConstants.pulselightColor),
                    onPressed: () {
                      Provider.of<RegimentViewModel>(
                        context,
                        listen: false,
                      ).regimentMode = RegimentMode.Symptoms;
                      Get.toNamed(rt_Regimen);
                    },
                  ),
                  LandingCard(
                    title: constants.strYourFamily,
                    lastStatus: 'subtitle text',
                    alerts: '',
                    icon: variable.icon_my_family,
                    color: Color(CommonConstants.weightlightColor),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        rt_UserAccounts,
                        arguments: UserAccountsArguments(
                          selectedIndex: 1,
                        ),
                      );
                    },
                  ),
                  LandingCard(
                    title: constants.strYourProviders,
                    lastStatus: 'subtitle text',
                    alerts: '',
                    icon: variable.icon_my_providers,
                    color: Color(CommonConstants.bpDarkColor),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        rt_UserAccounts,
                        arguments: UserAccountsArguments(
                          selectedIndex: 2,
                        ),
                      );
                    },
                  ),
                  LandingCard(
                    title: constants.strHowVideos,
                    lastStatus: 'subtitle text',
                    alerts: '',
                    icon: variable.icon_how_to_use,
                    color: Color(CommonConstants.GlucoDarkColor),
                    onPressed: () {},
                  ),
                  LandingCard(
                    title: constants.strChatWithUs,
                    lastStatus: 'subtitle text',
                    alerts: '',
                    icon: variable.icon_chat_dash,
                    color: Color(CommonConstants.ThermoDarkColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

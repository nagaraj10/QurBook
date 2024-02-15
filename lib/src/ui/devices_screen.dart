import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';

import '../../common/CommonUtil.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart';
import '../../constants/variable_constant.dart';
import '../../landing/view/landing_arguments.dart';
import '../../widgets/GradientAppBar.dart';
import '../utils/screenutils/size_extensions.dart';
import 'Dashboard.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FABService.trackCurrentScreen(FBAVitalsScreen);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        title: Text(
          strDevices,
          style: TextStyle(
              fontSize:
                  CommonUtil().isTablet! ? tabFontTitle : mobileFontTitle),
        ),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () => onBackPressed(context),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          onBackPressed(context);
          return Future.value(false);
        },
        child: DashboardScreen(),
      ),
    );
  }

  void onBackPressed(BuildContext context) {
    if (Navigator.canPop(context)) {
      Get.back();
    } else {
      Get.offAllNamed(
        rt_Landing,
        arguments: const LandingArguments(
          needFreshLoad: false,
        ),
      );
    }
  }
}

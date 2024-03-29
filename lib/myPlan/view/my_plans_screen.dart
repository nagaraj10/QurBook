import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';

import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart';
import '../../landing/view/landing_arguments.dart';
import '../../main.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/CartIconWithBadge.dart';
import '../../widgets/GradientAppBar.dart';
import '../../widgets/checkout_page.dart';
import 'myPlanList.dart';

class MyPlansScreen extends StatefulWidget {
  const MyPlansScreen({super.key});

  @override
  _MyPlansScreenState createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends State<MyPlansScreen> {
  bool cartEnable = false; // FUcrash bool ? to bool
  bool addPlanButton = false;

  @override
  void initState() {
    getConfiguration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          backgroundColor: mAppThemeProvider.primaryColor,
          elevation: 0,
          title: const Text(strMyPlans),
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 24.0.sp,
            onTap: () => onBackPressed(context),
          ),
          actions: cartEnable
              ? [
                  // FUcrash cartEnable! to cartEnable
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(right: 15.0.sp),
                      child: InkWell(
                        onTap: () {
                          Get.to(CheckoutPage())!.then((value) =>
                              FocusManager.instance.primaryFocus!.unfocus());
                        },
                        child: CartIconWithBadge(
                          color: Colors.white,
                          size: 32.0.sp,
                        ),
                      ),
                    ),
                  ),
                ]
              : [],
        ),
        body: WillPopScope(
          onWillPop: () {
            onBackPressed(context);
            return Future.value(false);
          },
          child: MyPlanList(),
        ),
      );

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

  Future<void> getConfiguration() async {
    final cartEnable = await PreferenceUtil.getCartEnable() ?? false;
    setState(() {
      this.cartEnable = cartEnable; // FUcrash
    });
  }
}

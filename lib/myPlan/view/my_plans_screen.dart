import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/myPlan/view/myPlanList.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/CartIconWithBadge.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/widgets/checkout_page.dart';

class MyPlansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        title: Text(strMyPlans),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () => onBackPressed(context),
        ),
        actions: [
          Center(
            child: Container(
                margin: EdgeInsets.only(right: 15.0.sp),
                child: InkWell(
                    onTap: () {
                      Get.to(CheckoutPage());
                    },
                    child:
                        CartIconWithBadge(color: Colors.white, size: 32.0.sp))),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          onBackPressed(context);
          return Future.value(false);
        },
        child: MyPlanList(),
      ),
    );
  }

  onBackPressed(BuildContext context) {
    if (Navigator.canPop(context)) {
      Get.back();
    } else {
      Get.offAllNamed(
        rt_Landing,
        arguments: LandingArguments(
          needFreshLoad: false,
        ),
      );
    }
  }
}

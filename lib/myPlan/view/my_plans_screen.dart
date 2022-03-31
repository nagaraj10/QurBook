import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/widgets/CartIconWithBadge.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart';
import '../../landing/view/landing_arguments.dart';
import 'myPlanList.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';

class MyPlansScreen extends StatefulWidget {


  @override
  _MyPlansScreenState createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends State<MyPlansScreen> {

  bool cartEnable=false;
  bool addPlanButton=false;

  @override
  void initState() {
    getConfiguration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        title: Text(strMyPlans),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () => onBackPressed(context),
        ),
        actions: cartEnable?[
          Center(
            child: Container(
                margin: EdgeInsets.only(right: 15.0.sp),
                child: InkWell(
                    onTap: () {
                      Get.to(CheckoutPage()).then((value) => FocusManager.instance.primaryFocus.unfocus());
                    },
                    child:
                        CartIconWithBadge(color: Colors.white, size: 32.0.sp))),
          ),
        ]:[],
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

  Future<void> getConfiguration() async {
    bool addplanbutton=await PreferenceUtil.getAddPlanBtn();
    bool cartEnable=await PreferenceUtil.getCartEnable();
   setState(() {
     this.cartEnable=cartEnable;
   });
  }
}

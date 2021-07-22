import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import '../../common/CommonUtil.dart';
import '../../common/SwitchProfile.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart';
import '../models/regiment_arguments.dart';
import '../../landing/view/landing_arguments.dart';
import 'regiment_tab.dart';
import '../view_model/regiment_view_model.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class RegimentScreen extends StatelessWidget {

  final RegimentArguments aruguments;

  RegimentScreen({this.aruguments});
  final GlobalKey<State> _key = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        title: Text(strRegimen),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () => onBackPressed(context),
        ),
        actions: [
          SwitchProfile().buildActions(
            context,
            _key,
            () {
              Provider.of<RegimentViewModel>(context, listen: false)
                  .fetchRegimentData(
                isInitial: true,
              );
              (context as Element).markNeedsBuild();
            },
            true,
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          onBackPressed(context);
          return Future.value(false);
        },
        child: RegimentTab(eventId: aruguments?.eventId,),
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

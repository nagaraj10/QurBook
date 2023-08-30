import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/more_menu/models/available_devices/TroubleShootingModel.dart';
import 'package:myfhb/more_menu/trouble_shoot_controller.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../constants/fhb_constants.dart' as Constants;

class TroubleShooting extends StatefulWidget {
  TroubleShooting();

  @override
  _TroubleShootingState createState() => _TroubleShootingState();
}

class _TroubleShootingState extends State<TroubleShooting> {
  bool isFirstym = true;
  late Timer _timer;
  late Random _random;
  String _annotationValue = '50 %';
  double _pointerValue = 50;
  bool startTest = true;
  TroubleShootController controller = Get.put(TroubleShootController());

  @override
  void initState() {
    controller.isFirstTym.value = true;
    controller.progressValue = 0;
    controller.progressText.value = "0 %";

    super.initState();
  }

  @override
  void dispose() {
    try {
      //controller.dispose();
      super.dispose();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      //print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(strTroubleShooting),
          flexibleSpace: GradientAppBar(),
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile,
            onTap: () {
              Navigator.pop(context, false);
            },
          ),
          actions: <Widget>[]),
      body: Obx(() => controller.isFirstTym.value
          ? getButtonWidget(strStartTest, () {
              controller.progressText.value = "0 %";
              controller.progressValue = 0.0;
              controller.troubleShootingApp();
            })
          : SingleChildScrollView(
              child: Container(
                  width: double.maxFinite,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: controller.isTroubleShootCompleted.value
                                ? controller.testSuccess.value
                                    ? ImageIcon(
                                        AssetImage(icon_tsSuccess),
                                        size: CommonUtil().isTablet!
                                            ? imageTabIcon
                                            : imageMobileIcon,
                                        color: Colors.green,
                                      )
                                    : ImageIcon(
                                        AssetImage(
                                          icon_tsFail,
                                        ),
                                        size: CommonUtil().isTablet!
                                            ? imageTabIcon
                                            : imageMobileIcon,
                                        color: Colors.orange)
                                : SizedBox()),
                        controller.isTroubleShootCompleted.value
                            ? SizedBox(
                                height: 50,
                              )
                            : SizedBox(),
                        Align(
                            alignment: Alignment.center,
                            child: controller.isTroubleShootCompleted.value
                                ? controller.testSuccess.value
                                    ? Text(
                                        controller.testMsg.value,
                                        style: TextStyle(color: Colors.green),
                                      )
                                    : Text(
                                        controller.testMsg.value,
                                        style: TextStyle(color: Colors.grey),
                                      )
                                : SizedBox()),
                        SizedBox(
                          height: 20,
                        ),
                        !controller.isTroubleShootCompleted.value
                            ? SizedBox(
                                height: 200.0,
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        child: TweenAnimationBuilder<double>(
                                            tween: Tween<double>(
                                                begin: 0.0, end: 1),
                                            duration: const Duration(
                                                milliseconds: 3500),
                                            builder: (context, value, _) =>
                                                new CircularProgressIndicator(
                                                    strokeWidth: 15.0,
                                                    value: controller
                                                        .progressValue,
                                                    color: Color(CommonUtil()
                                                        .getMyPrimaryColor()), //<-- SEE HERE
                                                    backgroundColor:
                                                        Colors.grey[100])),
                                      ),
                                    ),
                                    Center(
                                        child: Text(
                                            controller.progressText.value)),
                                  ],
                                ),
                              )
                            : getButtonWidget(strTestAgain, () {
                                controller.progressText.value = "0 %";
                                controller.progressValue = 0.0;
                                controller.troubleShootingApp();
                              }),
                        controller.isTroubleShootCompleted.value
                            ? SizedBox(
                                height: 50,
                              )
                            : SizedBox(),
                        controller.isTroubleShootCompleted.value
                            ? Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "Diagnostic Report",
                                      style: TextStyle(
                                          fontSize: CommonUtil().isTablet!
                                              ? Constants.tabFontTitle
                                              : Constants.mobileFontTitle,
                                          color: Color(
                                              CommonUtil().getMyPrimaryColor()),
                                          fontWeight: FontWeight.bold),
                                    )))
                            : SizedBox(),
                        controller.isTroubleShootCompleted.value
                            ? getListViewItemsOfTroubleShooting()
                            : SizedBox()
                      ])),
            )),
    );
  }

  Widget getListViewItemsOfTroubleShooting() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (c, i) =>
          getCardForTroubleShootItems(controller.troubleShootingList![i]),
      itemCount: controller.troubleShootingList.length ?? 0,
    );
  }

  Widget getCardForTroubleShootItems(
      TroubleShootingModel troubleShootingModel) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 50,
          child: Row(
            children: [
              troubleShootingModel.widget,
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  troubleShootingModel.name,
                  style: TextStyle(
                      fontSize: CommonUtil().isTablet!
                          ? Constants.tabHeader1
                          : Constants.mobileHeader1,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (!troubleShootingModel.isPass) {
                    controller.onTapOfDiagnosicResult(troubleShootingModel);
                  }
                },
                child: ImageIcon(
                  troubleShootingModel.isPass
                      ? AssetImage(icon_tsCheck)
                      : AssetImage(icon_tsUncheck),
                  color: troubleShootingModel.isPass
                      ? Colors.green
                      : Colors.orange,
                  size:
                      CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getButtonWidget(String btnText, Function() onPressed) {
    return Center(
        child: GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(CommonUtil().getMyPrimaryColor()),
        ),
        child: Center(
          child: Text(btnText,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
                color: ColorUtils.white,
              )),
        ),
      ),
    ));
  }
}

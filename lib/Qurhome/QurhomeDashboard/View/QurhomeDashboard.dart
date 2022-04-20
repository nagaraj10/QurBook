import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/variable_constant.dart';
import '../Controller/QurhomeDashboardController.dart';
import 'QurHomeRegimen.dart';

class QurhomeDashboard extends GetView<QurhomeDashboardController> {
  double sheelaIconsSize = 70;
  double buttonSize = 70;
  int index=0;
  BorderSide getBorder() {
    return BorderSide(
      color: Color(CommonUtil().getQurhomeGredientColor()),
      width: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Hello User",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.black,
            size: 24.0,
            onTap: () {
              PreferenceUtil.saveIfQurhomeisAcive(
                qurhomeStatus: false,
              );
              Get.back();
            },
          ),
          bottom: PreferredSize(
            child: Container(
              color: Color(
                CommonUtil().getQurhomeGredientColor(),
              ),
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(
              1.0,
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: SizedBox(
            height: buttonSize,
            width: buttonSize,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {},
              child: Container(
                height: sheelaIconsSize,
                width: sheelaIconsSize,
                padding: const EdgeInsets.all(
                  8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(
                      CommonUtil().getQurhomeGredientColor(),
                    ),
                    width: 1,
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Image.asset(
                  icon_mayaMain,
                  height: sheelaIconsSize,
                  width: sheelaIconsSize,
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SizedBox(
          height: 40,
          child: Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: getBorder(),
                  top: getBorder(),
                  right: getBorder(),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      child: Container(
                        color: controller.currentSelectedIndex == 0
                            ? Color(
                                CommonUtil().getQurhomeGredientColor(),
                              )
                            : Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  "Vitals",
                                  style: TextStyle(
                                    color: controller.currentSelectedIndex != 0
                                        ? Color(
                                            CommonUtil()
                                                .getQurhomeGredientColor(),
                                          )
                                        : Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        color: controller.currentSelectedIndex == 1
                            ? Color(
                                CommonUtil().getQurhomeGredientColor(),
                              )
                            : Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Spacer(
                                  flex: 2,
                                ),
                                Text(
                                  "Symptoms",
                                  style: TextStyle(
                                    color: controller.currentSelectedIndex != 1
                                        ? Color(
                                            CommonUtil()
                                                .getQurhomeGredientColor(),
                                          )
                                        : Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: QurHomeRegimenScreen(),
      ),
      onWillPop: () async {
        PreferenceUtil.saveIfQurhomeisAcive(
          qurhomeStatus: false,
        );
        Get.back();
        return true;
      },
    );
  }
}

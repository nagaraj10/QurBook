import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:myfhb/Qurhome/QurHomeSymptoms/view/SymptomListScreen.dart';
import 'package:myfhb/Qurhome/QurHomeVitals/view/VitalsList.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/router_variable.dart';
import '../../../src/ui/bot/view/sheela_arguments.dart';
import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/variable_constant.dart';
import '../Controller/QurhomeDashboardController.dart';
import 'QurHomeRegimen.dart';
import '../../../src/utils/screenutils/size_extensions.dart';

class QurhomeDashboard extends StatefulWidget {
  @override
  _QurhomeDashboardState createState() => _QurhomeDashboardState();
}

class _QurhomeDashboardState extends State<QurhomeDashboard> {
  final controller = Get.put(QurhomeDashboardController());

  double buttonSize = 70;
  int index = 0;

  BorderSide getBorder() {
    return BorderSide(
      color: Color(CommonUtil().getQurhomeGredientColor()),
      width: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (controller.currentSelectedIndex != 0 &&
                          controller.currentSelectedIndex != 1)
                      ? Container(
                          margin: EdgeInsets.only(
                            left: 8.h,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.h,
                              vertical: 4.h,
                            ),
                            child: controller.currentSelectedIndex == 2
                                ? AssetImageWidget(
                                    icon: icon_vitals_qurhome,
                                    height: 22.h,
                                    width: 22.h,
                                  )
                                : controller.currentSelectedIndex == 3
                                    ? AssetImageWidget(
                                        icon: icon_symptom_qurhome,
                                        height: 22.h,
                                        width: 22.h,
                                      )
                                    : SizedBox.shrink(),
                          ))
                      : SizedBox.shrink(),
                  Text(
                    controller.appBarTitle.value,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 70.w)
                ],
              ),
              leading: controller.currentSelectedIndex == 0
                  ? IconWidget(
                      icon: Icons.arrow_back_ios,
                      colors: Colors.black,
                      size: 24.0,
                      onTap: () {
                        Get.back();
                        PreferenceUtil.saveIfQurhomeisAcive(
                          qurhomeStatus: false,
                        );
                      },
                    )
                  : Container(
                      margin: EdgeInsets.only(
                        left: 8.h,
                      ),
                      child: InkWell(
                          onTap: () {
                            bottomTapped(0);
                          },
                          child: CommonUtil().qurHomeMainIcon())),
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
              actions: [
                InkWell(
                  onTap: () {
                    //Device Connected
                    Get.toNamed(
                      rt_Sheela,
                      arguments: SheelaArgument(
                        takeActiveDeviceReadings: true,
                      ),
                    );

                    //Device Not Connected
                    Get.toNamed(
                      rt_Sheela,
                      arguments: SheelaArgument(
                        sheelaInputs: requestSheelaForpo,
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: AssetImageWidget(
                      icon: icon_vitals_qurhome,
                      height: 22.h,
                      width: 22.h,
                    ),
                  ),
                )
              ],
            ),
            body: getCurrentTab(),
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
                  onPressed: () {
                    String sheela_lang =
                        PreferenceUtil.getStringValue(SHEELA_LANG);
                    Get.toNamed(
                      rt_Sheela,
                      arguments: SheelaArgument(
                        isSheelaAskForLang: !((sheela_lang ?? '').isNotEmpty),
                        langCode: (sheela_lang ?? ''),
                      ),
                    );
                  },
                  child: Container(
                    height: buttonSize,
                    width: buttonSize,
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
                      height: buttonSize,
                      width: buttonSize,
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: SizedBox(
              height: 45.h,
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
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          bottomTapped(2);
                        },
                        child: Container(
                          color: controller.currentSelectedIndex == 2
                              ? Color(
                                  CommonUtil().getQurhomeGredientColor(),
                                )
                              : Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Text(
                                    "Vitals",
                                    style: TextStyle(
                                      color:
                                          controller.currentSelectedIndex == 2
                                              ? Colors.white
                                              : Color(
                                                  CommonUtil()
                                                      .getQurhomeGredientColor(),
                                                ),
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
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          bottomTapped(3);
                        },
                        child: Container(
                          color: controller.currentSelectedIndex == 3
                              ? Color(
                                  CommonUtil().getQurhomeGredientColor(),
                                )
                              : Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Spacer(
                                    flex: 2,
                                  ),
                                  Text(
                                    "Symptoms",
                                    style: TextStyle(
                                      color:
                                          controller.currentSelectedIndex == 3
                                              ? Colors.white
                                              : Color(
                                                  CommonUtil()
                                                      .getQurhomeGredientColor(),
                                                ),
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
          onWillPop: () async {
            Get.back();
            PreferenceUtil.saveIfQurhomeisAcive(
              qurhomeStatus: false,
            );
            return true;
          },
        ));
  }

  Widget getCurrentTab() {
    Widget landingTab;
    switch (controller.currentSelectedIndex.value) {
      case 1:
        landingTab = QurHomeRegimenScreen();
        break;
      case 2:
        landingTab = VitalsList();
        break;
      case 3:
        landingTab = SymptomListScreen();
        break;
      default:
        landingTab = QurHomeRegimenScreen();
        break;
    }
    return landingTab;
  }

  void bottomTapped(int index) {
    controller.updateTabIndex(index);
  }
}

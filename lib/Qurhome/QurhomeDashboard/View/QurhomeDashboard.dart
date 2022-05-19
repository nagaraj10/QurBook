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
import 'package:intl/intl.dart';

class QurhomeDashboard extends StatefulWidget {
  @override
  _QurhomeDashboardState createState() => _QurhomeDashboardState();
}

class _QurhomeDashboardState extends State<QurhomeDashboard> {
  final controller = Get.put(QurhomeDashboardController());

  double buttonSize = 70;
  double textFontSize = 16;
  int index = 0;

  @override
  void initState() {
    try {
      super.initState();
      if (CommonUtil().isTablet) {
        buttonSize = 100;
        textFontSize = 26;
      }
      controller.updateTabIndex(0);
    } catch (e) {
      print(e);
    }
  }

  BorderSide getBorder() {
    return BorderSide(
      color: Color(CommonUtil().getQurhomeGredientColor()),
      width: 1.0,
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
                                ? CommonUtil().isTablet
                                    ? AssetImageWidget(
                                        icon: icon_vitals_qurhome,
                                        height: 22.h,
                                        width: 22.h,
                                      )
                                    : AssetImageWidget(
                                        icon: icon_vitals_qurhome,
                                        height: 22.h,
                                        width: 22.h,
                                      )
                                : controller.currentSelectedIndex == 3
                                    ? CommonUtil().isTablet
                                        ? AssetImageWidget(
                                            icon: icon_symptom_qurhome,
                                            height: 22.h,
                                            width: 22.h,
                                          )
                                        : AssetImageWidget(
                                            icon: icon_symptom_qurhome,
                                            height: 22.h,
                                            width: 22.h,
                                          )
                                    : SizedBox.shrink(),
                          ))
                      : SizedBox.shrink(),
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: TextStyle(
                            fontSize: textFontSize,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            if (controller.currentSelectedIndex.value == 0 ||
                                controller.currentSelectedIndex.value == 1) ...{
                              TextSpan(text: 'Hello '),
                            },
                            TextSpan(
                              text: controller.appBarTitle.value,
                              style: TextStyle(
                                  fontSize: textFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      if (controller.currentSelectedIndex.value == 0 ||
                          controller.currentSelectedIndex.value == 1) ...{
                        SizedBox(height: 3),
                        Text(
                          'Today, ' + getFormatedDate(),
                          style: TextStyle(
                            fontSize: 12.h,
                            color: Colors.grey,
                          ),
                        ),
                      },
                    ],
                  ),
                  SizedBox(width: 70.w)
                ],
              ),
              leading: controller.currentSelectedIndex == 0
                  ? IconWidget(
                      icon: Icons.arrow_back_ios,
                      colors: Colors.black,
                      size: CommonUtil().isTablet ? 35.0 : 24.0,
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
                          child: CommonUtil().isTablet
                              ? AssetImageWidget(
                                  icon: icon_qurhome,
                                  height: 45.h,
                                  width: 45.h,
                                )
                              : CommonUtil().qurHomeMainIcon())),
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
              // actions: [
              //   InkWell(
              //     onTap: () {
              //       controller.checkForConnectedDevices();
              //     },
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 8),
              //       child: AssetImageWidget(
              //         icon: icon_vitals_qurhome,
              //         height: 22.h,
              //         width: 22.h,
              //       ),
              //     ),
              //   )
              // ],
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
                    // left: getBorder(),
                    top: getBorder(),
                    // right: getBorder(),
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
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.w500,
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
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.w500,
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

  String getFormatedDate() {
    DateTime now = DateTime.now();
    return DateFormat('dd MMM yyyy').format(now);
  }
}

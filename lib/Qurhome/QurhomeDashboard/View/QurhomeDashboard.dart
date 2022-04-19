import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:get/get.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/router_variable.dart';
import '../../../src/ui/bot/view/sheela_arguments.dart';
import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/variable_constant.dart';
import '../Controller/QurhomeDashboardController.dart';
import 'QurHomeRegimen.dart';

class QurhomeDashboard extends GetView<QurhomeDashboardController> {
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
              Get.back();
              PreferenceUtil.saveIfQurhomeisAcive(
                qurhomeStatus: false,
              );
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
              onPressed: () {
                String sheela_lang = PreferenceUtil.getStringValue(SHEELA_LANG);
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SizedBox(
          height: 40,
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
                Flexible(
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
        body: QurHomeRegimenScreen(),
      ),
      onWillPop: () async {
        Get.back();
        PreferenceUtil.saveIfQurhomeisAcive(
          qurhomeStatus: false,
        );
        return true;
      },
    );
  }
}

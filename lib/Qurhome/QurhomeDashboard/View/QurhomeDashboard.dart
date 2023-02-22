import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurHomeSymptoms/view/SymptomListScreen.dart';
import 'package:myfhb/Qurhome/QurHomeVitals/view/VitalsList.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:myfhb/chat_socket/view/ChatUserList.dart';
import 'package:myfhb/chat_socket/viewModel/chat_socket_view_model.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/landing/view/widgets/qurhome_nav_drawer.dart';
import 'package:myfhb/landing/view_model/landing_view_model.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'package:provider/provider.dart';

import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/router_variable.dart';
import '../../../constants/variable_constant.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../Controller/QurhomeDashboardController.dart';
import 'QurHomeRegimen.dart';
import 'package:myfhb/main.dart';

class QurhomeDashboard extends StatefulWidget {
  @override
  _QurhomeDashboardState createState() => _QurhomeDashboardState();
}

class _QurhomeDashboardState extends State<QurhomeDashboard> with RouteAware {
  final controller = Get.put(QurhomeDashboardController());
  final qurHomeRegimenController = CommonUtil().onInitQurhomeRegimenController();
  double buttonSize = 70;
  double textFontSize = 16;
  int index = 0;

  final sheelBadgeController = Get.put(SheelaAIController());

  //LandingViewModel landingViewModel;

  double selOption = 30.0.sp;
  double unSelOption = 28.0.sp;

  MyProfileModel myProfile;

  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    try {
      super.initState();
      onInit();
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyFHB.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  onInit() async {
    try {
      if (CommonUtil.isUSRegion()) {
        Provider.of<ChatSocketViewModel>(Get.context)?.initSocket();
        CommonUtil().initSocket();

        Provider.of<LandingViewModel>(context, listen: false)
            .getQurPlanDashBoard(needNotify: true);
        await CommonUtil().getUserProfileData();
      }
      if (CommonUtil.REGION_CODE == "IN") {
        CommonUtil().requestQurhomeDialog();
      }
      getProfileApi();

      if (CommonUtil().isTablet) {
        CommonUtil().initQurHomePortraitLandScapeMode();
        buttonSize = 100;
        textFontSize = 26;
      }

      controller.updateTabIndex(0);
      controller.setActiveQurhomeTo(
        status: true,
      );

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        sheelBadgeController.getSheelaBadgeCount(isNeedSheelaDialog: true);
        //landingViewModel = Provider.of<LandingViewModel>(Get.context);
      });
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  BorderSide getBorder() {
    return BorderSide(
      color: Color(CommonUtil().getQurhomeGredientColor()),
      width: 1.0,
    );
  }

  @override
  dispose() {
    try {
      if(!CommonUtil.isUSRegion()){
        controller.setActiveQurhomeTo(
          status: false,
        );
      }
      CommonUtil().initPortraitMode();
      MyFHB.routeObserver.unsubscribe(this);
      super.dispose();
    } catch (e) {
      print(e);
    }
  }

  @override
  void didPopNext() {
    controller.updateBLETimer(Enable: false);
    if (controller.currentSelectedIndex.value == 0) {
      controller.updateBLETimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: CommonUtil().isTablet ? 110.00 : null,
              elevation: 0,
              centerTitle: true,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: (CommonUtil.isUSRegion())
                    ? controller.currentSelectedIndex == 0
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center
                    : MainAxisAlignment.center,
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
                                        height: 24.h,
                                        width: 24.h,
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
                                            height: 24.h,
                                            width: 24.h,
                                          )
                                        : AssetImageWidget(
                                            icon: icon_symptom_qurhome,
                                            height: 22.h,
                                            width: 22.h,
                                          )
                                    : SizedBox.shrink(),
                          ))
                      : SizedBox.shrink(),
                  if (CommonUtil.isUSRegion()) SizedBox(width: 22.w),
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
                          'Today, ' + qurHomeRegimenController.dateHeader.value,
                          style: TextStyle(
                            fontSize: 12.h,
                            color: Colors.grey,
                          ),
                        ),
                      },
                    ],
                  ),
                  if (CommonUtil.isUSRegion() &&
                      controller.currentSelectedIndex == 0)
                    Container(
                      child: Row(
                        children: [
                          SizedBox(width: 24.w),
                          getChatSocketIcon(),
                          SizedBox(width: 20.w),
                          CommonUtil().getNotificationIcon(context,
                              color:
                                  Color(CommonUtil().getQurhomePrimaryColor()),
                              isFromQurday: true),
                        ],
                      ),
                    ),
                  getSizedBoxIndReg(),
                ],
              ),
              leading: controller.currentSelectedIndex == 0
                  ? (CommonUtil.isUSRegion())
                      ? Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(
                              Icons.menu_rounded,
                            ),
                            color: Color(CommonUtil().getQurhomePrimaryColor()),
                            iconSize: CommonUtil().isTablet ? 34.0.sp : 24.0.sp,
                            onPressed: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                          ),
                        )
                      : IconWidget(
                          icon: Icons.arrow_back_ios,
                          colors: Colors.black,
                          size: CommonUtil().isTablet ? 38.0 : 24.0,
                          onTap: () {
                            Get.back();
                          },
                        )
                  : Container(
                      margin: EdgeInsets.only(
                        left: 8.h,
                      ),
                      child: InkWell(
                          onTap: () {
                            bottomTapped(0);
                            sheelBadgeController.getSheelaBadgeCount(
                                isNeedSheelaDialog: true);
                          },
                          child: CommonUtil.isUSRegion()
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.h,
                                    vertical: 4.h,
                                  ),
                                  child: Icon(
                                    Icons.home,
                                    size: 32.sp,
                                    color: Color(
                                        CommonUtil().getQurhomePrimaryColor()),
                                  ),
                                )
                              : CommonUtil().isTablet
                                  ? AssetImageWidget(
                                      icon: icon_qurhome,
                                      height: 48.h,
                                      width: 48.h,
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
                    if (sheelBadgeController?.sheelaIconBadgeCount?.value > 0) {
                      Get.toNamed(
                        rt_Sheela,
                        arguments: SheelaArgument(
                          rawMessage: sheelaQueueShowRemind,
                        ),
                      ).then((value) {
                        sheelBadgeController.getSheelaBadgeCount(
                            isNeedSheelaDialog: true);
                      });
                    } else {
                      String sheela_lang =
                          PreferenceUtil.getStringValue(SHEELA_LANG);
                      Get.toNamed(
                        rt_Sheela,
                        arguments: SheelaArgument(
                          isSheelaAskForLang: !((sheela_lang ?? '').isNotEmpty),
                          langCode: (sheela_lang ?? ''),
                        ),
                      ).then((value) {
                        sheelBadgeController.getSheelaBadgeCount(
                            isNeedSheelaDialog: true);
                      });
                    }
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
                    child: getSheelaIcon(),
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
            drawer: QurHomeNavigationDrawer(
              myProfile: myProfile,
              moveToLoginPage: moveToLoginPage,
              userChangedbool: false,
              refresh: (userChanged) => refresh(
                userChanged: userChanged,
              ),
            ),
          ),
          onWillPop: () async {
            Get.back();
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

  Widget getSheelaIcon() {
    return BadgeIcon(
      icon: Image.asset(
        icon_mayaMain,
        height: buttonSize,
        width: buttonSize,
      ),
      size: 18.h,
      fontSize: 14.sp,
      badgeColor: ColorUtils.countColor,
      badgeCount: sheelBadgeController?.sheelaIconBadgeCount?.value ?? 0,
      isForSheelaQueue: true,
    );
  }

  Widget getChatSocketIcon() {
    return BadgeIcon(
      icon: GestureDetector(
        onTap: () {
          Get.to(ChatUserList(careGiversList: [], isFromQurDay: true));
        },
        child: ImageIcon(AssetImage(icon_chat),
            size: CommonUtil().isTablet ? 33.0.sp : unSelOption,
            color: Color(CommonUtil().getQurhomePrimaryColor())),
      ),
      badgeColor: ColorUtils.countColor,
      badgeCount: Provider.of<ChatSocketViewModel>(Get.context)?.chatTotalCount,
    );
  }

  getProfileApi() async {
    final userId = await PreferenceUtil.getStringValue(KEY_USERID);
    MyProfileModel value =
        await addFamilyUserInfoRepository.getMyProfileInfoNew(userId);
    myProfile = value;
  }

  void moveToLoginPage() {
    PreferenceUtil.clearAllData().then(
      (value) {
        Navigator.pushAndRemoveUntil(
          Get.context,
          MaterialPageRoute(
            builder: (context) => PatientSignInScreen(),
          ),
          (route) => false,
        );
      },
    );
  }

  void refresh({
    bool userChanged = false,
  }) {
    try {
      if (userChanged) {
        //profileData = getMyProfile();
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Widget getSizedBoxIndReg() {
    if (CommonUtil.isUSRegion()) {
      if (controller.currentSelectedIndex == 0) {
        return SizedBox.shrink();
      } else {
        return SizedBox(width: 70.w);
      }
    } else {
      return SizedBox(width: 70.w);
    }
  }
}

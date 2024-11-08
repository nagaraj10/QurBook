import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurHomeSymptoms/view/SymptomListScreen.dart';
import 'package:myfhb/Qurhome/QurHomeVitals/view/VitalsList.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomePatientAlert.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomePatientRegimenList.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/CareGiverPatientList.dart';
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
import 'package:myfhb/src/ui/SheelaAI/Widgets/BLEBlinkingIcon.dart';
import 'package:myfhb/src/ui/SheelaAI/Widgets/common_bluetooth_widget.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'package:provider/provider.dart';

import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/router_variable.dart';
import '../../../constants/variable_constant.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../Controller/QurhomeDashboardController.dart';
import 'QurHomeRegimen.dart';
import 'package:myfhb/main.dart';

class QurhomeDashboard extends StatefulWidget {
  bool forPatientList;
  CareGiverPatientListResult? careGiverPatientListResult;

  QurhomeDashboard(
      {this.forPatientList = false, this.careGiverPatientListResult = null});

  @override
  _QurhomeDashboardState createState() => _QurhomeDashboardState();
}

class _QurhomeDashboardState extends State<QurhomeDashboard> with RouteAware {
  final controller = Get.put(QurhomeDashboardController());
  final qurHomeRegimenController =
      CommonUtil().onInitQurhomeRegimenController();
  /**
       * Declared the below size to maintain UI font size similar in 
       * Qurhome tablet ans mobile
       */
  double buttonSize =
      (CommonUtil().isTablet ?? false) ? imageTabMaya : imageMobileMaya;
  double textFontSize =
      (CommonUtil().isTablet ?? false) ? tabHeader1 : mobileHeader1;
  int index = 0;
  double badgeSize = (CommonUtil().isTablet ?? false) ? 40 : 30;
  final sheelBadgeController = Get.put(SheelaAIController());

  //LandingViewModel landingViewModel;

  double selOption = 30.0.sp;
  double unSelOption = 28.0.sp;

  MyProfileModel? myProfile;

  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final hubListViewController = CommonUtil().onInitHubListViewController();

  @override
  void initState() {
    try {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        controller.forPatientList.value = false;
        sheelBadgeController.isQueueDialogShowing.value = false;
        controller.isRegimenScreen.value=true;
        // Check if the language preference is not set or empty
        if (PreferenceUtil.getStringValue(SHEELA_LANG) == null ||
            PreferenceUtil.getStringValue(SHEELA_LANG) == '') {
          // If language preference is not set or empty, set it to the default language
          PreferenceUtil.saveString(SHEELA_LANG, strDefaultLanguage);
        }
        onInit();
      });
      super.initState();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyFHB.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  onInit() async {
    try {
      if (CommonUtil.isUSRegion()) {
        try {
          // Retrieve the ChatSocketViewModel instance using Provider
          Provider.of<ChatSocketViewModel>(context, listen: false).initSocket();
          CommonUtil().initSocket();
          CommonUtil().versionCheck(context);
          Provider.of<LandingViewModel>(context, listen: false)
              .getQurPlanDashBoard(needNotify: true);
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
        moveToPateintAlert();

        controller..enableModuleAccess()
        ..getModuleAccess();
        qurHomeRegimenController.getSOSButtonStatus();

        await CommonUtil().getUserProfileData();
        await CommonUtil().getMyRoute();
      }
      if (CommonUtil.REGION_CODE == "IN") {
        CommonUtil().requestQurhomeDialog();
      }
      getProfileApi();
      //Api call for get the dynamic content for
      //Qur home ideal for more than 5 minutes
      await controller.getDynamicContent();
      if (CommonUtil().isTablet!) {
        CommonUtil().initQurHomePortraitLandScapeMode();
        buttonSize = buttonSize.h;
        badgeSize = badgeSize.h;
        textFontSize = 26;
      }
      //Method To show remainder in qurbook tablet
      // await SheelaRemainderPopup.checkConditionToShowPopUp();

      controller..updateTabIndex(0)
      ..setActiveQurhomeTo(
        status: true,
      )

      ..setActiveQurhomeDashboardToChat(
        status: true,
      );

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        getSheelaBadgeCount();
        //landingViewModel = Provider.of<LandingViewModel>(Get.context);
        //Initilaize the screen idle timer
        if (sheelBadgeController.sheelaIconBadgeCount.value == 0) {
          controller.resetScreenIdleTimer();
        }
      });

      if (Platform.isAndroid) {
        CommonUtil().askPermssionLocationBleScan();
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  BorderSide getBorder() {
    return BorderSide(
      color: mAppThemeProvider.qurhomeGradientColor,
      width: 1.0,
    );
  }

  @override
  dispose() {
    try {
      if (!CommonUtil.isUSRegion()) {
        controller.setActiveQurhomeTo(
          status: false,
        );
      }
      controller.setActiveQurhomeDashboardToChat(
        status: false,
      );
      CommonUtil().initPortraitMode();
      controller.updateBLETimer(Enable: false);
      MyFHB.routeObserver.unsubscribe(this);
      controller.clear();
      controller.isRegimenScreen.value = false;
      super.dispose();

    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      print(e);
    }
  }

  @override
  void didPopNext() {
    controller.updateBLETimer(Enable: false);
    //Set value as true while Coming back from any other screen
    controller.isRegimenScreen.value = true;
    if (controller.currentSelectedIndex.value == 0) {
      controller.updateBLETimer();
    }
    controller.setActiveQurhomeDashboardToChat(
      status: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Coming back from any other screen check the count and
      // Initilaize the screen idle timer
      getSheelaBadgeCount();
      if (sheelBadgeController.sheelaIconBadgeCount.value == 0) {
        controller.resetScreenIdleTimer();
      }
    });
  }

  Widget badge(int count) => Positioned(
        right: 0,
        top: 0,
        child: Container(
          decoration: BoxDecoration(
            color: ColorUtils.countColor,
            borderRadius: BorderRadius.circular(
              badgeSize / 2,
            ),
          ),
          height: badgeSize,
          width: badgeSize,
          child: SizedBox(
            child: Center(
              child: Text(
                count > 9 ? '9+' : count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
      );

  double getLeadingWidth() {
    double width = controller.currentSelectedIndex == 0
        ? (CommonUtil.isUSRegion())
            ? (CommonUtil().isTablet ?? false)
                ? 129
                : 83
            : 58.0
        : 58.0;
    return width;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.isTrue
        ? Center(
            child: CircularProgressIndicator(),
          )
        : WillPopScope(
            child: Scaffold(
              drawerEnableOpenDragGesture: false,
              key: _scaffoldKey,
              onDrawerChanged: (isOpen){
                //check drawer is open or close
                // if closed and regimen is active restart the timer for ideal
                if(!isOpen && CommonUtil.isUSRegion() &&
                    controller.currentSelectedIndex == 0&&  controller.isRegimenScreen.value){
                  getSheelaBadgeCount();
                  //Initilaize the screen idle timer
                  if(sheelBadgeController.sheelaIconBadgeCount.value == 0 ){
                    controller.resetScreenIdleTimer();
                  }
                }
              },
              appBar: AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: CommonUtil().isTablet! ? 110.00 : null,
                elevation: 0,
                centerTitle: true,
                leadingWidth: getLeadingWidth(),
                actions: [
                  (!(CommonUtil.isUSRegion()) &&
                          hubListViewController.isUserHasParedDevice.value &&
                          (controller.currentSelectedIndex != 3))
                      ? Padding(
                          padding: const EdgeInsets.only(
                            right: 16,
                            left: 30,
                          ),
                          child: controller.currentSelectedIndex == 2
                              ? CommonBluetoothWidget.getDisabledBluetoothIcon()
                              : MyBlinkingBLEIcon(),
                        )
                      : SizedBox.shrink(),
                  ((CommonUtil.isUSRegion()) &&
                          hubListViewController.isUserHasParedDevice.value &&
                          (controller.currentSelectedIndex == 2))
                      ? Padding(
                          padding: const EdgeInsets.only(
                            right: 16,
                          ),
                          child:
                              CommonBluetoothWidget.getDisabledBluetoothIcon(),
                        )
                      : SizedBox.shrink(),
                ],
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
                              left: CommonUtil().isTablet! ? 8.h : 2.h,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: CommonUtil().isTablet! ? 30 : 4.h,
                                  top: 4.h,
                                  bottom: 4.h),
                              child: controller.currentSelectedIndex == 2
                                  ? CommonUtil().isTablet!
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
                                      ? CommonUtil().isTablet!
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
                    if (CommonUtil.isUSRegion())
                      SizedBox(width: CommonUtil().isTablet! ? 22.w : 10.w),
                    Expanded(
                      child: Center(
                        child: (controller.forPatientList.value ?? false)
                            ? RichText(
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                text: TextSpan(
                                    // Note: Styles for TextSpans must be explicitly defined.
                                    // Child text spans will inherit styles from parent
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: patient,
                                          style: TextStyle(
                                              fontSize: textFontSize,
                                              color: mAppThemeProvider.qurHomePrimaryColor)),
                                      TextSpan(
                                          text: controller
                                              .careGiverPatientListResult
                                              ?.firstName,
                                          style: TextStyle(
                                              fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: mAppThemeProvider.qurHomePrimaryColor)),
                                      TextSpan(text: " "),
                                      TextSpan(
                                        text: controller
                                            .careGiverPatientListResult
                                            ?.lastName,
                                        style: TextStyle(
                                            fontSize: textFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: mAppThemeProvider.qurHomePrimaryColor),
                                      ),
                                    ]))
                            : Column(
                                children: [
                                  RichText(
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    text: TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        if (controller.currentSelectedIndex
                                                    .value ==
                                                0 ||
                                            controller.currentSelectedIndex
                                                    .value ==
                                                1) ...{
                                          TextSpan(text: 'Hello '),
                                        },
                                        TextSpan(
                                          text: CommonUtil.getTitleName(
                                              controller.appBarTitle.value),
                                          style: (controller
                                                      .forPatientList.value ??
                                                  false)
                                              ? TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: mAppThemeProvider.qurHomePrimaryColor)
                                              : TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (controller.currentSelectedIndex.value ==
                                          0 ||
                                      controller.currentSelectedIndex.value ==
                                          1) ...{
                                    SizedBox(height: 3),
                                    (controller.forPatientList.value ?? false)
                                        ? Text("")
                                        : Text(
                                            qurHomeRegimenController
                                                .dateHeader.value,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11.h,
                                              color: Colors.black,
                                            ),
                                          ),
                                  },
                                ],
                              ),
                      ),
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
                                color: mAppThemeProvider.qurHomePrimaryColor,
                                isFromQurday: true),
                          ],
                        ),
                      ),
                    getSizedBoxIndReg(),
                  ],
                ),
                leading: controller.currentSelectedIndex == 0
                    ? (CommonUtil.isUSRegion())
                        ? Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.menu_rounded,
                                  ),
                                  color: mAppThemeProvider.qurHomePrimaryColor,
                                  iconSize: CommonUtil().isTablet!
                                      ? 34.0.sp
                                      : 24.0.sp,
                                  onPressed: () {
                                    //remove the ideal timer when drawer is open
                                     controller.isScreenNotIdle.value=true;
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                ),
                              ),
                              if (hubListViewController
                                  .isUserHasParedDevice.value) ...{
                                SizedBox(width: 2.w),
                                Expanded(
                                    child: CommonUtil().isTablet!
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: MyBlinkingBLEIcon(),
                                          )
                                        : MyBlinkingBLEIcon())
                              }
                            ],
                          )
                        : IconWidget(
                            icon: Icons.arrow_back_ios,
                            colors: Colors.black,
                            size: CommonUtil().isTablet! ? 38.0 : 24.0,
                            onTap: () {
                              controller.isScreenNotIdle.value=true;
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
                              getSheelaBadgeCount();
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
                                      color: mAppThemeProvider.qurHomePrimaryColor,
                                    ),
                                  )
                                : CommonUtil().qurHomeMainIcon())),
                bottom: PreferredSize(
                  child: Container(
                    color: mAppThemeProvider.qurhomeGradientColor,
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
              body: controller.forPatientList.value
                  ? getPatientDashboardCurrentTab()
                  : getCurrentTab(),
              floatingActionButton: controller.forPatientList.value
                  ? SizedBox()
                  : Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: CommonUtil().isTablet! ? 20.h : 20,
                          ),
                          child: SizedBox(
                            height: buttonSize,
                            width: buttonSize,
                            child: FloatingActionButton(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              onPressed: () {
                                controller.isScreenNotIdle.value=true;
                                if (sheelBadgeController
                                        .sheelaIconBadgeCount.value >
                                    0) {
                                  Get.toNamed(
                                    rt_Sheela,
                                    arguments: SheelaArgument(
                                      rawMessage: sheelaQueueShowRemind,
                                    ),
                                  )?.then((value) {
                                    if(sheelBadgeController.sheelaIconBadgeCount.value == 0 &&
                                     controller.isRegimenScreen.value){
                                      controller.resetScreenIdleTimer();
                                    }else{
                                      getSheelaBadgeCount();
                                    }
                                  });
                                } else {
                                  String sheela_lang =
                                      PreferenceUtil.getStringValue(
                                          SHEELA_LANG)!;
                                  Get.toNamed(
                                    rt_Sheela,
                                    arguments: SheelaArgument(
                                      isSheelaAskForLang:
                                          !((sheela_lang).isNotEmpty),
                                      langCode: (sheela_lang),
                                    ),
                                  )?.then((value) {
                                    if(sheelBadgeController.sheelaIconBadgeCount.value == 0 &&
                                        controller.isRegimenScreen.value){
                                      controller.resetScreenIdleTimer();
                                    }else{
                                      getSheelaBadgeCount();
                                    }
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
                                    color:mAppThemeProvider.qurhomeGradientColor,
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
                        if ((sheelBadgeController.sheelaIconBadgeCount.value) >
                            0)
                          badge(
                            sheelBadgeController.sheelaIconBadgeCount.value,
                          ),
                      ],
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              // SafeArea widget ensures that its child's content is visible and not obscured by system UI elements
              bottomNavigationBar: SafeArea(
                top: false,
                right: false,
                left: false,
                child: controller.forPatientList.value
                  ? SizedBox(
                      height: 45.h,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: getBorder(),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  controller.patientDashboardCurSelectedIndex
                                      .value = 0;
                                },
                                child: Container(
                                  color: controller
                                      .patientDashboardCurSelectedIndex ==
                                      0
                                      ? mAppThemeProvider.qurhomeGradientColor
                                      : Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Spacer(
                                            flex: 1,
                                          ),
                                          Text(
                                            strAlerts,
                                            style: TextStyle(
                                              color: controller
                                                          .patientDashboardCurSelectedIndex ==
                                                      0
                                                  ? Colors.white
                                                  : mAppThemeProvider.qurhomeGradientColor,
                                              fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,
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
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  controller.patientDashboardCurSelectedIndex
                                      .value = 1;
                                },
                                child: Container(
                                  color: controller
                                                .patientDashboardCurSelectedIndex ==
                                            1
                                        ? mAppThemeProvider.qurhomeGradientColor
                                        : Colors.white,
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Spacer(
                                            flex: 1,
                                          ),
                                          Text(
                                            strRegimen,
                                            style: TextStyle(
                                              color: controller
                                                          .patientDashboardCurSelectedIndex ==
                                                      1
                                                  ? Colors.white
                                                  : mAppThemeProvider.qurhomeGradientColor,
                                              fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,
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
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  controller.patientDashboardCurSelectedIndex
                                      .value = 2;
                                },
                                child: Container(
                                  color: controller
                                                .patientDashboardCurSelectedIndex ==
                                            2
                                        ? mAppThemeProvider.qurhomeGradientColor
                                        : Colors.white,
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Spacer(
                                            flex: 1,
                                          ),
                                          Text(
                                            strVitals,
                                            style: TextStyle(
                                              color: controller
                                                          .patientDashboardCurSelectedIndex ==
                                                      2
                                                  ? Colors.white
                                                  : mAppThemeProvider.qurhomeGradientColor,
                                              fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,
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
                    )
                  : SizedBox(
                      height: 45.h,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: getBorder(),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  controller.isScreenNotIdle.value=true;
                                  if (CommonUtil.isUSRegion() &&
                                      controller.isVitalModuleDisable.value) {
                                    FlutterToast().getToast(
                                        strFeatureNotEnable, Colors.black);
                                  } else {
                                    bottomTapped(2);
                                  }
                                },
                                child: Container(
                                  color: controller.currentSelectedIndex == 2
                                      ? mAppThemeProvider.qurhomeGradientColor
                                      : Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Spacer(
                                            flex: 1,
                                          ),
                                          Text(
                                            strVitals,
                                            style: TextStyle(
                                              color: (CommonUtil.isUSRegion() &&
                                                      controller
                                                          .isVitalModuleDisable
                                                          .value)
                                                  ? Colors.grey
                                                  : controller.currentSelectedIndex ==
                                                          2
                                                      ? Colors.white
                                                      : mAppThemeProvider.qurhomeGradientColor,
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
                                  controller.isScreenNotIdle.value=true;
                                  if (CommonUtil.isUSRegion() &&
                                      controller.isSymptomModuleDisable.value) {
                                    FlutterToast().getToast(
                                        strFeatureNotEnable, Colors.black);
                                  } else {
                                    bottomTapped(3);
                                  }
                                },
                                child: Container(
                                  color: controller.currentSelectedIndex == 3
                                      ? mAppThemeProvider.qurhomeGradientColor
                                      : Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              color: (CommonUtil.isUSRegion() &&
                                                      controller
                                                          .isSymptomModuleDisable
                                                          .value)
                                                  ? Colors.grey
                                                  : controller.currentSelectedIndex ==
                                                          3
                                                      ? Colors.white
                                                      : mAppThemeProvider.qurhomeGradientColor,
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
              drawer: QurHomeNavigationDrawer(
                myProfile: myProfile,
                controller: controller,
                moveToLoginPage: moveToLoginPage,
                userChangedbool: false,
                refresh: ((userChanged) {
                  controller.patientDashboardCurSelectedIndex.value = 0;
                  controller.forPatientList.value = false;
                  controller.isPatientClicked.value = false;
                  controller.careGiverPatientListResult = null;
                  refresh(
                    userChanged: userChanged,
                  );
                }),
                showPatientList: () {
                  CommonUtil().showPatientListOfCaregiver(context,
                      (user, result) {
                    if (user == "You") {
                      refresh(
                        userChanged: true,
                      );
                      Navigator.pop(context);
                      controller.patientDashboardCurSelectedIndex.value = 0;
                      controller.forPatientList.value = false;
                      sheelBadgeController.isSwitchedToOtherUsers.value=false; //set the bool false when no patient list is selected
                      controller.isPatientClicked.value = false;
                      controller.careGiverPatientListResult = null;
                      PreferenceUtil.saveString(
                          strKeyFamilyAlert, strNoValue);
                      PreferenceUtil.saveString(strKeyAlertChildID, '');
                      PreferenceUtil.saveCareGiver(strKeyCareGiver, null);
                    } else {
                      if (controller.careGiverPatientListResult?.childId !=
                          result?.childId) {
                        controller.forPatientList.value = true;
                        sheelBadgeController.isSwitchedToOtherUsers.value=true;//set the bool true when  patient list is selected
                        controller.careGiverPatientListResult = null;
                        controller.careGiverPatientListResult = result;
                        controller.patientDashboardCurSelectedIndex.value = 0;
                        controller.isPatientClicked.value = true;
                        controller.getPatientAlertList();
                        PreferenceUtil.saveString(
                            strKeyFamilyAlert, strYesValue);
                        PreferenceUtil.saveString(
                            strKeyAlertChildID, result?.childId ?? '');
                        PreferenceUtil.saveCareGiver(strKeyCareGiver,
                            controller.careGiverPatientListResult);
                      }

                      Navigator.pop(context);

                      setState(() {});
                    }
                  });
                },
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

  Widget getChatSocketIcon() {
    return BadgeIcon(
      icon: GestureDetector(
        onTap: () {
          if (Get.isRegistered<QurhomeDashboardController>()) {
            Get.find<QurhomeDashboardController>()
                .updateBLETimer(Enable: false);
          }

          Get.to(ChatUserList(careGiversList: [], isFromQurDay: true));
        },
        child: ImageIcon(AssetImage(icon_chat),
            size: CommonUtil().isTablet! ? 33.0.sp : unSelOption,
            color: mAppThemeProvider.qurHomePrimaryColor),
      ),
      badgeColor: ColorUtils.countColor,
      badgeCount: Provider.of<ChatSocketViewModel>(Get.context!).chatTotalCount,
    );
  }

  getProfileApi() async {
    final userId = await PreferenceUtil.getStringValue(KEY_USERID);
    MyProfileModel value =
        await addFamilyUserInfoRepository.getMyProfileInfoNew(userId!);
    myProfile = value;
  }

  void moveToLoginPage() {
    PreferenceUtil.clearAllData().then(
      (value) {
        Navigator.pushAndRemoveUntil(
          Get.context!,
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
        controller.getModuleAccess();
        qurHomeRegimenController.getSOSButtonStatus();
      }
      //setState(() {});
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

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

  getSheelaBadgeCount() {
    try {
      sheelBadgeController.getSheelaBadgeCount(
          isFromQurHomeRegimen: true,
          isNeedSheelaDialog:
              controller.estart.value.trim().isEmpty ? true : false);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        print(e);
      }
    }
  }

  void moveToPateintAlert() async {
    controller.isLoading.value = true;
    if (CommonUtil.isUSRegion()) {
      String? permissionValue =
          await PreferenceUtil.getStringValue(strKeyFamilyAlert);
      String? childId = await PreferenceUtil.getStringValue(strKeyAlertChildID);
      if (permissionValue == strYesValue) {
        if (childId != null && childId != "") {
          controller.forPatientList.value = true;
          sheelBadgeController.isSwitchedToOtherUsers.value=true;//set value to true if the user is switched to patient caregiver list
          CareGiverPatientListResult? response =
              await PreferenceUtil.getCareGiver(strKeyCareGiver);
          if (response != null) {
            controller.careGiverPatientListResult = null;
            controller.careGiverPatientListResult = response;
            controller.patientDashboardCurSelectedIndex.value = 0;

            controller.isPatientClicked.value = true;

            controller.getPatientAlertList();
          }
        }
      }
    }
    controller.isLoading.value = false;
  }

  // Function to get the current tab widget for the patient dashboard
  Widget getPatientDashboardCurrentTab() {
    // Variable to store the selected landing tab widget
    Widget landingTab;

    // Switch statement to determine the landing tab based on the selected index
    switch (controller.patientDashboardCurSelectedIndex.value) {
    // Case 0: Patient Alert tab
      case 0:
        landingTab = QurhomePatientAlert(); // Setting the landing tab to Patient Alert widget
        break;
    // Case 1: Patient Regimen List tab
      case 1:
        landingTab = QurHomePatientRegimenListScreen(
          // Passing necessary parameters to the Patient Regimen List widget
          careGiverPatientListResult: controller.careGiverPatientListResult,
        );
        break;
    // Case 2: Vitals List tab
      case 2:
        landingTab = VitalsList(); // Setting the landing tab to Vitals List widget
        break;
    // Default case: In case of an invalid index, default to Patient Alert tab
      default:
        landingTab = QurhomePatientAlert(); // Setting the landing tab to Patient Alert widget
        break;
    }

    // Returning the determined landing tab widget
    return landingTab;
  }

}

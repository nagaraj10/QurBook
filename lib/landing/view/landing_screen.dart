import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import '../../Qurhome/QurhomeDashboard/Controller/SheelaRemainderPopup.dart';
import '../../Qurhome/QurhomeDashboard/View/QurhomeDashboard.dart';
import '../../add_family_user_info/bloc/add_family_user_info_bloc.dart';
import '../../add_family_user_info/services/add_family_user_info_repository.dart';
import '../../authentication/view/login_screen.dart';
import '../../chat_socket/view/ChatDetail.dart';
import '../../chat_socket/view/ChatUserList.dart';
import '../../chat_socket/viewModel/chat_socket_view_model.dart';
import '../../chat_socket/viewModel/getx_chat_view_model.dart';
import '../../colors/fhb_colors.dart';
import '../../common/CommonConstants.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/SwitchProfile.dart';
import '../../common/common_circular_indicator.dart';
import '../../common/errors_widget.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../common/firestore_services.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as constants;
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_parameters.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../constants/variable_constant.dart';
import '../../src/blocs/Category/CategoryListBlock.dart';
import '../../src/model/GetDeviceSelectionModel.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/model/user/MyProfileResult.dart';
import '../../src/resources/repository/health/HealthReportListForUserRepository.dart';
import '../../src/ui/MyRecord.dart';
import '../../src/ui/MyRecordsArguments.dart';
import '../../src/ui/SheelaAI/Controller/SheelaAIController.dart';
import '../../src/ui/SheelaAI/Views/SuperMaya.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/dynamic_links.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/appointments/view/appointmentsMain.dart';
import '../../telehealth/features/chat/view/BadgeIcon.dart';
import '../../telehealth/features/chat/view/PDFViewerController.dart';
import '../../user_plans/view_model/user_plans_view_model.dart';
import '../service/landing_service.dart';
import '../view_model/landing_view_model.dart';
import 'corp_users_welcome_dialog.dart';
import 'landing_arguments.dart';
import 'widgets/home_widget.dart';
import 'widgets/navigation_drawer.dart' as NavigationDrawer;

class LandingScreen extends StatefulWidget {
  static _LandingScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<State<LandingScreen>>()
          as _LandingScreenState?;

  const LandingScreen({
    this.landingArguments,
  });

  final LandingArguments? landingArguments;

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  MyProfileModel? myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();
  final GlobalKey<State> _key = GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future? profileData;
  File? imageURIProfile;
  LandingViewModel? landingViewModel;
  CommonUtil commonUtil = CommonUtil();
  bool isUserMainId = true;
  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel? selectionResult;

  bool? bpMonitor = true;
  bool? glucoMeter = true;
  bool? pulseOximeter = true;
  bool? thermoMeter = true;
  bool? weighScale = true;
  var userId;

  final controller = Get.put(ChatUserListController());
  final qurhomeDashboardController = Get.put(QurhomeDashboardController());
  final controllerQurhomeRegimen =
      CommonUtil().onInitQurhomeRegimenController();

  SheelaAIController? sheelBadgeController =
      CommonUtil().onInitSheelaAIController();

  double selOption = 30.0.sp;
  double unSelOption = 28.0.sp;

  double selSheelaOption = 36.0;

  var landingScreenController = CommonUtil().onInitLandingScreenController();

  @override
  void initState() {
    try {
      super.initState();
      FABService.trackCurrentScreen(FBALandingScreen);
      Future.delayed(Duration.zero, () async {
        onInit();
      });
      SystemChannels.lifecycle.setMessageHandler((msg) async {
        if (msg != null) {
          if (msg == AppLifecycleState.resumed.toString()) {
            imageCache!.clear();
            imageCache!.clearLiveImages();
            profileData = getMyProfile();
          }
        }
        return null; // Since the handler expects a Future<String?>, you can return null here
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  onInit() async {
    try {
      controller.updateNewChatFloatShown(false);
      userId = PreferenceUtil.getStringValue(KEY_USERID);

      // Retrieve the ChatSocketViewModel instance using Provider
      Provider.of<ChatSocketViewModel>(Get.context!, listen: false).initSocket();

      await callImportantsMethod();
      moveToQurhome();
      callGetFamiltMappingCaregiver();
      var profilebanner =
          PreferenceUtil.getStringValue(constants.KEY_DASHBOARD_BANNER);
      if (profilebanner != null) {
        imageURIProfile = File(profilebanner);
      }
      checkIfUserIdSame();
      if (widget.landingArguments?.needFreshLoad ?? true) {
        profileData = getMyProfile();
        Provider.of<LandingViewModel>(context, listen: false)
            .getQurPlanDashBoard(needNotify: true);
      } else {
        Provider.of<LandingViewModel>(context, listen: false)
            .getQurPlanDashBoard();
      }
      Provider.of<LandingViewModel>(context, listen: false).checkIfUserIdSame();

      CommonUtil().initSocket();

      //Initialize a timer which will show remainder very 30 mins
      if (CommonUtil().isTablet == true) {
        SheelaRemainderPopup.checkConditionToShowPopUp();
      } else {
        sheelBadgeController?.getSheelaBadgeCount(
          makeApiRequest: true,
        );
      }
      sheelBadgeController?.isAllowSheelaLiveReminders = true;
      await CommonUtil().getMyRoute();
    } catch (e, stackTrace) {
      await CommonUtil().getMyRoute();
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  changeTabToAppointments() async {
    try {
      var notificationData = await PreferenceUtil.getNotifiationData();
      await PreferenceUtil.removeNotificationData();

      if (notificationData.redirect == 'appointmentList') {
        landingScreenController.updateTabIndex(3);
      } else if (notificationData.redirect == chat) {
        if ((notificationData.doctorId ?? '').isNotEmpty &&
            (notificationData.doctorName ?? '').isNotEmpty &&
            (notificationData.doctorPicture ?? '').isNotEmpty) {
          Get.to(
            () => ChatDetail(
              peerId: notificationData.doctorId,
              peerName: notificationData.doctorName,
              peerAvatar: notificationData.doctorPicture,
              patientId: "",
              patientName: "",
              patientPicture: "",
              isFromVideoCall: false,
              isCareGiver: false,
              isForGetUserId: true,
            ),
          );
        } else {
          Get.to(() => ChatUserList());
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      //print(e.toString());
      await PreferenceUtil.removeNotificationData();
    }
  }

  Future<MyProfileResult?> getIsCpUser() async {
    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE)!;
    return myProfile.result;
  }

  checkCpUser() async {
    var value = await LandingService.getMemberShipDetails();
    PreferenceUtil.saveActiveMembershipStatus(
        value.isSuccess! ? (value.result ?? []).length > 0 : false);
    if (value.isSuccess!) {
      bool isShown =
          await (PreferenceUtil.getIsCorpUserWelcomeMessageDialogShown()
              as FutureOr<bool>);

      if (!isShown) {
        MyProfileResult? cpUser = await getIsCpUser();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CorpUsersWelcomeDialog(cpUser, value.result![0]);
            });
      }
    }
  }

  Future<bool> _onBackPressed() {
    if (landingScreenController!.currentTabIndex.value != 0) {
      landingScreenController!.updateTabIndex(0);
      return Future.value(false);
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Do you want to exit for now?'),
            actions: <Widget>[
              FlatButtonWidget(
                bgColor: Colors.transparent,
                isSelected: true,
                title: 'CANCEL',
                onPress: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButtonWidget(
                bgColor: Colors.transparent,
                isSelected: true,
                title: 'OK',
                onPress: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        },
      ).then((value) => value as bool);
    }
  }

  @override
  Widget build(BuildContext context) {
    landingViewModel = Provider.of<LandingViewModel>(context);

    if (landingViewModel!.isURLCome) {
      landingViewModel!.isURLCome = false;
      Future.delayed(Duration(seconds: 2), () {
        if (widget.landingArguments?.url != null &&
            widget.landingArguments!.url!.isNotEmpty) {
          CommonUtil().launchURL(widget.landingArguments!.url!);
        }
      });
    }
    return FutureBuilder<MyProfileModel?>(
      future: profileData?.then((value) => value as MyProfileModel?),
      builder: (context, snapshot) {
        return Obx(() => Scaffold(
              key: _scaffoldKey,
              backgroundColor: const Color(bgColorContainer),
              body: WillPopScope(
                onWillPop: _onBackPressed,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        Visibility(
                          visible:
                              !landingScreenController!.isSearchVisible.value,
                          child: Container(
                            //height: CommonUtil().isTablet ? 90.00 : null,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: <Color>[
                                  Color(CommonUtil().getMyPrimaryColor()),
                                  Color(CommonUtil().getMyGredientColor()),
                                ],
                                stops: [0.3, 1.0],
                              ),
                              // color: Colors.white,
                            ),
                            child: SafeArea(
                              child: Row(
                                children: <Widget>[
                                  Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.menu_rounded,
                                      ),
                                      color: Colors.white,
                                      iconSize: CommonUtil().isTablet!
                                          ? 34.0.sp
                                          : 24.0.sp,
                                      onPressed: () {
                                        _scaffoldKey.currentState!.openDrawer();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: getAppBarTitle(),
                                  ),
                                  //TODO: Delete this - Added for Test
                                  // if (kDebugMode)
                                  //   IconButton(
                                  //     icon: Icon(Icons.cloud_upload),
                                  //     onPressed: () {
                                  //       CommonUtil.sendLogToServer();
                                  //     },
                                  //   ),

                                  Visibility(
                                    visible: landingScreenController!
                                            .currentTabIndex.value ==
                                        4,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: 5.0.w,
                                      ),
                                      child: IconWidget(
                                        icon: Icons.search,
                                        colors: Colors.white,
                                        size: CommonUtil().isTablet!
                                            ? 33.0.sp
                                            : 30.0.sp,
                                        onTap: () {
                                          landingScreenController
                                              ?.changeSearchBar(
                                            isEnabled: true,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: CommonUtil().getNotificationIcon(
                                      context,
                                      color: Colors.white,
                                    ),
                                  ),
                                  getSwitchProfileWidget(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: (snapshot.connectionState ==
                                  ConnectionState.waiting)
                              ? CommonCircularIndicator()
                              : (snapshot.hasError)
                                  ? Center(
                                      child: ErrorsWidget(),
                                    )
                                  : getCurrentTab(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              drawer: NavigationDrawer.NavigationDrawer(
                myProfile: myProfile,
                moveToLoginPage: moveToLoginPage,
                userChangedbool: landingViewModel!.isUserMainId,
                refresh: (userChanged) => refresh(
                  userChanged: userChanged,
                ),
                showPatientList: () {
                  CommonUtil().showPatientListOfCaregiver(context,
                      (user, result) {
                    if (user == "You") {
                      refresh(
                        userChanged: true,
                      );
                      Navigator.pop(context);
                      qurhomeDashboardController.currentSelectedTab.value = 0;

                      qurhomeDashboardController.forPatientList.value = false;
                      qurhomeDashboardController.isPatientClicked.value = false;
                      CommonUtil().navigateToQurhomeDasboard();
                    } else {
                      qurhomeDashboardController.forPatientList.value = true;
                      qurhomeDashboardController.careGiverPatientListResult =
                          null;
                      qurhomeDashboardController.careGiverPatientListResult =
                          result;
                      qurhomeDashboardController.currentSelectedTab.value = 0;
                      qurhomeDashboardController.isPatientClicked.value = true;
                      CommonUtil().navigateToQurhomePatientDasboard(result);
                    }
                  });
                },
              ),
              bottomNavigationBar: Obx(
                () => Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    currentIndex:
                        landingScreenController!.currentTabIndex.value,
                    //type: BottomNavigationBarType.fixed,
                    type: BottomNavigationBarType.shifting,
                    selectedFontSize: 12.sp,
                    unselectedFontSize: 10.sp,
                    selectedLabelStyle: TextStyle(
                      color: Color(CommonUtil().getMyPrimaryColor()),
                    ),
                    unselectedLabelStyle: const TextStyle(
                      color: Colors.black54,
                    ),
                    selectedItemColor: Color(CommonUtil().getMyPrimaryColor()),
                    unselectedItemColor: Colors.black54,
                    items: [
                      BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage(
                            variable.icon_home,
                          ),
                          size: CommonUtil().isTablet!
                              ? 33.0.sp
                              : landingScreenController!
                                          .currentTabIndex.value ==
                                      0
                                  ? selOption
                                  : unSelOption,
                        ),
                        label: variable.strhome,
                      ),
                      BottomNavigationBarItem(
                        icon: getChatSocketIcon(),
                        label: variable.strChat,
                      ),
                      BottomNavigationBarItem(
                        icon: getSheelaIcon(),
                        label: variable.strMaya,
                      ),
                      BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage(variable.icon_th),
                          size: CommonUtil().isTablet!
                              ? 33.0.sp
                              : landingScreenController!
                                          .currentTabIndex.value ==
                                      3
                                  ? selOption
                                  : unSelOption,
                        ),
                        label: constants.strAppointment,
                      ),
                      BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage(variable.icon_records),
                          size: CommonUtil().isTablet!
                              ? 33.0.sp
                              : landingScreenController!
                                          .currentTabIndex.value ==
                                      4
                                  ? selOption
                                  : unSelOption,
                        ),
                        label: variable.strMyRecords,
                      )
                    ],
                    //backgroundColor: Colors.grey[200],
                    onTap: (index) {
                      landingScreenController!.updateTabIndex(index);
                    },
                  ),
                ),
              ),
            ));
      },
    );
  }

  Widget getChatIcon() {
    var count = 0;
    var targetID = PreferenceUtil.getStringValue(constants.KEY_USERID);
    return StreamBuilder<QuerySnapshot<Map<dynamic, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(constants.STR_CHAT_LIST)
          .doc(targetID)
          .collection(constants.STR_USER_LIST)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          count = 0;
          snapshot.data!.docs.forEach((element) {
            if (element.data()[constants.STR_IS_READ_COUNT] != null &&
                element.data()[constants.STR_IS_READ_COUNT] != '') {
              count =
                  count + element.data()[constants.STR_IS_READ_COUNT] as int;
            }
          });
          return BadgeIcon(
            icon: GestureDetector(
              child: ImageIcon(
                const AssetImage(variable.icon_chat),
                color: landingScreenController!.currentTabIndex.value == 1
                    ? Color(CommonUtil().getMyPrimaryColor())
                    : Colors.black54,
              ),
            ),
            badgeColor: ColorUtils.countColor,
            badgeCount: count,
          );
        } else {
          return BadgeIcon(
            icon: GestureDetector(
              child: ImageIcon(
                const AssetImage(variable.icon_chat),
                color: landingScreenController!.currentTabIndex.value == 1
                    ? Color(CommonUtil().getMyPrimaryColor())
                    : Colors.black54,
              ),
            ),
            badgeColor: ColorUtils.countColor,
            badgeCount: 0,
          );
        }
      },
    );
  }

  Widget getCurrentTab() {
    final Function onBackPressed = () {
      landingScreenController!.updateTabIndex(0);
    };
    Widget landingTab;
    switch (landingScreenController!.currentTabIndex.value) {
      case 1:
        landingTab = ChatUserList(
          isHome: true,
          onBackPressed: onBackPressed,
        );
        break;
      case 2:
        landingTab = SuperMaya(
          isHome: true,
          onBackPressed: onBackPressed,
        );
        break;
      case 3:
        landingTab = AppointmentsMain(
          isHome: true,
          onBackPressed: onBackPressed,
        );
        break;
      case 4:
        landingTab = MyRecords(
          isHome: true,
          argument: MyRecordsArgument(fromClass: 'landing'),
          onBackPressed: onBackPressed,
        );
        break;
      default:
        landingTab = HomeWidget(
          refresh: (userChanged) => refresh(
            userChanged: userChanged,
          ),
        );
        break;
    }
    return landingTab;
  }

  Widget _getUserName() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5.0.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  /*CommonUtil().getUserName()*/ myProfile?.result != null &&
                          myProfile?.result?.firstName != null &&
                          myProfile?.result?.firstName != ''
                      ? 'Hey ${toBeginningOfSentenceCase(myProfile?.result?.firstName ?? "")}'
                      : myProfile != null
                          ? 'Hey User'
                          : '',
                  style: TextStyle(
                    fontSize: CommonUtil().isTablet!
                        ? constants.tabFontTitle
                        : constants.mobileFontTitle,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getAppBarTitle() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 5.0.w,
        ),
        Expanded(
          child: _getUserName(),
        )
      ],
    );
  }

  Widget getChatSocketIcon() {
    return BadgeIcon(
      icon: GestureDetector(
        child: ImageIcon(
          const AssetImage(variable.icon_chat),
          size: CommonUtil().isTablet!
              ? 33.0.sp
              : landingScreenController!.currentTabIndex.value == 1
                  ? selOption
                  : unSelOption,
          color: landingScreenController!.currentTabIndex.value == 1
              ? Color(CommonUtil().getMyPrimaryColor())
              : Colors.black54,
        ),
      ),
      badgeColor: ColorUtils.countColor,
      badgeCount: Provider.of<ChatSocketViewModel>(Get.context!).chatTotalCount,
    );
  }

  Widget getSheelaIcon() {
    return BadgeIcon(
      icon: Image.asset(
        variable.icon_mayaMain,
        height: CommonUtil().isTablet!
            ? 33.0.sp
            : landingScreenController!.currentTabIndex.value == 2
                ? selSheelaOption
                : unSelOption,
        width: CommonUtil().isTablet!
            ? 33.0.sp
            : landingScreenController!.currentTabIndex.value == 2
                ? selSheelaOption
                : unSelOption,
      ),
      size: 14.h,
      fontSize: 12.sp,
      badgeColor: ColorUtils.countColor,
      badgeCount: sheelBadgeController?.sheelaIconBadgeCount.value,
      isForSheelaQueue: true,
    );
  }

  Future<MyProfileModel?> getMyProfile() async {
    final userId = await PreferenceUtil.getStringValue(constants.KEY_USERID);
    final userIdMain =
        await PreferenceUtil.getStringValue(constants.KEY_USERID);

    if (userId != userIdMain) {
      isUserMainId = false;
    }
    try {
      await getDeviceSelectionValues().then((value) => {});
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    if (userId != null && userId.isNotEmpty) {
      try {
        MyProfileModel value =
            await addFamilyUserInfoRepository.getMyProfileInfoNew(userId);
        myProfile = value;

        if (value != null) {
          if (value.result!.userProfileSettingCollection3!.isNotEmpty) {
            var profileSetting =
                value.result?.userProfileSettingCollection3![0].profileSetting;
            if (profileSetting?.preferredMeasurement != null) {
              PreferredMeasurement? preferredMeasurement =
                  profileSetting?.preferredMeasurement!;
              await PreferenceUtil.saveString(Constants.STR_KEY_HEIGHT,
                      preferredMeasurement!.height!.unitCode!)
                  .then((value) {
                PreferenceUtil.saveString(Constants.STR_KEY_WEIGHT,
                        preferredMeasurement.weight!.unitCode!)
                    .then((value) {
                  PreferenceUtil.saveString(
                          Constants.STR_KEY_TEMP,
                          preferredMeasurement.temperature!.unitCode!
                              .toUpperCase())
                      .then((value) {});
                });
              });
            } else {
              CommonUtil().commonMethodToSetPreference();
            }
          } else {
            CommonUtil().commonMethodToSetPreference();
          }
        } else {
          CommonUtil().commonMethodToSetPreference();
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        CommonUtil().commonMethodToSetPreference();
      }
    } else {
      CommonUtil().logout(moveToLoginPage);
    }
    return myProfile;
  }

  void moveToLoginPage() {
    if (controllerQurhomeRegimen.evryOneMinuteRemainder != null &&
        controllerQurhomeRegimen.evryOneMinuteRemainder?.isActive == true) {
      controllerQurhomeRegimen.evryOneMinuteRemainder?.cancel();
      controllerQurhomeRegimen.evryOneMinuteRemainder = null;
    }
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
        profileData = getMyProfile();
      }
      setState(() {});
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  void moveToQurhome() async {
    var result = await healthReportListForUserRepository.getDeviceSelection();
    if (result.isSuccess!) {
      if (Platform.isIOS) {
        reponseToRemoteNotificationMethodChannel.invokeListMethod(
          QurhomeDefaultUI,
          {
            'status':
                (result.result!.first.profileSetting?.qurhomeDefaultUI ?? false)
          },
        );
      }
      if (result.result!.first.profileSetting?.qurhomeDefaultUI ?? false) {
        if (!PreferenceUtil.getIfQurhomeisDefaultUI()) {
          PreferenceUtil.saveQurhomeAsDefaultUI(
            qurhomeStatus: true,
          );
        }
        CommonUtil().enableBackgroundNotification();
        Get.to(
          () => QurhomeDashboard(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut(
                () => QurhomeDashboardController(),
              );
            },
          ),
        );
      } else if (PreferenceUtil.getIfQurhomeisDefaultUI()) {
        CommonUtil().disableBackgroundNotification();
        PreferenceUtil.saveQurhomeAsDefaultUI(
          qurhomeStatus: false,
        );
      }
    }

    if (widget.landingArguments?.needFreshLoad ?? true) {
      try {
        commonUtil.versionCheck(context);
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
  }

  void dbInitialize() {
    final commonConstants = CommonConstants();
    commonConstants.getCountryMetrics();
  }

  callImportantsMethod() async {
    if (!Get.isRegistered<PDFViewController>()) {
      Get.lazyPut(
        () => PDFViewController(),
      );
    }
    await CommonUtil().validateToken();
    await Provider.of<UserPlansViewModel>(context, listen: false)
        .getUserPlanInfoLocal();

    try {
      getFamilyRelationAndMediaType();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    try {
      getProfileData();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    try {
      try {
        CategoryListBlock _categoryListBlock = CategoryListBlock();

        _categoryListBlock.getCategoryLists().then((value) {});
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }

      getFamilyRelationAndMediaType();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    try {
      final addFamilyUserInfoBloc = AddFamilyUserInfoBloc();
      await addFamilyUserInfoBloc.getDeviceSelectionValues().then((value) {});
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    var url = (PreferenceUtil.getStringValue(constants.KEY_DYNAMIC_URL) ?? '');
    if (url.isNotEmpty) {
      try {
        Uri deepLink = Uri.parse(jsonDecode(url));
        DynamicLinks.processDynamicLink(deepLink);
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
    checkCpUser();
  }

  Future<GetDeviceSelectionModel?> getDeviceSelectionValues() async {
    await healthReportListForUserRepository.getDeviceSelection().then((value) {
      selectionResult = value;
      if (selectionResult!.isSuccess!) {
        if (selectionResult!.result != null) {
          bpMonitor = selectionResult!.result![0].profileSetting!.bpMonitor !=
                      null &&
                  selectionResult!.result![0].profileSetting!.bpMonitor != ''
              ? selectionResult!.result![0].profileSetting!.bpMonitor
              : true;
          glucoMeter = selectionResult!.result![0].profileSetting!.glucoMeter !=
                      null &&
                  selectionResult!.result![0].profileSetting!.glucoMeter != ''
              ? selectionResult!.result![0].profileSetting!.glucoMeter
              : true;
          pulseOximeter = selectionResult!
                          .result![0].profileSetting!.pulseOximeter !=
                      null &&
                  selectionResult!.result![0].profileSetting!.pulseOximeter !=
                      ''
              ? selectionResult!.result![0].profileSetting!.pulseOximeter
              : true;
          thermoMeter =
              selectionResult!.result![0].profileSetting!.thermoMeter != null &&
                      selectionResult!.result![0].profileSetting!.thermoMeter !=
                          ''
                  ? selectionResult!.result![0].profileSetting!.thermoMeter
                  : true;
          weighScale = selectionResult!.result![0].profileSetting!.weighScale !=
                      null &&
                  selectionResult!.result![0].profileSetting!.weighScale != ''
              ? selectionResult!.result![0].profileSetting!.weighScale
              : true;
          if (selectionResult!.result![0].profileSetting != null) {
            if (selectionResult!
                    .result![0].profileSetting!.preferred_language !=
                null) {
              final preferredLanguage = selectionResult!
                  .result![0].profileSetting!.preferred_language;
              var currentLanguage = '';
              if (preferredLanguage != 'undef') {
                currentLanguage = preferredLanguage!.split('-').first;
              } else {
                currentLanguage = 'en';
              }
              PreferenceUtil.saveString(Constants.SHEELA_LANG,
                  CommonUtil.langaugeCodes[currentLanguage] ?? strDefaultLanguage);
            }
            if (selectionResult!.result![0].profileSetting!.preColor != null &&
                selectionResult!.result![0].profileSetting!.greColor != null) {
              PreferenceUtil.saveTheme(Constants.keyPriColor,
                  selectionResult!.result![0].profileSetting!.preColor!);
              PreferenceUtil.saveTheme(Constants.keyGreyColor,
                  selectionResult!.result![0].profileSetting!.greColor!);
              //HomeScreen.of(context).refresh();
              //setState(() {});
            } else {
              PreferenceUtil.saveTheme(
                  Constants.keyPriColor,
                  PreferenceUtil.getSavedTheme(Constants.keyPriColor) ??
                      0xff5f0cf9);
              PreferenceUtil.saveTheme(
                  Constants.keyGreyColor,
                  PreferenceUtil.getSavedTheme(Constants.keyGreyColor) ??
                      0xff9929ea);
            }
            sheelBadgeController?.isAllowSheelaLiveReminders = (selectionResult!
                            .result![0].profileSetting!.sheelaLiveReminders !=
                        null &&
                    selectionResult!
                            .result![0].profileSetting!.sheelaLiveReminders !=
                        '')
                ? selectionResult!
                        .result![0].profileSetting!.sheelaLiveReminders ??
                    true
                : true;
            print('----------isAllowBool: ' +
                (sheelBadgeController?.isAllowSheelaLiveReminders ?? true)
                    .toString());
          } else {
            PreferenceUtil.saveTheme(
                Constants.keyPriColor,
                PreferenceUtil.getSavedTheme(Constants.keyPriColor) ??
                    0xff5f0cf9);
            PreferenceUtil.saveTheme(
                Constants.keyGreyColor,
                PreferenceUtil.getSavedTheme(Constants.keyGreyColor) ??
                    0xff9929ea);
          }
        } else {
          bpMonitor = true;
          glucoMeter = true;
          pulseOximeter = true;
          thermoMeter = true;
          weighScale = true;
        }
      } else {
        bpMonitor = true;
        glucoMeter = true;
        pulseOximeter = true;
        thermoMeter = true;
        weighScale = true;
      }
    });
    return selectionResult;
  }

  void getFamilyRelationAndMediaType() async {
    try {
      await CommonUtil().getAllCustomRoles();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    try {
      await CommonUtil().getMediaTypes();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  void getProfileData() async {
    try {
      await CommonUtil().getUserProfileData();
      profileData = getMyProfile();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  void checkIfUserIdSame() async {
    final userId = await PreferenceUtil.getStringValue(constants.KEY_USERID);
    final userIdMain =
        await PreferenceUtil.getStringValue(constants.KEY_USERID_MAIN);

    setState(() {
      if (userId != userIdMain) {
        isUserMainId = false;
      } else {
        isUserMainId = true;
      }
    });
  }

  void callGetFamiltMappingCaregiver() {
    controller.getFamilyMappingList().then((familyMembersList) {
      if (familyMembersList != null) {
        if (familyMembersList?.result != null) {
          if (familyMembersList?.result?.isNotEmpty) {
            if (familyMembersList?.result?.length > 0) {
              controller.updateNewChatFloatShown(true);
            } else {
              controller.updateNewChatFloatShown(false);
            }
          } else {
            controller.updateNewChatFloatShown(false);
          }
        } else {
          controller.updateNewChatFloatShown(false);
        }
      } else {
        controller.updateNewChatFloatShown(false);
      }
    });
  }

  Widget getSwitchProfileWidget() {
    return FutureBuilder<MyProfileModel?>(
        future: getMyProfile(),
        builder: (context, snapshot) {
          if (snapshot != null) if (snapshot.data != null && snapshot.hasData)
            PreferenceUtil.saveProfileData(
                Constants.KEY_PROFILE, snapshot.data);

          imageCache!.clear();
          imageCache!.clearLiveImages();

          return SwitchProfile().buildActions(
            context,
            _key,
            () {
              profileData = getMyProfile();
              checkIfUserIdSame();
              landingViewModel!.getQurPlanDashBoard(needNotify: true);
              landingViewModel!.checkIfUserIdSame().then((value) {
                isUserMainId = value;
              });
              FirestoreServices().updateFirestoreListner();

              setState(() {});
              (context as Element).markNeedsBuild();
            },
            true,
          );
        });
  }
}

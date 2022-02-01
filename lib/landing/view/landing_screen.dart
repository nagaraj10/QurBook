import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/chat_socket/constants/const_socket.dart';
import 'package:myfhb/chat_socket/model/TotalCountModel.dart';
import 'package:myfhb/chat_socket/model/UserChatListModel.dart';
import 'package:myfhb/chat_socket/view/ChatUserList.dart';
import 'package:myfhb/chat_socket/viewModel/chat_socket_view_model.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/landing/service/landing_service.dart';
import 'package:myfhb/landing/view/corp_users_welcome_dialog.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';
import 'package:myfhb/src/utils/dynamic_links.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFViewerController.dart';
import 'package:myfhb/user_plans/view_model/user_plans_view_model.dart';
import 'package:provider/provider.dart';

import '../../add_family_user_info/bloc/add_family_user_info_bloc.dart';
import '../../add_family_user_info/services/add_family_user_info_repository.dart';
import '../../authentication/view/login_screen.dart';
import '../../colors/fhb_colors.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonDialogBox.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/SwitchProfile.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart' as constants;
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/variable_constant.dart' as variable;
import '../../reminders/QurPlanReminders.dart';
import '../../src/model/GetDeviceSelectionModel.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/resources/repository/health/HealthReportListForUserRepository.dart';
import '../../src/ui/MyRecord.dart';
import '../../src/ui/MyRecordsArguments.dart';
import '../../src/ui/bot/SuperMaya.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/appointments/view/appointmentsMain.dart';
import '../../telehealth/features/chat/view/BadgeIcon.dart';
import '../../telehealth/features/chat/view/home.dart';
import '../view_model/landing_view_model.dart';
import 'landing_arguments.dart';
import 'widgets/home_widget.dart';
import 'widgets/navigation_drawer.dart';

class LandingScreen extends StatefulWidget {
  static _LandingScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<State<LandingScreen>>();

  const LandingScreen({
    this.landingArguments,
  });

  final LandingArguments landingArguments;

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  MyProfileModel myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();
  final GlobalKey<State> _key = GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future profileData;
  File imageURIProfile;
  LandingViewModel landingViewModel;
  CommonUtil commonUtil = CommonUtil();
  bool isUserMainId = true;
  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel selectionResult;

  bool bpMonitor = true;
  bool glucoMeter = true;
  bool pulseOximeter = true;
  bool thermoMeter = true;
  bool weighScale = true;
  var userId;

  @override
  void initState() {
    super.initState();
    mInitialTime = DateTime.now();
    dbInitialize();

    userId = PreferenceUtil.getStringValue(KEY_USERID);

    QurPlanReminders.getTheRemindersFromAPI();
    Provider.of<ChatSocketViewModel>(Get.context)?.initSocket();
    callImportantsMethod();

    var profilebanner =
        PreferenceUtil.getStringValue(constants.KEY_DASHBOARD_BANNER);
    if (profilebanner != null) {
      imageURIProfile = File(profilebanner);
    }
    checkIfUserIdSame();
    if (widget.landingArguments?.needFreshLoad ?? true) {
      try {
        commonUtil.versionCheck(context);
      } catch (e) {}
      profileData = getMyProfile();
      Provider.of<LandingViewModel>(context, listen: false)
          .getQurPlanDashBoard(needNotify: true);
    } else {
      Provider.of<LandingViewModel>(context, listen: false)
          .getQurPlanDashBoard();
    }
    Provider.of<LandingViewModel>(context, listen: false).checkIfUserIdSame();

    Future.delayed(Duration(seconds: 1)).then((_) {
      if (Platform.isIOS) {
        if (PreferenceUtil.isKeyValid(constants.NotificationData)) {
          changeTabToAppointments();
        }
      }
    });

    initSocket();
  }

  void initSocket() {

    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .off(getChatTotalCountOn);

    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .emitWithAck(getChatTotalCountEmit, {
      'userId': userId,
    }, ack: (countResponseEmit) {
      if (countResponseEmit != null) {
        TotalCountModel totalCountModel =
            TotalCountModel.fromJson(countResponseEmit);
        if (totalCountModel != null) {
          Provider.of<ChatSocketViewModel>(Get.context, listen: false)
              ?.updateChatTotalCount(totalCountModel);
        }
      }
    });

    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .on(getChatTotalCountOn, (countResponseOn) {
      if (countResponseOn != null) {
        TotalCountModel totalCountModelOn =
            TotalCountModel.fromJson(countResponseOn);
        if(totalCountModelOn!=null){
          Provider.of<ChatSocketViewModel>(Get.context, listen: false)
              ?.updateChatTotalCount(totalCountModelOn);
        }

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Landing Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  changeTabToAppointments() async {
    try {
      var notificationData = await PreferenceUtil.getNotifiationData();
      if (notificationData.redirect == 'appointmentList') {
        landingViewModel.updateTabIndex(3);
        await PreferenceUtil.removeNotificationData();
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<MyProfileResult> getIsCpUser() async {
    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    return myProfile.result;
  }

  checkCpUser() async {
    var value = await LandingService.getMemberShipDetails();
    PreferenceUtil.saveActiveMembershipStatus(
        value.isSuccess ? (value.result ?? []).length > 0 : false);
    if (value.isSuccess) {
      bool isShown =
          await PreferenceUtil.getIsCorpUserWelcomeMessageDialogShown();

      if (!isShown) {
        MyProfileResult cpUser = await getIsCpUser();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CorpUsersWelcomeDialog(cpUser, value.result[0]);
            });
      }
    }
  }

  Future<bool> _onBackPressed() {
    if (landingViewModel.currentTabIndex != 0) {
      landingViewModel.updateTabIndex(0);
      return Future.value(false);
    } else {
      return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Do you want to exit for now?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            },
          ) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    landingViewModel = Provider.of<LandingViewModel>(context);
    if (landingViewModel.isURLCome) {
      landingViewModel.isURLCome = false;
      Future.delayed(Duration(seconds: 2), () {
        if (widget?.landingArguments?.url != null &&
            widget?.landingArguments?.url.isNotEmpty) {
          CommonUtil().launchURL(widget?.landingArguments?.url);
        }
      });
    }
    return FutureBuilder<MyProfileModel>(
        future: profileData,
        builder: (context, snapshot) {
          return Scaffold(
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
                        visible: !landingViewModel.isSearchVisible,
                        child: Container(
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
                                    iconSize: 24.0.sp,
                                    onPressed: () {
                                      _scaffoldKey.currentState.openDrawer();
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
                                  visible:
                                      landingViewModel.currentTabIndex == 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: 5.0.w,
                                    ),
                                    child: IconWidget(
                                      icon: Icons.search,
                                      colors: Colors.white,
                                      size: 30.0.sp,
                                      onTap: () {
                                        landingViewModel?.changeSearchBar(
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
                                SwitchProfile().buildActions(
                                  context,
                                  _key,
                                  () {
                                    profileData = getMyProfile();
                                    checkIfUserIdSame();
                                    landingViewModel.getQurPlanDashBoard(
                                        needNotify: true);
                                    landingViewModel
                                        .checkIfUserIdSame()
                                        .then((value) {
                                      isUserMainId = value;
                                    });
                                    setState(() {});
                                    (context as Element).markNeedsBuild();
                                  },
                                  true,
                                ),
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
            drawer: NavigationDrawer(
              myProfile: myProfile,
              moveToLoginPage: moveToLoginPage,
              userChangedbool: landingViewModel.isUserMainId,
              refresh: (userChanged) => refresh(
                userChanged: userChanged,
              ),
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: landingViewModel.currentTabIndex,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 10.sp,
                unselectedFontSize: 10.sp,
                selectedLabelStyle: TextStyle(
                  color: Color(CommonUtil().getMyPrimaryColor()),
                ),
                unselectedLabelStyle: const TextStyle(
                  color: Colors.black54,
                ),
                selectedIconTheme: IconThemeData(
                  color: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                ),
                unselectedIconTheme: const IconThemeData(
                  color: Colors.black54,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage(
                        variable.icon_home,
                      ),
                    ),
                    title: Text(
                      variable.strhome,
                      style: TextStyle(
                        color: landingViewModel.currentTabIndex == 0
                            ? Color(
                                CommonUtil().getMyPrimaryColor(),
                              )
                            : Colors.black54,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: getChatSocketIcon(),
                    title: Text(
                      variable.strChat,
                      style: TextStyle(
                        color: landingViewModel.currentTabIndex == 1
                            ? Color(CommonUtil().getMyPrimaryColor())
                            : Colors.black54,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      variable.icon_mayaMain,
                      height: 25,
                      width: 25,
                    ),
                    title: Text(
                      variable.strMaya,
                      style: TextStyle(
                        color: landingViewModel.currentTabIndex == 2
                            ? Color(CommonUtil().getMyPrimaryColor())
                            : Colors.black54,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage(variable.icon_th),
                    ),
                    title: Text(
                      constants.strAppointment,
                      style: TextStyle(
                        color: landingViewModel.currentTabIndex == 3
                            ? Color(CommonUtil().getMyPrimaryColor())
                            : Colors.black54,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage(variable.icon_records),
                    ),
                    title: Text(
                      variable.strMyRecords,
                      style: TextStyle(
                        color: landingViewModel.currentTabIndex == 4
                            ? Color(CommonUtil().getMyPrimaryColor())
                            : Colors.black54,
                      ),
                    ),
                  )
                ],
                //backgroundColor: Colors.grey[200],
                onTap: (index) {
                  landingViewModel.updateTabIndex(index);
                },
              ),
            ),
          );
        });
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
          snapshot.data.docs.forEach((element) {
            if (element.data()[constants.STR_IS_READ_COUNT] != null &&
                element.data()[constants.STR_IS_READ_COUNT] != '') {
              count = count + element.data()[constants.STR_IS_READ_COUNT];
            }
          });
          return BadgeIcon(
            icon: GestureDetector(
              child: ImageIcon(
                const AssetImage(variable.icon_chat),
                color: landingViewModel.currentTabIndex == 1
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
                color: landingViewModel.currentTabIndex == 1
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
      landingViewModel.updateTabIndex(0);
    };
    Widget landingTab;
    switch (landingViewModel.currentTabIndex) {
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

  Widget _getUserName() => AnimatedSwitcher(
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
                    myProfile?.result != null &&
                            myProfile.result.firstName != null &&
                            myProfile.result.firstName != ''
                        ? 'Hey ${toBeginningOfSentenceCase(myProfile?.result?.firstName ?? "")}'
                        : myProfile != null
                            ? 'Hey User'
                            : '',
                    style: TextStyle(
                      fontSize: 18.0.sp,
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
          color: landingViewModel.currentTabIndex == 1
              ? Color(CommonUtil().getMyPrimaryColor())
              : Colors.black54,
        ),
      ),
      badgeColor: ColorUtils.countColor,
      badgeCount: Provider.of<ChatSocketViewModel>(Get.context)?.chatTotalCount,
    );
  }

  Future<MyProfileModel> getMyProfile() async {
    final userId = await PreferenceUtil.getStringValue(constants.KEY_USERID);
    final userIdMain =
        await PreferenceUtil.getStringValue(constants.KEY_USERID);

    if (userId != userIdMain) {
      isUserMainId = false;
    }
    try {
      await getDeviceSelectionValues().then((value) => {});
    } catch (e) {}
    if (userId != null && userId.isNotEmpty) {
      try {
        MyProfileModel value =
            await addFamilyUserInfoRepository.getMyProfileInfoNew(userId);
        myProfile = value;
      } catch (e) {}
    } else {
      CommonUtil().logout(moveToLoginPage);
    }
    return myProfile;
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
    if (userChanged) {
      profileData = getMyProfile();
    }
    setState(() {});
  }

  void dbInitialize() {
    final commonConstants = CommonConstants();
    commonConstants.getCountryMetrics();
  }

  void callImportantsMethod() async {
    Get.lazyPut(
      () => PDFViewController(),
    );
    await CommonUtil().validateToken();
    await Provider.of<UserPlansViewModel>(context, listen: false)
        ?.getUserPlanInfoLocal();

    try {
      getFamilyRelationAndMediaType();
    } catch (e) {}
    try {
      getProfileData();
    } catch (e) {}

    try {
      await CommonUtil().getMedicalPreference();
    } catch (e) {}

    try {
      CommonDialogBox().getCategoryList();
      getFamilyRelationAndMediaType();
    } catch (e) {}

    try {
      final addFamilyUserInfoBloc = AddFamilyUserInfoBloc();
      await addFamilyUserInfoBloc.getDeviceSelectionValues().then((value) {});
    } catch (e) {}
    var url = (PreferenceUtil.getStringValue(constants.KEY_DYNAMIC_URL) ?? '');
    if (url?.isNotEmpty ?? false) {
      try {
        Uri deepLink = Uri.parse(jsonDecode(url));
        DynamicLinks.processDynamicLink(deepLink);
      } catch (e) {}
    }
    checkCpUser();
  }

  Future<GetDeviceSelectionModel> getDeviceSelectionValues() async {
    await healthReportListForUserRepository.getDeviceSelection().then((value) {
      selectionResult = value;
      if (selectionResult.isSuccess) {
        if (selectionResult.result != null) {
          bpMonitor =
              selectionResult.result[0].profileSetting.bpMonitor != null &&
                      selectionResult.result[0].profileSetting.bpMonitor != ''
                  ? selectionResult.result[0].profileSetting.bpMonitor
                  : true;
          glucoMeter =
              selectionResult.result[0].profileSetting.glucoMeter != null &&
                      selectionResult.result[0].profileSetting.glucoMeter != ''
                  ? selectionResult.result[0].profileSetting.glucoMeter
                  : true;
          pulseOximeter =
              selectionResult.result[0].profileSetting.pulseOximeter != null &&
                      selectionResult.result[0].profileSetting.pulseOximeter !=
                          ''
                  ? selectionResult.result[0].profileSetting.pulseOximeter
                  : true;
          thermoMeter =
              selectionResult.result[0].profileSetting.thermoMeter != null &&
                      selectionResult.result[0].profileSetting.thermoMeter != ''
                  ? selectionResult.result[0].profileSetting.thermoMeter
                  : true;
          weighScale =
              selectionResult.result[0].profileSetting.weighScale != null &&
                      selectionResult.result[0].profileSetting.weighScale != ''
                  ? selectionResult.result[0].profileSetting.weighScale
                  : true;
          if (selectionResult.result[0].profileSetting != null) {
            if (selectionResult.result[0].profileSetting.preferred_language !=
                null) {
              final preferredLanguage =
                  selectionResult.result[0].profileSetting.preferred_language;
              var currentLanguage = '';
              if (preferredLanguage != 'undef') {
                currentLanguage = preferredLanguage.split('-').first;
              } else {
                currentLanguage = 'en';
              }
              PreferenceUtil.saveString(Constants.SHEELA_LANG,
                  CommonUtil.langaugeCodes[currentLanguage] ?? 'en-IN');
            }
            if (selectionResult.result[0].profileSetting.preColor != null &&
                selectionResult.result[0].profileSetting.greColor != null) {
              PreferenceUtil.saveTheme(Constants.keyPriColor,
                  selectionResult.result[0].profileSetting.preColor);
              PreferenceUtil.saveTheme(Constants.keyGreyColor,
                  selectionResult.result[0].profileSetting.greColor);
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
    } catch (e) {}
    try {
      await CommonUtil().getMediaTypes();
    } catch (e) {}
  }

  void getProfileData() async {
    try {
      await CommonUtil().getUserProfileData();
    } catch (e) {}
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
}

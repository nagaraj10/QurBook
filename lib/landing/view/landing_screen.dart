import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/user_plans/view_model/user_plans_view_model.dart';
import '../../add_family_user_info/bloc/add_family_user_info_bloc.dart';
import '../../add_family_user_info/services/add_family_user_info_repository.dart';
import '../../authentication/view/login_screen.dart';
import '../../colors/fhb_colors.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonDialogBox.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/SwitchProfile.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart' as constants;
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/variable_constant.dart' as variable;
import 'landing_arguments.dart';
import '../view_model/landing_view_model.dart';
import '../../reminders/QurPlanReminders.dart';
import '../../src/model/GetDeviceSelectionModel.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/resources/repository/health/HealthReportListForUserRepository.dart';
import '../../src/ui/MyRecord.dart';
import '../../src/ui/MyRecordsArguments.dart';
import '../../src/ui/bot/SuperMaya.dart';
import '../../src/ui/bot/common/botutils.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/appointments/view/appointmentsMain.dart';
import '../../telehealth/features/chat/view/BadgeIcon.dart';
import '../../telehealth/features/chat/view/home.dart';
import '../../video_call/model/NotificationModel.dart';
import 'package:provider/provider.dart';

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

  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel selectionResult;

  bool bpMonitor = true;
  bool glucoMeter = true;
  bool pulseOximeter = true;
  bool thermoMeter = true;
  bool weighScale = true;

  @override
  void initState() {
    super.initState();
    dbInitialize();
    QurPlanReminders.getTheRemindersFromAPI();
    callImportantsMethod();

    var profilebanner =
        PreferenceUtil.getStringValue(constants.KEY_DASHBOARD_BANNER);
    if (profilebanner != null) {
      imageURIProfile = File(profilebanner);
    }
    if (widget.landingArguments?.needFreshLoad ?? true) {
      try {
        commonUtil.versionCheck(context);
      } catch (e) {}
      Provider.of<LandingViewModel>(context, listen: false)
          .getQurPlanDashBoard(needNotify: true);
    } else {
      Provider.of<LandingViewModel>(context, listen: false)
          .getQurPlanDashBoard();
    }
    profileData = getMyProfile();

    Future.delayed(Duration(seconds: 1)).then((_) {
      if (Platform.isIOS) {
        if (PreferenceUtil.isKeyValid(constants.NotificationData)) {
          changeTabToAppointments();
        }
      }
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
      print(e.toString());
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
                              Visibility(
                                visible: landingViewModel.currentTabIndex == 4,
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
                                  landingViewModel.getQurPlanDashBoard(
                                      needNotify: true);
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
                      child:
                          (snapshot.connectionState == ConnectionState.waiting)
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
                color: Color(CommonUtil().getMyPrimaryColor()),
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
                          ? Color(CommonUtil().getMyPrimaryColor())
                          : Colors.black54,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: getChatIcon(),
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
        landingTab = ChatHomeScreen(
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
                    myProfile != null ??
                            myProfile.result.firstName != null &&
                                myProfile.result.firstName != ''
                        ? 'Hey ${toBeginningOfSentenceCase(myProfile.result.firstName)}'
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

  Future<MyProfileModel> getMyProfile() async {
    final userId = PreferenceUtil.getStringValue(constants.KEY_USERID);
    if (userId != null && userId.isNotEmpty) {
      await addFamilyUserInfoRepository
          .getMyProfileInfoNew(userId)
          .then((value) {
        myProfile = value;
      });
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
    await CommonUtil().validateToken();
    await Provider.of<UserPlansViewModel>(context, listen: false)
        ?.getUserPlanInfo();

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
    try {
      await getDeviceSelectionValues().then((value) => {});
    } catch (e) {}
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
                  Utils.langaugeCodes[currentLanguage] ?? 'en-IN');
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
}

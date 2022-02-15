import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/QurHub/View/hub_list_screen.dart';
import 'package:myfhb/add_family_user_info/bloc/add_family_user_info_bloc.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonDialogBox.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/device_integration/view/screens/Device_Widget.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/Authentication/UserModel.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({
    this.fromPlans = false,
  });

  final bool fromPlans;
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  MyProfileBloc _myProfileBloc;
  BuildContext _myContext;
  final GlobalKey _showMaya = GlobalKey();
  final GlobalKey _provider = GlobalKey();
  final GlobalKey _records = GlobalKey();
  final GlobalKey _family = GlobalKey();
  final GlobalKey _coverImage = GlobalKey();
  UserModel saveuser = UserModel();
  File imageURIProfile;
  String date;
  String devicevalue1;
  String devicevalue2;

  bool noInternet = true;
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();

  //ChatViewModel chatViewModel = new ChatViewModel();
  CommonUtil commonUtil = new CommonUtil();

  @override
  void initState() {
    super.initState();
    mInitialTime = DateTime.now();
    //chatViewModel.getUnreadMSGCount(PreferenceUtil.getStringValue(Constants.KEY_USERID));

    /*
    var isFirstTime =
        PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_DASHBOARD);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          Duration(milliseconds: 200),
          () => isFirstTime
              ? null
              : ShowCaseWidget.of(_myContext).startShowCase(
                  [_showMaya, _provider, _records, _family, _coverImage]));
    });
    */
    dbInitialize();
    QurPlanReminders.getTheRemindersFromAPI();
    callImportantsMethod();

    String profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_DASHBOARD_BANNER);
    if (profilebanner != null) {
      imageURIProfile = File(profilebanner);
    }
    // try {
    //   if (!widget.fromPlans) commonUtil.versionCheck(context);
    // } catch (e) {}


  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Dashboard Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        PreferenceUtil.saveString(
            Constants.KEY_SHOWCASE_DASHBOARD, variable.strtrue);
      },
      builder: Builder(
        builder: (context) {
          _myContext = context;
          return Scaffold(
              key: scaffold_state,
              backgroundColor: Colors.grey[200],
              body: ChangeNotifierProvider(
                create: (context) => DevicesViewModel(),
                child: ShowDevicesNew(
                  fromPlans: widget.fromPlans,
                ),
              ));
        },
      ),
    );
  }

  void moveToFamilyOrprovider(int position) {
    Navigator.pushNamed(
      context,
      router.rt_UserAccounts,
      arguments: UserAccountsArguments(selectedIndex: position),
    ).then((value) {
      setState(() {});
    });

    /* Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: router.rt_UserAccounts),
        builder: (context) => UserAccounts(
            arguments: UserAccountsArguments(selectedIndex: position)),
      ),
    );*/
  }

  moveToNextScreen(int position) {
    if (checkPagesForEveryIndex(position)) {
      getProfileData();
      navigateToHomeScreen(position);
    } else if (noInternet == false) {
      new FHBBasicWidget()
          .showInSnackBar(Constants.STR_NO_CONNECTIVITY, scaffold_state);
    } else {
      getProfileData();

      navigateToHomeScreen(position);
    }
  }

  void navigateToHomeScreen(int position) {
    Navigator.pushNamed(
      context,
      router.rt_HomeScreen,
      arguments: HomeScreenArguments(selectedIndex: position),
    ).then((value) {
      setState(() {});
    });
  }

  void navigateToTelehealthScreen(int position) async {
    // await for camera and mic permissions before pushing video page
    Navigator.pushNamed(
      context,
      router.rt_TelehealthProvider,
      arguments: HomeScreenArguments(selectedIndex: position),
    ).then((value) {
      setState(() {});
    });
  }

  bool checkPagesForEveryIndex(int position) {
    bool condition = false;

    switch (position) {
      case 1:
        if (PreferenceUtil.getCompleteData(Constants.KEY_COMPLETE_DATA) !=
            null) {
          condition = true;
        } else {
          new FHBUtils().check().then((intenet) {
            if (intenet != null && intenet) {
              condition = true;
              noInternet = true;
            } else {
              condition = false;
              noInternet = false;
            }
          });
        }
    }

    return condition;
  }

  bool checkPagesForFamilyOrProvider(int position) {
    bool condition = false;
    getFamilyRelationAndMediaType();

    switch (position) {
      case 1:
        if (PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER) != null) {
          condition = true;
        } else {
          new FHBUtils().check().then((intenet) {
            if (intenet != null && intenet) {
              condition = true;
              noInternet = true;
            } else {
              condition = false;
              noInternet = false;
            }
          });
        }
    }

    return condition;
  }

  void dbInitialize() {
    var commonConstants = new CommonConstants();
    commonConstants.getCountryMetrics();
  }

  void callImportantsMethod() async {
    try {
      getFamilyRelationAndMediaType();
    } catch (e) {}
    try {
      getProfileData();
    } catch (e) {}
    try {
      syncDevices();
    } catch (e) {}

    try {
      await new CommonUtil().getMedicalPreference();
    } catch (e) {}

    try {
      new CommonDialogBox().getCategoryList();
      getFamilyRelationAndMediaType();
    } catch (e) {}

    try {
      AddFamilyUserInfoBloc addFamilyUserInfoBloc = new AddFamilyUserInfoBloc();
      addFamilyUserInfoBloc.getDeviceSelectionValues().then((value) {});
    } catch (e) {}
  }

  void getFamilyRelationAndMediaType() async {
    try {
      await new CommonUtil().getAllCustomRoles();
    } catch (e) {}
    try {
      await new CommonUtil().getMediaTypes();
    } catch (e) {}
  }

  void getProfileData() async {
    try {
      await new CommonUtil().getUserProfileData();
    } catch (e) {}
  }

  void syncDevices() async {
    await new CommonUtil().syncDevices();
  }

  Future<void> _handleCameraAndMic() async {
    await Permission.microphone.request();
    await Permission.camera.request();
  }

  Widget getChatIcon() {
    int count = 0;
    String targetID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    return StreamBuilder<QuerySnapshot<Map<dynamic, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(STR_CHAT_LIST)
            .doc(targetID)
            .collection(STR_USER_LIST)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            count = 0;
            snapshot.data.docs.forEach((element) {
              if (element.data()[STR_IS_READ_COUNT] != null &&
                  element.data()[STR_IS_READ_COUNT] != '') {
                count = count + element.data()[STR_IS_READ_COUNT];
              }
            });
            return BadgeIcon(
                icon: GestureDetector(
                  child: ImageIcon(
                    AssetImage(variable.icon_chat),
                    color: Colors.black54,
                  ),
                ),
                badgeColor: ColorUtils.countColor,
                badgeCount: count);
          } else {
            return BadgeIcon(
                icon: GestureDetector(
                  child: ImageIcon(
                    AssetImage(variable.icon_chat),
                    color: Colors.black54,
                  ),
                ),
                badgeColor: ColorUtils.countColor,
                badgeCount: 0);
          }
        });
  }

  String createGroupId(String patientId, String peerId) {
    String groupId = '';

    if (patientId.hashCode <= peerId.hashCode) {
      groupId = '$patientId-$peerId';
    } else {
      groupId = '$peerId-$patientId';
    }

    return groupId;
  }
}

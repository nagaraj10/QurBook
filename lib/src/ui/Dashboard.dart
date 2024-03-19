import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../add_family_user_info/bloc/add_family_user_info_bloc.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonDialogBox.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../device_integration/view/screens/Device_Widget.dart';
import '../../device_integration/viewModel/Device_model.dart';
import '../../telehealth/features/chat/view/BadgeIcon.dart';
import '../blocs/User/MyProfileBloc.dart';
import '../model/Authentication/UserModel.dart';
import '../model/home_screen_arguments.dart';
import '../model/user/user_accounts_arguments.dart';
import '../utils/FHBUtils.dart';
import '../utils/colors_utils.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({
    this.fromPlans = false,
  });

  final bool fromPlans;
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  MyProfileBloc? _myProfileBloc;
  BuildContext? _myContext;
  final GlobalKey _showMaya = GlobalKey();
  final GlobalKey _provider = GlobalKey();
  final GlobalKey _records = GlobalKey();
  final GlobalKey _family = GlobalKey();
  final GlobalKey _coverImage = GlobalKey();
  UserModel saveuser = UserModel();
  File? imageURIProfile;
  String? date;
  String? devicevalue1;
  String? devicevalue2;

  bool noInternet = true;
  GlobalKey<ScaffoldMessengerState> scaffold_state =
      GlobalKey<ScaffoldMessengerState>();

  CommonUtil commonUtil = CommonUtil();

  @override
  void initState() {
    super.initState();
    final profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_DASHBOARD_BANNER);
    if (profilebanner != null) {
      imageURIProfile = File(profilebanner);
    }
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
  }

  moveToNextScreen(int position) {
    if (checkPagesForEveryIndex(position)) {
      getProfileData();
      navigateToHomeScreen(position);
    } else if (noInternet == false) {
      FHBBasicWidget()
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
          FHBUtils().check().then((intenet) {
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
          FHBUtils().check().then((intenet) {
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
    var commonConstants = CommonConstants();
    commonConstants.getCountryMetrics();
  }

  void callImportantsMethod() async {
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
      syncDevices();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    try {
      CommonDialogBox().getCategoryList();
      getFamilyRelationAndMediaType();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    try {
      AddFamilyUserInfoBloc addFamilyUserInfoBloc = AddFamilyUserInfoBloc();
      addFamilyUserInfoBloc.getDeviceSelectionValues().then((value) {});
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
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
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  void syncDevices() async {
    await CommonUtil().syncDevices();
  }

  Future<void> _handleCameraAndMic() async {
    await Permission.microphone.request();
    await Permission.camera.request();
  }

  Widget getChatIcon() {
    int count = 0;
    String? targetID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    return StreamBuilder<QuerySnapshot<Map<dynamic, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(STR_CHAT_LIST)
            .doc(targetID)
            .collection(STR_USER_LIST)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            count = 0;
            snapshot.data!.docs.forEach((element) {
              if (element.data()[STR_IS_READ_COUNT] != null &&
                  element.data()[STR_IS_READ_COUNT] != '') {
                count = count + element.data()[STR_IS_READ_COUNT] as int;
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

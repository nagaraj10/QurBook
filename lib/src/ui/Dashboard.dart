import 'dart:io';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/device_integration/view/screens/Device_Widget.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/Authentication/UserModel.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
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

    callImportantsMethod();

    print(
        'User Id : ${PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN)}');
    print(
        'Auth Token : ${PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)}');

    String profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_DASHBOARD_BANNER);
    if (profilebanner != null) {
      imageURIProfile = File(profilebanner);
    }
    try {
      commonUtil.versionCheck(context);
    } catch (e) {
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
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 10.sp,
                  unselectedFontSize: 10.sp,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: InkWell(
                            // onTap: () {
                            //   navigateToTelehealthScreen(0);
                            // },
                            child: ImageIcon(
                          AssetImage(variable.icon_th),
                          color: Colors.black54,
                        )),
                        title: Text(
                          variable.strTelehealth,
                          style: TextStyle(color: Colors.black54),
                        )),
                    /*BottomNavigationBarItem(
                        icon: InkWell(
                          // onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ChatHomeScreen()),
                          //   );
                          // },
                            child: ImageIcon(
                              AssetImage(variable.icon_chat),
                              color: Colors.black54,
                            )),
                        title: Text(
                          variable.strChat,
                          style: TextStyle(color: Colors.black54),
                        )),*/
                    BottomNavigationBarItem(
                        icon: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatHomeScreen()),
                            );
                          },
                          child: getChatIcon(),
                        ),
                        title: Text(
                          variable.strChat,
                          style: TextStyle(color: Colors.black54),
                        )),
                    BottomNavigationBarItem(
                        icon: InkWell(
                          // onTap: () {
                          //   moveToNextScreen(2);
                          // },
                          child: Image.asset(
                            PreferenceUtil.getStringValue(
                                        Constants.keyMayaAsset) !=
                                    null
                                ? PreferenceUtil.getStringValue(
                                        Constants.keyMayaAsset) +
                                    variable.strExtImg
                                : variable.icon_mayaMain,
                            height: 25,
                            width: 25,
                          ),
                        ),
                        title: Text(
                          'Sheela G',
                          style: TextStyle(color: Colors.black54),
                        )),
                    BottomNavigationBarItem(
                        icon: InkWell(
                            // onTap: () {
                            //   moveToNextScreen(1);
                            // },
                            child: ImageIcon(
                          AssetImage(variable.icon_records),
                          color: Colors.black54,
                        )),
                        title: Text(
                          variable.strMyRecords,
                          style: TextStyle(color: Colors.black54),
                        )),
                    /*BottomNavigationBarItem(
                          icon: InkWell(
                              onTap: () {
                                moveToFamilyOrprovider(2);
                              },
                              child: ImageIcon(
                                AssetImage(variable.icon_provider),
                                color: Colors.black54,
                              )),
                          title: Text(
                            variable.strMyProvider,
                            style: TextStyle(color: Colors.black54),
                          )),*/
                    BottomNavigationBarItem(
                        icon: InkWell(
                            // onTap: () {
                            //   Navigator.pushNamed(
                            //     context,
                            //     router.rt_UserAccounts,
                            //     arguments:
                            //         UserAccountsArguments(selectedIndex: 0),
                            //   ).then((value) {
                            //     setState(() {});
                            //   });
                            // },
                            child: ImageIcon(
                          AssetImage(variable.icon_profile),
                          color: Colors.black54,
                        )),
                        title: Text(
                          variable.strProfile,
                          style: TextStyle(color: Colors.black54),
                        )),
                  ],
                  onTap: (tappedIndex) {
                    switch (tappedIndex) {
                      case 0:
                        navigateToTelehealthScreen(0);
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatHomeScreen()),
                        );
                        break;
                      case 2:
                        moveToNextScreen(2);
                        break;
                      case 3:
                        moveToNextScreen(1);
                        break;
                      case 4:
                        Navigator.pushNamed(
                          context,
                          router.rt_UserAccounts,
                          arguments: UserAccountsArguments(selectedIndex: 0),
                        ).then((value) {
                          setState(() {});
                        });
                        break;
                      default:
                        navigateToTelehealthScreen(0);
                        break;
                    }
                  },
                ),
              ),
              backgroundColor: Colors.grey[200],
              body: SingleChildScrollView(
                //height: 1.sh - 200,
                child: ChangeNotifierProvider(
                  create: (context) => DevicesViewModel(),
                  child: ShowDevicesNew(),
                ),
              ));
        },
      ),
    );
  }

  saveMediaDialog(BuildContext cont, bool isProfileImage) {
    return showDialog<void>(
      context: cont,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: Text(Constants.makeAChoice),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(Constants.GALLERY_TITLE),
                      onTap: () {
                        Navigator.pop(context);

                        var image =
                            ImagePicker.pickImage(source: ImageSource.gallery);
                        image.then((value) {
                          imageURIProfile = value;
                          PreferenceUtil.saveString(
                              Constants.KEY_DASHBOARD_BANNER, value.path);

                          (cont as Element).markNeedsBuild();
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                      child: Text(Constants.CAMERA_TITLE),
                      onTap: () {
                        Navigator.pop(context);

                        var image =
                            ImagePicker.pickImage(source: ImageSource.camera);
                        image.then((value) {
                          imageURIProfile = value;
                          PreferenceUtil.saveString(
                              Constants.KEY_DASHBOARD_BANNER, value.path);

                          (cont as Element).markNeedsBuild();
                        });
                      },
                    ),
                  ],
                ),
              ));
        });
      },
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
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(STR_CHAT_LIST)
            .document(targetID)
            .collection(STR_USER_LIST)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            count = 0;
            snapshot.data.documents.toList().forEach((element) {
              if (element.data[STR_IS_READ_COUNT] != null &&
                  element.data[STR_IS_READ_COUNT] != '') {
                count = count + element.data[STR_IS_READ_COUNT];
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

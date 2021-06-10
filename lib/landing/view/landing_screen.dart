import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/notifications/myfhb_notifications.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsMain.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:provider/provider.dart';
import 'widgets/home_widget.dart';
import 'widgets/navigation_drawer.dart';
import 'package:myfhb/landing/view_model/landing_view_model.dart';

class LandingScreen extends StatefulWidget {
  static _LandingScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<State<LandingScreen>>();

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;
  MyProfileModel myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();
  final GlobalKey<State> _key = GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future profileData;
  LandingViewModel landingViewModel;

  @override
  void initState() {
    super.initState();
    profileData = getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    landingViewModel = Provider.of<LandingViewModel>(context);
    return FutureBuilder<MyProfileModel>(
      future: profileData,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: ErrorsWidget(),
            ),
          );
        } else {
          return Scaffold(
            key: _scaffoldKey,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[
                            Color(CommonUtil().getMyPrimaryColor()),
                            Color(CommonUtil().getMyGredientColor())
                          ],
                              stops: [
                            0.3,
                            1.0
                          ])),
                      child: IntrinsicHeight(
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              PreferredSize(
                                preferredSize: Size.fromHeight(1.sh * 0.15),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                        Color(CommonUtil().getMyPrimaryColor()),
                                        Color(CommonUtil().getMyGredientColor())
                                      ],
                                          stops: [
                                        0.3,
                                        1.0
                                      ])),
                                  child: SafeArea(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.menu_rounded,
                                                ),
                                                color: Colors.white,
                                                iconSize: 24.0.sp,
                                                onPressed: () {
                                                  _scaffoldKey.currentState
                                                      .openDrawer();
                                                },
                                              ),
                                              Expanded(
                                                child: _getUserName(),
                                              ),
                                              Center(
                                                child: CommonUtil()
                                                    .getNotificationIcon(
                                                        context),
                                              ),
                                              SwitchProfile().buildActions(
                                                context,
                                                _key,
                                                () {
                                                  (context as Element)
                                                      .markNeedsBuild();
                                                },
                                                true,
                                              ),
                                              SizedBox(
                                                width: 10.0.w,
                                              ),
                                            ],
                                          ),
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
                    Expanded(
                      child: getCurrentTab(),
                    ),
                  ],
                ),
              ],
            ),
            drawer: NavigationDrawer(
              myProfile: myProfile,
              moveToLoginPage: moveToLoginPage,
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
                currentIndex: _selectedIndex,
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
                  const BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage(
                        variable.icon_home,
                      ),
                    ),
                    label: variable.strhome,
                  ),
                  BottomNavigationBarItem(
                    icon: getChatIcon(),
                    label: variable.strChat,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      variable.icon_mayaMain,
                      height: 25,
                      width: 25,
                    ),
                    label: variable.strMaya,
                  ),
                  const BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage(variable.icon_th),
                    ),
                    label: variable.strTelehealth,
                  ),
                  const BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage(variable.icon_records),
                    ),
                    label: variable.strMyRecords,
                  )
                ],
                //backgroundColor: Colors.grey[200],
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget getChatIcon() {
    var count = 0;
    final targetID = PreferenceUtil.getStringValue(constants.KEY_USERID);
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
                const AssetImage(variable.icon_chat),
                color: _selectedIndex == 1
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
                color: _selectedIndex == 1
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
    Function onBackPressed = () {
      setState(() {
        _selectedIndex = 0;
      });
    };
    Widget landingTab;
    switch (_selectedIndex) {
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
        );
        break;
      case 4:
        landingTab = MyRecords(
          isHome: true,
          argument: MyRecordsArgument(),
          onBackPressed: onBackPressed,
        );
        break;
      default:
        landingTab = HomeWidget();
        break;
    }
    return landingTab;
  }

  Widget _getUserName() {
    var resultWidget = null;
    resultWidget = AnimatedSwitcher(
      duration: Duration(milliseconds: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5.0.w,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    myProfile != null ??
                            myProfile.result.firstName != null &&
                                myProfile.result.firstName != ''
                        ? 'Hey ' +
                            toBeginningOfSentenceCase(
                                myProfile.result.firstName)
                        : 'Hey User',
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
            ),
          )
        ],
      ),
    );
    return resultWidget;
  }

  Future<MyProfileModel> getMyProfile() async {
    var userId = PreferenceUtil.getStringValue(constants.KEY_USERID);
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
            builder: (BuildContext context) => PatientSignInScreen(),
          ),
          (route) => false,
        );
      },
    );
  }

  void refresh() {
    setState(() {});
  }
}

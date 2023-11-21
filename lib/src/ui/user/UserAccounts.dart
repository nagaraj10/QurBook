import 'dart:io';
import 'package:get/get.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/landing/view_model/landing_view_model.dart';
import 'package:myfhb/myPlan/view/myPlanList.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_family/screens/MyFamily.dart';
import 'package:myfhb/my_providers/screens/my_provider.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:provider/provider.dart';

import 'MyProfilePage.dart';

class UserAccounts extends StatefulWidget {
  UserAccountsArguments? arguments;

  UserAccounts({this.arguments});

  @override
  _UserAccountsState createState() => _UserAccountsState();
}

class _UserAccountsState extends State<UserAccounts>
    with SingleTickerProviderStateMixin {
  double sliverBarHeight = 220;
  TabController? _sliverTabController;
  int selectedTab = 0;
  bool _isEditable = false;
  File? imageURIProfile, profileImage;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  MyProfileModel? myProfile;
  bool islogout = false;
  final GlobalKey<State> _key = GlobalKey<State>();
  MyProfileModel? profileData;
  bool isUserMainId = true;
  LandingViewModel? landingViewModel;
  bool firstTym = true;

  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    //fetchUserProfileInfo();
    _sliverTabController = TabController(
        vsync: this, length: 4, initialIndex: widget.arguments!.selectedIndex!);
    _sliverTabController!.addListener(_handleSelected);

    setValueForProfile();
    Provider.of<LandingViewModel>(context, listen: false)
        .getQurPlanDashBoard(needNotify: true);
  }

  fetchUserProfileInfo() async {
    var userid =
        await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN)!;
    myProfile = await addFamilyUserInfoRepository.getMyProfileInfoNew(userid);
  }

  void _handleSelected() {
    FocusManager.instance.primaryFocus!.unfocus();
    this.setState(() {
      selectedTab = _sliverTabController!.index;
//      if (selectedTab != 0) {
      sliverBarHeight = 50;
//      } else {
//        sliverBarHeight = 220;
//      }
    });
  }

  Future<bool>? onBackPressed(BuildContext context) {
    // if (widget?.cartType == CartType.RETRY_CART) {
    //   PageNavigator.goToPermanent(context, router.rt_Landing);
    // }
    // Navigator.of(context).pop(true);

    if (Navigator.canPop(context)) {
      Get.back();
    } else {
      Get.offAllNamed(
        router.rt_Landing,
        arguments: LandingArguments(
          needFreshLoad: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //MyProfileModel myProfile;
    landingViewModel = Provider.of<LandingViewModel>(context);

    if (!islogout) fetchUserProfileInfo();

    return WillPopScope(
        onWillPop: () => onBackPressed(context)!,
        child: Scaffold(
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(CommonUtil().getMyPrimaryColor()),
                    Color(CommonUtil().getMyGredientColor()),
                  ],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () => onBackPressed(
                  context), /* {
                Navigator.popUntil(context, (Route<dynamic> route) {
                  if (Navigator.canPop(context)) {
                    bool shouldPop = false;
                    if (route.settings.name == router.rt_Landing ||
                        route.settings == null) {
                      shouldPop = true;
                    }
                    return shouldPop;
                  } else {
                    return true;
                  }
                });
                // Navigator.pop(context);
              } */
            ),
            actions: <Widget>[
              // if (CommonUtil.REGION_CODE != 'IN')
              // if (selectedTab == 1) getSwitchProfileWidget()
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0.h),
              child: TabBar(
                isScrollable: true,
                controller: _sliverTabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2,
                tabs: [
                  Tab(child: Text(variable.strMyInfo, style: getTitleStyle())),
                  Tab(
                      child:
                          Text(variable.strMyFamily, style: getTitleStyle())),
                  Tab(
                      child:
                          Text(variable.strMyProvider, style: getTitleStyle())),
                  Tab(child: Text(variable.strMyPlans, style: getTitleStyle()))
                ],
              ),
            ),
          ),
          body: Container(
            child: TabBarView(
              controller: _sliverTabController,
              children: <Widget>[
                MyProfilePage(),
                MyFamily(),
                MyProvider(),
                MyPlanList()
              ],
            ),
          ),
        ));
  }

  moveToLoginPage() {
    CommonUtil().moveToLoginPage();
  }

  Widget getProfileSwitchWidget() {
    return FutureBuilder<Widget>(
      future: getSwitchIcon(),
      initialData: const SizedBox.shrink(),
      builder: (context, snapshot) {
        return snapshot.data ?? SizedBox();
      },
    );
  }

  Future<Widget> getSwitchIcon() {
    return SwitchProfile().buildActionsNew(context, _key, () {
      setValueForProfile();
      firstTym = false;
      checkIfUserIdSame();
      landingViewModel!.getQurPlanDashBoard(needNotify: true);
      landingViewModel!.checkIfUserIdSame().then((value) {
        isUserMainId = value;
      });
      QurPlanReminders.getTheRemindersFromAPI();

      (context as Element).markNeedsBuild();
      setState(() {});
    }, true, (profileData ?? MyProfileModel())).then((widget) {
      return widget;
    });
  }

  Widget getSwitchProfileWidget() {
    Widget profileWidget = SizedBox();

    return FutureBuilder<MyProfileModel>(
        future: getMyProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null && snapshot.hasData)
              PreferenceUtil.saveProfileData(
                  Constants.KEY_PROFILE_MAIN, snapshot.data);

            imageCache!.clear();
            imageCache!.clearLiveImages();

            profileWidget = getProfileSwitchWidget();
            return profileWidget;
          } else {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                  child: Container(
                      width: 22, height: 22, child: CommonCircularIndicator())),
            );
          }
        });
  }

  void checkIfUserIdSame() async {
    final userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final userIdMain =
        await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    setState(() {
      if (userId != userIdMain) {
        isUserMainId = false;
      } else {
        isUserMainId = true;
      }
    });
  }

  Future<MyProfileModel> getMyProfile() async {
    final userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final userIdMain =
        await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    if (userIdMain != null && userIdMain.isNotEmpty) {
      try {
        MyProfileModel value =
            await addFamilyUserInfoRepository.getMyProfileInfoNew(userIdMain);
        myProfile = value;

        if (value != null) {
          if (value.result!.userProfileSettingCollection3!.isNotEmpty) {
            var profileSetting =
                value.result?.userProfileSettingCollection3![0].profileSetting;
            if (profileSetting?.preferredMeasurement != null) {
              PreferredMeasurement preferredMeasurement =
                  profileSetting!.preferredMeasurement!;
              await PreferenceUtil.saveString(Constants.STR_KEY_HEIGHT,
                      preferredMeasurement.height!.unitCode!)
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
      } catch (e,stackTrace) {
                    CommonUtil().appLogs(message: e,stackTrace:stackTrace);

        CommonUtil().commonMethodToSetPreference();
      }
    } else {
      CommonUtil().logout(moveToLoginPage);
    }
    return myProfile!;
  }

  void setValueForProfile() {
    getMyProfile().then((profile) {
      profileData = profile;
    });
  }

  getTitleStyle() {
    return TextStyle(
      fontSize: CommonUtil().isTablet!
          ? Constants.tabHeader1
          : Constants.mobileHeader1,
      fontWeight: FontWeight.w600,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

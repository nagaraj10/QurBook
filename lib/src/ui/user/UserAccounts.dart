import 'dart:io';
import 'package:get/get.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/myPlan/view/myPlanList.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/my_family/screens/MyFamily.dart';
import 'package:myfhb/my_providers/screens/my_provider.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';

import 'MyProfilePage.dart';

class UserAccounts extends StatefulWidget {
  UserAccountsArguments arguments;

  UserAccounts({this.arguments});

  @override
  _UserAccountsState createState() => _UserAccountsState();
}

class _UserAccountsState extends State<UserAccounts>
    with SingleTickerProviderStateMixin {
  double sliverBarHeight = 220;
  TabController _sliverTabController;
  int selectedTab = 0;
  bool _isEditable = false;
  File imageURIProfile, profileImage;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  MyProfileModel myProfile;
  bool islogout = false;

  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    //fetchUserProfileInfo();
    _sliverTabController = TabController(
        vsync: this, length: 4, initialIndex: widget.arguments.selectedIndex);
    _sliverTabController.addListener(_handleSelected);
  }

  fetchUserProfileInfo() async {
    var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    myProfile = await addFamilyUserInfoRepository.getMyProfileInfoNew(userid);
  }

  void _handleSelected() {
    FocusManager.instance.primaryFocus.unfocus();
    this.setState(() {
      selectedTab = _sliverTabController.index;
//      if (selectedTab != 0) {
      sliverBarHeight = 50;
//      } else {
//        sliverBarHeight = 220;
//      }
    });
  }

  Future<bool> onBackPressed(BuildContext context) {
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
    if (!islogout) fetchUserProfileInfo();

    return new WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: Scaffold(
          backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
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
              // IconButton(
              //     icon: Icon(
              //       Icons.exit_to_app,
              //       size: 24.0.sp,
              //     ),
              //     onPressed: () {
              //       new FHBBasicWidget().exitApp(context, () {
              //         islogout = true;
              //         new CommonUtil().logout(moveToLoginPage);
              //       });
              //     })
              /* selectedTab == 0
                  ? IconButton(
                      icon: _isEditable
                          ? Visibility(visible: false, child: Icon(Icons.save))
                          : Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          if (_isEditable) {
                            _isEditable = false;
                          } else {
                            _isEditable = true;
                            //sliverBarHeight = 50;
                            if (myProfile?.result != null) {
                              Navigator.pushNamed(
                                      context, router.rt_AddFamilyUserInfo,
                                      arguments: AddFamilyUserInfoArguments(
                                          myProfileResult: myProfile?.result,
                                          fromClass:
                                              CommonConstants.user_update))
                                  .then((value) {
                                setState(() {
                                  _isEditable = false;
                                });
                              });
                            } else {
                              FlutterToast().getToast(
                                  'Unable to Fetch User Profile data',
                                  Colors.red);
                              setState(() {
                                _isEditable = false;
                              });
                            }
                          }
                          sliverBarHeight = 220;
                        });
                      })
                  : Container(
                      height: 0.0.h,
                      width: 0.0.h,
                    )*/
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
                  Tab(text: variable.strMyInfo),
                  Tab(text: variable.strMyFamily),
                  Tab(text: variable.strMyProvider),
                  Tab(text: variable.strMyPlans)
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
    new CommonUtil().moveToLoginPage();
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
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

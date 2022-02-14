import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/IntroScreens/IntroWidget.dart';
import 'package:myfhb/Orders/View/OrdersView.dart';
import 'package:myfhb/QurHub/hub_list_screen.dart';

import 'package:myfhb/claim/screen/ClaimList.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/landing/view/widgets/help_support.dart';
import 'package:myfhb/my_reports/view/my_report_screen.dart';
import 'package:myfhb/user_plans/view/user_profile_image.dart';
import '../../../colors/fhb_colors.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/FHBBasicWidget.dart';
import '../../../more_menu/screens/more_menu_screen.dart';
import '../../../src/model/user/MyProfileModel.dart';
import '../../../src/model/user/user_accounts_arguments.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import 'drawer_tile.dart';
import '../../../constants/variable_constant.dart' as variable;
import '../../../authentication/constants/constants.dart';
import '../../../constants/router_variable.dart' as router;

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer(
      {@required this.myProfile,
      @required this.moveToLoginPage,
      @required this.refresh,
      @required this.userChangedbool});

  final MyProfileModel myProfile;
  final Function moveToLoginPage;
  final Function(bool userChanged) refresh;
  final bool userChangedbool;

  @override
  Widget build(BuildContext context) {
    print('*********************************');
    print(userChangedbool);
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: AppBar().preferredSize.height,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0.w,
                        right: 20.0.w,
                        bottom: 20.0.h,
                      ),
                      child: Column(
                        children: [
                          AssetImageWidget(
                            icon: myFHB_logo,
                            height: 100.0.h,
                            width: 100.0.h,
                          ),
                          SizedBox(
                            height: 20.0.h,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 70.0.h,
                                width: 70.0.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: UserProfileImage(
                                  myProfile,
                                  textColor:
                                      Color(CommonUtil().getMyPrimaryColor()),
                                  circleColor: Color(bgColorContainer),
                                ),
                              ),
                              SizedBox(
                                width: 10.0.w,
                              ),
                              getNameWidget(),
                            ],
                          )
                        ],
                      ),
                    ),
                    DrawerTile(
                      title: variable.strProfile,
                      icon: variable.icon_profile,
                      onPressed: () async {
                        Navigator.pop(context);
                        await Navigator.pushNamed(
                          context,
                          router.rt_UserAccounts,
                          arguments: UserAccountsArguments(
                            selectedIndex: 0,
                          ),
                        );
                        if (refresh != null) {
                          refresh(true);
                        }
                      },
                    ),
                    // DrawerTile(
                    //   title: variable.strMyRecords,
                    //   icon: variable.icon_records,
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //     Navigator.pushNamed(
                    //       context,
                    //       router.rt_MyRecords,
                    //       arguments: MyRecordsArgument(),
                    //     );
                    //   },
                    // ),
                    DrawerTile(
                      title: variable.strMyProvider,
                      icon: variable.icon_provider,
                      onPressed: () async {
                        Navigator.pop(context);
                        await Navigator.pushNamed(
                          context,
                          router.rt_UserAccounts,
                          arguments: UserAccountsArguments(
                            selectedIndex: 2,
                          ),
                        );
                        if (refresh != null) {
                          refresh(true);
                        }
                      },
                    ),
                    DrawerTile(
                      title: variable.strMyFamily,
                      iconWidget: SvgPicture.asset(
                        variable.icon_my_family_menu,
                        color: Colors.black54,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await Navigator.pushNamed(
                          context,
                          router.rt_UserAccounts,
                          arguments: UserAccountsArguments(
                            selectedIndex: 1,
                          ),
                        );
                        if (refresh != null) {
                          refresh(true);
                        }
                      },
                    ),
                    //QurHub
                    DrawerTile(
                      title: variable.strQurHub,
                      iconWidget: SvgPicture.asset(
                        variable.icon_qurhub,
                        color: Colors.black54,
                      ),
                      onPressed: () async {
                        try {
                          Navigator.pop(context);
                          Get.to(
                            HubListScreen(),
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                    DrawerTile(
                      title: variable.strMyOrders,
                      iconWidget: Image.asset(
                        variable.icon_orderHistory,
                        color: Colors.black54,
                        width: 24.sp,
                        height: 24.sp,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(
                          OrdersView(),
                        );
                      },
                    ),
                    DrawerTile(
                      title: variable.strSettings,
                      iconWidget: SvgPicture.asset(
                        variable.icon_settings,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreMenuScreen(
                              refresh: refresh,
                            ),
                          ),
                        );
                      },
                    ),
                    DrawerTile(
                      title: HELP_SUPPORT,
                      iconWidget: Image.asset(
                        variable.icon_help_support,
                        color: Colors.black54,
                        width: 24.sp,
                        height: 24.sp,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpSupport(),
                          ),
                        );
                      },
                    ),
                    DrawerTile(
                      title: variable.strRefer_friend,
                      // iconWidget: SvgPicture.asset(
                      //   variable.icon_logout,
                      //   color: Colors.black54,
                      // ),
                      iconWidget: Image.asset(
                        variable.icon_refer_friend_icon,
                        width: 24.sp,
                        height: 24.sp,
                      ),
                      onPressed: () {
                        CommonUtil().accessContactsDialog();
                        Navigator.pop(context);
                      },
                    ),
                    DrawerTile(
                      title: variable.strReports,
                      /*iconWidget: SvgPicture.asset(
                          variable.icon_settings,
                          color: Colors.black54,
                        ),*/
                      iconWidget: Image.asset(
                        variable.icon_report_icon,
                        width: 24.sp,
                        height: 24.sp,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportListScreen(),
                          ),
                        );
                      },
                    ),
                    Visibility(
                        child: DrawerTile(
                          title: variable.strMyClaims,
                          /*iconWidget: SvgPicture.asset(
                          variable.icon_settings,
                          color: Colors.black54,
                        ),*/
                          iconWidget: SvgPicture.asset(
                            variable.icon_claim,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClaimList(),
                              ),
                            );
                          },
                        ),
                        visible: userChangedbool),
                    DrawerTile(
                      title: variable.strLogout,
                      iconWidget: SvgPicture.asset(
                        variable.icon_logout,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        FHBBasicWidget().exitApp(context, () {
                          CommonUtil().logout(moveToLoginPage);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getNameWidget() {
    var name = toBeginningOfSentenceCase((myProfile?.result?.name != null &&
            myProfile?.result?.name != '')
        ? myProfile?.result?.name?.capitalizeFirstofEach
        : myProfile?.result?.firstName != null &&
                myProfile?.result?.lastName != null
            ? ('${myProfile?.result?.firstName?.capitalizeFirstofEach ?? ''} ${myProfile?.result?.lastName?.capitalizeFirstofEach}')
            : '');
    final phoneNumber =
        (myProfile?.result?.userContactCollection3?.length ?? 0) > 0
            ? myProfile?.result?.userContactCollection3[0].phoneNumber
            : '';

    return Flexible(
      child: RichText(
        text: TextSpan(
          text: name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0.sp,
          ),
          children: ((phoneNumber != null && phoneNumber != ''))
              ? [
                  TextSpan(
                    text: '\n$phoneNumber',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0.sp,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

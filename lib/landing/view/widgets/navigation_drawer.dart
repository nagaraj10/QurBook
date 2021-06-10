import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/more_menu/screens/more_menu_screen.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/landing/view/widgets/drawer_tile.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/constants/router_variable.dart' as router;

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({
    @required this.myProfile,
    @required this.moveToLoginPage,
  });

  final MyProfileModel myProfile;
  final Function moveToLoginPage;

  @override
  Widget build(BuildContext context) => Drawer(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  height: 50.0.h,
                                  width: 50.0.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: FHBBasicWidget()
                                        .getProfilePicWidgeUsingUrlForProfile(
                                      myProfile,
                                    ),
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
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            router.rt_UserAccounts,
                            arguments: UserAccountsArguments(
                              selectedIndex: 0,
                            ),
                          );
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
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            router.rt_UserAccounts,
                            arguments: UserAccountsArguments(
                              selectedIndex: 2,
                            ),
                          );
                        },
                      ),
                      DrawerTile(
                        title: variable.strMyFamily,
                        iconWidget: SvgPicture.asset(
                          variable.icon_my_family,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            router.rt_UserAccounts,
                            arguments: UserAccountsArguments(
                              selectedIndex: 1,
                            ),
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
                              builder: (context) => MoreMenuScreen(),
                            ),
                          );
                        },
                      ),
                      DrawerTile(
                        title: variable.strLogout,
                        iconWidget: SvgPicture.asset(
                          variable.icon_logout,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          new FHBBasicWidget().exitApp(context, () {
                            new CommonUtil().logout(moveToLoginPage);
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

  Widget getNameWidget() {
    final name = toBeginningOfSentenceCase((myProfile?.result?.name != null &&
            myProfile?.result?.name != '')
        ? myProfile?.result?.name?.capitalizeFirstofEach
        : myProfile?.result?.firstName != null &&
                myProfile?.result?.lastName != null
            ? ('${myProfile?.result?.firstName?.capitalizeFirstofEach ?? ''} ${myProfile?.result?.lastName?.capitalizeFirstofEach}')
            : '');
    var phoneNumber =
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
          children: (phoneNumber?.isNotEmpty ?? '')
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

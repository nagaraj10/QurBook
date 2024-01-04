import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:myfhb/Orders/View/OrdersView.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';

import 'package:myfhb/claim/screen/ClaimList.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/landing/view/widgets/help_support.dart';
import 'package:myfhb/my_reports/view/my_report_screen.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsMain.dart';
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

class QurHomeNavigationDrawer extends StatelessWidget {
  const QurHomeNavigationDrawer(
      {required this.myProfile,
      required this.moveToLoginPage,
      required this.refresh,
      required this.userChangedbool,
      required this.showPatientList});

  final MyProfileModel? myProfile;
  final Function() moveToLoginPage;
  final Function(bool userChanged)? refresh;
  final bool? userChangedbool;
  final Function() showPatientList;

  @override
  Widget build(BuildContext context) {
    // print('*********************************');
    // print(userChangedbool);
    return Container(
      width: CommonUtil().isTablet!
          ? MediaQuery.of(context).size.width * 0.75
          : null,
      child: Drawer(
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
                              height:
                                  CommonUtil().isTablet! ? 110.0.h : 100.0.h,
                              width: CommonUtil().isTablet! ? 110.0.h : 100.0.h,
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  height:
                                      CommonUtil().isTablet! ? 75.0.h : 70.0.h,
                                  width:
                                      CommonUtil().isTablet! ? 75.0.h : 70.0.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: UserProfileImage(
                                    PreferenceUtil.getProfileData(KEY_PROFILE),
                                    textColor:
                                        Color(CommonUtil().getMyPrimaryColor()),
                                    circleColor: Color(bgColorContainer),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0.w,
                                ),
                                getNameWidget(),
                                SizedBox(
                                  width: 20.0.w,
                                ),
                                if (CommonUtil.isUSRegion())
                                  getProfileSwitchWidget()
                                /*   InkWell(
                                      child: Image.asset(
                                        variable.icon_switch,
                                        height: 26.0.h,
                                        width: 26.0.h,
                                      ),
                                      onTap: () {
                                        showPatientList();
                                      })*/
                              ],
                            )
                          ],
                        ),
                      ),
                      DrawerTile(
                        title: variable.strProfile,
                        icon: variable.icon_profile,
                        onPressed: () async {
                          try {
                            setQurhomeDashboardFalse();
                            Get.back();
                            if (Get.isRegistered<QurhomeDashboardController>())
                              Get.find<QurhomeDashboardController>()
                                  .updateBLETimer(Enable: false);

                            Get.to(UserAccounts(
                              arguments:
                                  UserAccountsArguments(selectedIndex: 0),
                            ));
                          } catch (e, stackTrace) {
                            CommonUtil()
                                .appLogs(message: e, stackTrace: stackTrace);

                            //print(e);
                          }
                        },
                      ),
                      DrawerTile(
                        title: variable.strAppointments,
                        icon: variable.icon_th,
                        onPressed: () async {
                          try {
                            setQurhomeDashboardFalse();
                            clearControllerValues();
                            Get.back();
                            Get.to(AppointmentsMain(isFromQurday: true));
                          } catch (e, stackTrace) {
                            CommonUtil()
                                .appLogs(message: e, stackTrace: stackTrace);

                            //print(e);
                          }
                        },
                      ),
                      DrawerTile(
                        title: variable.strMyRecords,
                        icon: variable.icon_records,
                        onPressed: () async {
                          try {
                            setQurhomeDashboardFalse();
                            Get.back();
                            if (Get.isRegistered<QurhomeDashboardController>())
                              Get.find<QurhomeDashboardController>()
                                  .updateBLETimer(Enable: false);
                            clearControllerValues();

                            Get.to(MyRecords(
                              argument: MyRecordsArgument(),
                            ));
                          } catch (e, stackTrace) {
                            CommonUtil()
                                .appLogs(message: e, stackTrace: stackTrace);

                            //print(e);
                          }
                        },
                      ),
                      // DrawerTile(
                      //   title: variable.strMyRecords,
                      //   icon: variable.icon_records,
                      //   onPressed: () {
                      //     Get.back();
                      //     Navigator.pushNamed(
                      //       context,
                      //       router.rt_MyRecords,
                      //       arguments: MyRecordsArgument(),
                      //     );
                      //   },
                      // ),
                      /*DrawerTile(
                        title: variable.strMyProvider,
                        icon: variable.icon_provider,
                        onPressed: () async {
                          try {
                            Get.back();
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
                          } catch (e,stackTrace) {
                            //print(e);
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
                          try {
                            Get.back();
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
                          } catch (e,stackTrace) {
                            //print(e);
                          }
                        },
                      ),*/
                      //QurHub
                      /*DrawerTile(
                        title: variable.strConnectedDevices,
                        iconWidget: SvgPicture.asset(
                          variable.icon_connected_device,
                          color: Colors.black54,
                        ),
                        onPressed: () async {
                          try {
                            Get.back();
                            // Get.to(
                            //   () => HubListScreen(),
                            //   binding: BindingsBuilder(
                            //     () {
                            //       if (!Get.isRegistered<
                            //           HubListController>()) {
                            //         Get.lazyPut(
                            //           () => HubListController(),
                            //         );
                            //       }
                            //     },
                            //   ),
                            // );
                            Get.to(
                              () => HubListView(),
                              binding: BindingsBuilder(
                                () {
                                  if (!Get.isRegistered<
                                      HubListViewController>()) {
                                    Get.lazyPut(
                                      () => HubListViewController(),
                                    );
                                  }
                                },
                              ),
                            );
                          } catch (e,stackTrace) {
                            //print(e);
                          }
                        },
                      ),*/
                      Visibility(
                        visible: CommonUtil.REGION_CODE == 'IN',
                        child: DrawerTile(
                          title: variable.strMyOrders,
                          iconWidget: Image.asset(
                            variable.icon_orderHistory,
                            color: Colors.black54,
                            width: 24.sp,
                            height: 24.sp,
                          ),
                          onPressed: () {
                            try {
                              setQurhomeDashboardFalse();
                              Get.back();
                              if (Get.isRegistered<
                                  QurhomeDashboardController>())
                                Get.find<QurhomeDashboardController>()
                                    .updateBLETimer(Enable: false);

                              Get.to(() => OrdersView());
                            } catch (e, stackTrace) {
                              CommonUtil()
                                  .appLogs(message: e, stackTrace: stackTrace);

                              //print(e);
                            }
                          },
                        ),
                      ),
                      DrawerTile(
                        title: variable.strSettings,
                        iconWidget: SvgPicture.asset(
                          variable.icon_settings,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setQurhomeDashboardFalse();
                          try {
                            clearControllerValues();
                            if (Get.isRegistered<QurhomeDashboardController>())
                              Get.find<QurhomeDashboardController>()
                                  .updateBLETimer(Enable: false);
                            Get.back();
                            Navigator.pushNamed(context, router.rt_more_menu,
                                    arguments: refresh)
                                .then((value) {});
                            // Get.to(() => MoreMenuScreen(refresh: refresh));
                          } catch (e, stackTrace) {
                            CommonUtil()
                                .appLogs(message: e, stackTrace: stackTrace);

                            //print(e);
                          }
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
                          try {
                            setQurhomeDashboardFalse();
                            clearControllerValues();

                            Get.back();
                            Get.to(() => HelpSupport());
                          } catch (e, stackTrace) {
                            CommonUtil()
                                .appLogs(message: e, stackTrace: stackTrace);

                            //print(e);
                          }
                        },
                      ),
                      DrawerTile(
                        title: variable.strRefer_friend,
                        isGreyout: true,
                        // iconWidget: SvgPicture.asset(
                        //   variable.icon_logout,
                        //   color: Colors.black54,
                        // ),
                        iconWidget: Image.asset(
                          variable.icon_refer_friend_icon,
                          color: Colors.grey,
                          width: 24.sp,
                          height: 24.sp,
                        ),
                        onPressed: () {
                          setQurhomeDashboardFalse();
                          /*try {
                            Get.back();
                            CommonUtil().accessContactsDialog();
                          } catch (e,stackTrace) {
                            //print(e);
                          }*/
                        },
                      ),
                      DrawerTile(
                        title: variable.strAdvancedRegimen,
                        iconWidget: SvgPicture.asset(
                          variable.icon_my_family_menu,
                          color: Colors.black54,
                        ),
                        onPressed: () async {
                          setQurhomeDashboardFalse();
                          clearControllerValues();

                          Get.back();
                          if (Get.isRegistered<QurhomeDashboardController>())
                            Get.find<QurhomeDashboardController>()
                                .updateBLETimer(Enable: false);

                          await Navigator.pushNamed(context, router.rt_Regimen);
                        },
                      ),
                      Visibility(
                        visible: CommonUtil.REGION_CODE == 'IN',
                        child: DrawerTile(
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
                            try {
                              setQurhomeDashboardFalse();
                              Get.back();
                              if (Get.isRegistered<
                                  QurhomeDashboardController>())
                                Get.find<QurhomeDashboardController>()
                                    .updateBLETimer(Enable: false);

                              Get.to(() => ReportListScreen());
                            } catch (e, stackTrace) {
                              CommonUtil()
                                  .appLogs(message: e, stackTrace: stackTrace);

                              //print(e);
                            }
                          },
                        ),
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
                              try {
                                setQurhomeDashboardFalse();
                                Get.back();
                                if (Get.isRegistered<
                                    QurhomeDashboardController>())
                                  Get.find<QurhomeDashboardController>()
                                      .updateBLETimer(Enable: false);

                                Get.to(() => ClaimList());
                              } catch (e, stackTrace) {
                                CommonUtil().appLogs(
                                    message: e, stackTrace: stackTrace);

                                //print(e);
                              }
                            },
                          ),
                          visible: userChangedbool! &&
                              CommonUtil.REGION_CODE == 'IN'),
                      DrawerTile(
                        title: variable.strLogout,
                        iconWidget: SvgPicture.asset(
                          variable.icon_logout,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          FHBBasicWidget().exitApp(context, () {
                            if (Get.isRegistered<QurhomeDashboardController>())
                              Get.find<QurhomeDashboardController>()
                                  .updateBLETimer(Enable: false);
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
      ),
    );
  }

  Widget getNameWidget() {
    MyProfileModel myProfile;
    String? name = "";
    var phoneNumber = "";

    try {
      myProfile = PreferenceUtil.getProfileData(KEY_PROFILE)!;
      if (myProfile.result?.firstName != null &&
          myProfile.result?.firstName != "") {
        name = '${myProfile.result?.firstName?.capitalizeFirstofEach} ';
      }
      if (myProfile.result?.lastName != null &&
          myProfile.result?.lastName != "") {
        name += '${myProfile.result?.lastName?.capitalizeFirstofEach}';
      }

      phoneNumber = (myProfile.result!.userContactCollection3!.length) > 0
          ? myProfile.result!.userContactCollection3![0]!.phoneNumber!
          : '';
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      //print(e);
    }

    return Flexible(
      child: RichText(
        text: TextSpan(
          text: name,
          style: TextStyle(
            color: Colors.black,
            fontSize: CommonUtil().isTablet! ? 20.0.sp : 18.0.sp,
          ),
          children: ((phoneNumber != null && phoneNumber != ''))
              ? [
                  TextSpan(
                    text: '\n$phoneNumber',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: CommonUtil().isTablet! ? 18.0.sp : 16.0.sp,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  void clearControllerValues() {
    /* final controller = Get.put(QurhomeDashboardController());

    controller.currentSelectedTab.value = 0;

    controller.forPatientList.value = false;
    controller.isPatientClicked.value = false;
    controller.careGiverPatientListResult = null;
    */
  }

  Widget getProfileSwitchWidget() {
    return FutureBuilder<bool>(
      future: CommonUtil().checkIfUserIdSame(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot?.data ?? false) {
            return InkWell(
                child: Image.asset(
                  variable.icon_switch,
                  height: 26.0.h,
                  width: 26.0.h,
                ),
                onTap: () {
                  showPatientList();
                });
          } else {
            return SizedBox();
          }
        } else {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
                child: Container(
                    width: 22, height: 22, child: CommonCircularIndicator())),
          );
        }
      },
    );
  }

  void setQurhomeDashboardFalse() {
    CommonUtil()
        .onInitQurhomeDashboardController()
        .setActiveQurhomeDashboardToChat(status: false);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/firebase_analytics_service.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../authentication/constants/constants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/router_variable.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../regiment/view_model/regiment_view_model.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import '../model/myPlanListModel.dart';
import '../viewModel/myPlanViewModel.dart';
import 'myPlanDetail.dart';

class MyPlanList extends StatefulWidget {
  MyPlanList({
    this.fromDashBoard = false,
  });

  bool fromDashBoard;

  @override
  _MyPlanState createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlanList> {
  MyPlanListModel? myPlanListModel;
  MyPlanViewModel myPlanViewModel = MyPlanViewModel();
  bool isSearch = false;
  List<MyPlanListResult> myPLanListResult = [];
  final GlobalKey _GotoRegimentKey = GlobalKey();
  final GlobalKey _PlanCardKey = GlobalKey();
  late bool isFirst;
  bool addplanbutton = false;
  bool showRenewOrSubscribeButton = false;
  late BuildContext _myContext;
  @override
  void initState() {
    super.initState();
    mInitialTime = DateTime.now();
    FocusManager.instance.primaryFocus!.unfocus();
    getConfiguration();
    if (widget.fromDashBoard) {
      Provider.of<RegimentViewModel>(
        context,
        listen: false,
      ).updateTabIndex(currentIndex: 3);
    }
    Provider.of<PlanWizardViewModel>(context, listen: false).getCreditBalance();
    Provider.of<PlanWizardViewModel>(context, listen: false).fetchCartItem();
    Provider.of<PlanWizardViewModel>(context, listen: false).updateCareCount();
    Provider.of<PlanWizardViewModel>(context, listen: false).updateDietCount();

    PreferenceUtil.init();

    isFirst = PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_MyPlan);
    try {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Future.delayed(
            Duration(milliseconds: 1000),
            () => isFirst
                ? null
                : ShowCaseWidget.of(_myContext)!.startShowCase([_PlanCardKey]));
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<void> getConfiguration() async {
    bool? addplanbutton = await PreferenceUtil.getAddPlanBtn();
    bool? showRenewOrSubscribeButton =
        await PreferenceUtil.getUnSubscribeValue();
    print('addplanbtn: ' + addplanbutton.toString());
    setState(() {
      this.addplanbutton = addplanbutton ?? false;
      this.showRenewOrSubscribeButton = showRenewOrSubscribeButton ?? false;
    });
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus!.unfocus();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'MyPlans Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(onFinish: () {
      PreferenceUtil.saveString(
          Constants.KEY_SHOWCASE_MyPlan, variable.strtrue);
    }, builder: Builder(builder: (context) {
      _myContext = context;
      return Scaffold(
          floatingActionButton: addplanbutton
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    var firebase = FirebaseAnalyticsService();
                    firebase.trackEvent("on_add_plan_button_click", {
                      "user_id": PreferenceUtil.getStringValue(KEY_USERID_MAIN)
                    });

                    // await Get.toNamed(rt_Diseases);
                    await Get.toNamed(rt_PlanWizard)!.then((value) =>
                        FocusManager.instance.primaryFocus!.unfocus());
                  },
                  backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(strAddPlan,
                      style: TextStyle(
                          fontSize: (CommonUtil().isTablet ?? false)
                              ? tabFontTitle
                              : mobileFontTitle,
                          color: Colors.white)),
                )
              : Container(),
          body: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                  child: Column(
                children: [
                  SearchWidget(
                    onChanged: (providerName) {
                      if (providerName != '' && providerName.length > 2) {
                        isSearch = true;
                        onSearchedNew(providerName);
                      } else {
                        setState(() {
                          isSearch = false;
                        });
                      }
                    },
                    onClosePress: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  Expanded(
                    child: myPlanListModel != null
                        ? hospitalList(myPlanListModel!.result)
                        : getPlanList(),
                  )
                ],
              )),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: EdgeInsets.only(
              //       bottom: 20.0.h,
              //     ),
              //     child: getTheRegimen(),
              //   ),
              // ),
            ],
          ));
    }));
  }

  onSearchedNew(String doctorName) async {
    myPLanListResult.clear();
    if (doctorName != null) {
      myPLanListResult = myPlanViewModel.getProviderSearch(doctorName);
    }
    setState(() {});
  }

  Widget getTheRegimen() {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.0.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FHBBasicWidget.customShowCase(
              _GotoRegimentKey,
              Constants.GoToRegimentDescription,
              ElevatedButton(style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(
                  10.0.sp,
                ),),
                onPressed: () async {
                  Provider.of<RegimentViewModel>(
                    context,
                    listen: false,
                  ).updateTabIndex(currentIndex: 0);
                  Provider.of<RegimentViewModel>(
                    context,
                    listen: false,
                  ).regimentMode = RegimentMode.Schedule;
                  Provider.of<RegimentViewModel>(
                    context,
                    listen: false,
                  ).regimentFilter = RegimentFilter.Scheduled;
                  await Get.toNamed(rt_Regimen);
                },
                child: TextWidget(
                  text: goToRegimen,
                  fontsize: 14.0.sp,
                ),
              ),
              Constants.DailyRegimen),
        ],
      ),
    );
  }

  Widget hospitalList(List<MyPlanListResult>? planList) {
    return (planList != null && planList.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (ctx, i) {
              return i != 0
                  ? myPlanListItem(
                      ctx, i, isSearch ? myPLanListResult : planList)
                  : FHBBasicWidget.customShowCase(
                      _PlanCardKey,
                      Constants.MyPlanCard,
                      myPlanListItem(
                          ctx, i, isSearch ? myPLanListResult : planList),
                      Constants.SubscribedPlans);
            },
            itemCount: isSearch ? myPLanListResult.length : planList.length,
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  child: Center(
                child: CommonUtil.REGION_CODE == 'IN'
                    ? Text(
                        variable.strNoPlans,
                        style: TextStyle(
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader2
                                : mobileHeader2),
                      )
                    : Text(variable.strNoPlansUS,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 20.0.sp, color: Colors.black)),
              )),
            ),
          );
  }

  Widget getPlanList() {
    return FutureBuilder<MyPlanListModel?>(
      future: myPlanViewModel.getMyPlanList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: CommonCircularIndicator(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          if (snapshot.hasData &&
              snapshot.data!.result != null &&
              snapshot.data!.result!.isNotEmpty) {
            return hospitalList(snapshot.data!.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: CommonUtil.REGION_CODE == 'IN'
                      ? Text(variable.strNoPlans,
                          style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader2
                                  : mobileHeader2))
                      : Text(variable.strNoPlansUS,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0.sp, color: Colors.black)),
                )),
              ),
            );
          }
        }
      },
    );
  }

  Widget myPlanListItem(
      BuildContext context, int i, List<MyPlanListResult> planList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyPlanDetail(
                    packageId: planList[i].packageid,
                    // title: planList[i].title,
                    // providerName: planList[i].providerName,
                    // docName: planList[i].docNick,
                    // isExpired: planList[i].isexpired,
                    // startDate: planList[i].startdate,
                    // endDate: planList[i].enddate,
                    // icon: planList[i]?.metadata?.icon,
                    // catIcon: planList[i]?.catmetadata?.icon,
                    // providerIcon: planList[i]?.providermetadata?.icon,
                    // descriptionURL: planList[i]?.metadata?.descriptionURL,
                    // price: planList[i]?.price,
                    // isExtendable: planList[i]?.isExtendable,
                  )),
        ).then((value) {
          FocusManager.instance.primaryFocus!.unfocus();
          if (value == 'refreshUI') {
            setState(() {});
          }
        });
      },
      child: Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFe3e2e2),
                blurRadius: 16, // has the effect of softening the shadow
                spreadRadius: 5, // has the effect of extending the shadow
                offset: Offset(
                  0, // horizontal, move right 10
                  0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.0.w,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 20.h,
                    child: CommonUtil().customImage(
                      getImage(i, planList),
                      planInitial: planList[i].providerName ?? '',
                    ),
                  ),
                  SizedBox(
                    width: 20.0.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          planList[i].title != null
                              ? toBeginningOfSentenceCase(planList[i].title)!
                              : '',
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 180.0.w,
                              child: Text(
                                planList[i].providerName != null
                                    ? toBeginningOfSentenceCase(
                                        planList[i].providerName)!
                                    : '',
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.lightgraycolor),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Start Date: ',
                                  style: TextStyle(
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  CommonUtil().dateFormatConversion(
                                      planList[i].startdate),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (planList[i].tags != strMemb)
                    Row(
                      children: [
                        showRenewOrSubscribeButton
                            ? Column(
                                children: [
                                  Align(
                                    child: SizedBoxWithChild(
                                      height: 32.0.h,
                                      child: ElevatedButton(style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            side: BorderSide(
                                                color: planList[i].isexpired ==
                                                        '1'
                                                    ? Color(CommonUtil()
                                                        .getMyPrimaryColor())
                                                    : Colors.red)),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: planList[i].isexpired == '1'
                                            ? Color(CommonUtil()
                                                .getMyPrimaryColor())
                                            : Colors.red,
                                        padding: EdgeInsets.all(
                                          8.0.sp,
                                        ),),
                                        onPressed: () async {
                                          if (planList[i].isexpired == '1') {
                                            if (planList[i].ispublic == '0') {
                                              FlutterToast().getToast(
                                                "Please contact your care coordinator for renewal",
                                                Colors.red,
                                              );
                                            } else {
                                              await CommonUtil().renewAlertDialog(
                                                  context,
                                                  packageId:
                                                      planList[i].packageid,
                                                  price: planList[i].price,
                                                  startDate:
                                                      planList[i].startdate,
                                                  endDate: planList[i].enddate,
                                                  isExpired: true,
                                                  packageDuration:
                                                      planList[i].duration,
                                                  IsExtendable: planList[i]
                                                              .isExtendable ==
                                                          '1'
                                                      ? true
                                                      : false, refresh: () {
                                                setState(() {});
                                              });
                                            }
                                          } else {
                                            if (planList[i].price == '0') {
                                              await CommonUtil()
                                                  .unSubcribeAlertDialog(
                                                      context,
                                                      packageId:
                                                          planList[i].packageid,
                                                      refresh: () {
                                                setState(() {});
                                              });
                                            } else {
                                              await CommonUtil()
                                                  .alertDialogForNoReFund(
                                                      context,
                                                      packageId:
                                                          planList[i].packageid,
                                                      refresh: () {
                                                setState(() {});
                                              });
                                            }
                                          }
                                        },
                                        child: TextWidget(
                                          text: planList[i].isexpired == '1'
                                              ? (planList[i].ispublic == '0'
                                                  ? strExpired
                                                  : strIsRenew)
                                              : strUnSubscribe,
                                          fontsize: 12.0.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Align(
                                    child: SizedBoxWithChild(
                                      height: 32.0.h,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              side: BorderSide(
                                                  color: planList[i]
                                                              .isexpired ==
                                                          '1'
                                                      ? Colors.red
                                                      : Color(CommonUtil()
                                                          .getMyPrimaryColor()))),
                                          backgroundColor: Colors.transparent,
                                          foregroundColor:
                                              planList[i].isexpired == '1'
                                                  ? Colors.red
                                                  : Color(CommonUtil()
                                                      .getMyPrimaryColor()),
                                          padding: EdgeInsets.all(
                                            8.0.sp,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: TextWidget(
                                          text: planList[i].isexpired == '1'
                                              ? strExpired
                                              : strActive,
                                          fontsize: 12.0.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(width: 4.w),
                      ],
                    )
                ],
              ),
              SizedBox(height: 5.h),
            ],
          )),
    );
  }

  String getImage(int i, List<MyPlanListResult> planList) {
    String? image = '';
    if (planList[i] != null) {
      if (planList[i].metadata != null && planList[i].metadata != '') {
        if (planList[i].metadata!.icon != null &&
            planList[i].metadata!.icon != '') {
          image = planList[i].metadata!.icon;
        } else {
          if (planList[i].catmetadata != null &&
              planList[i].catmetadata != '') {
            if (planList[i].catmetadata!.icon != null &&
                planList[i].catmetadata!.icon != '') {
              image = planList[i].catmetadata!.icon;
            } else {
              if (planList[i].providermetadata != null &&
                  planList[i].providermetadata != '') {
                if (planList[i].providermetadata!.icon != null &&
                    planList[i].providermetadata!.icon != '') {
                  image = planList[i].providermetadata!.icon;
                } else {
                  image = '';
                }
              } else {
                image = '';
              }
            }
          } else {
            if (planList[i].providermetadata != null &&
                planList[i].providermetadata != '') {
              if (planList[i].providermetadata!.icon != null &&
                  planList[i].providermetadata!.icon != '') {
                image = planList[i].providermetadata!.icon;
              } else {
                image = '';
              }
            } else {
              image = '';
            }
          }
        }
      } else {
        if (planList[i].catmetadata != null && planList[i].catmetadata != '') {
          if (planList[i].catmetadata!.icon != null &&
              planList[i].catmetadata!.icon != '') {
            image = planList[i].catmetadata!.icon;
          } else {
            if (planList[i].providermetadata != null &&
                planList[i].providermetadata != '') {
              if (planList[i].providermetadata!.icon != null &&
                  planList[i].providermetadata!.icon != '') {
                image = planList[i].providermetadata!.icon;
              } else {
                image = '';
              }
            } else {
              image = '';
            }
          }
        } else {
          if (planList[i].providermetadata != null &&
              planList[i].providermetadata != '') {
            if (planList[i].providermetadata!.icon != null &&
                planList[i].providermetadata!.icon != '') {
              image = planList[i].providermetadata!.icon;
            } else {
              image = '';
            }
          } else {
            image = '';
          }
        }
      }
    } else {
      if (planList[i].catmetadata != null && planList[i].catmetadata != '') {
        if (planList[i].catmetadata!.icon != null &&
            planList[i].catmetadata!.icon != '') {
          image = planList[i].catmetadata!.icon;
        } else {
          if (planList[i].providermetadata != null &&
              planList[i].providermetadata != '') {
            if (planList[i].providermetadata!.icon != null &&
                planList[i].providermetadata!.icon != '') {
              image = planList[i].providermetadata!.icon;
            } else {
              image = '';
            }
          } else {
            image = '';
          }
        }
      } else {
        if (planList[i].providermetadata != null &&
            planList[i].providermetadata != '') {
          if (planList[i].providermetadata!.icon != null &&
              planList[i].providermetadata!.icon != '') {
            image = planList[i].providermetadata!.icon;
          } else {
            image = '';
          }
        } else {
          image = '';
        }
      }
    }

    return image!;
  }
}

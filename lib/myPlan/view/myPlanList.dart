import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/router_variable.dart';
import '../../constants/variable_constant.dart' as variable;
import '../model/myPlanListModel.dart';
import 'myPlanDetail.dart';
import '../viewModel/myPlanViewModel.dart';
import '../../regiment/view_model/regiment_view_model.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class MyPlanList extends StatefulWidget {
  MyPlanList({
    this.fromDashBoard = false,
  });

  bool fromDashBoard;

  @override
  _MyPlanState createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlanList> {
  MyPlanListModel myPlanListModel;
  MyPlanViewModel myPlanViewModel = MyPlanViewModel();
  bool isSearch = false;
  List<MyPlanListResult> myPLanListResult = [];
  final GlobalKey _GotoRegimentKey = GlobalKey();
  final GlobalKey _PlanCardKey = GlobalKey();
  bool isFirst;
  BuildContext _myContext;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus.unfocus();
    if (widget.fromDashBoard) {
      Provider.of<RegimentViewModel>(
        context,
        listen: false,
      ).updateTabIndex(currentIndex: 3);
    }
    PreferenceUtil.init();

    isFirst = PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_MyPlan);
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(
            Duration(milliseconds: 1000),
            () => isFirst
                ? null
                : ShowCaseWidget.of(_myContext).startShowCase([_PlanCardKey]));
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus.unfocus();
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
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              //TODO: Uncomment for actual plans screen
              // await Get.toNamed(rt_Diseases);
              await Get.toNamed(rt_PlanWizard);
            },
            elevation: 2,
            backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
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
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  Expanded(
                    child: myPlanListModel != null ?? myPlanListModel.isSuccess
                        ? hospitalList(myPlanListModel.result)
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
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                color: Color(CommonUtil().getMyPrimaryColor()),
                textColor: Colors.white,
                padding: EdgeInsets.all(
                  10.0.sp,
                ),
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

  Widget hospitalList(List<MyPlanListResult> planList) {
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
                child: Text(variable.strNoPlans),
              )),
            ),
          );
  }

  Widget getPlanList() {
    return FutureBuilder<MyPlanListModel>(
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
                  child: CircularProgressIndicator(
                      backgroundColor:
                          Color(CommonUtil().getMyPrimaryColor())),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          if (snapshot?.hasData &&
              snapshot?.data?.result != null &&
              snapshot?.data?.result.isNotEmpty) {
            return hospitalList(snapshot.data.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(variable.strNoPlans),
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
                    title: planList[i].title,
                    providerName: planList[i].providerName,
                    docName: planList[i].docNick,
                    packageId: planList[i].packageid,
                    isExpired: planList[i].isexpired,
                    startDate: planList[i].startdate,
                    endDate: planList[i].enddate,
                    icon: planList[i]?.metadata?.icon,
                    catIcon: planList[i]?.catmetadata?.icon,
                    providerIcon: planList[i]?.providermetadata?.icon,
                    descriptionURL: planList[i]?.metadata?.descriptionURL,
                    price: planList[i]?.price,
                    isExtendable: planList[i]?.isExtendable,
                  )),
        ).then((value) {
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
                    radius: 20,
                    child: CommonUtil().customImage(getImage(i, planList)),
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
                              ? toBeginningOfSentenceCase(planList[i].title)
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
                                        planList[i].providerName)
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
                  Row(
                    children: [
                      Column(
                        children: [
                          Align(
                            child: SizedBoxWithChild(
                              height: 32.0.h,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(
                                        color: planList[i].isexpired == '1'
                                            ? Color(CommonUtil()
                                                .getMyPrimaryColor())
                                            : Colors.red)),
                                color: Colors.transparent,
                                textColor: planList[i].isexpired == '1'
                                    ? Color(
                                        CommonUtil().getMyPrimaryColor())
                                    : Colors.red,
                                padding: EdgeInsets.all(
                                  8.0.sp,
                                ),
                                onPressed: () async {
                                  if (planList[i].isexpired == '1') {
                                    await CommonUtil().renewAlertDialog(context,
                                        packageId: planList[i]?.packageid,
                                        price: planList[i]?.price,
                                        IsExtendable:
                                            planList[i]?.isExtendable == '1'
                                                ? false
                                                : true, refresh: () {
                                      setState(() {});
                                    });
                                  } else {
                                    await CommonUtil().unSubcribeAlertDialog(context,
                                        packageId: planList[i].packageid,
                                        refresh: () {
                                      setState(() {});
                                    });
                                  }
                                },
                                child: TextWidget(
                                  text: planList[i].isexpired == '1'
                                      ? strIsRenew
                                      : strUnSubscribe,
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
    var image = '';
    if (planList[i] != null) {
      if (planList[i].metadata != null && planList[i].metadata != '') {
        if (planList[i].metadata.icon != null &&
            planList[i].metadata.icon != '') {
          image = planList[i].metadata.icon;
        } else {
          if (planList[i].catmetadata != null &&
              planList[i].catmetadata != '') {
            if (planList[i].catmetadata.icon != null &&
                planList[i].catmetadata.icon != '') {
              image = planList[i].catmetadata.icon;
            } else {
              if (planList[i].providermetadata != null &&
                  planList[i].providermetadata != '') {
                if (planList[i].providermetadata.icon != null &&
                    planList[i].providermetadata.icon != '') {
                  image = planList[i].providermetadata.icon;
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
              if (planList[i].providermetadata.icon != null &&
                  planList[i].providermetadata.icon != '') {
                image = planList[i].providermetadata.icon;
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
          if (planList[i].catmetadata.icon != null &&
              planList[i].catmetadata.icon != '') {
            image = planList[i].catmetadata.icon;
          } else {
            if (planList[i].providermetadata != null &&
                planList[i].providermetadata != '') {
              if (planList[i].providermetadata.icon != null &&
                  planList[i].providermetadata.icon != '') {
                image = planList[i].providermetadata.icon;
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
            if (planList[i].providermetadata.icon != null &&
                planList[i].providermetadata.icon != '') {
              image = planList[i].providermetadata.icon;
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
        if (planList[i].catmetadata.icon != null &&
            planList[i].catmetadata.icon != '') {
          image = planList[i].catmetadata.icon;
        } else {
          if (planList[i].providermetadata != null &&
              planList[i].providermetadata != '') {
            if (planList[i].providermetadata.icon != null &&
                planList[i].providermetadata.icon != '') {
              image = planList[i].providermetadata.icon;
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
          if (planList[i].providermetadata.icon != null &&
              planList[i].providermetadata.icon != '') {
            image = planList[i].providermetadata.icon;
          } else {
            image = '';
          }
        } else {
          image = '';
        }
      }
    }

    return image;
  }
}

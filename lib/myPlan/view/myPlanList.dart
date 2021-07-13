import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/myPlan/view/myPlanDetail.dart';
import 'package:myfhb/myPlan/viewModel/myPlanViewModel.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';

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
  MyPlanViewModel myPlanViewModel = new MyPlanViewModel();
  bool isSearch = false;
  List<MyPlanListResult> myPLanListResult = List();
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
              await Get.toNamed(rt_Diseases);
            },
            elevation: 2.0,
            backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
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
      myPLanListResult = await myPlanViewModel.getProviderSearch(doctorName);
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
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Color(new CommonUtil().getMyPrimaryColor()),
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
                  Get.toNamed(rt_Regimen);
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
    return (planList != null && planList.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (BuildContext ctx, int i) {
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
    return new FutureBuilder<MyPlanListModel>(
      future: myPlanViewModel.getMyPlanList(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: new Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: new CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor())),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          if (snapshot?.hasData &&
              snapshot?.data?.result != null &&
              snapshot?.data?.result?.length > 0) {
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
                  )),
        ).then((value) {
          if (value == 'refreshUI') {
            setState(() {});
          }
        });
      },
      child: Container(
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFe3e2e2),
                blurRadius: 16, // has the effect of softening the shadow
                spreadRadius: 5.0, // has the effect of extending the shadow
                offset: Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  new CommonUtil().dateFormatConversion(
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
                            alignment: Alignment.center,
                            child: SizedBoxWithChild(
                              height: 32.0.h,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: planList[i].isexpired == '1'
                                            ? Color(new CommonUtil()
                                                .getMyPrimaryColor())
                                            : Colors.red)),
                                color: Colors.transparent,
                                textColor: planList[i].isexpired == '1'
                                    ? Color(
                                        new CommonUtil().getMyPrimaryColor())
                                    : Colors.red,
                                padding: EdgeInsets.all(
                                  8.0.sp,
                                ),
                                onPressed: () async {
                                  if (planList[i].isexpired == '1') {
                                    CommonUtil().renewAlertDialog(context,
                                        packageId: planList[i].packageid,
                                        refresh: () {
                                      setState(() {});
                                    });
                                  } else {
                                    CommonUtil().unSubcribeAlertDialog(context,
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
    String image = '';
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

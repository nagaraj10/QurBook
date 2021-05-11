import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/myPlan/services/myPlanService.dart';
import 'package:myfhb/myPlan/view/myPlanDetail.dart';
import 'package:myfhb/myPlan/viewModel/myPlanViewModel.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/subscribeModel.dart';
import 'package:myfhb/plan_dashboard/view/planDetailsView.dart';
import 'package:myfhb/plan_dashboard/viewModel/planViewModel.dart';
import 'package:myfhb/plan_dashboard/viewModel/subscribeViewModel.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class PlanList extends StatefulWidget {
  @override
  _MyPlanState createState() => _MyPlanState();
}

class _MyPlanState extends State<PlanList> {
  PlanListModel myPlanListModel;
  PlanViewModel myPlanViewModel = new PlanViewModel();
  bool isSearch = false;
  List<PlanListResult> myPLanListResult = List();
  SubscribeViewModel subscribeViewModel = new SubscribeViewModel();
  FlutterToast toast = new FlutterToast();

  @override
  void initState() {
    super.initState();
    Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
      isInitial: true,
    );
    Provider.of<RegimentViewModel>(
      context,
      listen: false,
    ).handleSearchField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Visibility(
      visible: Provider.of<RegimentViewModel>(context).regimentsDataAvailable,
      child: Container(
        child: Column(
          children: [
            SearchWidget(
              onChanged: (title) {
                if (title != '' && title.length > 2) {
                  isSearch = true;
                  onSearchedNew(title);
                } else {
                  setState(() {
                    isSearch = false;
                  });
                }
              },
            ),
            Expanded(
              child: myPlanListModel != null ?? myPlanListModel.isSuccess
                  ? planList(myPlanListModel.result)
                  : getPlanList(),
            )
          ],
        ),
      ),
      replacement: Center(
        child: Padding(
          padding: EdgeInsets.all(
            10.0.sp,
          ),
          child: Text(
            Constants.mplansForFamily,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }

  onSearchedNew(String title) async {
    myPLanListResult.clear();
    if (title != null) {
      myPLanListResult = await myPlanViewModel.getSearch(title);
    }
    setState(() {});
  }

  Widget planList(List<PlanListResult> planList) {
    return (planList != null && planList.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx, int i) => hospitalListItem(
                ctx, i, isSearch ? myPLanListResult : planList),
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
    return new FutureBuilder<PlanListModel>(
      future: myPlanViewModel.getPlanList(),
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
            return planList(snapshot.data.result);
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

  Widget hospitalListItem(
      BuildContext context, int i, List<PlanListResult> planList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyPlanDetailView(
                    title: planList[i].title,
                    providerName: planList[i].providerName,
                    description: planList[i].description,
                    issubscription: planList[i].isSubscribed,
                    packageId: planList[i].packageid,
                    price: planList[i].price,
                    packageDuration: planList[i].packageDuration,
                    providerId: planList[i].plinkid,
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
                    child: ClipOval(
                        child: CircleAvatar(
                      backgroundImage: AssetImage('assets/launcher/myfhb1.png'),
                      radius: 18,
                      backgroundColor: Colors.transparent,
                    )),
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
                        Text(
                          planList[i].providerName != null
                              ? toBeginningOfSentenceCase(
                                  planList[i].providerName)
                              : '',
                          style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.lightgraycolor),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Duration: ',
                                  style: TextStyle(
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                planList[i].packageDuration != null
                                    ? Text(
                                        planList[i].packageDuration + ' days',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                planList[i].isSubscribed == '1'
                                    ? Text(
                                        'Start Date: ',
                                        style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w400),
                                      )
                                    : SizedBox(width: 55.w),
                                planList[i].isSubscribed == '1'
                                    ? Text(
                                        new CommonUtil().dateFormatConversion(
                                            planList[i].startDate),
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : SizedBox(width: 55.w),
                                planList[i].isSubscribed == '0'
                                    ? SizedBox(width: 60.w)
                                    : SizedBox(width: 55.w),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          planList[i].price != null
                              ? Visibility(
                                  visible: planList[i].price.isNotEmpty &&
                                      planList[i].price != '0',
                                  child: TextWidget(
                                      text: INR + planList[i].price,
                                      fontsize: 16.0.sp,
                                      fontWeight: FontWeight.w500,
                                      colors: Color(new CommonUtil()
                                          .getMyPrimaryColor())),
                                  replacement: TextWidget(
                                      text: FREE,
                                      fontsize: 16.0.sp,
                                      fontWeight: FontWeight.w500,
                                      colors: Color(new CommonUtil()
                                          .getMyPrimaryColor())),
                                )
                              : Container(),
                          SizedBox(height: 8.h),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBoxWithChild(
                              width: 95.0.w,
                              height: 32.0.h,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Color(new CommonUtil()
                                            .getMyPrimaryColor()))),
                                color: Colors.transparent,
                                textColor:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                padding: EdgeInsets.all(
                                  8.0.sp,
                                ),
                                onPressed: () async {
                                  if (planList[i].isSubscribed == '0') {
                                    CommonUtil().profileValidationCheck(context,
                                        packageId: planList[i].packageid,
                                        isSubscribed: planList[i].isSubscribed,
                                        providerId: planList[i].plinkid,
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
                                  text: planList[i].isSubscribed == '0'
                                      ? strSubscribe
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
}

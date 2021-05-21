import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/myPlan/services/myPlanService.dart';
import 'package:myfhb/myPlan/view/myPlanDetail.dart';
import 'package:myfhb/myPlan/viewModel/myPlanViewModel.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/viewModel/subscribeViewModel.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class MyPlanList extends StatefulWidget {
  @override
  _MyPlanState createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlanList> {
  MyPlanListModel myPlanListModel;
  MyPlanViewModel myPlanViewModel = new MyPlanViewModel();
  bool isSearch = false;
  List<MyPlanListResult> myPLanListResult = List();

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus.unfocus();
    Provider.of<RegimentViewModel>(
      context,
      listen: false,
    ).updateTabIndex(currentIndex: 3);
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus.unfocus();
    super.dispose();
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
      replacement: Center(
        child: Padding(
          padding: EdgeInsets.all(
            10.0.sp,
          ),
          child: Text(
            Constants.plansForFamily,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }

  onSearchedNew(String doctorName) async {
    myPLanListResult.clear();
    if (doctorName != null) {
      myPLanListResult = await myPlanViewModel.getProviderSearch(doctorName);
    }
    setState(() {});
  }

  Widget hospitalList(List<MyPlanListResult> planList) {
    return (planList != null && planList.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (BuildContext ctx, int i) =>
                myPlanListItem(ctx, i, isSearch ? myPLanListResult : planList),
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
                    startDate: planList[i].startdate,
                    endDate: planList[i].enddate,
                    icon: planList[i]?.metadata?.icon,
                  )),
        );
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
                    child: planList[i] != null &&
                            planList[i].metadata != null &&
                            planList[i].metadata.icon != null &&
                            planList[i].metadata.icon != ''
                        ? planList[i]
                                ?.metadata
                                ?.icon
                                .toString()
                                .toLowerCase()
                                ?.contains('.svg')
                            ? ClipOval(
                                child: SvgPicture.network(
                                planList[i]?.metadata?.icon,
                                placeholderBuilder: (BuildContext context) =>
                                    new CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        backgroundColor: Color(new CommonUtil()
                                            .getMyPrimaryColor())),
                              ))
                            : ClipOval(
                                child: CachedNetworkImage(
                                    imageUrl: planList[i]?.metadata?.icon,
                                    placeholder: (context, url) =>
                                        new CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                            backgroundColor: Color(
                                                new CommonUtil()
                                                    .getMyPrimaryColor())),
                                    errorWidget: (context, url, error) =>
                                        ClipOval(
                                            child: CircleAvatar(
                                          backgroundImage:
                                              AssetImage(qurHealthLogo),
                                          radius: 18,
                                          backgroundColor: Colors.transparent,
                                        ))),
                              )
                        : ClipOval(
                            child: CircleAvatar(
                            backgroundImage: AssetImage(qurHealthLogo),
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
                              width: 95.0.w,
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
}

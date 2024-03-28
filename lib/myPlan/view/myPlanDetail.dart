import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';

import '../../authentication/constants/constants.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../common/errors_widget.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../plan_dashboard/view/plan_pdf_viewer.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import '../model/myPlanListModel.dart';
import '../viewModel/myPlanViewModel.dart';

class MyPlanDetail extends StatefulWidget {
  final String? packageId;
  final String? templateName;

  bool showRenew;

  MyPlanDetail(
      {Key? key,
      required this.packageId,
      this.showRenew = false,
      this.templateName = null})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlanDetail();
  }
}

class PlanDetail extends State<MyPlanDetail> {
  MyPlanViewModel myPlanViewModel = MyPlanViewModel();

  String? title;
  String? tags;
  String? providerName;
  String? docName;
  String? startDate;
  String? endDate;
  String? packageId;
  String? isExpired;
  String icon = '';
  String catIcon = '';
  String providerIcon = '';
  String descriptionURL = '';
  String price = '';
  String isExtendable = '';
  String isPlublic = '';
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  bool showRenewOrSubscribeButton = false;
  late Future<MyPlanListModel?> planListFetch;
  String? packageDuration;
  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBAPlanDetailsScreen);
    getConfiguration();
    planListFetch = myPlanViewModel.getMyPlanListDetail(widget.packageId);
  }

  Future<void> getConfiguration() async {
    final showRenewOrSubscribeButton =
        await PreferenceUtil.getUnSubscribeValue();
    setState(() {
      this.showRenewOrSubscribeButton = showRenewOrSubscribeButton ?? false;
    });
  }

  void setValues(MyPlanListResult planList) {
    title = planList.title;
    tags = planList.tags;
    providerName = planList.providerName;
    docName = planList.metadata?.doctorName;
    startDate = planList.startdate;
    endDate = planList.enddate;
    endDate = planList.enddate;
    packageId = planList.packageid;
    isExpired = planList.isexpired;
    icon = planList.metadata?.icon ?? '';
    catIcon = planList.catmetadata?.icon ?? '';
    providerIcon = planList.providermetadata?.icon ?? '';
    descriptionURL = planList.metadata?.descriptionURL ?? '';
    price = planList.price ?? '';
    isExtendable = planList.isExtendable ?? '';
    isPlublic = planList.ispublic ?? '';
    packageDuration = planList.duration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
        ),
        title: Text(
          'My Plan',
          style: TextStyle(
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder<MyPlanListModel?>(
        future: planListFetch,
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
              MyPlanListResult planList =
                  snapshot.data?.result![0] as MyPlanListResult;
              setValues(planList);
              return getMainWidget();
            } else {
              return SafeArea(
                child: Center(
                  child: Text('Plan information not available'),
                ),
              );
            }
          }
        },
      ),
    );
  }

  showRenewAlert() async {
    await Future.delayed(Duration(seconds: 2));
    if (CommonUtil.isRenewDialogOpened) return;
    CommonUtil.isRenewDialogOpened = true;
    CommonUtil().renewAlertDialog(context,
        packageId: widget.packageId,
        price: price,
        startDate: startDate,
        endDate: endDate,
        isExpired: isExpired == '1' ? true : false, refresh: () {
      print('ns done');
    },
        IsExtendable: isExtendable == '1' ? true : false,
        moveToCart: true,
        nsBody: {
          "templateName": "${widget.templateName}",
          "contextId": "${widget.packageId}"
        },
        packageDuration: packageDuration);
  }

  Widget getMainWidget() {
    if (widget.showRenew) {
      showRenewAlert();
      widget.showRenew = false;
    }
    return Builder(
      builder: (contxt) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        height: 1.sh - AppBar().preferredSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 0.25.sh,
              ),
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 26,
                          child: CommonUtil().customImage(
                            getImage(),
                            planInitial: providerName,
                          )),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title != null && title != ''
                                ? toBeginningOfSentenceCase(title!.trim())!
                                : '-',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            providerName != null && providerName != ''
                                ? toBeginningOfSentenceCase(providerName)!
                                : '-',
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          docName != null && docName != ''
                              ? Row(
                                  children: [
                                    Text('Plan approved by:',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.grey[600])),
                                    SizedBox(width: 4.w),
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                            toBeginningOfSentenceCase(docName)!,
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 16.sp)),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            children: [
                              Text('Start Date: ',
                                  style: TextStyle(fontSize: 9)),
                              Text(
                                  startDate != null && startDate != ''
                                      ? CommonUtil()
                                          .dateFormatConversion(startDate)
                                      : '-',
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 5),
                              Text('End Date: ', style: TextStyle(fontSize: 9)),
                              Text(
                                  endDate != null && endDate != ''
                                      ? CommonUtil()
                                          .dateFormatConversion(endDate)
                                      : '-',
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: descriptionURL != null && descriptionURL != ''
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 0.65.sh,
                      child: PlanPdfViewer(
                        url: descriptionURL,
                        scaffoldKey: _scaffoldKey,
                      ),
                      //),
                    )
                  : Column(
                      children: [
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]!)),
                              height: 0.62.sh,
                              width: 0.45.sh,
                              child: Center(child: Text(strEmptyWebView)),
                              //),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            if (tags != strMemb && showRenewOrSubscribeButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      if (isExpired == '1') {
                        if (isPlublic == '0') {
                          FlutterToast().getToast(
                            "Please contact your care coordinator for renewal",
                            Colors.red,
                          );
                        } else {
                          await CommonUtil().renewAlertDialog(context,
                              packageId: packageId,
                              price: price,
                              startDate: startDate,
                              endDate: endDate,
                              isExpired: isExpired == '1' ? true : false,
                              IsExtendable: isExtendable == '1' ? true : false,
                              packageDuration: packageDuration, refresh: () {
                            Navigator.pop(context);
                          });
                        }
                      } else {
                        if (price == '0') {
                          await CommonUtil().unSubcribeAlertDialog(
                            context,
                            packageId: packageId,
                            fromDetail: true,
                          );
                        } else {
                          await CommonUtil().alertDialogForNoReFund(
                            context,
                            packageId: packageId,
                            fromDetail: true,
                          );
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isExpired == '1'
                            ? mAppThemeProvider.primaryColor
                            : Colors.red,
                      ),
                    ),
                    child: Text(
                      isExpired == '1'
                          ? (isPlublic == '0'
                              ? strExpired.toUpperCase()
                              : strIsRenew.toUpperCase())
                          : strUnSubscribe.toUpperCase(),
                      style: TextStyle(
                        color: isExpired == '1'
                            ? mAppThemeProvider.primaryColor
                            : Colors.red,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    //hoverColor: Color(getMyPrimaryColor()),
                    onPressed: () async {
                      if (isExpired == '1') {
                        Navigator.of(context).pop();
                      } else {
                        await CommonUtil().renewAlertDialog(context,
                            packageId: packageId,
                            price: price,
                            startDate: startDate,
                            endDate: endDate,
                            isExpired: isExpired == '1' ? true : false,
                            IsExtendable: isExtendable == '1' ? true : false,
                            packageDuration: packageDuration, refresh: () {
                          Navigator.pop(context);
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Color(
                          CommonUtil().getMyPrimaryColor(),
                        ),
                      ),
                    ),
                    //hoverColor: Color(getMyPrimaryColor()),
                    child: Text(
                      isExpired == '1'
                          ? 'cancel'.toUpperCase()
                          : 'renew'.toUpperCase(),
                      style: TextStyle(
                        color: mAppThemeProvider.primaryColor,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  ///// removed activities list for ui screen changed

  /*Widget getActivityList() {
    return FutureBuilder<MyPlanDetailModel>(
      future: myPlanViewModel.getMyPlanDetails(packageId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: Center(
                child: SizedBox(
                  width: 20.0.h,
                  height: 20.0.h,
                  child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      backgroundColor:
                      mAppThemeProvider.primaryColor),
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
            return activitiesList(snapshot.data.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 5.0,
                child: Container(
                    child: Center(
                      child: Text(
                        variable.strNoActivities,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    )),
              ),
            );
          }
        }
      },
    );
  }

  Widget activitiesList(List<MyPlanDetailResult> actList) {
    return (actList != null && actList.length > 0)
        ? Container(
      constraints: BoxConstraints(minHeight: 20, maxHeight: 280),
      margin: EdgeInsets.symmetric(horizontal: 50.0),
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: actList.length,
          itemBuilder: (BuildContext ctx, int i) =>
              getEventCardWidget(ctx, i, actList),
        ),
      ),
    )
        : SafeArea(
      child: SizedBox(
        height: 1.sh / 5.0,
        child: Container(
            child: Center(
              child: Text(
                variable.strNoActivities,
                style: TextStyle(fontSize: 12.sp),
              ),
            )),
      ),
    );
  }

  Widget getEventCardWidget(
      BuildContext context, int i, List<MyPlanDetailResult> actList) {
    return Container(
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.only(top: 4.0),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE7FC),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.sp,
              child: Text(
                  actList[i].titletext != null && actList[i].titletext != ''
                      ? actList[i].titletext
                      : '',
                  style: TextStyle(fontSize: 10.sp)),
            ),
            SizedBox(height: 4.0.sp),
            SizedBox(
              width: 200.sp,
              child: Text(
                actList[i].repeattext != null && actList[i].repeattext != ''
                    ? actList[i].repeattext
                    : '',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ));
  }*/
  downloadFileForIos(List<String> updatedData) async {
    var response = await CommonUtil()
        .loadPdf(url: updatedData.first, fileName: updatedData.last);
    CommonUtil().showStatusToUser(response, _scaffoldKey);
  }

  String getImage() {
    String image;
    if (icon != null && icon != '') {
      image = icon;
    } else {
      if (catIcon != null && catIcon != '') {
        image = catIcon;
      } else {
        if (providerIcon != null && providerIcon != '') {
          image = providerIcon;
        } else {
          image = '';
        }
      }
    }

    return image;
  }
}

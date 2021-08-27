import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/my_reports/model/report_model.dart';
import 'package:myfhb/my_reports/view_model/report_view_model.dart';
import '../../common/errors_widget.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../src/utils/screenutils/size_extensions.dart';
import 'report_web_view.dart';

class MyReportList extends StatefulWidget {
  @override
  _MyReportList createState() => _MyReportList();
}

class _MyReportList extends State<MyReportList> {
  ReportModel reportModel;
  MyReportViewModel myReportViewModel = MyReportViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          child: Column(
            children: [
              Expanded(
                child: getReportList(),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget getReportList() {
    return FutureBuilder<ReportModel>(
      future: myReportViewModel.getReportList(),
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
          if (snapshot?.hasData &&
              snapshot?.data?.result != null &&
              snapshot?.data?.result.isNotEmpty) {
            return reportList(snapshot.data.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(variable.strNoReports),
                )),
              ),
            );
          }
        }
      },
    );
  }

  Widget reportList(List<MyReportResult> reportList) {
    return (reportList != null && reportList.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (ctx, i) {
              return myPlanListItem(ctx, i, reportList);
            },
            itemCount: reportList.length,
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  child: Center(
                child: Text(variable.strNoReports),
              )),
            ),
          );
  }

  Widget myPlanListItem(
      BuildContext context, int i, List<MyReportResult> reportList) {
    return InkWell(
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReportWebView(
                embededUrl: reportList[i].embeddedUrl,
                  reportId: reportList[i].reportId,
                  id: reportList[i].id
              )),
        );
      },
      child: Container(
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.only(left: 10, right: 10, top: 8),
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
                  /*SizedBox(
                    width: 15.0.w,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 20,
                    child: CommonUtil().customImage(getImage(i, planList)),
                  ),
                  SizedBox(
                    width: 20.0.w,
                  ),*/
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          reportList[i].reportName != null
                              ? toBeginningOfSentenceCase(
                                  reportList[i].reportName)
                              : '',
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        /*Column(
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
                        ),*/
                      ],
                    ),
                  ),
                  /*Row(
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
                                    ? Color(CommonUtil().getMyPrimaryColor())
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
                                            ? true
                                            : false, refresh: () {
                                          setState(() {});
                                        });
                                  } else {
                                    await CommonUtil().unSubcribeAlertDialog(
                                        context,
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
                  )*/
                ],
              ),
              SizedBox(height: 5.h),
            ],
          )),
    );
  }
}

import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/viewModel/myPlanViewModel.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class MyPlanDetail extends StatefulWidget {
  final String title;
  final String providerName;
  final String docName;
  final String startDate;
  final String endDate;
  final String packageId;

  MyPlanDetail(
      {Key key,
      @required this.title,
      @required this.providerName,
      @required this.docName,
      @required this.startDate,
      @required this.endDate,
      @required this.packageId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlanDetail();
  }
}

class PlanDetail extends State<MyPlanDetail> {
  MyPlanViewModel myPlanViewModel = new MyPlanViewModel();

  String title;
  String providerName;
  String docName;
  String startDate;
  String endDate;
  String packageId;

  @override
  void initState() {
    super.initState();
    setValues();
  }

  void setValues() {
    title = widget.title;
    providerName = widget.providerName;
    docName = widget.docName;
    startDate = widget.startDate;
    endDate = widget.endDate;
    packageId = widget.packageId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
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
        body: getMainWidget());
  }

  Widget getMainWidget() {
    return Column(
      children: [
        SizedBox(height: 30),
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 200,
                                child: Text(
                                  title != null && title != '' ? title : '-',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                width: 200,
                                child: Text(
                                    providerName != null && providerName != ''
                                        ? providerName
                                        : '-',
                                    style: TextStyle(color: Colors.grey[600])),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                width: 200,
                                child: Text(
                                    docName != null && docName != ''
                                        ? docName
                                        : '-',
                                    style: TextStyle()),
                              ),
                              SizedBox(height: 8),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Start Date: ",
                                          style: TextStyle(fontSize: 9)),
                                      Text(
                                          startDate != null && startDate != ''
                                              ? new CommonUtil()
                                                  .dateFormatConversion(
                                                      startDate)
                                              : '-',
                                          style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 5),
                                      Text("End Date: ",
                                          style: TextStyle(fontSize: 9)),
                                      Text(
                                          endDate != null && endDate != ''
                                              ? new CommonUtil()
                                                  .dateFormatConversion(endDate)
                                              : '-',
                                          style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text("Activities Associated",
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [getActivityList()],
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey[500]),
                      SizedBox(height: 3),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  Color(new CommonUtil().getMyPrimaryColor())),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  )),
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/launcher/myfhb1.png'),
              radius: 24,
              backgroundColor: Colors.transparent,
            )
          ],
        ),
      ],
    );
  }

  Widget getActivityList() {
    return new FutureBuilder<MyPlanDetailModel>(
      future: myPlanViewModel.getMyPlanDetails(packageId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: new Center(
                child: SizedBox(
                  width: 20.0.h,
                  height: 20.0.h,
                  child: new CircularProgressIndicator(
                      strokeWidth: 1.0,
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
        ? new Container(
            constraints: BoxConstraints(minHeight: 20, maxHeight: 280),
            margin: new EdgeInsets.symmetric(horizontal: 50.0),
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
  }
}

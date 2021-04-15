import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/viewModel/myPlanViewModel.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';

class MyPlanDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlanDetail();
  }
}

class PlanDetail extends State<MyPlanDetail> {
  MyPlanViewModel myPlanViewModel = new MyPlanViewModel();

  @override
  void initState() {
    super.initState();
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
        body: getPlanDetails(context));
  }

  Widget getPlanDetails(BuildContext context) {
    return FutureBuilder<MyPlanDetailModel>(
      future: myPlanViewModel.getMyPlanDetails(""),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CircularProgressIndicator(
                    backgroundColor: Color(CommonUtil().getMyPrimaryColor())),
              )),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          if (snapshot.hasData) {
            return getMainWidget(snapshot.data.result);
          }
          return SizedBox(
            height: 1.sh / 1.3,
            child: new Center(
              child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: new CircularProgressIndicator(
                  backgroundColor: Color(
                    new CommonUtil().getMyPrimaryColor(),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget getMainWidget(MyPlanDetailResult myPlanDetailResult) {
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
                                  myPlanDetailResult != null &&
                                          myPlanDetailResult.planPackage != null
                                      ? myPlanDetailResult.planPackage
                                      : '-',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                width: 200,
                                child: Text(
                                    myPlanDetailResult != null &&
                                            myPlanDetailResult.provider != null
                                        ? myPlanDetailResult.provider
                                        : '-',
                                    style: TextStyle(color: Colors.grey[600])),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                width: 200,
                                child:
                                    Text("Dr.Ramakrishnan", style: TextStyle()),
                              ),
                              SizedBox(height: 8),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Start Date: ",
                                          style: TextStyle(fontSize: 9)),
                                      Text(
                                          myPlanDetailResult != null &&
                                                  myPlanDetailResult
                                                          .startDate !=
                                                      null
                                              ? new CommonUtil().dateFormatConversion(myPlanDetailResult.startDate)
                                              : '-',
                                          style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 5),
                                      Text("End Date: ",
                                          style: TextStyle(fontSize: 9)),
                                      Text(
                                          myPlanDetailResult != null &&
                                                  myPlanDetailResult.endDate !=
                                                      null
                                              ? new CommonUtil().dateFormatConversion(myPlanDetailResult.endDate)
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
                        children: [
                          Container(
                            constraints:
                                BoxConstraints(minHeight: 20, maxHeight: 300),
                            margin: new EdgeInsets.symmetric(horizontal: 55.0),
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: 6,
                                itemBuilder: (c, i) => getEventCardWidget(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
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

  Widget getEventCardWidget() {
    return Container(
        padding: EdgeInsets.all(6.0),
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE7FC),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            SizedBox(width: 5),
            Text(
              '10.00AM',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 120,
              child: Text('Blood Pressure', style: TextStyle(fontSize: 9)),
            ),
          ],
        ));
  }
}

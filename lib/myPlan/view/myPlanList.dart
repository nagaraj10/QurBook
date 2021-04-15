import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/myPlan/services/myPlanService.dart';
import 'package:myfhb/myPlan/view/myPlanDetail.dart';
import 'package:myfhb/myPlan/viewModel/myPlanViewModel.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class MyPlanList extends StatefulWidget {
  @override
  _MyPlanState createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlanList> {
  MyPlanListModel myPlanListModel;
  MyPlanViewModel myPlanViewModel = new MyPlanViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      children: [
        myPlanListModel != null ?? myPlanListModel.isSuccess
            ? hospitalList(myPlanListModel.result)
            : getPlanList()
      ],
    )));
  }

  Widget hospitalList(List<MyPlanListResult> planList) {
    return (planList != null && planList.length > 0)
        ? new ListView.builder(
            itemBuilder: (BuildContext ctx, int i) =>
                hospitalListItem(ctx, i, planList),
            itemCount: planList.length,
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
              height: 1.sh / 1.3,
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
          final items = snapshot.data ??
              <MyPlanListModel>[]; // handle the case that data is null
          return (snapshot.data.result != null &&
                  snapshot.data.result.length > 0)
              ? hospitalList(snapshot.data.result)
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
      },
    );
  }

  Widget hospitalListItem(
      BuildContext context, int i, List<MyPlanListResult> planList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyPlanDetail()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(left: 15, right: 15, top: 8),
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
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 22,
              child: ClipOval(
                  child: CircleAvatar(
                backgroundImage: AssetImage('assets/launcher/myfhb1.png'),
                radius: 20,
                backgroundColor: Colors.transparent,
              )),
            ),
            SizedBox(
              width: 20.0.w,
            ),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5.0.h),
                  AutoSizeText(
                    planList[i].planPackage != null
                        ? toBeginningOfSentenceCase(planList[i].planPackage)
                        : '',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.0.h),
                  Column(
                    children: [
                      AutoSizeText(
                        planList[i].provider,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.lightgraycolor),
                      ),
                      SizedBox(height: 5.0.h),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          AutoSizeText(
                            'Start Date:',
                            style: TextStyle(
                                fontSize: 12.0.sp, fontWeight: FontWeight.w400),
                          ),
                          AutoSizeText(
                            new CommonUtil().dateFormatConversion(planList[i].startDate),
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 12.0.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

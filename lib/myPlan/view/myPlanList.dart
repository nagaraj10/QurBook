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
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
        Expanded(
          child: myPlanListModel != null ?? myPlanListModel.isSuccess
              ? hospitalList(myPlanListModel.result)
              : getPlanList(),
        )
      ],
    )));
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

  Widget hospitalListItem(
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
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.only(left: 12, right: 12, top: 8),
        decoration: BoxDecoration(
          color: planList[i].isexpired == '1' ? Colors.grey[400] : Colors.white,
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
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5.0.h),
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
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 250.0.w,
                        child: Text(
                          planList[i].providerName != null
                              ? toBeginningOfSentenceCase(
                                  planList[i].providerName)
                              : '',
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
                            'Start Date:',
                            style: TextStyle(
                                fontSize: 10.0.sp, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            new CommonUtil()
                                .dateFormatConversion(planList[i].startdate),
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

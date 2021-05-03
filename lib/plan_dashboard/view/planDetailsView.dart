import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

class MyPlanDetailView extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final String issubscription;
  final String packageId;
  final String providerName;

  MyPlanDetailView(
      {Key key,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.issubscription,
      @required this.packageId,
      @required this.providerName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlanDetail();
  }
}

class PlanDetail extends State<MyPlanDetailView> {
  //MyPlanViewModel myPlanViewModel = new MyPlanViewModel();

  String title;
  String description;
  String price;
  String issubscription;
  String packageId;
  String providerName;

  @override
  void initState() {
    super.initState();
    setValues();
  }

  void setValues() {
    title = widget.title;
    description = widget.description;
    price = widget.price;
    issubscription = widget.issubscription;
    packageId = widget.packageId;
    providerName = widget.providerName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
              size: 24.0,
            ),
          ),
          title: Text(
            'Plans',
            style: TextStyle(
              fontSize: 18.0,
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
                                  description != null && description != '' ? description : '-',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              
                              // SizedBox(
                              //   width: 200,
                              //   child: Text(
                              //       docName != null && docName != ''
                              //           ? docName
                              //           : '-',
                              //       style: TextStyle()),
                              // ),
                              // SizedBox(height: 8),
                              // Column(
                              //   children: [
                              //     Row(
                              //       children: [
                              //         Text("Start Date: ",
                              //             style: TextStyle(fontSize: 9)),
                              //         Text(
                              //             startDate != null && startDate != ''
                              //                 ? new CommonUtil()
                              //                     .dateFormatConversion(
                              //                         startDate)
                              //                 : '-',
                              //             style: TextStyle(
                              //                 fontSize: 9,
                              //                 fontWeight: FontWeight.bold)),
                              //         SizedBox(width: 5),
                              //         Text("End Date: ",
                              //             style: TextStyle(fontSize: 9)),
                              //         Text(
                              //             endDate != null && endDate != ''
                              //                 ? new CommonUtil()
                              //                     .dateFormatConversion(endDate)
                              //                 : '-',
                              //             style: TextStyle(
                              //                 fontSize: 9,
                              //                 fontWeight: FontWeight.bold)),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              // Column(
                              //   children: [
                              //     SizedBox(height: 10),
                              //     Text("Activities Associated",
                              //         style: TextStyle(
                              //             color: Colors.grey[500],
                              //             fontSize: 10)),
                              //   ],
                              // ),
                            ],
                          ),
                        ],
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [getActivityList()],
                      // ),
                      SizedBox(height: 20),
                      //Divider(color: Colors.grey[500]),
                      SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlineButton(
                            //hoverColor: Color(getMyPrimaryColor()),
                            child: Text(
                              issubscription == '1'
                                  ? 'subscribe'.toUpperCase()
                                  : 'unsubscribe'.toUpperCase(),
                              style: TextStyle(
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                fontSize: 13,
                              ),
                            ),
                            onPressed: () async {
                              // open profile page
                              //Navigator.of(context).pop();
                              CommonUtil().mDisclaimerAlertDialog();
                              
                            },
                            borderSide: BorderSide(
                              color: Color(
                                CommonUtil().getMyPrimaryColor(),
                              ),
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          OutlineButton(
                            //hoverColor: Color(getMyPrimaryColor()),
                            child: Text(
                              'cancel'.toUpperCase(),
                              style: TextStyle(
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                fontSize: 13,
                              ),
                            ),
                            onPressed: () async {
                              // open profile page
                              Navigator.of(context).pop();
                            },
                            borderSide: BorderSide(
                              color: Color(
                                CommonUtil().getMyPrimaryColor(),
                              ),
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                        ],
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

  // Widget getActivityList() {
  //   return new FutureBuilder<MyPlanDetailModel>(
  //     future: myPlanViewModel.getMyPlanDetails(packageId),
  //     builder: (BuildContext context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return SafeArea(
  //           child: SizedBox(
  //             height: 1.sh / 4.5,
  //             child: new Center(
  //               child: SizedBox(
  //                 width: 20.0.h,
  //                 height: 20.0.h,
  //                 child: new CircularProgressIndicator(
  //                     strokeWidth: 1.0,
  //                     backgroundColor:
  //                         Color(new CommonUtil().getMyPrimaryColor())),
  //               ),
  //             ),
  //           ),
  //         );
  //       } else if (snapshot.hasError) {
  //         return ErrorsWidget();
  //       } else {
  //         if (snapshot?.hasData &&
  //             snapshot?.data?.result != null &&
  //             snapshot?.data?.result?.length > 0) {
  //           return activitiesList(snapshot.data.result);
  //         } else {
  //           return SafeArea(
  //             child: SizedBox(
  //               height: 1.sh / 5.0,
  //               child: Container(
  //                   child: Center(
  //                 child: Text(
  //                   variable.strNoActivities,
  //                   style: TextStyle(fontSize: 12.sp),
  //                 ),
  //               )),
  //             ),
  //           );
  //         }
  //       }
  //     },
  //   );
  // }

  // Widget activitiesList(List<MyPlanDetailResult> actList) {
  //   return (actList != null && actList.length > 0)
  //       ? new Container(
  //           constraints: BoxConstraints(minHeight: 20, maxHeight: 280),
  //           margin: new EdgeInsets.symmetric(horizontal: 50.0),
  //           child: Scrollbar(
  //             child: ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: actList.length,
  //               itemBuilder: (BuildContext ctx, int i) =>
  //                   getEventCardWidget(ctx, i, actList),
  //             ),
  //           ),
  //         )
  //       : SafeArea(
  //           child: SizedBox(
  //             height: 1.sh / 5.0,
  //             child: Container(
  //                 child: Center(
  //               child: Text(
  //                 variable.strNoActivities,
  //                 style: TextStyle(fontSize: 12.sp),
  //               ),
  //             )),
  //           ),
  //         );
  // }

  // Widget getEventCardWidget(
  //     BuildContext context, int i, List<MyPlanDetailResult> actList) {
  //   return Container(
  //       padding: EdgeInsets.all(4.0),
  //       margin: EdgeInsets.only(top: 4.0),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFEDE7FC),
  //         borderRadius: BorderRadius.circular(4),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           SizedBox(
  //             width: 200.sp,
  //             child: Text(
  //                 actList[i].titletext != null && actList[i].titletext != ''
  //                     ? actList[i].titletext
  //                     : '',
  //                 style: TextStyle(fontSize: 10.sp)),
  //           ),
  //           SizedBox(height: 4.0.sp),
  //           SizedBox(
  //             width: 200.sp,
  //             child: Text(
  //               actList[i].repeattext != null && actList[i].repeattext != ''
  //                   ? actList[i].repeattext
  //                   : '',
  //               style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //         ],
  //       ));
  // }
}

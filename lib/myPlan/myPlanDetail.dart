import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';

class MyPlanDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlanDetail();
  }
}

class PlanDetail extends State<MyPlanDetail> {
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
      body: Column(
        children: [
          SizedBox(height: 30),
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: 340,
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                width: double.infinity,
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
                                Text(
                                  "Diabetes Management",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text("QurHealth Hospital",
                                    style: TextStyle(color: Colors.grey[600])),
                                Text("Dr.Ramakrishnan", style: TextStyle()),
                                SizedBox(height: 8),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Start Date:",
                                            style: TextStyle(fontSize: 9)),
                                        Text("Apr 08 2021",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(width: 5),
                                        Text("End Date:",
                                            style: TextStyle(fontSize: 9)),
                                        Text("Apr 08 2021",
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
                                Column(
                                  children: [
                                    Container(
                                        width: 220,
                                        padding: EdgeInsets.all(6.0),
                                        margin: EdgeInsets.only(top: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDE7FC),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '10.00AM',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(width: 15),
                                            Text('Blood Pressure',
                                                style: TextStyle(fontSize: 10)),
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Column(
                                  children: [
                                    Container(
                                        width: 220,
                                        padding: EdgeInsets.all(6.0),
                                        margin: EdgeInsets.only(top: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDE7FC),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '10.00AM',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(width: 15),
                                            Text('Blood Pressure',
                                                style: TextStyle(fontSize: 10)),
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Column(
                                  children: [
                                    Container(
                                        width: 220,
                                        padding: EdgeInsets.all(6.0),
                                        margin: EdgeInsets.only(top: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDE7FC),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '10.00AM',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(width: 15),
                                            Text('Blood Pressure',
                                                style: TextStyle(fontSize: 10)),
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Column(
                                  children: [
                                    Container(
                                        width: 220,
                                        padding: EdgeInsets.all(6.0),
                                        margin: EdgeInsets.only(top: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDE7FC),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '10.00AM',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(width: 15),
                                            Text('Blood Pressure',
                                                style: TextStyle(fontSize: 10)),
                                          ],
                                        )),
                                  ],
                                )
                                /*Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 200, // constrain height
                                      child:
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 4,
                                        itemBuilder: (context, position) {
                                          return Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Text(
                                                position.toString(),
                                                style: TextStyle(fontSize: 22.0),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                )*/
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 2,),
                        Divider(color: Colors.grey[500]),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "OK",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(
                                    new CommonUtil().getMyPrimaryColor())),
                          ),
                        )
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
      ),
    );
  }

  Widget getCardWidgetForUser() {
    return Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFe3e2e2),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 2.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Row(
          children: [
            Text('10.00 AM'),
            Text('Blood Pressure'),
          ],
        ));
  }
}

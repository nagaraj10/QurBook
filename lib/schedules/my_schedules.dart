import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

import 'my_appointments.dart';
import 'my_reminders.dart';

class MySchedule extends StatefulWidget {
  @override
  _MyScheduleState createState() => _MyScheduleState();
}

class _MyScheduleState extends State<MySchedule>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(fhbColors.bgColorContainer),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: Container(
            width: 0,
            height: 0,
          ),
          backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                /*   icon: ImageIcon(
                  AssetImage('assets/navicons/schedule.png'),
                  size: 20,
                ), */
                text: 'Appointments',
              ),
              Tab(
                //icon: Icon(Icons.alarm),
                text: 'Reminders',
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
          ),
          //title: Text('My Schedules'),
          //centerTitle: true,
        ),
      ),
      //),
      body: TabBarView(
        controller: _tabController,
        children: [MyAppointment(), MyReminders()],
      ),
      /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ), */
    );
  }

  /*  var listItem = new ListView.builder(
    itemCount: 20,
    itemBuilder: (BuildContext context, int index) {
      return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(fhbColors.cardShadowColor),
                blurRadius: 16, // has the effect of softening the shadow
                spreadRadius: 0.0, // has the effect of extending the shadow
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.deepPurple[300],
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          new FHBUtils().convertMonthFromString(
                              DateTime.now().toString()),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          new FHBUtils()
                              .convertDateFromString(DateTime.now().toString()),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      )
                    ]),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Reminder Title',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black)),
                    Text(
                      'Description',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      new FHBUtils()
                          .getFormattedDateString(DateTime.now().toString()),
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 1, height: 30, color: Colors.deepPurple[100]),
                      SizedBox(width: 10),
                      Icon(
                        FontAwesomeIcons.mapMarkedAlt,
                        size: 20,
                        color: Colors.deepPurple[300],
                      ),
                    ],
                  ))
            ],
          ));
    },
  );
 */
}

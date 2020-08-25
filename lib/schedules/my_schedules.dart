import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

import 'my_appointments.dart';
import 'my_reminders.dart';

import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;

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
              Tab(text: variable.strAppointments),
              Tab(
                text: variable.strRemainders,
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [MyAppointment(), MyReminders()],
      ),
    );
  }
}

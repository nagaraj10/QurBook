import 'package:flutter/material.dart';
import '../common/CommonUtil.dart';
import '../widgets/GradientAppBar.dart';
import '../colors/fhb_colors.dart' as fhbColors;
import '../src/utils/screenutils/size_extensions.dart';

import 'my_appointments.dart';
import 'my_reminders.dart';

import '../constants/fhb_constants.dart' as Constants;
import '../constants/variable_constant.dart' as variable;
import '../constants/router_variable.dart' as router;

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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(fhbColors.bgColorContainer),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0.h),
        child: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: Container(
            width: 0.0.h,
            height: 0.0.h,
          ),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
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

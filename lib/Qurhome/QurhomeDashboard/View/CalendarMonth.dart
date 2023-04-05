import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';


class CalendarMonth extends StatefulWidget {
  CalendarMonth({
    this.regimentsList,
  });

  final List<RegimentDataModel> regimentsList;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CalendarMonth> {
  Map<DateTime, List<dynamic>> _events;

  // List<EventNewModel> eventNewModel = new List<EventNewModel>();
  // List<MonthlyAppointmentModel> appointmentModel = new List<MonthlyAppointmentModel>();
  DateTime monthToday = DateTime.now();
  var str_doctorId;
  List<DateTime> nextMonths = new List();

  @override
  void initState() {
    super.initState();
    _events = {};
    getNextSixMonth();
    // createMockDatas();
  }

  @override
  void dispose() {
    super.dispose();

  }

  getNextSixMonth() {
    for (int i = 0; i < 6; i++) {
      nextMonths.add(new DateTime(monthToday.year, (monthToday.month + i), 01));
    }
  }

  Widget getEventList(List<RegimentDataModel> data) {
    try {
      try {
        data = data.toList();
        // _events = _groupEvents(data);
      } catch (e) {}

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            eventLoader: (DateTime dateTime) => _events[
            DateTime(dateTime.year, dateTime.month, dateTime.day, 12)],
            calendarFormat: CalendarFormat.month,
            firstDay: DateTime.now(),
            focusedDay: DateTime.now(),
            lastDay: DateTime(2200),
            daysOfWeekHeight: 50.0.h,
            calendarStyle: CalendarStyle(
              canMarkersOverflow: true,
              todayTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0.sp,
                color: Colors.white,
              ),
              defaultTextStyle: TextStyle(
                fontSize: 16.0.sp,
              ),
              weekendTextStyle: DaysOfWeekStyle().weekendStyle.copyWith(
                fontSize: 16.0.sp,
                color: Colors.red,
              ),
              disabledTextStyle: TextStyle(
                color: const Color(0xFFBFBFBF),
                fontSize: 16.0.sp,
              ),
              outsideTextStyle: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 16.0.sp,
              ),
              // outsideWeekendStyle: TextStyle(
              //   color: const Color(0xFFEF9A9A),
              //   fontSize: 16.0.sp,
              // ),
              selectedTextStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: 16.0.sp,
              ),
              weekendStyle: DaysOfWeekStyle().weekendStyle.copyWith(
                fontSize: 16.0.sp,
                color: Colors.red,
              ),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: 16.0.sp,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.black,
                size: 24.0.sp,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 24.0.sp,
              ),
              formatButtonDecoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(
                  20.0.sp,
                ),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.0.sp,
              ),
              formatButtonShowsNext: false,
            ),
            startingDayOfWeek: StartingDayOfWeek.sunday,
            /* onDaySelected: (date, events) {
                setState(() {
                  _selectedEvents = events;
                });
              },*/
            /*onDayLongPressed: (day, events) => {
                Navigator.pop(context)
              },*/

            onDaySelected: (day, events) => {
              Navigator.pop(context, day.toString()),
            },
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, events) => Container(
                margin: EdgeInsets.all(
                  9.0.sp,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  /*color: Color(CommonUtil.primaryColor),*/
                  borderRadius: BorderRadius.circular(
                    16.0.sp,
                  ),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0.sp,
                  ),
                ),
              ),
              todayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(9.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.black),
                  )),
              markerBuilder: (context, date, events) {
                final children = <Widget>[];
                if (events.isNotEmpty) {
                  children.add(
                    Container(
                        margin: EdgeInsets.all(
                          9.0.sp,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(CommonUtil().getMyPrimaryColor()),
                          borderRadius: BorderRadius.circular(
                            16.0.sp,
                          ),
                        ),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0.sp,
                          ),
                        )),
                  );

                  // if (events.isNotEmpty) {
                  children.add(
                    Positioned(
                      right: 4.0.w,
                      top: 4.0.h,
                      child: _buildEventsMarker(date),
                    ),
                  );
                }
//                      if (holidays.isNotEmpty) {
//                        children.add(
//                          Positioned(
//                            right: -2,
//                            top: -2,
//                            child: _buildHolidaysMarker(),
//                          ),
//                        );
//                      }
                return Stack(
                  children: [
                    Container(height: 10,width: 10,color: Colors.orange,)
                  ],
                );
              },
              // dowBuilder:
            ),
          ),
        ],
      );
    } catch (e) {}
  }

  Map<DateTime, bool> _groupEvents(List<RegimentDataModel> dataMonthly) {
    Map<DateTime, bool> data = {};

    if (dataMonthly.length > 0) {
      for (int j = 0; j < dataMonthly.length; j++) {
        DateTime dateFrmModel = dataMonthly[j].estart;
        DateTime date = DateTime(dateFrmModel.year, dateFrmModel.month, dateFrmModel.day, 12);
        //data[date][true];
      }
    }
    return data;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Date Picker',
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
        ),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: getEventList([]),
    );
  }


  Widget _buildEventsMarker(DateTime date) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Color(CommonUtil().getMyPrimaryColor()))),
      width: 16.0.h,
      height: 16.0.h,
      child: Center(
        child: TextWidget(
          text: 'd',
          colors: Color(CommonUtil().getMyPrimaryColor()),
          fontsize: 10.0.sp,
        ),
      ),
    );
  }
}

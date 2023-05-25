import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class CalendarMonth extends StatefulWidget {
  String? patientId;
  CalendarMonth({this.patientId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CalendarMonth> {
  late Map<DateTime, List<dynamic>> _events;
  bool onPageChanged = false;
  DateTime monthToday = DateTime.now();
  var str_doctorId;
  final controller = CommonUtil().onInitQurhomeRegimenController();

  @override
  void initState() {
    super.initState();
    _events = {};
    getMonthList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getMonthList() {
    controller.getCalendarRegimenList(patientId: widget.patientId);
  }

  Widget? getEventList(List<RegimentDataModel> data) {
    try {
      try {
        data = data.toList();
        _events = _groupEvents(data);
      } catch (e) {}

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            onPageChanged: (dateTime) {
              controller.selectedDate.value = dateTime;
              onPageChanged = true;
              controller.getCalendarRegimenList();
            },
            eventLoader: (DateTime dateTime) {
              return _events[DateTime(
                      dateTime.year, dateTime.month, dateTime.day, 12)] ??
                  [];
            },
            calendarFormat: CalendarFormat.month,
            firstDay: DateTime(2010),
            focusedDay: onPageChanged
                ? controller.selectedDate.value
                : controller.selectedCalendar.value,
            lastDay: DateTime(2200),
            // currentDay: controller.selectedCalendar.value,
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
            onDaySelected: (day, events) {
              controller.selectedDate.value = day;
              controller.selectedCalendar.value = DateTime.now();
              // controller.selectedCalendar.value = day;
              Get.back(result: day.toString());
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
                      color: Color(CommonUtil().getQurhomePrimaryColor()),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.black),
                  )),
              markerBuilder: (context, date, events) {
                final children = <Widget>[];
                if (events.isNotEmpty) {
                  children.add(Container(
                    height: 7,
                    width: 7,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                  ));
                }
                return Stack(
                  children: children,
                );
              },
              // dowBuilder:
            ),
          ),
        ],
      );
    } catch (e) {}
  }

  Map<DateTime, List<dynamic>> _groupEvents(
      List<RegimentDataModel> dataMonthly) {
    Map<DateTime, List<dynamic>> data = {};

    if (dataMonthly.length > 0) {
      for (int j = 0; j < dataMonthly.length; j++) {
        DateTime? dateFrmModel = dataMonthly[j].estart;
        DateTime date = DateTime(
            dateFrmModel!.year, dateFrmModel.month, dateFrmModel.day, 12);
        List<bool> boolList = [];
        try {
          boolList.add(true);
          data[date] = boolList;
        } catch (e) {
          print(e);
        }
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(CommonUtil().getQurhomePrimaryColor()),
          title: Text(
            CommonUtil().CHOOSE_DATE,
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
        body: Container(
          child: Obx(
            () => controller.loadingCalendar.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GetBuilder<QurhomeRegimenController>(
                    id: "refreshCalendar",
                    builder: (val) {
                      return getEventList(controller
                              .qurHomeRegimenCalendarResponseModel
                              ?.regimentsList ??
                          [])!;
                    }),
          ),
        ));
  }
}

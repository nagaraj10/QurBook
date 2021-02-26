import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/model/timeModel.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsListViewModel.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class DoctorTimeSlotWidget extends StatefulWidget {
  Past doc;
  ValueChanged<String> onChanged;

  DoctorTimeSlotWidget({this.doc, this.onChanged});

  @override
  DoctorTimeSlotWidgetState createState() => DoctorTimeSlotWidgetState();
}

class DoctorTimeSlotWidgetState extends State<DoctorTimeSlotWidget> {
  Timer timer;
  String hour;
  String minutes;
  String days;
  Time time;
  AppointmentsListViewModel appointmentsViewModel;

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    appointmentsViewModel =
        Provider.of<AppointmentsListViewModel>(context, listen: false);
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (widget.doc.plannedStartDateTime != null) {
        setState(() {
          hour = appointmentsViewModel
              .getTimeSlot(widget.doc.plannedStartDateTime)
              .hours;
          minutes = appointmentsViewModel
              .getTimeSlot(widget.doc.plannedStartDateTime)
              .minutes;
          days = appointmentsViewModel
              .getTimeSlot(widget.doc.plannedStartDateTime)
              .daysCount;
        });
      } else {
        setState(() {
          hour = Constants.STATIC_HOUR;
          minutes = Constants.STATIC_HOUR;
          days = Constants.ZERO;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return days != Constants.ZERO && days != null
        ? TextWidget(
            fontsize: 12.0.sp,
            text: days + Constants.Appointments_days,
            fontWeight: FontWeight.w500,
            colors: Colors.black,
          )
        : ((hour == Constants.STATIC_HOUR &&
                    minutes == Constants.STATIC_HOUR) ||
                hour == null ||
                minutes == null)
            ? Container()
            : Row(
                children: [
                  ClipRect(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(new CommonUtil().getMyPrimaryColor())),
                      ),
                      height: 35.0.h,
                      width: 25.0.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(2.0.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextWidget(
                            fontsize: 12.0.sp,
                            text: hour,
                            fontWeight: FontWeight.w500,
                            colors: Colors.grey,
                          ),
                          TextWidget(
                            fontsize: 7.0.sp,
                            text: Constants.Appointments_hours,
                            fontWeight: FontWeight.w500,
                            colors: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBoxWidget(width: 2.0.w),
                  ClipRect(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(new CommonUtil().getMyPrimaryColor())),
                      ),
                      height: 35.0.h,
                      width: 25.0.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(
                        2.0.sp,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextWidget(
                            fontsize: 12.0.sp,
                            text: minutes,
                            fontWeight: FontWeight.w500,
                            colors: Colors.grey,
                          ),
                          TextWidget(
                            fontsize: 7.0.sp,
                            text: Constants.Appointments_minutes,
                            fontWeight: FontWeight.w500,
                            colors: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
  }
}

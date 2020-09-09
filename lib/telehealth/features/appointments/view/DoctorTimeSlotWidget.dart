import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class DoctorTimeSlotWidget extends StatefulWidget {
  History doc;
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

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (widget.doc.plannedStartDateTime != null) {
        String hours, min;
        int dys;
        DateTime dob1 = DateFormat(Constants.Appointments_slot_format)
            .parse(widget.doc.plannedStartDateTime);
        DateTime dob2 = DateFormat(Constants.Appointments_slot_format)
            .parse('${DateTime.now()}');
        Duration dur = dob1.difference(dob2);
        dys = dur.inDays;
        hours = dur.inHours >= 0 && dur.inHours <= 24
            ? (dur.inHours.remainder(24))
                .round()
                .toString()
                .padLeft(2, Constants.ZERO)
            : Constants.STATIC_HOUR;
        min = dur.inHours >= 0 && dur.inHours <= 24
            ? (dur.inMinutes.remainder(60))
                .toString()
                .padLeft(2, Constants.ZERO)
            : Constants.STATIC_HOUR;
        setState(() {
          hour = dur.inHours.remainder(24).toInt() <= 0 || dur.inHours >= 24
              ? Constants.STATIC_HOUR
              : hours;
          minutes =  dur.inHours >= 24 || int.parse(min) <=0
              ? Constants.STATIC_HOUR
              : min;
//
          days = dys >= 0 ? dys.toString() : Constants.ZERO;
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
            fontsize: 10,
            text: days + Constants.Appointments_days,
            fontWeight: FontWeight.w500,
            colors: Colors.black,
          )
        : ((hour == Constants.STATIC_HOUR &&
                    minutes == Constants.STATIC_HOUR) ||
                hour == null ||
                minutes == null)
//        ||
//                hour.length == 0 ||
//                minute.length == 0)
            ? Container()
            : Row(
                children: [
                  ClipRect(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(new CommonUtil().getMyPrimaryColor())),
                      ),
                      height: 29,
                      width: 25,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextWidget(
                            fontsize: 10,
                            text: hour,
                            fontWeight: FontWeight.w500,
                            colors: Colors.grey,
                          ),
                          TextWidget(
                            fontsize: 5,
                            text: Constants.Appointments_hours,
                            fontWeight: FontWeight.w500,
                            colors: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBoxWidget(width: 2.0),
                  ClipRect(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(new CommonUtil().getMyPrimaryColor())),
                      ),
                      height: 29,
                      width: 25,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextWidget(
                            fontsize: 10,
                            text: minutes,
                            fontWeight: FontWeight.w500,
                            colors: Colors.grey,
                          ),
                          TextWidget(
                            fontsize: 5,
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

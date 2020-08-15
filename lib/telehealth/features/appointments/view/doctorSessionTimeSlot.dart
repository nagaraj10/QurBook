import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/appointments/view/getTimeSlot.dart';

class DoctorSessionTimeSlot extends StatefulWidget {
  final String doctorId;
  final String date;
  final List<DoctorIds> docs;
  final int i;

  DoctorSessionTimeSlot({this.doctorId, this.date, this.docs, this.i});

  @override
  State<StatefulWidget> createState() {
    return DoctorSessionTimeSlotState();
  }
}

class DoctorSessionTimeSlotState extends State<DoctorSessionTimeSlot> {
  MyProviderViewModel providerViewModel;
  CommonWidgets commonWidgets = new CommonWidgets();
  DateTime _selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 65,
          color: Colors.grey[200],
          child: DatePicker(
            DateTime.now().add(Duration(days: -0)),
            controller: _controller,
            width: 40,
            height: 45,
            initialSelectedDate: DateTime.now(),
            selectionColor: Color(new CommonUtil().getMyPrimaryColor()),
            selectedTextColor: Colors.white,
            dayTextStyle: TextStyle(
                fontSize: fhbStyles.fnt_day, fontWeight: FontWeight.w600),
            dateTextStyle: TextStyle(
                fontSize: fhbStyles.fnt_date, fontWeight: FontWeight.w700),
            onDateChange: (date) {
              setState(() {
                _selectedValue = date;
              });
            },
          ),
        ),
        getTimeSlots(),
      ],
    );
  }

  SessionData sessionData;

  Widget getTimeSlots() {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 12),
      child: GetTimeSlots(
          dateSlotTimingsObj: sessionData = SessionData(
              doctorId: 'doc7777',
              date: '11-08-20',
              day: 'Wednessday',
              sessionCounts: 3,
              sessions: [
                SessionsTime(
                    doctorSessionId: '444',
                    sessionEndTime: '01:50',
                    sessionStartTime: '10:04',
                    slotCounts: 3,
                    slots: [
                      Slots(
                          slotNumber: 2,
                          endTime: '10:45',
                          isAvailable: true,
                          startTime: '10:45'),
                      Slots(
                          slotNumber: 2,
                          endTime: '12:00',
                          isAvailable: true,
                          startTime: '11:45'),
                      Slots(
                          slotNumber: 2,
                          endTime: '01:45',
                          isAvailable: true,
                          startTime: '12:45')
                    ])
              ]),
          docs: widget.docs,
          j: widget.i,
          selectedDate: _selectedValue),
    );
  }
}

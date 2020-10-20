import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotsResultModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/GetTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/SlotsAvailabilityViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';

class DoctorSessionTimeSlot extends StatefulWidget {
  final String doctorId;
  final String date;
  final List<Doctors> docs;
  final int i;
  Past doctorsData;
  bool isReshedule;
  final String healthOrganizationId;
  final List<HealthOrganizationResult> healthOrganizationResult;
  final int doctorListPos;
  Function(String) closePage;

  DoctorSessionTimeSlot(
      {this.doctorId,
      this.date,
      this.docs,
      this.i,
      this.isReshedule,
      this.doctorsData,
      this.healthOrganizationId,
      this.healthOrganizationResult,
      this.doctorListPos,
      this.closePage});

  @override
  State<StatefulWidget> createState() {
    return DoctorSessionTimeSlotState();
  }
}

class DoctorSessionTimeSlotState extends State<DoctorSessionTimeSlot> {
  SlotsAvailabilityViewModel slotsAvailabilityViewModel =
      new SlotsAvailabilityViewModel();
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
            initialSelectedDate: initialDate(),
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

  DateTime initialDate() {
    if (widget.doctorsData != null) {
      if (widget.doctorsData.plannedFollowupDate != null) {
        return DateTime.parse(widget.doctorsData.plannedFollowupDate);
      } else {
        return DateTime.now();
      }
    } else {
      return DateTime.now();
    }
  }

  Widget getTimeSlots() {
    return new FutureBuilder<SlotsResultModel>(
      future: slotsAvailabilityViewModel.fetchTimeSlots(
          _selectedValue.toString(),
          widget.doctorId,
          widget.healthOrganizationId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
                child: new Column(
              children: <Widget>[
                SizedBoxWidget(height: 20.0),
                new SizedBox(
                  child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor())),
                  height: 20.0,
                  width: 20.0,
                ),
                SizedBoxWidget(height: 120.0),
              ],
            ));
          } else if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else {
            return snapshot.data.sessionCounts != null
                ? Container(
                    margin: EdgeInsets.only(left: 5, top: 12),
                    child: GetTimeSlots(
                      dateSlotTimingsObj: snapshot.data,
                      docs: widget.docs,
                      j: widget.i,
                      selectedDate: _selectedValue,
                      isReshedule: widget.isReshedule,
                      doctorsData: widget.doctorsData,
                      healthOrganizationResult: widget.healthOrganizationResult,
                      doctorListPos: widget.doctorListPos,
                      closePage: (value) {
                        widget.closePage(value);
                      },
                    ),
                  )
                : Column(
                    children: <Widget>[
                      SizedBoxWidget(
                        height: 8,
                      ),
                      new Text(
                        slotsAreNotAvailable,
                        style: TextStyle(fontSize: 10.0),
                      ),
                      SizedBoxWidget(
                        height: 8,
                      ),
                    ],
                  );
          }
        } else {
          return Column(
            children: <Widget>[
              SizedBoxWidget(
                height: 8,
              ),
              new Text(
                slotsAreNotAvailable,
                style: TextStyle(fontSize: 10.0),
              ),
              SizedBoxWidget(
                height: 8,
              ),
            ],
          );
        }
      },
    );
  }
}

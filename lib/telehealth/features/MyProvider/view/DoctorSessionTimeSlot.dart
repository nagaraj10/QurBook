import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorsFromHospitalModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotsResultModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/GetTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/SlotsAvailabilityViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class DoctorSessionTimeSlot extends StatefulWidget {
  final String doctorId;
  final String date;
  final List<Doctors> docs;
  final int i;
  final int doctorListIndex;
  Past doctorsData;
  bool isReshedule;
  final String healthOrganizationId;
  final List<HealthOrganizationResult> healthOrganizationResult;
  final List<ResultFromHospital> resultFromHospitalList;
  final int doctorListPos;
  Function(String) closePage;
  Function() refresh;
  bool isFromNotification;
  ValueChanged<String> onChanged;
  DateTime onUserChangedDate;
  bool isFromHospital;
  dynamic body;

  DoctorSessionTimeSlot(
      {this.doctorId,
      this.date,
      this.docs,
      this.i,
      this.doctorListIndex,
      this.isReshedule,
      this.doctorsData,
      this.healthOrganizationId,
      this.healthOrganizationResult,
      this.resultFromHospitalList,
      this.doctorListPos,
      this.closePage,
      this.refresh,
      this.isFromNotification,
      this.onChanged,
      this.onUserChangedDate,
      this.isFromHospital,
      this.body});

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
    getSelectedValue();
  }

  getSelectedValue() {
    DateTime sValue;
    if (widget.doctorsData != null) {
      if (widget.doctorsData.plannedFollowupDate != null) {
        int scrollDays = DateTime.parse(widget.doctorsData.plannedFollowupDate)
            .difference(DateTime.now())
            .inDays;
        if (scrollDays >= 0) {
          sValue = DateTime.parse(widget.doctorsData.plannedFollowupDate);
        } else {
          sValue = DateTime.now();
        }
      } else {
        sValue = DateTime.now();
      }
      setState(() {
        _selectedValue = sValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 65.0.h,
          color: Colors.grey[200],
          child: DatePicker(
            DateTime.now().add(Duration(days: -0)),
            controller: _controller,
            width: 40.0.w,
            height: 45.0.h,
            initialSelectedDate: initialDate(),
            selectionColor: Color(new CommonUtil().getMyPrimaryColor()),
            selectedTextColor: Colors.white,
            dayTextStyle: TextStyle(
              fontSize: fhbStyles.fnt_day,
              fontWeight: FontWeight.w600,
            ),
            dateTextStyle: TextStyle(
              fontSize: fhbStyles.fnt_date,
              fontWeight: FontWeight.w700,
            ),
            onDateChange: (date) {
              setState(() {
                _selectedValue = date;
              });
              widget.onChanged(date.toString());
            },
            isScrollToDate: widget.doctorsData != null
                ? widget.doctorsData.plannedFollowupDate != null
                    ? true
                    : false
                : false,
            scrollToDate: widget.doctorsData != null
                ? widget.onUserChangedDate != null
                    ? widget.onUserChangedDate.toString()
                    : widget.doctorsData.plannedFollowupDate != null
                        ? widget.doctorsData.plannedFollowupDate
                        : DateTime.now().toString()
                : DateTime.now().toString(),
          ),
        ),
        getTimeSlots(),
      ],
    );
  }

  DateTime initialDate() {
    if (widget.doctorsData != null) {
      if (widget.onUserChangedDate != null) {
        setState(() {
          _selectedValue = widget.onUserChangedDate;
        });
        return widget.onUserChangedDate;
      } else if (widget.doctorsData.plannedFollowupDate != null) {
        int scrollDays = DateTime.parse(widget.doctorsData.plannedFollowupDate)
            .difference(DateTime.now())
            .inDays;
        if (scrollDays >= 0) {
          return DateTime.parse(widget.doctorsData.plannedFollowupDate);
        } else {
          return DateTime.now();
        }
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
                SizedBoxWidget(height: 20.0.h),
                new SizedBox(
                  child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor())),
                  height: 20.0.h,
                  width: 20.0.h,
                ),
                SizedBoxWidget(height: 120.0.h),
              ],
            ));
          } else if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else {
            return snapshot.data.sessionCounts != null &&
                    snapshot.data.sessions != null
                ? snapshot.data.sessions[0].slots != null &&
                        snapshot.data.sessions[0].slots.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(left: 5, top: 12),
                        child: GetTimeSlots(
                          dateSlotTimingsObj: snapshot.data,
                          docs: widget.docs,
                          j: widget.i,
                          doctorListIndex: widget.doctorListIndex,
                          selectedDate: _selectedValue,
                          isReshedule: widget.isReshedule,
                          doctorsData: widget.doctorsData,
                          healthOrganizationResult:
                              widget.healthOrganizationResult,
                          resultFromHospitalList: widget.resultFromHospitalList,
                          doctorListPos: widget.doctorListPos,
                          closePage: (value) {
                            widget.closePage(value);
                          },
                          isRefresh: () {
                            widget.refresh();
                          },
                          isFromNotification: widget.isFromNotification,
                          isFromHospital: widget.isFromHospital,
                          body: widget.body,
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          SizedBoxWidget(
                            height: 8.0.h,
                          ),
                          new Text(
                            slotsAreNotAvailable,
                            style: TextStyle(
                              fontSize: 12.0.sp,
                            ),
                          ),
                          SizedBoxWidget(
                            height: 8.0.h,
                          ),
                        ],
                      )
                : Column(
                    children: <Widget>[
                      SizedBoxWidget(
                        height: 8.0.h,
                      ),
                      new Text(
                        slotsAreNotAvailable,
                        style: TextStyle(
                          fontSize: 12.0.sp,
                        ),
                      ),
                      SizedBoxWidget(
                        height: 8.0.h,
                      ),
                    ],
                  );
          }
        } else {
          return Column(
            children: <Widget>[
              SizedBoxWidget(
                height: 8.0.h,
              ),
              new Text(
                slotsAreNotAvailable,
                style: TextStyle(
                  fontSize: 12.0.sp,
                ),
              ),
              SizedBoxWidget(
                height: 8.0.h,
              ),
            ],
          );
        }
      },
    );
  }
}

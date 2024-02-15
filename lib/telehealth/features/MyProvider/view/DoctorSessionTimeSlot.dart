import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../common/common_circular_indicator.dart';
import '../../../../common/errors_widget.dart';
import '../../../../constants/fhb_parameters.dart';
import '../../../../constants/variable_constant.dart';
import '../../../../landing/service/landing_service.dart';
import '../../../../my_providers/models/Doctors.dart';
import '../../../../my_providers/models/GetDoctorsByIdModel.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../styles/styles.dart' as fhbStyles;
import '../../appointments/model/fetchAppointments/past.dart';
import '../model/DoctorsFromHospitalModel.dart';
import '../model/getAvailableSlots/AvailableTimeSlotsModel.dart';
import '../model/healthOrganization/HealthOrganizationResult.dart';
import '../viewModel/SlotsAvailabilityViewModel.dart';
import 'CommonWidgets.dart';
import 'GetTimeSlots.dart';

class DoctorSessionTimeSlot extends StatefulWidget {
  final String? doctorId;
  final String? date;
  final List<Doctors?>? docs;
  final List<DoctorResult?>? docsReschedule;
  final int? i;
  final int? doctorListIndex;
  Past? doctorsData;
  bool? isReshedule;
  final String? healthOrganizationId;
  final List<HealthOrganizationResult>? healthOrganizationResult;
  final List<ResultFromHospital>? resultFromHospitalList;
  final int? doctorListPos;
  Function(String)? closePage;
  Function()? refresh;
  bool? isFromNotification;
  ValueChanged<String>? onChanged;
  DateTime? onUserChangedDate;
  bool? isFromHospital;
  dynamic body;
  bool? isFromFollowOrReschedule;
  bool? isFromFollowUpApp;
  bool? isFromFollowUpTake;
  num? doctorAppoinmentTransLimit;
  num? noOfDoctorAppointments;

  DoctorSessionTimeSlot({
    this.doctorId,
    this.date,
    this.docs,
    this.docsReschedule,
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
    this.body,
    this.isFromFollowOrReschedule,
    this.isFromFollowUpApp,
    this.isFromFollowUpTake,
  });

  @override
  State<StatefulWidget> createState() {
    return DoctorSessionTimeSlotState();
  }
}

class DoctorSessionTimeSlotState extends State<DoctorSessionTimeSlot> {
  SlotsAvailabilityViewModel slotsAvailabilityViewModel =
      SlotsAvailabilityViewModel();
  CommonWidgets commonWidgets = CommonWidgets();
  DateTime? _selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();

  @override
  void initState() {
    super.initState();
    getSelectedValue();
    updateMembershipStatus();
  }

  getSelectedValue() {
    DateTime sValue;
    if (widget.doctorsData != null) {
      if (widget.doctorsData!.plannedFollowupDate != null) {
        int scrollDays =
            DateTime.parse(widget.doctorsData!.plannedFollowupDate!)
                .difference(DateTime.now())
                .inDays;
        if (scrollDays >= 0) {
          sValue = DateTime.parse(widget.doctorsData!.plannedFollowupDate!);
        } else {
          sValue = DateTime.now();
        }
      } else {
        sValue = DateTime.now();
      }
      setState(
        () {
          _selectedValue = sValue;
        },
      );
    }
  }

  updateMembershipStatus() async {
    var value = await LandingService.getMemberShipDetails();
    PreferenceUtil.saveActiveMembershipStatus(
      value.isSuccess! ? (value.result ?? []).length > 0 : false,
    );
    // Iterate through the result list
    value.result?.forEach((result) {
      // Iterate through the benefitType list in additionalInfo
      result.additionalInfo?.benefitType?.forEach((benefitType) {
        // Check if fieldName is "Doctor Appointment"
        if (benefitType.fieldName == strBenefitDoctorAppointment) {
          // Get the transactionLimit
          widget.doctorAppoinmentTransLimit = benefitType.transactionLimit;
        }
      });
    });
    if(value.result?.first.noOfDoctorAppointments!=null){
      widget.noOfDoctorAppointments= value.result?.first.noOfDoctorAppointments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 80.0.h,
          color: Colors.grey[200],
          child: DatePicker(
            DateTime.now().add(Duration(days: -0)),
            controller: _controller,
            width: 40.0.w,
            height: 45.0.h,
            initialSelectedDate: initialDate(),
            selectionColor: Color(CommonUtil().getMyPrimaryColor()),
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
              widget.onChanged!(date.toString());
            },
            isScrollToDate: widget.doctorsData != null
                ? widget.doctorsData!.plannedFollowupDate != null
                    ? true
                    : false
                : false,
            scrollToDate: widget.doctorsData != null
                ? widget.onUserChangedDate != null
                    ? widget.onUserChangedDate.toString()
                    : widget.doctorsData!.plannedFollowupDate != null
                        ? widget.doctorsData!.plannedFollowupDate
                        : DateTime.now().toString()
                : DateTime.now().toString(),
          ),
        ),
        getTimeSlots(),
      ],
    );
  }

  DateTime? initialDate() {
    if (widget.doctorsData != null) {
      if (widget.onUserChangedDate != null) {
        setState(() {
          _selectedValue = widget.onUserChangedDate;
        });
        return widget.onUserChangedDate;
      } else if (widget.doctorsData!.plannedFollowupDate != null) {
        int scrollDays =
            DateTime.parse(widget.doctorsData!.plannedFollowupDate!)
                .difference(DateTime.now())
                .inDays;
        if (scrollDays >= 0) {
          return DateTime.parse(widget.doctorsData!.plannedFollowupDate!);
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
    return FutureBuilder<AvailableTimeSlotsModel?>(
      future: slotsAvailabilityViewModel.fetchTimeSlots(
          _selectedValue.toString(),
          widget.doctorId!,
          widget.healthOrganizationId!),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Column(
              children: <Widget>[
                SizedBoxWidget(height: 20.0.h),
                SizedBox(
                  child: CommonCircularIndicator(),
                  height: 20.0.h,
                  width: 20.0.h,
                ),
                SizedBoxWidget(height: 120.0.h),
              ],
            ));
          } else if (snapshot.hasError) {
            return ErrorsWidget();
          } else {
            return (snapshot.data!.isSuccess != null &&
                    !snapshot.data!.isSuccess! &&
                    (snapshot.data!.message ?? '').isNotEmpty)
                ? Column(
                    children: <Widget>[
                      SizedBoxWidget(
                        height: 8.0.h,
                      ),
                      Text(
                        snapshot.data!.message!,
                        style: TextStyle(
                          fontSize: 12.0.sp,
                        ),
                      ),
                      SizedBoxWidget(
                        height: 8.0.h,
                      ),
                    ],
                  )
                : snapshot.data!.result != null &&
                        snapshot.data!.result!.sessions != null &&
                        snapshot.data!.result!.sessions != null
                    ? snapshot.data!.result!.sessions![0].slots != null &&
                            snapshot
                                .data!.result!.sessions![0].slots!.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(left: 5, top: 12),
                            child: GetTimeSlots(
                              dateSlotTimingsObj: snapshot.data!.result,
                              docs: widget.docs,
                              docsReschedule: widget.docsReschedule,
                              j: widget.i,
                              doctorListIndex: widget.doctorListIndex,
                              selectedDate: _selectedValue,
                              isReshedule: widget.isReshedule,
                              doctorsData: widget.doctorsData,
                              healthOrganizationResult:
                                  widget.healthOrganizationResult,
                              resultFromHospitalList:
                                  widget.resultFromHospitalList,
                              doctorListPos: widget.doctorListPos,
                              closePage: (value) {
                                widget.closePage!(value);
                              },
                              isRefresh: () {
                                widget.refresh!();
                              },
                              noOfDoctorAppointments:widget.noOfDoctorAppointments,
                              doctorAppoinmentTransLimit:widget.doctorAppoinmentTransLimit,
                              isFromNotification: widget.isFromNotification,
                              isFromHospital: widget.isFromHospital,
                              body: widget.body,
                              isFromFollowReschedule:
                                  widget.isFromFollowOrReschedule,
                              isFromFollowUpApp: widget.isFromFollowUpApp,
                              isFromFollowUpTake: widget.isFromFollowUpTake,
                            ),
                          )
                        : Column(
                            children: <Widget>[
                              SizedBoxWidget(
                                height: 8.0.h,
                              ),
                              Text(
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
                          Text(
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
              Text(
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

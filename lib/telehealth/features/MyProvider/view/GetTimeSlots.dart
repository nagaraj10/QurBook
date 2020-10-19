import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotsResultModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/BookingConfirmation.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/SessionList.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as AppointmentConstant;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/resheduleModel.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/resheduleAppointmentViewModel.dart';
import 'package:provider/provider.dart';

class GetTimeSlots extends StatelessWidget {
  SlotsResultModel dateSlotTimingsObj;
  final List<Doctors> docs;
  final int j;
  Past doctorsData;
  final DateTime selectedDate;
  bool isReshedule;
  FlutterToast toast = new FlutterToast();
  List<String> bookingIds = [];
  final List<HealthOrganizationResult> healthOrganizationResult;
  final int doctorListPos;
  Function(String) closePage;

  GetTimeSlots(
      {this.dateSlotTimingsObj,
      this.docs,
      this.j,
      this.selectedDate,
      this.isReshedule,
      this.doctorsData,
      this.healthOrganizationResult,
      this.doctorListPos,
      this.closePage});

  @override
  Widget build(BuildContext context) {
    int rowPosition = -1;
    int itemPosition = -1;
    return Column(
      children: <Widget>[
        SessionList(
          sessionData: dateSlotTimingsObj.sessions,
          selectedPosition: (rowPos, itemPos) {
            rowPosition = rowPos;
            itemPosition = itemPos;
          },
        ),
        SizedBoxWidget(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBoxWithChild(
            width: 85,
            height: 35,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(
                      color: Color(new CommonUtil().getMyPrimaryColor()))),
              color: Colors.transparent,
              textColor: Color(new CommonUtil().getMyPrimaryColor()),
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                if (isReshedule == true) {
                  print(doctorsData.slotNumber);
                  print(doctorsData.bookingId);
                  print(selectedDate.toString().substring(0, 10));
                  String selectedSlot = dateSlotTimingsObj
                      .sessions[rowPosition].slots[itemPosition].slotNumber
                      .toString();
                  resheduleAppoitment(
                      context,
                      [doctorsData],
                      selectedSlot,
                      selectedDate.toString().substring(0, 10),
                      doctorsData.doctorSessionId);
                } else {
                  if (rowPosition > -1 && itemPosition > -1) {
                    if (patientAddressCheck()) {
                      if (doctorsData == null) {
                        navigateToConfirmBook(context, rowPosition,
                            itemPosition, null, false, false);
                      } else {
                        navigateToConfirmBook(
                            context,
                            rowPosition,
                            itemPosition,
                            doctorsData.doctorFollowUpFee,
                            true,
                            true);
                      }
                    } else {
                      toast.getToast(noAddress, Colors.red);
                    }
                  } else {
                    toast.getToast(selectSlotsMsg, Colors.red);
                  }
                }
              },
              child: TextWidget(text: bookNow, fontsize: 12),
            ),
          ),
        ),
        SizedBoxWidget(
          height: 10,
        ),
      ],
    );
  }

  navigateToConfirmBook(BuildContext context, int rowPos, int itemPos,
      String followUpFee, bool isNewAppointment, bool isFollowUp) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmation(
            docs: docs,
            followUpFee: followUpFee,
            isNewAppointment: isNewAppointment,
            i: j,
            selectedDate: selectedDate,
            sessionData: dateSlotTimingsObj.sessions,
            rowPosition: rowPos,
            itemPosition: itemPos,
            isFollowUp: isFollowUp,
            doctorsData: doctorsData,
            healthOrganizationResult: healthOrganizationResult,
            doctorListPos: doctorListPos,
            closePage: (value) {
              closePage(value);
            },
          ),
        ));
  }

  resheduleAppoitment(BuildContext context, List<Past> appointments,
      String slotNumber, String resheduledDate, String doctorSessionId) {
    resheduleAppointment(
            context, appointments, slotNumber, resheduledDate, doctorSessionId)
        .then((value) {
      Navigator.pop(context);
      if (value == null) {
        toast.getToast(AppointmentConstant.SLOT_NOT_AVAILABLE, Colors.red);
      } else if (value.isSuccess == true) {
        toast.getToast(
            AppointmentConstant.YOUR_RESHEDULE_SUCCESS, Colors.green);
      } else if (value.message.contains(AppointmentConstant.NOT_AVAILABLE)) {
        toast.getToast(AppointmentConstant.SLOT_NOT_AVAILABLE, Colors.red);
      } else {
        toast.getToast(AppointmentConstant.RESHEDULE_CANCEL, Colors.red);
      }
    });
  }

  Future<ResheduleModel> resheduleAppointment(
      BuildContext context,
      List<Past> appointments,
      String slotNumber,
      String resheduledDate,
      String doctorSessionId) async {
    for (int i = 0; i < appointments.length; i++) {
      bookingIds.add(appointments[i].bookingId);
    }
    ResheduleAppointmentViewModel reshedule =
        Provider.of<ResheduleAppointmentViewModel>(context, listen: false);
    ResheduleModel resheduleAppointment = await reshedule.resheduleAppointment(
        bookingIds, slotNumber.toString(), resheduledDate, doctorSessionId);
    return resheduleAppointment;
  }

  bool patientAddressCheck() {
    bool condition;

    String address1 = PreferenceUtil.getStringValue(Constants.ADDRESS1);
    String city = PreferenceUtil.getStringValue(Constants.CITY);
    String state = PreferenceUtil.getStringValue(Constants.STATE);
    String pincode = PreferenceUtil.getStringValue(Constants.PINCODE);

    if (address1 != '' && city != '' && state != '' && pincode != '') {
      condition = true;
    } else {
      condition = false;
    }
    return condition;
  }
}

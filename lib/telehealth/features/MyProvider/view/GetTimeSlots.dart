import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/BookingConfirmation.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/SessionList.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/resheduleModel.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsViewModel.dart';
import 'package:path/path.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class GetTimeSlots extends StatelessWidget {
  SessionData dateSlotTimingsObj;
  final List<DoctorIds> docs;
  final int j;
  History doctorsData;
  final DateTime selectedDate;
  bool isReshedule;
  FlutterToast toast = new FlutterToast();
  List<String> bookingIds = [];
  AppointmentsViewModel appointmentsViewModel = AppointmentsViewModel();

  GetTimeSlots(
      {this.dateSlotTimingsObj,
      this.docs,
      this.j,
      this.selectedDate,
      this.isReshedule,
      this.doctorsData});

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
                  resheduleAppoitment(
                      context,
                      [doctorsData],
                      doctorsData.slotNumber.toString(),
                      selectedDate.toString().substring(0, 10));
                } else {
                  if (rowPosition > -1 && itemPosition > -1) {
                    if (doctorsData == null) {
                      print('normal Appointmnt');
                      navigateToConfirmBook(
                          context, rowPosition, itemPosition, null, false);
                    } else {
                      print('new Appointmnt from history');
                      navigateToConfirmBook(context, rowPosition, itemPosition,
                          doctorsData.followupFee, true);
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
      String followUpFee, bool isNewAppointment) {
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
              itemPosition: itemPos),
        ));
  }

  resheduleAppoitment(BuildContext context, List<History> appointments,
      String slotNumber, String resheduledDate) {
    resheduleAppointment(context, appointments, slotNumber, resheduledDate)
        .then((value) {
      Navigator.pop(context);
      if (value == null) {
        toast.getToast(Constants.SLOT_NOT_AVAILABLE, Colors.red);
      } else if (value.status == 200 &&
          value.success == true &&
          value.message.contains('success')) {
        toast.getToast(Constants.YOUR_RESHEDULE_SUCCESS, Colors.green);
      } else if (value.message.contains('not available')) {
        toast.getToast(Constants.SLOT_NOT_AVAILABLE, Colors.red);
      } else {
        toast.getToast(Constants.RESHEDULE_CANCEL, Colors.red);
      }
    });
  }

  Future<Reshedule> resheduleAppointment(
      BuildContext context,
      List<History> appointments,
      String slotNumber,
      String resheduledDate) async {
    for (int i = 0; i < appointments.length; i++) {
      bookingIds.add(appointments[i].bookingId);
    }
    Reshedule resheduleAppointment =
        await appointmentsViewModel.resheduleAppointment(
            bookingIds, slotNumber.toString(), resheduledDate);
    return resheduleAppointment;
  }
}

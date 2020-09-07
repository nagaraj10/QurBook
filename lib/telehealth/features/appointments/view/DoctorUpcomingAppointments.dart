import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/view/DoctorTimeSlotWidget.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsViewModel.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorUpcomingAppointments extends StatefulWidget {
  History doc;
  String hour;
  String minute;
  String days;
  ValueChanged<String> onChanged;

  DoctorUpcomingAppointments({this.doc, this.onChanged});

  @override
  DoctorUpcomingAppointmentState createState() =>
      DoctorUpcomingAppointmentState();
}

class DoctorUpcomingAppointmentState extends State<DoctorUpcomingAppointments> {
  AppointmentsCommonWidget commonWidget = AppointmentsCommonWidget();
  FlutterToast toast = new FlutterToast();
  List<String> bookingIds = new List();
  AppointmentsViewModel appointmentsViewModel = AppointmentsViewModel();
  SharedPreferences prefs;
  ChatViewModel chatViewModel = ChatViewModel();
  /* Timer timer;
  String hour;
  String minutes;
  String days;*/

  @override
  void initState() {
    // TODO: implement initState
    /*timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (widget.doc.plannedStartDateTime != null) {
        String hours, min;
        int dys;
        DateTime dob1 = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(widget.doc.plannedStartDateTime);
        DateTime dob2 =
            DateFormat("yyyy-MM-dd HH:mm:ss").parse('${DateTime.now()}');
        Duration dur = dob1.difference(dob2);
        dys = dur.inDays;
        hours = dur.inHours >= 0 && dur.inHours <= 24
            ? (dur.inHours.remainder(24)).round().toString().padLeft(2, '0')
            : '00';
        min = dur.inHours >= 0 && dur.inHours <= 24
            ? (dur.inMinutes.remainder(60)).toString().padLeft(2, '0')
            : '00';
        setState(() {
          hour = dur.inHours.remainder(24).toInt() <= 0 || dur.inHours >= 24
              ? '00'
              : hours;
          minutes = dur.inHours.remainder(24).toInt() <= 0 || dur.inHours >= 24
              ? '00'
              : min;
          days = dys >= 0 ? dys.toString() : '0';
        });
      } else {
        setState(() {
          hour = '00';
          minutes = '00';
          days = '0';
        });
      }
    });*/
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 0.5,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: Stack(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
//                      width:MediaQuery.of(context).size.width/1.8,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          docPhotoView(widget.doc),
                          SizedBoxWidget(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              commonWidget.docName(
                                  context, widget.doc.doctorName),
                              SizedBoxWidget(height: 3.0, width: 0),
                              widget.doc.specialization == null
                                  ? Container()
                                  : commonWidget.docStatus(
                                      context, widget.doc.specialization ?? ''),
                              widget.doc.specialization == null
                                  ? Container()
                                  : SizedBox(height: 3.0),
                              commonWidget.docLoc(context, widget.doc.location),
                              SizedBox(height: 5.0),
                              DoctorTimeSlotWidget(
                                doc: widget.doc,
                                onChanged: widget.onChanged,
                              ),
                              SizedBoxWidget(height: 15.0),
                              commonWidget.docIcons(widget.doc, context)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          //joinCallIcon(doc),
                          IconButton(
                              icon: ImageIcon(
                                  AssetImage(Constants.Appointments_chatImage)),
                              onPressed: () {
                                  goToChatIntegration(widget.doc);
                              }),
                          SizedBoxWidget(
                            height:
                                (widget.hour == '00' || widget.minute == '00')
                                    ? 0
                                    : 15,
                          ),
                          SizedBoxWidget(
                            height: widget.doc.specialization == null ? 30 : 40,
                          ),
                          commonWidget.count(widget.doc.slotNumber),
                          TextWidget(
                            fontsize: 10,
                            text: DateFormat("hh:mm a")
                                    .format(DateTime.parse(
                                        widget.doc.plannedStartDateTime))
                                    .toString() ??
                                '',
                            fontWeight: FontWeight.w600,
                            colors: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                          TextWidget(
                            fontsize: 10,
                            text: DateFormat.yMMMEd()
                                    .format(DateTime.parse(
                                        widget.doc.plannedStartDateTime))
                                    .toString() ??
                                '',
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.visible,
                            colors: Colors.black,
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            SizedBoxWidget(height: 10.0),
            Container(height: 1, color: Colors.black26),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 67, top: 10, bottom: 10),
              child: Row(
                children: [
                  commonWidget.iconWithText(Constants.Appointments_receiptImage,
                      Colors.black38, Constants.Appointments_receipt, () {
                    moveToBilsPage(widget.doc.paymentMediaMetaId);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(
                      Constants.Appointments_resheduleImage,
                      Colors.black38,
                      Constants.Appointments_reshedule, () {
                    navigateToProviderScreen(widget.doc, true);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(Constants.Appointments_cancelImage,
                      Colors.black38, Constants.Appointments_cancel, () {
                    _displayDialog(context, [widget.doc]);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                ],
              ),
            )
          ],
        ));
  }

  void goToChatIntegration(History doc){
    //chat integration start
    String doctorId = doc.doctorId;
    String doctorName = doc.doctorName;
    String doctorPic = doc.doctorPic;
    chatViewModel.storePatientDetailsToFCM(doctorId, doctorName, doctorPic, context);
  }

  void navigateToProviderScreen(doc, isReshedule) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResheduleMain(
                doc: doc,
                isReshedule: isReshedule,
              )),
    ).then((value) => widget.onChanged('Completed'));
  }

  Widget docPhotoView(History doc) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFe3e2e2),
                blurRadius: 16,
                // has the effect of softening the shadow
                spreadRadius: 5.0,
                // has the effect of extending the shadow
                offset: Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ]),
        child: ClipOval(
          child: Container(
            child: //Container(color: Color(fhbColors.bgColorContainer)),
                doc.doctorPic == null
                    ? Container(color: Color(fhbColors.bgColorContainer))
                    : Image.network(
                        doc.doctorPic,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
            color: Color(fhbColors.bgColorContainer),
            height: 50,
            width: 50,
          ),
        ));
  }

  _displayDialog(BuildContext context, List<History> appointments) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: Colors.transparent,
            content: Container(
              width: double.maxFinite,
              height: 250.0,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Container(
                          height: 160,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextWidget(
                                  text: parameters
                                      .cancellationAppointmentConfirmation,
                                  fontsize: 14,
                                  fontWeight: FontWeight.w500,
                                  colors: Colors.grey[600]),
                              SizedBoxWidget(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(color: Colors.grey)),
                                      color: Colors.transparent,
                                      textColor: Colors.grey,
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                          text: parameters.no, fontsize: 12),
                                    ),
                                  ),
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Colors.blue[800])),
                                      color: Colors.transparent,
                                      textColor: Colors.blue[800],
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context,
                                            getCancelAppoitment(appointments));
                                      },
                                      child: TextWidget(
                                          text: parameters.yes, fontsize: 12),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  getCancelAppoitment(List<History> appointments) {
    cancelAppointment(appointments).then((value) {
      if (value.status == 200 && value.success == true) {
        widget.onChanged('Completed');
        toast.getToast(Constants.YOUR_BOOKING_SUCCESS, Colors.green);
      } else {
        toast.getToast(Constants.BOOKING_CANCEL, Colors.red);
      }
    });
  }

  Future<CancelAppointmentModel> cancelAppointment(
      List<History> appointments) async {
    for (int i = 0; i < appointments.length; i++) {
      bookingIds.add(appointments[i].bookingId);
    }
    CancelAppointmentModel cancelAppointment =
        await appointmentsViewModel.fetchCancelAppointment(bookingIds);

    return cancelAppointment;
  }
  void moveToBilsPage(String paymentMediaMetaId) async {
    List<String> paymentID = new List();
    paymentID.add(paymentMediaMetaId);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MyRecords(
        categoryPosition: new AppointmentsCommonWidget()
            .getCategoryPosition(Constants.STR_BILLS),
        allowSelect: true,
        isAudioSelect: false,
        isNotesSelect: false,
        selectedMedias: paymentID,
        isFromChat: false,
        showDetails: true,
      ),
    ));
  }
}

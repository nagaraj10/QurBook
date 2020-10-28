import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsListViewModel.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorPastAppointments extends StatefulWidget {
  Past doc;
  ValueChanged<String> onChanged;
  Function(String) closePage;

  DoctorPastAppointments({this.doc, this.onChanged,this.closePage});

  @override
  DoctorPastAppointmentState createState() => DoctorPastAppointmentState();
}

class DoctorPastAppointmentState extends State<DoctorPastAppointments> {
  AppointmentsCommonWidget commonWidget = AppointmentsCommonWidget();
  CommonWidgets providerCommonWidget = CommonWidgets();
  FlutterToast toast = new FlutterToast();
  List<String> bookingIds = new List();
  AppointmentsListViewModel appointmentsViewModel;
  SharedPreferences prefs;
  ChatViewModel chatViewModel = ChatViewModel();

  @override
  void initState() {
    // TODO: implement initState
    appointmentsViewModel =
        Provider.of<AppointmentsListViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return doctorsHistoryListCard(widget.doc);
  }

  Widget doctorsHistoryListCard(Past doc) {
    return Card(
        color: Colors.white,
        elevation: 0.5,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: Stack(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonWidget.docPhotoView(doc),
                        SizedBoxWidget(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            commonWidget.docName(
                                context,
                                widget.doc.doctor.user.firstName +
                                    ' ' +
                                    widget.doc.doctor.user.lastName),
                            SizedBoxWidget(height: 3.0, width: 0),
                            widget.doc?.doctor?.specialization == null
                                ? Container()
                                : Text((widget.doc.doctor.doctorProfessionalDetailCollection !=
                                            null &&
                                        widget
                                                .doc
                                                .doctor
                                                .doctorProfessionalDetailCollection
                                                .length >
                                            0)
                                    ? widget.doc.doctor.doctorProfessionalDetailCollection[0].specialty != null
                                        ? widget
                                                    .doc
                                                    .doctor
                                                    .doctorProfessionalDetailCollection[
                                                        0]
                                                    .specialty
                                                    .name !=
                                                null
                                            ? widget
                                                .doc
                                                .doctor
                                                .doctorProfessionalDetailCollection[0]
                                                .specialty
                                                .name
                                            : ''
                                        : ''
                                    : ''),
                            widget.doc.doctor.specialization == null
                                ? Container()
                                : SizedBox(height: 3.0),
                            commonWidget.docLoc(
                                context,
                                widget
                                        .doc
                                        ?.doctor
                                        ?.user
                                        ?.userAddressCollection3[0]
                                        ?.city
                                        ?.name ??
                                    ''),
                            SizedBoxWidget(height: 5.0),
                            SizedBoxWidget(height: 15.0),
                            commonWidget.docIcons(false,doc, context, () {})
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          //joinCallIcon(doc),
                          SizedBoxWidget(
                            height: widget.doc?.doctor?.specialization == null
                                ? 30
                                : 40,
                          ),
                          commonWidget.count(doc.slotNumber),
                          doc.plannedFollowupDate == null
                              ? TextWidget(
                                  fontsize: 10,
                                  text: doc.plannedStartDateTime == null
                                      ? ''
                                      : DateFormat(Constants
                                                  .Appointments_time_format)
                                              .format(DateTime.parse(
                                                  doc.plannedStartDateTime))
                                              .toString() ??
                                          '',
                                  fontWeight: FontWeight.w600,
                                  colors: Color(
                                      new CommonUtil().getMyPrimaryColor()),
                                )
                              : TextWidget(
                                  fontsize: 9,
                                  text: Constants.Appointments_followUpStatus,
                                  overflow: TextOverflow.visible,
                                  fontWeight: FontWeight.w400,
                                  colors: Colors.black38,
                                ),
                          TextWidget(
                            fontsize: 10,
                            text: doc.plannedFollowupDate == null
                                ? doc.plannedStartDateTime == null
                                    ? ""
                                    : DateFormat.yMMMEd()
                                            .format(DateTime.parse(
                                                doc.plannedStartDateTime))
                                            .toString() ??
                                        ''
                                : DateFormat.yMMMEd()
                                        .format(DateTime.parse(
                                            doc.plannedFollowupDate))
                                        .toString() ??
                                    '',
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.visible,
                            colors: Colors.black,
                          ),
                          TextWidget(
                            fontsize: 15,
                            text: doc.plannedFollowupDate == null
                                ? ''
                                : 'INR ' +
                                        providerCommonWidget.getMoneyWithForamt(
                                            doc.doctorFollowUpFee) ??
                                    '',
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.visible,
                            colors: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            SizedBoxWidget(height: 5.0),
            Container(height: 1, color: Colors.black26),
//            SizedBoxWidget(height: 10.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 60, top: 10, bottom: 10),
              child: Row(
                children: [
                  commonWidget.iconWithText(Constants.Appointments_chatImage,
                      Colors.black38, Constants.Appointments_chat, () {
                    goToChatIntegration(doc);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(
                      Constants.Appointments_prescriptionImage,
                      Colors.black38,
                      Constants.STR_PRESCRIPTION,
                      () {},
                      null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(Constants.Appointments_receiptImage,
                      Colors.black38, Constants.Appointments_receipt, () {
                    moveToBilsPage(doc.healthRecord);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  GestureDetector(
                    onTap: () {
                      navigateToProviderScreen(doc, false);
                    },
                    child: commonWidget.svgWithText(
                        Constants.Appointments_newAppoinmentImage,
                        Colors.black38,
                        Constants.Appointments_new),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void navigateToProviderScreen(doc, isReshedule) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResheduleMain(
                doc: doc,
                isReshedule: isReshedule,
            closePage: (value){
                  widget.closePage(value);
            },
              )),
    );
  }

  void goToChatIntegration(Past doc) {
    //chat integration start
    String doctorId = doc.doctor.id;
    String doctorName = doc.doctor.user.name;
    String doctorPic = doc.doctor.user.profilePicThumbnailUrl;
    chatViewModel.storePatientDetailsToFCM(
        doctorId, doctorName, doctorPic, context);
  }

  void moveToBilsPage(HealthRecord healthRecord) async {
    List<String> paymentID = new List();
    if (healthRecord != null &&
        healthRecord.bills != null &&
        healthRecord.bills.length > 0) {
      for (int i = 0; i < healthRecord.bills.length; i++) {
        paymentID.add(healthRecord.bills[i]);
      }
    }
//    print(paymentID.length);
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
          isAssociateOrChat: true),
    ));
  }
}

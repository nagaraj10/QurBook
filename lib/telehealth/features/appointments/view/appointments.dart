import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/telehealth/features/appointments/model/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  TextEditingController _searchQueryController = TextEditingController();
  final GlobalKey<State> _key = new GlobalKey<State>();
  AppointmentsViewModel appointmentsViewModel = AppointmentsViewModel();
  var items = List<String>();
  AppointmentsCommonWidget commonWidget = AppointmentsCommonWidget();
  List<History> upcomingInfo = List();
  List<String> bookingIds = new List();
  List<History> historyInfo = List();
  bool isSearch = false;
  List<History> upcomingTimeInfo = List();

  List<String> hours = List();
  List<String> minutes = List();

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      hours = appointmentsViewModel.getTimeSlot(upcomingInfo, isSearch).hours;
      minutes =
          appointmentsViewModel.getTimeSlot(upcomingInfo, isSearch).minutes;
      if (hours.length != 0 && minutes.length != 0) {
        setState(() {
          hours;
          minutes;
        });
      } else {
        setState(() {
          hours = List.filled(
              appointmentsViewModel
                  .appointmentsModel.response.data.upcoming.length,
              '00');
          minutes = List.filled(
              appointmentsViewModel
                  .appointmentsModel.response.data.upcoming.length,
              '00');
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: body(), floatingActionButton: commonWidget.floatingButton());
  }

  Widget search() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 40),
                  decoration: BoxDecoration(
                      color: Color(fhbColors.cardShadowColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: TextField(
                    controller: _searchQueryController,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black54,
                      ),
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                    style: TextStyle(color: Colors.black54, fontSize: 16.0),
                    onChanged: (value) {
                      if (value.trim().length > 1) {
                        setState(() {
                          isSearch = true;
                          upcomingInfo = appointmentsViewModel
                              .filterSearchResults(value)
                              .upcoming;
                          historyInfo = appointmentsViewModel
                              .filterSearchResults(value)
                              .history;
                        });
                      } else {
                        setState(() {
                          isSearch = false;
                          upcomingInfo.clear();
                          historyInfo.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
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

  FlutterToast toast = new FlutterToast();

  getCancelAppoitment(List<History> appointments) {
    cancelAppointment(appointments).then((value) {
      Navigator.pop(context);
      if (value.status == 200 && value.success == true) {
        toast.getToast(Constants.YOUR_BOOKING_SUCCESS, Colors.green);
      } else {
        toast.getToast(Constants.BOOKING_CANCEL, Colors.red);
      }
    });
  }

  Widget body() {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxWidget(
                width: 0,
                height: 20,
              ),
              search(),
              getDoctorsAppoinmentsList()
            ],
          )),
    );
  }

  void navigateToProviderScreen() {
    Navigator.of(context).pop();
    Navigator.pushNamed(
      context,
      '/telehealth-providers',
      arguments: HomeScreenArguments(selectedIndex: 1),
    ).then((value) {});
  }

  Widget getDoctorsAppoinmentsList() {
    return FutureBuilder(
        future: appointmentsViewModel.fetchAppointments(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            AppointmentsModel appointmentsData = snapshot.data;
//            if(hours==null || minutes==null){
//              hours = List.filled(appointmentsData
//                  .response.data.upcoming.length, '00');
//              minutes = List.filled(appointmentsData
//                  .response.data.upcoming.length, '00');
//            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBoxWidget(
                  width: 0,
                  height: 10,
                ),
                isSearch
                    ? minutes.length == upcomingInfo.length
                        ? commonWidget.title(Constants.Appointments_upcoming)
                        : Container()
                    : appointmentsData.response.data.upcoming.length != 0 &&
                            minutes.length ==
                                appointmentsData.response.data.upcoming.length
                        ? commonWidget.title(Constants.Appointments_upcoming)
                        : Container(),
                SizedBoxWidget(
                  width: 0,
                  height: 10,
                ),
                isSearch
                    ? minutes.length == upcomingInfo.length
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext ctx, int i) =>
                                doctorsAppointmentsListCard(
                                    isSearch
                                        ? upcomingInfo[i]
                                        : appointmentsData
                                            .response.data.upcoming[i],
                                    hours[i],
                                    minutes[i]),
                            itemCount: !isSearch
                                ? appointmentsData.response.data.upcoming.length
                                : upcomingInfo.length,
                          )
                        : Container()
                    : minutes.length ==
                            appointmentsData.response.data.upcoming.length
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext ctx, int i) =>
                                doctorsAppointmentsListCard(
                                    isSearch
                                        ? upcomingInfo[i]
                                        : appointmentsData
                                            .response.data.upcoming[i],
                                    hours[i],
                                    minutes[i]),
                            itemCount: !isSearch
                                ? appointmentsData.response.data.upcoming.length
                                : upcomingInfo.length,
                          )
                        : Container(),
                SizedBoxWidget(
                  width: 0,
                  height: 10,
                ),
                isSearch
                    ? historyInfo.length != 0
                        ? commonWidget.title(Constants.Appointments_history)
                        : Container()
                    : appointmentsData.response.data.history.length != 0
                        ? commonWidget.title(Constants.Appointments_history)
                        : Container(),
                SizedBoxWidget(
                  width: 0,
                  height: 10,
                ),
                new ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext ctx, int i) =>
                      doctorsHistoryListCard(isSearch
                          ? historyInfo[i]
                          : appointmentsData.response.data.history[i]),
                  itemCount: isSearch
                      ? historyInfo.length
                      : appointmentsData.response.data.history.length,
                )
              ],
            );
          } else {
            return new Center(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.grey,
              ),
            );
          }
        });
  }

  Widget doctorsAppointmentsListCard(History doc, String hour, String minute) {
    return Card(
        color: Colors.white,
        elevation: 0.5,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        docPhotoView(),
                        SizedBoxWidget(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            commonWidget.docName(context, doc.doctorName),
                            SizedBoxWidget(height: 3.0, width: 0),
                            commonWidget.docStatus(context, doc.specialization),
                            SizedBox(height: 3.0),
                            commonWidget.docLoc(context, doc.location),
                            SizedBox(height: 5.0),
                            commonWidget.docTimeSlot(
                                context, doc, hour, minute),
                            SizedBoxWidget(height: 10.0),
                            commonWidget.docIcons(doc)
                          ],
                        ),
                      ],
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 6.5),
                      child: Column(
                        children: [
                          //joinCallIcon(doc),
                          SizedBoxWidget(
                            height: 30,
                          ),
                          commonWidget.count(doc.slotNumber),
                          TextWidget(
                            fontsize: 10,
                            text: DateFormat("hh:mm a")
                                    .format(DateTime.parse(
                                        doc.plannedStartDateTime))
                                    .toString() ??
                                '',
                            fontWeight: FontWeight.w600,
                            colors: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                          TextWidget(
                            fontsize: 8,
                            text: DateFormat.yMMMEd()
                                .format(
                                    DateTime.parse(doc.plannedStartDateTime))
                                .toString(),
                            fontWeight: FontWeight.w400,
                            colors: Colors.black26,
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
                      Colors.black38, Constants.Appointments_receipt, () {}),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(
                      Constants.Appointments_resheduleImage,
                      Colors.black38,
                      Constants.Appointments_reshedule, () {
                    navigateToProviderScreen();
                  }),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(Constants.Appointments_cancelImage,
                      Colors.black38, Constants.Appointments_cancel, () {
                    getCancelAppoitment([doc]);
                  }),
                  SizedBoxWidget(width: 15.0),
                ],
              ),
            )
          ],
        ));
  }

  Widget docPhotoView() {
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
            color: Color(fhbColors.bgColorContainer),
            height: 50,
            width: 50,
          ),
        ));
  }

  Widget doctorsHistoryListCard(History doc) {
    return Card(
        color: Colors.white,
        elevation: 0.5,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        docPhotoView(),
                        SizedBoxWidget(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            commonWidget.docName(context, doc.doctorName),
                            SizedBoxWidget(height: 3.0, width: 0),
                            commonWidget.docStatus(
                                context, doc.specialization ?? ''),
                            SizedBox(height: 3.0),
                            commonWidget.docLoc(context, doc.location),
                            SizedBoxWidget(height: 5.0),
                            SizedBoxWidget(height: 15.0),
                            commonWidget.docIcons(doc)
                          ],
                        ),
                      ],
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 6.5),
                      child: Column(
                        children: [
                          //joinCallIcon(doc),
                          SizedBoxWidget(
                            height: 30,
                          ),
                          commonWidget.count(doc.slotNumber),
                          TextWidget(
                            fontsize: 9,
                            text: Constants.Appointments_followUpStatus,
                            overflow: TextOverflow.visible,
                            fontWeight: FontWeight.w400,
                            colors: Colors.black38,
                          ),
                          TextWidget(
                            fontsize: 10,
                            text: DateFormat.yMMMEd()
                                    .format(DateTime.parse(
                                        doc.plannedStartDateTime))
                                    .toString() ??
                                '',
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.visible,
                            colors: Colors.black,
                          ),
                          TextWidget(
                            fontsize: 15,
                            text: doc.followupFee ?? '',
                            fontWeight: FontWeight.w600,
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
                      Colors.black38, Constants.Appointments_chat, () {}),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(
                      Constants.Appointments_prescriptionImage,
                      Colors.black38,
                      Constants.STR_PRESCRIPTION,
                      () {}),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(Constants.Appointments_receiptImage,
                      Colors.black38, Constants.Appointments_receipt, () {}),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.svgWithText(
                      Constants.Appointments_newAppoinmentImage,
                      Colors.black38,
                      Constants.Appointments_new),
                ],
              ),
            )
          ],
        ));
  }
}

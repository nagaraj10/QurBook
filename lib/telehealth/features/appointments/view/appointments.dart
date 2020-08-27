import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/telehealth/features/appointments/model/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsViewModel.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> daysCount;
  Timer timer;
  SharedPreferences prefs;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      hours = appointmentsViewModel.getTimeSlot(upcomingInfo, isSearch).hours;
      minutes =
          appointmentsViewModel.getTimeSlot(upcomingInfo, isSearch).minutes;
      daysCount =
          appointmentsViewModel.getTimeSlot(upcomingInfo, isSearch).daysCount;
      if (hours.length != 0 && minutes.length != 0) {
        setState(() {
          hours;
          minutes;
          daysCount;
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
          daysCount = List.filled(
              appointmentsViewModel
                  .appointmentsModel.response.data.upcoming.length,
              '0');
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: body(),
        floatingActionButton: commonWidget.floatingButton(context));
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

  void navigateToProviderScreen(doc, isReshedule) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResheduleMain(
                doc: doc,
                isReshedule: isReshedule,
              )),
    );
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
                                    minutes[i],
                                    daysCount[i]),
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
                                    minutes[i],
                                    daysCount[i]),
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.grey,
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              alignment: Alignment.center,
              child: Center(
                child: Text(variable.strNoAppointments),
              ),
            );
          }
        });
  }

  Widget doctorsAppointmentsListCard(
      History doc, String hour, String minute, String days) {
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
                          docPhotoView(doc),
                          SizedBoxWidget(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              commonWidget.docName(context, doc.doctorName),
                              SizedBoxWidget(height: 3.0, width: 0),
                              doc.specialization == null
                                  ? Container()
                                  : commonWidget.docStatus(
                                      context, doc.specialization ?? ''),
                              doc.specialization == null
                                  ? Container()
                                  : SizedBox(height: 3.0),
                              commonWidget.docLoc(context, doc.location),
                              SizedBox(height: 5.0),
                              commonWidget.docTimeSlot(
                                  context, doc, hour, minute, days),
                              SizedBoxWidget(height: 15.0),
                              commonWidget.docIcons(doc)
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
                                //chat integration start
                                String doctorId = doc.doctorId;
                                String doctorName = doc.doctorName;
                                String doctorPic = doc.doctorPic;
                                storePatientDetailsToFCM(
                                    doctorId, doctorName, doctorPic);
                              }),
                          SizedBoxWidget(
                            height: (hour == '00' || minutes == '00') ? 0 : 15,
                          ),
                          SizedBoxWidget(
                            height: doc.specialization == null ? 30 : 40,
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
                  commonWidget.iconWithText(
                      Constants.Appointments_receiptImage,
                      Colors.black38,
                      Constants.Appointments_receipt,
                      () {},
                      null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(
                      Constants.Appointments_resheduleImage,
                      Colors.black38,
                      Constants.Appointments_reshedule, () {
                    navigateToProviderScreen(doc, true);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(Constants.Appointments_cancelImage,
                      Colors.black38, Constants.Appointments_cancel, () {
                    _displayDialog(context, [doc]);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                ],
              ),
            )
          ],
        ));
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

  Widget doctorsHistoryListCard(History doc) {
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
                        docPhotoView(doc),
                        SizedBoxWidget(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            commonWidget.docName(context, doc.doctorName),
                            SizedBoxWidget(height: 3.0, width: 0),
                            doc.specialization == null
                                ? Container()
                                : commonWidget.docStatus(
                                    context, doc.specialization ?? ''),
                            doc.specialization == null
                                ? Container()
                                : SizedBox(height: 3.0),
                            commonWidget.docLoc(context, doc.location),
                            SizedBoxWidget(height: 5.0),
                            SizedBoxWidget(height: 15.0),
                            commonWidget.docIcons(doc)
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
                            height: doc.specialization == null ? 30 : 40,
                          ),
                          commonWidget.count(doc.slotNumber),
                          TextWidget(
                            fontsize: 9,
                            text: doc.followupDate == null
                                ? ''
                                : Constants.Appointments_followUpStatus,
                            overflow: TextOverflow.visible,
                            fontWeight: FontWeight.w400,
                            colors: Colors.black38,
                          ),
                          TextWidget(
                            fontsize: 10,
                            text: doc.followupDate == null
                                ? ""
                                : DateFormat.yMMMEd()
                                        .format(
                                            DateTime.parse(doc.followupDate))
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
                    //chat integration start
                    String doctorId = doc.doctorId;
                    String doctorName = doc.doctorName;
                    String doctorPic = doc.doctorPic;
                    storePatientDetailsToFCM(doctorId, doctorName, doctorPic);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(
                      Constants.Appointments_prescriptionImage,
                      Colors.black38,
                      Constants.STR_PRESCRIPTION,
                      () {},
                      null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(
                      Constants.Appointments_receiptImage,
                      Colors.black38,
                      Constants.Appointments_receipt,
                      () {},
                      null),
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

  String getPatientName() {
    MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    String patientName =
        myProfile.response.data.generalInfo.qualifiedFullName !=null ?
            myProfile.response.data.generalInfo.qualifiedFullName.firstName +
                myProfile.response.data.generalInfo.qualifiedFullName.lastName:'';

    return patientName;
  }

  String getProfileURL() {
    MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    String patientPicURL =
        myProfile.response.data.generalInfo.profilePicThumbnailURL;

    return patientPicURL;
  }

  void storePatientDetailsToFCM(
      String doctorId, String doctorName, String doctorPic) {
    Firestore.instance.collection('users').document(doctorId).setData({
      'nickname': doctorName != null ? doctorName : '',
      'photoUrl': doctorPic != null ? doctorPic : '',
      'id': doctorId,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'chattingWith': null
    });

    storeDoctorDetailsToFCM(doctorId, doctorName, doctorPic);
  }

  Future<void> storeDoctorDetailsToFCM(
      String doctorId, String doctorName, String doctorPic) async {
    prefs = await SharedPreferences.getInstance();

    String patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    String patientName = getPatientName();
    String patientPicUrl = getProfileURL();

    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: patientId)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.instance.collection('users').document(patientId).setData({
        'nickname': patientName != null ? patientName : '',
        'photoUrl': patientPicUrl != null ? patientPicUrl : '',
        'id': patientId,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null
      });

      // Write data to local
      await prefs.setString('id', patientId);
      await prefs.setString('nickname', patientName);
      await prefs.setString('photoUrl', patientPicUrl);
    } else {
      // Write data to local
      await prefs.setString('id', documents[0]['id']);
      await prefs.setString('nickname', documents[0]['nickname']);
      await prefs.setString('photoUrl', documents[0]['photoUrl']);
      await prefs.setString('aboutMe', documents[0]['aboutMe']);
    }

    goToChatPage(doctorId, doctorName, doctorPic);
  }

  void goToChatPage(String doctorId, String doctorName, String doctorPic) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  peerId: doctorId,
                  peerAvatar: doctorPic != null ? doctorPic : '',
                  peerName: doctorName,
                )));
  }
}

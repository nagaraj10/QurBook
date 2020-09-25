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
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/telehealth/features/appointments/model/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/view/DoctorUpcomingAppointments.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsViewModel.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  ChatViewModel chatViewModel = ChatViewModel();
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
    setState(() {});
    super.initState();
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

            return ((appointmentsData?.response?.data?.history != null &&
                        appointmentsData.response?.data?.history?.length > 0) ||
                    (appointmentsData?.response?.data?.upcoming != null &&
                        appointmentsData?.response?.data?.upcoming?.length > 0))
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBoxWidget(
                        width: 0,
                        height: 10,
                      ),
                      isSearch
                          ? (upcomingInfo != null && upcomingInfo.length != 0)
                              ? commonWidget
                                  .title(Constants.Appointments_upcoming)
                              : Container()
                          : (appointmentsData.response.data.upcoming != null &&
                                  appointmentsData
                                          .response.data.upcoming.length !=
                                      0)
                              ? commonWidget
                                  .title(Constants.Appointments_upcoming)
                              : Container(),
                      SizedBoxWidget(
                        width: 0,
                        height: 10,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext ctx, int i) =>
                            DoctorUpcomingAppointments(
                                doc: isSearch
                                    ? upcomingInfo[i]
                                    : appointmentsData
                                        .response.data.upcoming[i],
                                onChanged: (value) {
                                  setState(() {});
                                }),
                        itemCount: !isSearch
                            ? appointmentsData.response.data.upcoming.length
                            : upcomingInfo.length,
                      ),
                      SizedBoxWidget(
                        width: 0,
                        height: 10,
                      ),
                      isSearch
                          ? (historyInfo != null && historyInfo.length != 0)
                              ? commonWidget
                                  .title(Constants.Appointments_history)
                              : Container()
                          : (appointmentsData.response.data.history != null &&
                                  appointmentsData
                                          .response.data.history.length !=
                                      0)
                              ? commonWidget
                                  .title(Constants.Appointments_history)
                              : Container(),
                      SizedBoxWidget(
                        width: 0,
                        height: 10,
                      ),
                      (appointmentsData?.response?.data?.history != null &&
                              appointmentsData
                                      ?.response?.data?.history?.length >
                                  0)
                          ? new ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext ctx, int i) =>
                                  doctorsHistoryListCard(isSearch
                                      ? historyInfo[i]
                                      : appointmentsData
                                          .response.data.history[i]),
                              itemCount: isSearch
                                  ? historyInfo.length
                                  : appointmentsData
                                      .response.data.history.length,
                            )
                          : Container()
                    ],
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 2,
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(variable.strNoAppointments),
                    ),
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
                            commonWidget.docIcons(doc, context)
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
                          doc.followupDate == null
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
                            text: doc.followupDate == null
                                ? doc.plannedStartDateTime == null
                                    ? ""
                                    : DateFormat.yMMMEd()
                                            .format(DateTime.parse(
                                                doc.plannedStartDateTime))
                                            .toString() ??
                                        ''
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
                            text: doc?.followupFee != null
                                ? 'INR ${doc?.followupFee.split('.')[0]}'
                                : '',
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
                    moveToBilsPage(doc.paymentMediaMetaId);
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

  void goToChatIntegration(History doc) {
    //chat integration start
    String doctorId = doc.doctorId;
    String doctorName = doc.doctorName;
    String doctorPic = doc.doctorPic;
    chatViewModel.storePatientDetailsToFCM(
        doctorId, doctorName, doctorPic, context);
  }

  void moveToBilsPage(String paymentMediaMetaId) async {
    List<String> paymentID = new List();
    paymentID.add(paymentMediaMetaId);
    int position = await new AppointmentsCommonWidget()
        .getCategoryPosition(Constants.STR_BILLS);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MyRecords(
        categoryPosition: position,
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

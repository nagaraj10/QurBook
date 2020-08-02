import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/telehealth/features/appointments/model/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/mockData.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/telehealth/features/appointments/services/apiServices.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  TextEditingController _searchQueryController = TextEditingController();
  final GlobalKey<State> _key = new GlobalKey<State>();
  var items = List<String>();
  List<History> upcomingInfo = List();
  List<History> historyInfo = List();
  bool onSearch = false;
  List<String> hours = List();
  List<String> minutes = List();
  ApiFetch api = ApiFetch();

  @override
  void initState() {
    upcomingInfo = doctorsData.response.data.upcoming;
    historyInfo = doctorsData.response.data.history;
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void filterSearchResults(String query) {
    List<History> dummySearchListUpcoming = List<History>();
    List<History> dummySearchListHistory = List<History>();
    List<History> docInfo = List();
    dummySearchListUpcoming = doctorsData.response.data.upcoming;
    dummySearchListHistory = doctorsData.response.data.history;

    if (query.isNotEmpty) {
      dummySearchListUpcoming = doctorsData.response.data.upcoming
          .where((element) =>
              element.doctorName
                  .toLowerCase()
                  .trim()
                  .contains(query.toLowerCase().trim()) ||
              element.status
                  .toLowerCase()
                  .trim()
                  .contains(query.toLowerCase().trim()) ||
              element.location
                  .toLowerCase()
                  .trim()
                  .contains(query.toLowerCase().trim()))
          .toList();
      dummySearchListHistory = doctorsData.response.data.history
          .where((element) =>
              element.doctorName
                  .toLowerCase()
                  .trim()
                  .contains(query.toLowerCase().trim()) ||
              element.status
                  .toLowerCase()
                  .trim()
                  .contains(query.toLowerCase().trim()) ||
              element.location
                  .toLowerCase()
                  .trim()
                  .contains(query.toLowerCase().trim()))
          .toList();
      setState(() {
        upcomingInfo = dummySearchListUpcoming;
        historyInfo = dummySearchListHistory;
      });
      return;
    } else {
      setState(() {
        upcomingInfo = doctorsData.response.data.upcoming;
        historyInfo = doctorsData.response.data.upcoming;
      });
    }
  }

  String _getTime() {
    List<String> dummySearchList = List<String>();
    List<String> dummyHour = List<String>();
    List<String> dummyMinutes = List<String>();
    dummySearchList
        .addAll(upcomingInfo.map((e) => e.actualEndDateTime).toList());
    for (int i = 0; i < dummySearchList.length; i++) {
      DateTime dob = DateTime.parse(dummySearchList[i]);
      Duration dur = dob.difference(DateTime.now());
      String differenceInHours = dur.inHours >= 0 && dur.inHours <= 24
          ? (dur.inHours.remainder(24)).round().toString().padLeft(2, '0')
          : '00';
      String differenceInMinutes = dur.inHours >= 0 && dur.inHours <= 24
          ? (dur.inMinutes.remainder(60)).toString().padLeft(2, '0')
          : '00';
      dummyMinutes.add(
          int.parse(differenceInMinutes) <= 0 ? '00' : differenceInMinutes);
//      print(minutes.toList());
      dummyHour.add(
          dur.inHours.remainder(24).toInt() <= 0 ? '00' : differenceInHours);
    }
    if (upcomingInfo.length > 0) {
      setState(() {
        minutes = dummyMinutes;
//      print(minutes.toList());
        hours = dummyHour;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(), body: body(), floatingActionButton: floatingButton());
  }

  Widget appBar() {
    return AppBar(
        flexibleSpace: GradientAppBar(),
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBoxWidget(
              height: 0,
              width: 30,
            ),
            IconWidget(
              icon: Icons.arrow_back_ios,
              colors: Colors.white,
              size: 20,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: getTitle());
  }

  Widget getTitle() {
    return Row(
      children: [
        Expanded(
          child: TextWidget(
            text: Constants.Appointments_Title,
            colors: Colors.white,
            overflow: TextOverflow.visible,
            fontWeight: FontWeight.w600,
            fontsize: 18,
            softwrap: true,
          ),
        ),
        IconWidget(
          icon: Icons.notifications,
          colors: Colors.white,
          size: 22,
          onTap: () {},
        ),
        new SwitchProfile().buildActions(context, _key, callBackToRefresh),
        IconWidget(
          icon: Icons.more_vert,
          colors: Colors.white,
          size: 24,
          onTap: () {},
        ),
      ],
    );
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
//                      if (value.trim().length > 2) {
//                        Future.delayed(Duration(seconds: 2));
                      filterSearchResults(value);
//                      }
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

  Widget floatingButton() {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
            width: 2, color: Color(new CommonUtil().getMyPrimaryColor())),
      ),
      elevation: 0.0,
      onPressed: () {},
      child: IconWidget(
        icon: Icons.add,
        colors: Color(new CommonUtil().getMyPrimaryColor()),
        size: 24,
        onTap: () {},
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Container(
//          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxWidget(
                width: 0,
                height: 20,
              ),
              search(),
              SizedBoxWidget(
                width: 0,
                height: 10,
              ),
              (upcomingInfo.length == hours.length)
                  ? Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextWidget(
                        text: Constants.Appointments_upcoming,
                        colors: Color(CommonUtil().getMyPrimaryColor()),
                        overflow: TextOverflow.visible,
                        fontWeight: FontWeight.w500,
                        fontsize: 14,
                        softwrap: true,
                      ),
                    )
                  : Container(),
              SizedBoxWidget(
                width: 0,
                height: 10,
              ),
              (upcomingInfo.length == hours.length)
                  ? getDoctorsAppoinmentsList(upcomingInfo, hours, minutes)
                  : Container(),
              SizedBoxWidget(
                width: 0,
                height: 10,
              ),
              (historyInfo.length != 0)
                  ? Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextWidget(
                        text: Constants.Appointments_history,
                        colors: Color(CommonUtil().getMyPrimaryColor()),
                        overflow: TextOverflow.visible,
                        fontWeight: FontWeight.w500,
                        fontsize: 14,
                        softwrap: true,
                      ),
                    )
                  : Container(),
              SizedBoxWidget(
                width: 0,
                height: 10,
              ),
              (historyInfo.length != 0)
                  ? getDoctorsHistoryList(historyInfo)
                  : Container(),
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
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (BuildContext context) => TelehealthProviders(
//                  bottomindex: 1,
//                  arguments: HomeScreenArguments(selectedIndex: 1),
//                )));
  }

  Widget getDoctorsAppoinmentsList(info, hour, minute) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext ctx, int i) =>
          doctorsAppointmentsListCard(info[i], hour[i], minute[i]),
      itemCount: info.length,
    );
  }

  Widget docName(doc) {
    return Row(
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.5),
          child: Row(
            children: [
              TextWidget(
                text: doc,
                fontWeight: FontWeight.w500,
                fontsize: fhbStyles.fnt_doc_name,
                softwrap: false,
                overflow: TextOverflow.ellipsis,
                colors: Colors.black,
              ),
              SizedBox(
                width: 0,
                height: 8.0,
              ),
              IconWidget(
                  colors: Color(new CommonUtil().getMyPrimaryColor()),
                  icon: Icons.info,
                  size: 10,
                  onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget docStatus(doc) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.5),
      child: TextWidget(
        text: doc,
        colors: Colors.black26,
        fontsize: fhbStyles.fnt_doc_specialist,
        softwrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget docLoc(doc) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.5),
      child: TextWidget(
        text: doc,
        overflow: TextOverflow.ellipsis,
        softwrap: false,
        fontWeight: FontWeight.w200,
        colors: Colors.black87,
        fontsize: fhbStyles.fnt_city,
      ),
    );
  }

  Widget docTimeSlot(History doc, hour, minute) {
    return ((hour == '00' && minute == '00') ||
            hours.length == 0 ||
            minutes.length == 0 ||
            upcomingInfo.length == 0)
        ? Container()
        : Row(
            children: [
              ClipRect(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(new CommonUtil().getMyPrimaryColor())),
                  ),
                  height: 29,
                  width: 25,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextWidget(
                        fontsize: 10,
                        text: hour,
                        fontWeight: FontWeight.w500,
                        colors: Colors.grey,
                      ),
                      TextWidget(
                        fontsize: 5,
                        text: Constants.Appointments_hours,
                        fontWeight: FontWeight.w500,
                        colors: Color(new CommonUtil().getMyPrimaryColor()),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBoxWidget(width: 2.0),
              ClipRect(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(new CommonUtil().getMyPrimaryColor())),
                  ),
                  height: 29,
                  width: 25,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextWidget(
                        fontsize: 10,
                        text: minute,
                        fontWeight: FontWeight.w500,
                        colors: Colors.grey,
                      ),
                      TextWidget(
                        fontsize: 5,
                        text: Constants.Appointments_minutes,
                        fontWeight: FontWeight.w500,
                        colors: Color(new CommonUtil().getMyPrimaryColor()),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
  }

  Widget docIcons(doc) {
    return Row(
      children: [
        iconWithText(
            Constants.Appointments_notesImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.Appointments_notes,
            () {}),
        SizedBoxWidget(width: 15.0),
        iconWithText(
            Constants.Appointments_voiceNotesImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.STR_VOICE_NOTES,
            () {}),
        SizedBoxWidget(width: 15.0),
        iconWithText(
            Constants.Appointments_recordsImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.Appointments_records,
            () {}),
      ],
    );
  }

  Widget joinCallIcon(doc) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 20,
        width: 70,
        child: OutlineButton(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          borderSide:
              BorderSide(color: Color(new CommonUtil().getMyPrimaryColor())),
          onPressed: () {},
          child: TextWidget(
            text: Constants.Appointments_joinCall,
            colors: Color(new CommonUtil().getMyPrimaryColor()),
            fontsize: 8,
          ),
          color: Color(new CommonUtil().getMyPrimaryColor()),
        ),
      ),
    );
  }

  Widget count(doc) {
    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue[200],
              width: 3,
            ),
            borderRadius: BorderRadius.circular(50.0),
            gradient: LinearGradient(
              colors: <Color>[
                Color(new CommonUtil().getMyPrimaryColor()),
                Color(new CommonUtil().getMyGredientColor())
              ],
            )),
        height: 40,
        width: 40,
        alignment: Alignment.center,
        child: TextWidget(
          fontsize: 20,
          text: doc,
          fontWeight: FontWeight.w600,
          colors: Colors.white,
        ),
      ),
    );
  }

  Widget doctorsAppointmentsListCard(History doc, hour, minute) {
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
                            docName(doc.doctorName),
                            SizedBoxWidget(height: 3.0, width: 0),
                            docStatus(doc.status),
                            SizedBox(height: 3.0),
                            docLoc(doc.location),
                            SizedBox(height: 5.0),
                            docTimeSlot(doc, hour, minute),
                            SizedBoxWidget(height: 10.0),
                            docIcons(doc)
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        //joinCallIcon(doc),
                        SizedBoxWidget(
                          height: 30,
                        ),
                        count(doc.slotNumber),
                        TextWidget(
                          fontsize: 10,
                          text: doc.actualStartDateTime,
                          fontWeight: FontWeight.w600,
                          colors: Color(new CommonUtil().getMyPrimaryColor()),
                        ),
                        TextWidget(
                          fontsize: 8,
                          text: '${doc.followupDate}',
                          fontWeight: FontWeight.w400,
                          colors: Colors.black26,
                        ),
                      ],
                    )
                  ],
                )),
            SizedBoxWidget(height: 10.0),
            Container(height: 1, color: Colors.black26),
//            SizedBoxWidget(height: 10.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 67, top: 10, bottom: 10),
              child: Row(
                children: [
                  iconWithText(Constants.Appointments_receiptImage,
                      Colors.black38, Constants.Appointments_receipt, () {}),
                  SizedBoxWidget(width: 15.0),
                  iconWithText(Constants.Appointments_resheduleImage,
                      Colors.black38, Constants.Appointments_reshedule, () {
                    navigateToProviderScreen();
                  }),
                  SizedBoxWidget(width: 15.0),
                  iconWithText(Constants.Appointments_cancelImage,
                      Colors.black38, Constants.Appointments_cancel, () {
                    api.cancel();
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

  Widget iconWithText(String imageText, Color color, String text, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 20,
            width: 20,
            child: Image.asset(
              imageText,
              color: color,
            ),
          ),
          SizedBoxWidget(
            height: 5.0,
          ),
          TextWidget(
            fontsize: 8,
            text: text,
            fontWeight: FontWeight.w400,
            colors: color,
          ),
        ],
      ),
    );
  }

  Widget svgWithText(String imageText, Color color, String text) {
    return Column(
      children: [
        Container(
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              imageText,
              color: color,
            )),
        SizedBoxWidget(
          height: 5.0,
        ),
        TextWidget(
          fontsize: 8,
          text: text,
          fontWeight: FontWeight.w400,
          colors: color,
        ),
      ],
    );
  }

  Widget getDoctorsHistoryList(info) {
    return new ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext ctx, int i) => doctorsHistoryListCard(info[i]),
      itemCount: info.length,
    );
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
                            docName(doc.doctorName),
                            SizedBoxWidget(height: 3.0, width: 0),
                            docStatus(doc.status),
                            SizedBox(height: 3.0),
                            docLoc(doc.location),
                            SizedBoxWidget(height: 5.0),
                            SizedBoxWidget(height: 15.0),
                            docIcons(doc)
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        //joinCallIcon(doc),
                        SizedBoxWidget(
                          height: 30,
                        ),
                        count(doc.slotNumber),
                        TextWidget(
                          fontsize: 9,
                          text: Constants.Appointments_followUpStatus,
                          fontWeight: FontWeight.w400,
                          colors: Colors.black38,
                        ),
                        TextWidget(
                          fontsize: 10,
                          text: '${doc.followupDate}',
                          fontWeight: FontWeight.w500,
                          colors: Colors.black,
                        ),
                        TextWidget(
                          fontsize: 15,
                          text: doc.followupFee,
                          fontWeight: FontWeight.w600,
                          colors: Color(new CommonUtil().getMyPrimaryColor()),
                        ),
                      ],
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
                  iconWithText(Constants.Appointments_chatImage, Colors.black38,
                      Constants.Appointments_chat, () {}),
                  SizedBoxWidget(width: 15.0),
                  iconWithText(Constants.Appointments_prescriptionImage,
                      Colors.black38, Constants.STR_PRESCRIPTION, () {}),
                  SizedBoxWidget(width: 15.0),
                  iconWithText(Constants.Appointments_receiptImage,
                      Colors.black38, Constants.Appointments_receipt, () {}),
                  SizedBoxWidget(width: 15.0),
                  svgWithText(Constants.Appointments_newAppoinmentImage,
                      Colors.black38, Constants.Appointments_new),
                ],
              ),
            )
          ],
        ));
  }
}

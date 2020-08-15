import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/appointments/model/mockData.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/telehealth/features/appointments/view/doctorSessionTimeSlot.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class ResheduleAppointments extends StatefulWidget {
  History doc;

  ResheduleAppointments({this.doc});

  @override
  _ResheduleAppointmentsState createState() => _ResheduleAppointmentsState();
}

class _ResheduleAppointmentsState extends State<ResheduleAppointments> {
  DateTime _selectedValue = DateTime.now();
  CommonWidgets _commonWidgets = CommonWidgets();
  AppointmentsCommonWidget appointmentsCommonWidget =
      AppointmentsCommonWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: doctorsListItem(context),
    );
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
      title: TextWidget(
        text: widget.doc.doctorName ?? '',
        colors: Colors.white,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w600,
        fontsize: 18,
        softwrap: true,
      ),
    );
  }

  Widget doctorsListItem(BuildContext ctx) {
    return Container(
        height: MediaQuery.of(context).size.height/2,
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 20, right: 20, top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFe3e2e2),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 5.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: expandedListItem(ctx));
  }

  Widget expandedListItem(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          getDoctorsWidget(),
          _commonWidgets.getSizedBox(20.0),
          DoctorSessionTimeSlot(
              date: _selectedValue.toString(),
              doctorId: '',
              docs: docIDs,
              i: 0),
        ],
      ),
    );
  }

  Widget getDoctorsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: _commonWidgets.getClipOvalImageNew(
                  null, fhbStyles.cardClipImage),
            ),

          ],
        ),
        _commonWidgets.getSizeBoxWidth(10.0),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      _commonWidgets
                          .getTextForDoctors('${widget.doc.doctorName}'),
                      _commonWidgets.getSizeBoxWidth(10.0),
                      _commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.info,
                          onTap: () {
                            print('on Info pressed');
                                showDoctorDetailView(
                                    widget.doc, context);
                          }),
                    ],
                  )),
//                  docs[i].isActive
//                      ?
                  _commonWidgets.getIcon(
                      width: fhbStyles.imageWidth,
                      height: fhbStyles.imageHeight,
                      icon: Icons.check_circle,
                      onTap: () {
                        print('on check  pressed');
                      }),
                  _commonWidgets.getSizeBoxWidth(15.0),


                  GestureDetector(
                      onTap: () {},
                      child: ImageIcon(
                        AssetImage('assets/icons/record_fav.png'),
                        color: Colors.black,
                        size: fhbStyles.imageWidth,
                      )),
                  _commonWidgets.getSizeBoxWidth(10.0),
                ],
              ),
              _commonWidgets.getSizedBox(5.0),
              Row(children: [
                Expanded(
                    child: widget.doc.specialization != null
                        ? _commonWidgets
                            .getDoctoSpecialist('${widget.doc.specialization}')
                        : SizedBox()),
                _commonWidgets.getDoctoSpecialist('INR ${300}'),

                _commonWidgets.getSizeBoxWidth(10.0),
              ]),
              _commonWidgets.getSizedBox(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _commonWidgets
                          .getDoctorsAddress('${widget.doc.location}')),
                  _commonWidgets.getMCVerified(true, 'Verified'),

                  _commonWidgets.getSizeBoxWidth(10.0),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget showDoctorDetailView(History docs, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              width: MediaQuery.of(context).size.width - 20,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    top: -1.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: _commonWidgets.getClipOvalImageNew(
                                null, fhbStyles.detailClipImage),
                          ),
                          _commonWidgets.getSizeBoxWidth(10.0),
                          Expanded(
                            // flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            _commonWidgets.getTextForDoctors('${docs.doctorName}'),
                                _commonWidgets.getDoctoSpecialist(
                                    '${docs.specialization}'),

                                _commonWidgets.getDoctorsAddress('${docs.location}'),
                                _commonWidgets.getTextForDoctors('Can Speak'),

                              ],
                            ),
                          ),
                        ],
                      ),
                      _commonWidgets.getSizedBox(20),
                      _commonWidgets.getTextForDoctors('About'),
                      _commonWidgets.getHospitalDetails('5 yrs Exp'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }


}


import 'dart:typed_data';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/Data.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/ProfilePic.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';

import 'package:myfhb/styles/styles.dart' as fhbStyles;

class CommonWidgets {
  Widget getTextForDoctors(String docName) {
    return Text(
      docName != null ? docName : '',
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: fhbStyles.fnt_doc_name),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getSizedBox(double height) {
    return SizedBox(height: height);
  }

  Widget getRaisedButton() {
    return new RaisedButton(
      textColor: Colors.white,
      color: Color(new CommonUtil().getMyPrimaryColor()),
      onPressed: () {},
      padding: const EdgeInsets.all(8.0),
      child: new Text(
        "Book Now",
      ),
    );
  }

  Widget getDoctoSpecialist(String phoneNumber) {
    return Text(
      phoneNumber != null ? phoneNumber : '',
      style: TextStyle(
          color: Color(0xFF8C8C8C), fontSize: fhbStyles.fnt_doc_specialist),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getDoctorsAddress(String address) {
    return Text(
      address != null ? address : '',
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: TextStyle(
          fontWeight: FontWeight.w200,
          color: Color(0xFF8C8C8C),
          fontSize: fhbStyles.fnt_city),
    );
  }

  Widget getHospitalDetails(String address) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
      child: Text(
        address,
        style: TextStyle(
            color: Color(0xFF8C8C8C), fontSize: fhbStyles.fnt_abt_doc),
        softWrap: true,
      ),
    );
  }

  Widget getDownArrowWidget() {
    return Container(
      color: Colors.white,
      width: 15,
      height: 30,
      child: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.blue,
      ),
    );
  }

  Widget getBookMarkedIcon(DoctorIds docs) {
    return docs.isActive
        ? ImageIcon(
            AssetImage('assets/icons/record_fav_active.png'),
            color: Color(new CommonUtil().getMyPrimaryColor()),
            size: fhbStyles.imageWidth,
          )
        : ImageIcon(
            AssetImage('assets/icons/record_fav.png'),
            color: Colors.black,
            size: fhbStyles.imageWidth,
          );
  }

  Widget getGridView() {
    return GridView.count(
      crossAxisCount: 5,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 8.0,
      children: <Widget>[
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
      ],
    );
  }

  Widget getIcon(
      {double width,
      double height,
      IconData icon,
      Colors colors,
      Function onTap}) {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        child: Icon(
          icon,
          color: Color(new CommonUtil().getMyPrimaryColor()),
          size: width,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget getSizeBoxWidth(double width) {
    return SizedBox(width: width);
  }

  Widget getClipOvalImage(String profileImage, double imageSize) {
    return ClipOval(
        child: Image.network(
      'https://heyr2.com/r2/admin/images/profile/${profileImage != null ? profileImage : 'Patient0.jpg'}',
      fit: BoxFit.cover,
      height: imageSize,
      width: imageSize,
    ));
  }

  Widget getClipOvalImageNew(ProfilePic profileImage, double imageSize) {
    return ClipOval(child: getProfilePicWidget(profileImage));
  }

  Widget getProfilePicWidget(ProfilePic profilePicThumbnail) {
    return profilePicThumbnail != null
        ? Image.memory(
            Uint8List.fromList(profilePicThumbnail.data),
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          )
        : Container(
            color: Color(fhbColors.bgColorContainer),
            height: 50,
            width: 50,
          );
  }

  Widget showDoctorDetailView(DoctorIds docs, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child:
                                getClipOvalImageNew(docs.profilePic,fhbStyles.detailClipImage),
                          ),
                          getSizeBoxWidth(10.0),
                          Expanded(
                            // flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                getTextForDoctors('${docs.name}'),
                                getDoctoSpecialist('${docs.specialization}'),
                                getDoctorsAddress('${docs.city}')
                              ],
                            ),
                          ),
                        ],
                      ),
                      getSizedBox(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getTextForDoctors('About'),
                          getHospitalDetails(
                              'A hospital is a place where a person goes to be healed when he or she is sick or injured. Doctors and nurses work at hospitals. Doctors make use of advanced medical technology to heal patients. ')
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget getTimeSlotText(String textSlotTime) {
    return Text(
      textSlotTime,
      style: TextStyle(color: Colors.blueGrey, fontSize: fhbStyles.fnt_day),
    );
  }

  List<Widget> getTimeSlots(List<DateSlotTimings> dateTimeSlotsList) {
    List<Widget> rowTimeWidget = new List();

    for (DateSlotTimings dateSlotTimingsObj in dateTimeSlotsList) {
      rowTimeWidget.add(new Row(
        children: [
          Expanded(
              flex: 1,
              child: dateSlotTimingsObj.dateTimings == ''
                  ? getSizeBoxWidth(142.0)
                  : getTimeSlotText(dateSlotTimingsObj.dateTimings)),
          Expanded(
              flex: 2,
              child: Row(
                children:
                    getSpecificTimeSlots(dateSlotTimingsObj.dateTimingsSlots),
              )),
        ],
      ));
    }

    rowTimeWidget.add(getSizedBox(20));

    rowTimeWidget.add(Align(
      alignment: Alignment.center,
      child: getRaisedButton(),
    ));
    return rowTimeWidget;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
          width: 1, //
          color: Colors.green //        <--- border width here
          ),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    );
  }

  getSpecificTimeSlots(List<DateTiming> dateTimingsSlots) {
    List<Widget> rowSpecificTimeSlots = new List();

    for (DateTiming dateTiming in dateTimingsSlots) {
      rowSpecificTimeSlots.add(getSpecificSlots(dateTiming.timeslots));
    }

    return rowSpecificTimeSlots;
  }

  getGridViewWidget(List<DateTiming> dateTimingsSlot) {
    return GridView.count(
      crossAxisCount: 5,
      crossAxisSpacing: 30,
      childAspectRatio: 3,
      children: dateTimingsSlot.map((value) {
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Text("Item ${value}"),
        );
      }).toList(),
    );
  }

  getSpecificTimeSlotsNew(List<DateTiming> dateTimingsSlots) {
    List<Widget> rowSpecificTimeSlots = new List();

    for (int i = 0; i < dateTimingsSlots.length; i++) {
      if (i > 0 && i % 5 == 0) {
        rowSpecificTimeSlots
            .add(getSpecificSlots(dateTimingsSlots[i].timeslots));
      } else {
        rowSpecificTimeSlots.add(Row(
          children: [],
        ));
      }
    }

    return rowSpecificTimeSlots;
  }

  Widget getSpecificSlots(String time) {
    return Container(
      width: 35,
      margin: const EdgeInsets.all(2.0),
      //padding: const EdgeInsets.only(left: 5.0,right: 5.0,top:2.0,bottom: 2.0),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      decoration: myBoxDecoration(),
      child: Center(
        child: Text(
          time,
          style:
              TextStyle(fontSize: fhbStyles.fnt_date_slot, color: Colors.green),
        ),
      ),
    );
  }

  Widget getDatePickerSlot(
      DatePickerController _controller, Function(DateTime) dateTimeSelected) {
    return Container(
      height: 65,
      color: Color(fhbColors.cardShadowColor),
      child: DatePicker(
        DateTime.now().add(Duration(days: -3)),
        controller: _controller,
        width: 50,
        height: 60,
        initialSelectedDate: DateTime.now(),
        selectionColor: Color(new CommonUtil().getMyPrimaryColor()),
        selectedTextColor: Colors.white,
        dayTextStyle:
            TextStyle(fontSize: fhbStyles.fnt_day, fontWeight: FontWeight.bold),
        dateTextStyle: TextStyle(
            fontSize: fhbStyles.fnt_date, fontWeight: FontWeight.bold),
        onDateChange: (date) {
          print(date);
          dateTimeSelected(date);
        },
      ),
    );
  }

  Widget getDoctorStatusWidget(DoctorIds docs) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 15.0,
        height: 15.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: getDoctorStatus('${docs.isActive}')
            //color: getDoctorStatus('5'),
            ),
      ),
    );
  }

  BoxDecoration getCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: const Color(fhbColors.cardShadowColor),
          blurRadius: 16, // has the effect of softening the shadow
          spreadRadius: 0, // has the effect of extending the shadow
        )
      ],
    );
  }

  Color getDoctorStatus(String s) {
    print(s + 'getDoctorStatus' );
    switch (s) {
      case 'available':
        return Colors.green;
      case 'busy':
        return Colors.red;
      default:
        return null;
    }
  }
}

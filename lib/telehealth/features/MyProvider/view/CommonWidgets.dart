import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:gmiwidgetspackage/widgets/GridViewWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/Data.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/ProfilePic.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';

import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/view/GridViewNew.dart';

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
    return  SizedBoxWithChild(
      width: 85,
      height: 35,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.deepPurple)),
        color: Colors.white,
        textColor: Colors.deepPurple,
        padding: EdgeInsets.all(8.0),
        onPressed: () {
        },
        child:
        TextWidget(text: 'Book Now', fontsize: 12),
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
          color: Colors.grey[600],
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

  Widget getBookMarkedIcon(DoctorIds docs, Function onClick) {
    return GestureDetector(
        onTap: () {
          onClick();
        },
        child: docs.isDefault
            ? ImageIcon(
          AssetImage('assets/icons/record_fav_active.png'),
          color: Color(new CommonUtil().getMyPrimaryColor()),
          size: fhbStyles.imageWidth,
        )
            : ImageIcon(
          AssetImage('assets/icons/record_fav.png'),
          color: Colors.black,
          size: fhbStyles.imageWidth,
        ));
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
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: getClipOvalImageNew(
                                docs.profilePic, fhbStyles.detailClipImage),
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
      style: TextStyle(color: Colors.blueGrey, fontSize: fhbStyles.fnt_sessionTime),
    );
  }

  List<Widget> getTimeSlots(List<SessionsTime> dateTimeSlotsList) {
    List<Widget> rowTimeWidget = new List();
    String sessionTimings='';

    for (SessionsTime dateSlotTimingsObj in dateTimeSlotsList) {
      sessionTimings = removeLastThreeDigits(dateSlotTimingsObj.sessionStartTime)+" - "
          +removeLastThreeDigits(dateSlotTimingsObj.sessionEndTime);
      rowTimeWidget.add(
          Container(
            height: 90.0,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: sessionTimings == ''
                    ? getSizeBoxWidth(142.0)
                    : getTimeSlotText(sessionTimings)),
            Expanded(
                flex: 2,
                child: GridViewNew(dateSlotTimingsObj.slots)),
          ],
        ),
      ));
    }

    rowTimeWidget.add(getSizedBox(10));

    rowTimeWidget.add(Align(
      alignment: Alignment.center,
      child: getRaisedButton(),
    ));

    rowTimeWidget.add(SizedBoxWidget(height: 10,));
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

  getSpecificTimeSlots(List<Slots> dateTimingsSlots) {
    List<Widget> rowSpecificTimeSlots = new List();
    String timeSlots ='';

    for (Slots dateTiming in dateTimingsSlots) {

      timeSlots = removeLastThreeDigits(dateTiming.startTime);

      rowSpecificTimeSlots.add(getSpecificSlots(timeSlots));
    }

    return rowSpecificTimeSlots;
  }

  getGridViewWidget(List<Slots> dateTimingsSlot) {
    /*return GridViewWidget(list: dateTimingsSlot,crossAxisCount: 4,crossAxisSpacing: 1.0
        ,childAspectRatio: 1.5,widget: timeSlotsItem(dateTimingsSlot));*/
    List _selectedIndexs=[];
    int _selectedIndex = 0;

    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 1.0,
      childAspectRatio: 1.5,
      children: List.generate(dateTimingsSlot.length, (index) {
        final _isSelected = dateTimingsSlot.contains(index);
        return GestureDetector(
          onTap: (){
            if(_isSelected){
              _selectedIndexs.remove(dateTimingsSlot[index]);

            }else{
              _selectedIndexs.add(dateTimingsSlot[index]);
            }
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: _isSelected?Colors.blue:null,
              border: Border.all(color: Colors.green),
              borderRadius: new BorderRadius.circular(5),
            ),
            child: Text(removeLastThreeDigits(dateTimingsSlot[index].startTime),style: TextStyle(fontSize: fhbStyles.fntSlots),),
          ),
        );
      }),
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
      height: 70,
      color: Color(fhbColors.cardShadowColor),
      child: DatePicker(
        DateTime.now().add(Duration(days: -0)),
        controller: _controller,
        daysCount: 8,
        width: 55,
        height: 65,
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

  Widget getDoctorStatusWidget(DoctorIds docs, int position) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getDoctorStatus('${docs.isActive}', position)
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

  Color getDoctorStatus(String s, int position) {
    print(s + 'getDoctorStatus');
    if (position % 2 == 0) {
      s = 'available';
    } else {
      s = 'busy';
    }
    switch (s) {
      case 'available':
        return Colors.green;
      case 'busy':
        return Colors.red;
      default:
        return null;
    }
  }

  removeLastThreeDigits(String string){

    String removedString='';
    removedString = string.substring(0, string.length - 3);

    return removedString;
  }
}

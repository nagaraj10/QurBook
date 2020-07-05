import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';

class CommonWidgets {
  Widget getTextForDoctors(String docName) {
    return Text(
      docName != null ? docName : '',
      style: TextStyle(fontWeight: FontWeight.w500),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getSizedBox(double height) {
    return SizedBox(height: height);
  }

  Widget getDoctorPhoneNumber(String phoneNumber) {
    return Text(
      phoneNumber != null ? phoneNumber : '',
      style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF8C8C8C)),
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
        fontWeight: FontWeight.w400,
        color: Color(0xff5e1fe0),
      ),
    );
  }

  Widget getDownArrowWidget() {
    return Container(
      color: Colors.white,
      width: 30,
      height: 60,
      child: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.blue,
      ),
    );
  }

  Widget getSizeBoxWidth(double width) {
    return SizedBox(width: width);
  }

  Widget getClipOvalImage(String profileImage) {
    return ClipOval(
        child: Image.network(
      'https://heyr2.com/r2/admin/images/profile/${profileImage != null ? profileImage : 'Patient0.jpg'}',
      fit: BoxFit.cover,
      height: 60,
      width: 60,
    ));
  }

  Widget getTimeSlotText(String textSlotTime) {
    return Text(
      textSlotTime,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget getDateSlotsForDoctors() {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Text(
              '10.00am - 11.30am',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.blueGrey,
              ),
            ),
            new CommonWidgets().getSizedBox(20.0),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "10.30",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "10.45",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "11.00",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            Text(
              '02.00pm - 04.00pm',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(width: 20.0),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "02.30",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "03.00",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "03.30",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            Text(
              '05.00pm - 11.00pm',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(width: 20.0),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "05.00",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "05.30",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "06.00",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(width: 142.0),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "05.00",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "05.30",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: myBoxDecoration(),
              child: Text(
                "06.00",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> getTimeSlots(List<DateSlotTimings> dateTimeSlotsList) {
    List<Widget> rowTimeWidget = new List();

    for (DateSlotTimings dateSlotTimingsObj in dateTimeSlotsList) {
      rowTimeWidget.add(new Row(
        children: [
          Expanded(
            flex:1,
            child: dateSlotTimingsObj.dateTimings == ''
                ? getSizeBoxWidth(142.0)
                : getTimeSlotText(dateSlotTimingsObj.dateTimings),
          ),
          Expanded(
            flex:1,
            child:
          Row(
            children: getSpecificTimeSlots(dateSlotTimingsObj.dateTimingsSlots),
          )),
          getSizedBox(5.0)
        ],
      ));
    }
    return rowTimeWidget;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
          width: 2, //
          color: Colors.lightBlueAccent //        <--- border width here
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

  Widget getSpecificSlots(String time) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      decoration: myBoxDecoration(),
      child: Text(
        time,
        style: TextStyle(
            fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }

Widget getDatePickerSlot(DatePickerController _controller,Function(DateTime) dateTimeSelected){

  return Container(
    height:90,
              child: DatePicker(
                DateTime.now().add(Duration(days: -3)),
                width: 50,
                height: 85,
                controller: _controller,
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.blue,
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  print(date);
                  dateTimeSelected(date);
                },
              ),
            );
}
}

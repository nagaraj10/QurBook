import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/src/model/AppointmentModel.dart';
import 'package:myfhb/src/model/ReminderModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/common/CommonUtil.dart';

import 'my_appointments.dart';

class AddAppointments extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final ReminderModel model;

  AddAppointments({this.model});

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointments> {
  //bool isUpdate = false;
  List<bool> isSelected = [false, false, false];
  /*DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();*/
  static DateTime selectedDate;
  static TimeOfDay selectedTime;
  String id = '';
  String myCurrentDate = '';
  String myCurrentTime = '';
  @override
  void initState() {
    //init();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  TextEditingController hosContoller = TextEditingController();
  TextEditingController docNameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  bool _isTitleEmpty = false;
  bool _isNoteEmpty = false;
  bool _isTimeAfter = true;

  int intervalIndex = 0;

  SharedPreferences prefs;
  dynamic detailsList =
      new List(); // our default setting is to login, and we should switch to creating an account when the user chooses to
  dynamic reverseDetailsList = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        title: Text('Add Appointment'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: hosContoller,
                          decoration: InputDecoration(
                              labelText: 'Hospital Name',
                              errorText: _isTitleEmpty
                                  ? 'Hospital name can\'t be empty'
                                  : null),
                        ),
                        TextFormField(
                          controller: docNameController,
                          decoration: InputDecoration(
                              labelText: "Doctor's Name",
                              errorText: _isNoteEmpty
                                  ? 'Doctor name can\'t be empty'
                                  : null),
                        ),
                        Padding(
                          child: Text(
                            'Appointment Date & Time',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            OutlineButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(
                                      /*isUpdate?FHBUtils().getFormattedDateOnly(widget.model.date):*/
                                      FHBUtils().getFormattedDateOnly(
                                          selectedDate.toString())),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                            OutlineButton(
                              onPressed: () {
                                _selectTime(context);
                                //setState(() {});
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(/*isUpdate?widget.model.time:*/
                                      FHBUtils().formatTimeOfDay(selectedTime)),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.alarm,
                                    size: 18,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Opacity(
                              opacity: _isTimeAfter ? 0.0 : 1.0,
                              child: Text(
                                'wrong time picked',
                                style: TextStyle(
                                    color: Colors.red[500], fontSize: 14.0),
                              ),
                            )),
                        TextFormField(
                          controller: reasonController,
                          decoration: InputDecoration(
                            labelText: 'Reason',
//                              errorText: _isTitleEmpty
//                                  ? 'Hospital name can\'t be empty'
//                                  : null
                          ),
                        ),
                      ]),
                ),
              ),
              RaisedGradientButton(
                gradient: LinearGradient(colors: [
                  Color(new CommonUtil().getMyPrimaryColor()),
                  Color(new CommonUtil().getMyGredientColor()),
                ]),
                width: 200,
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  NewAppointment();
                  //Navigator.of(context).pop();
                },
              )
              //RaisedButton(child: Text('Save'), onPressed: () {})
            ]),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2100));

    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });

    if (FHBUtils().checkdate(selectedDate)) {
      //print('280------$_isTimeAfter');
      setState(() {
        _isTimeAfter = true;
      });
      //print('284------$_isTimeAfter');
    } else {
      if (FHBUtils().checkTime(selectedTime)) {
        setState(() {
          _isTimeAfter = true;
        });
        //print('288------$_isTimeAfter');
        //_isTimeAfter=true;
      } else {
        setState(() {
          _isTimeAfter = false;
        });
        //print('292------$_isTimeAfter');
        //_isTimeAfter=false;
      }
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );

    //print('291------$_isTimeAfter');
    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
      });

    //todo check date and time

    if (!FHBUtils().checkdate(selectedDate)) {
      if (FHBUtils().checkTime(selectedTime)) {
        setState(() {
          _isTimeAfter = true;
        });
        //print('299------$_isTimeAfter');
        //_isTimeAfter=true;
      } else {
        setState(() {
          _isTimeAfter = false;
        });
        //print('303------$_isTimeAfter');
        //_isTimeAfter=false;
      }
    }
  }

  void NewAppointment() async {
    //prefs = await SharedPreferences.getInstance();
    //TODO logic to check text field is empty or not
    if (hosContoller.text.isEmpty || docNameController.text.isEmpty) {
      setState(() {
        hosContoller.text.isEmpty ? _isTitleEmpty = true : _isNoteEmpty = false;
        docNameController.text.isEmpty
            ? _isNoteEmpty = true
            : _isNoteEmpty = false;
      });
    } else if (!_isTimeAfter) {
      //do nothing
    } else {
      AppointmentModel model = new AppointmentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          hName: hosContoller.text,
          dName: docNameController.text,
          appDate: FHBUtils().getFormattedDateOnly(selectedDate.toString()),
          appTime: FHBUtils().formatTimeOfDay(selectedTime),
          reason: reasonController.text);

      await FHBUtils().createNewAppointment(model).then((_) {
        Navigator.of(context).pop();
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:myfhb/common/CommonUtil.dart';

class AddReminder extends StatefulWidget {
  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  List<bool> isSelected = [false, false, false];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController tileContoller = TextEditingController();
  TextEditingController notesController = TextEditingController();
  List<String> selectedInterval = ['Day', 'Week', 'Month'];

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
        title: Text('Add Reminder'),
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
                          controller: tileContoller,
                          decoration: InputDecoration(labelText: 'Title'),
                        ),
                        TextFormField(
                          controller: notesController,
                          decoration: InputDecoration(labelText: 'Notes'),
                        ),
                        Padding(
                          child: Text(
                            'Remind me',
                            textAlign: TextAlign.start,
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
                                  Text(FHBUtils().getFormattedDateOnly(
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
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(
                                      FHBUtils().formatTimeOfDay(selectedTime)),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.alarm,
                                    size: 18,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Text('Repeated interval'),
                        SizedBox(height: 10),
                        Center(
                          child: ToggleButtons(
                            borderColor: Colors.black,
                            //TODO chnage theme
                            fillColor: Color(new CommonUtil().getMyPrimaryColor()),
                            borderWidth: 1,
                            selectedBorderColor: Colors.black,
                            selectedColor: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 100, maxHeight: 40),
                                //padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Daily',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 100, maxHeight: 40),
                                //padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Weekly',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 100, maxHeight: 40),
                                //padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Monthly',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                                intervalIndex = index;
                              });
                            },
                            isSelected: isSelected,
                          ),
                        ),

                        /*  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            OutlineButton(
                                onPressed: () {}, child: Text('Daily')),
                            OutlineButton(
                                onPressed: () {}, child: Text('Weekly')),
                            OutlineButton(
                                onPressed: () {}, child: Text('Monthly'))
                          ],
                        ) */
                      ]),
                ),
              ),
              RaisedGradientButton(
                gradient: LinearGradient(colors: [
                  //TODO chnage theme
                  Color(new CommonUtil().getMyPrimaryColor()),
                  Color(new CommonUtil().getMyGredientColor()),
                ]),
                width: 200,
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setReminder();
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
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });
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
        });

    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
      });
  }

  void setReminder() async {
    //prefs = await SharedPreferences.getInstance();

    await getRemindersList();

    Map<String, dynamic> items = {};
    items['title'] = tileContoller.text;
    items['notes'] = notesController.text;
    items['date'] = FHBUtils().getFormattedDateOnly(selectedDate.toString());
    items['time'] = FHBUtils().formatTimeOfDay(selectedTime);
    items['interval'] = selectedInterval[intervalIndex];

    await detailsList.add(items);

    var reminderData = json.encode(detailsList);
    prefs.setString('reminders', reminderData);

    /*  //reverseDetailsList = detailsList.reversed.toList();

    setState(() {}); */

    Navigator.of(context).pop();
  }

  getRemindersList() async {
    prefs = await SharedPreferences.getInstance();

    String getData = await prefs.get('reminders');
    if (getData == null) {
      detailsList = new List();
    } else {
      detailsList = json.decode(getData);

      reverseDetailsList = detailsList.reversed.toList();
    }

    return detailsList;
  }
}
